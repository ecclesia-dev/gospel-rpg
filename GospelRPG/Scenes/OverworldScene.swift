import SpriteKit

protocol OverworldSceneDelegate: AnyObject {
    func didTriggerEvent()
    func didRequestMenu()
}

class OverworldScene: SKScene {
    
    weak var overworldDelegate: OverworldSceneDelegate?
    
    var mapData: [[Int]] = []
    var playerX: Int = 5
    var playerY: Int = 5
    var triggerX: Int = 5
    var triggerY: Int = 5
    
    let tileSize: CGFloat = 32
    var playerNode: SKNode!
    var cameraNode2: SKCameraNode!
    var tileNodes: [[SKSpriteNode]] = []
    var isMoving = false
    
    var partyColor: SKColor = .white
    var partySecondary: SKColor = .yellow
    
    /// Asset name for the player character sprite (e.g. "jesus", "peter")
    var playerCharacterID: String = "jesus"
    
    var chapterNumber: Int = 1
    
    // Hold-to-move support
    var moveTimer: Timer?
    /// Initial delay timer before the repeating hold-move fires
    var moveTimerInitial: Timer?
    var activeMoveDir: (Int, Int) = (0, 0)
    
    override func didMove(to view: SKView) {
        backgroundColor = SKColor(red: 0.08, green: 0.12, blue: 0.06, alpha: 1)
        setupMap()
        setupPlayer()
        setupCamera()
        setupControls()
        setupAmbience()
    }
    
    // MARK: - Asset helpers
    
    /// Returns an SKTexture if the named xcassets image exists; otherwise nil (use procedural fallback).
    private func tryTexture(named name: String) -> SKTexture? {
        #if canImport(UIKit)
        guard UIImage(named: name) != nil else { return nil }
        #endif
        return SKTexture(imageNamed: name)
    }
    
    /// Maps a MapTile type to its xcassets image name.
    private func tileImageName(for tile: MapTile) -> String? {
        switch tile {
        case .grass:       return "tile_grass"
        case .water:       return "tile_water"
        case .sand:        return "tile_sand"
        case .path:        return "tile_dirt_path"
        case .building:    return "tile_wall_mud"
        case .tree:        return "tile_tree"
        case .mountain:    return "tile_rock"
        case .bridge:      return "tile_stone_floor"
        case .door:        return "tile_door"
        case .npc:         return "tile_grass"
        // New tile types — try named assets, fall back to procedural colour
        case .darkGrass:   return "tile_dark_grass"
        case .stone:       return "tile_stone_floor"
        case .palmBranch:  return "tile_palm"
        }
    }
    
    func setupMap() {
        tileNodes = []
        for y in 0..<mapData.count {
            var row: [SKSpriteNode] = []
            for x in 0..<mapData[y].count {
                let tileType = MapTile(rawValue: mapData[y][x]) ?? .grass
                
                // Fix 1: Load PNG asset if available; fall back to procedural colour
                let tile: SKSpriteNode
                if let imageName = tileImageName(for: tileType),
                   let texture = tryTexture(named: imageName) {
                    tile = SKSpriteNode(texture: texture, size: CGSize(width: tileSize, height: tileSize))
                } else {
                    tile = SKSpriteNode(color: tileType.color, size: CGSize(width: tileSize, height: tileSize))
                }
                
                tile.position = CGPoint(
                    x: CGFloat(x) * tileSize + tileSize / 2,
                    y: CGFloat(mapData.count - 1 - y) * tileSize + tileSize / 2
                )
                
                // Overlay decorations only when NOT using a real texture (or always for dynamic elements)
                let usingProcedural = tileImageName(for: tileType).flatMap { tryTexture(named: $0) } == nil
                
                if usingProcedural {
                    // Add detail to some tiles
                    if tileType == .grass {
                        if (x + y * 3) % 5 == 0 {
                            let tuft = SKSpriteNode(color: SKColor(red: 0.15, green: 0.5, blue: 0.15, alpha: 0.6), size: CGSize(width: 4, height: 6))
                            tuft.position = CGPoint(x: CGFloat.random(in: -8...8), y: CGFloat.random(in: -8...8))
                            tile.addChild(tuft)
                        }
                        if (x * 7 + y * 13) % 17 == 0 {
                            let flower = SKShapeNode(circleOfRadius: 2)
                            flower.fillColor = [SKColor.yellow, SKColor.red, SKColor.white, SKColor.purple][abs(x + y) % 4]
                            flower.strokeColor = .clear
                            flower.position = CGPoint(x: CGFloat.random(in: -6...6), y: CGFloat.random(in: -6...6))
                            tile.addChild(flower)
                        }
                    } else if tileType == .tree {
                        let trunk = SKSpriteNode(color: .brown, size: CGSize(width: 6, height: 10))
                        trunk.position = CGPoint(x: 0, y: -6)
                        tile.addChild(trunk)
                        let canopy = SKSpriteNode(color: SKColor(red: 0.15, green: 0.5, blue: 0.15, alpha: 1), size: CGSize(width: 20, height: 16))
                        canopy.position = CGPoint(x: 0, y: 4)
                        tile.addChild(canopy)
                        let shadow = SKSpriteNode(color: SKColor(white: 0, alpha: 0.15), size: CGSize(width: 18, height: 6))
                        shadow.position = CGPoint(x: 4, y: -12)
                        tile.addChild(shadow)
                    } else if tileType == .mountain {
                        let peak = SKShapeNode()
                        let path = CGMutablePath()
                        path.move(to: CGPoint(x: 0, y: 12))
                        path.addLine(to: CGPoint(x: -10, y: -6))
                        path.addLine(to: CGPoint(x: 10, y: -6))
                        path.closeSubpath()
                        peak.path = path
                        peak.fillColor = SKColor(red: 0.6, green: 0.6, blue: 0.65, alpha: 1)
                        peak.strokeColor = SKColor(red: 0.4, green: 0.4, blue: 0.45, alpha: 1)
                        peak.lineWidth = 1
                        tile.addChild(peak)
                        let snow = SKShapeNode()
                        let snowPath = CGMutablePath()
                        snowPath.move(to: CGPoint(x: 0, y: 12))
                        snowPath.addLine(to: CGPoint(x: -4, y: 4))
                        snowPath.addLine(to: CGPoint(x: 4, y: 4))
                        snowPath.closeSubpath()
                        snow.path = snowPath
                        snow.fillColor = .white
                        snow.strokeColor = .clear
                        tile.addChild(snow)
                    } else if tileType == .sand {
                        if (x + y * 2) % 3 == 0 {
                            let dot = SKSpriteNode(color: SKColor(red: 0.75, green: 0.65, blue: 0.4, alpha: 0.5), size: CGSize(width: 2, height: 2))
                            dot.position = CGPoint(x: CGFloat.random(in: -8...8), y: CGFloat.random(in: -8...8))
                            tile.addChild(dot)
                        }
                    } else if tileType == .path {
                        let border = SKSpriteNode(color: SKColor(red: 0.55, green: 0.45, blue: 0.25, alpha: 0.3), size: CGSize(width: tileSize, height: 2))
                        border.position = CGPoint(x: 0, y: -tileSize/2 + 1)
                        tile.addChild(border)
                    } else if tileType == .bridge {
                        for i in 0..<3 {
                            let plank = SKSpriteNode(color: SKColor(red: 0.45, green: 0.3, blue: 0.1, alpha: 1), size: CGSize(width: 28, height: 2))
                            plank.position = CGPoint(x: 0, y: CGFloat(i) * 10 - 10)
                            tile.addChild(plank)
                        }
                        let leftRail = SKSpriteNode(color: SKColor(red: 0.4, green: 0.25, blue: 0.1, alpha: 1), size: CGSize(width: 3, height: tileSize))
                        leftRail.position = CGPoint(x: -13, y: 0)
                        tile.addChild(leftRail)
                        let rightRail = SKSpriteNode(color: SKColor(red: 0.4, green: 0.25, blue: 0.1, alpha: 1), size: CGSize(width: 3, height: tileSize))
                        rightRail.position = CGPoint(x: 13, y: 0)
                        tile.addChild(rightRail)
                    } else if tileType == .building {
                        let roof = SKSpriteNode(color: SKColor(red: 0.5, green: 0.2, blue: 0.1, alpha: 1), size: CGSize(width: 28, height: 8))
                        roof.position = CGPoint(x: 0, y: 8)
                        tile.addChild(roof)
                        let window = SKSpriteNode(color: SKColor(red: 0.9, green: 0.8, blue: 0.3, alpha: 0.6), size: CGSize(width: 6, height: 6))
                        window.position = CGPoint(x: 0, y: -2)
                        tile.addChild(window)
                        window.run(.repeatForever(.sequence([
                            .fadeAlpha(to: 0.3, duration: 2.0),
                            .fadeAlpha(to: 0.6, duration: 2.0)
                        ])))
                    } else if tileType == .door {
                        let doorFrame = SKSpriteNode(color: .brown, size: CGSize(width: 16, height: 24))
                        tile.addChild(doorFrame)
                        let handle = SKSpriteNode(color: .yellow, size: CGSize(width: 3, height: 3))
                        handle.position = CGPoint(x: 5, y: 0)
                        doorFrame.addChild(handle)
                    }
                }
                
                // NPC markers are always drawn (dynamic element regardless of texture)
                if tileType == .npc {
                    if usingProcedural { tile.color = MapTile.grass.color }
                    let npcMarker = SKShapeNode(circleOfRadius: 8)
                    npcMarker.fillColor = .yellow
                    npcMarker.strokeColor = .orange
                    npcMarker.lineWidth = 2
                    tile.addChild(npcMarker)
                    npcMarker.run(.repeatForever(.sequence([
                        .scale(to: 1.3, duration: 0.5),
                        .scale(to: 1.0, duration: 0.5)
                    ])))
                    let excl = SKLabelNode(fontNamed: "Courier-Bold")
                    excl.text = "!"
                    excl.fontSize = 16
                    excl.fontColor = .red
                    excl.position = CGPoint(x: 0, y: 16)
                    tile.addChild(excl)
                }
                
                // Water animation always applied
                if tileType == .water {
                    tile.run(.repeatForever(.sequence([
                        .colorize(with: SKColor(red: 0.15, green: 0.35, blue: 0.85, alpha: 1), colorBlendFactor: 0.3, duration: 1.0),
                        .colorize(with: SKColor(red: 0.1, green: 0.3, blue: 0.8, alpha: 1), colorBlendFactor: 0.0, duration: 1.0)
                    ])))
                }
                
                addChild(tile)
                row.append(tile)
            }
            tileNodes.append(row)
        }
    }
    
    func setupPlayer() {
        // Ground shadow
        let shadow = SKShapeNode(ellipseOf: CGSize(width: 48, height: 14))
        shadow.fillColor = SKColor(white: 0, alpha: 0.3)
        shadow.strokeColor = .clear
        shadow.name = "playerShadow"
        shadow.zPosition = 8
        addChild(shadow)
        
        // Fix 1: Load PNG asset for player character; fall back to procedural renderer
        if let texture = tryTexture(named: playerCharacterID) {
            let spriteSize = CGSize(width: 24, height: 32)
            let sprite = SKSpriteNode(texture: texture, size: spriteSize)
            sprite.setScale(2.0)
            playerNode = sprite
        } else {
            playerNode = PixelArtRenderer.drawCharacter(primary: partyColor, secondary: partySecondary)
            playerNode.setScale(2.0)
        }
        
        playerNode.zPosition = 10
        updatePlayerPosition(animated: false)
        addChild(playerNode)
        PixelArtRenderer.addHaloGlow(to: playerNode)
        PixelArtRenderer.addIdleAnimation(to: playerNode)
    }
    
    func setupCamera() {
        cameraNode2 = SKCameraNode()
        camera = cameraNode2
        addChild(cameraNode2)
        updateCamera(animated: false)
    }
    
    func setupControls() {
        let dpadContainer = SKNode()
        dpadContainer.zPosition = 100
        dpadContainer.name = "dpad"
        
        let directions: [(String, CGFloat, CGFloat)] = [
            ("up", 0, 40), ("down", 0, -40), ("left", -40, 0), ("right", 40, 0)
        ]
        
        for (name, dx, dy) in directions {
            let btn = SKShapeNode(rectOf: CGSize(width: 36, height: 36), cornerRadius: 6)
            btn.fillColor = SKColor(white: 0.2, alpha: 0.7)
            btn.strokeColor = SKColor(white: 0.5, alpha: 0.8)
            btn.lineWidth = 2
            btn.position = CGPoint(x: dx, y: dy)
            btn.name = "btn_\(name)"
            
            let arrow = SKLabelNode(fontNamed: "Courier-Bold")
            arrow.fontSize = 20
            switch name {
            case "up": arrow.text = "▲"
            case "down": arrow.text = "▼"
            case "left": arrow.text = "◀"
            case "right": arrow.text = "▶"
            default: break
            }
            arrow.verticalAlignmentMode = .center
            arrow.name = "btn_\(name)"
            btn.addChild(arrow)
            dpadContainer.addChild(btn)
        }
        
        cameraNode2.addChild(dpadContainer)
        
        let offsetX = -(size.width / 2) + 80
        let offsetY = -(size.height / 2) + 80
        dpadContainer.position = CGPoint(x: offsetX, y: offsetY)
        
        let menuBtn = SKShapeNode(rectOf: CGSize(width: 70, height: 30), cornerRadius: 6)
        menuBtn.fillColor = SKColor(white: 0.2, alpha: 0.7)
        menuBtn.strokeColor = .yellow
        menuBtn.lineWidth = 2
        menuBtn.position = CGPoint(x: size.width / 2 - 60, y: -(size.height / 2) + 30)
        menuBtn.name = "btn_menu"
        menuBtn.zPosition = 100
        let menuLabel = SKLabelNode(fontNamed: "Courier-Bold")
        menuLabel.text = "MENU"
        menuLabel.fontSize = 14
        menuLabel.fontColor = .yellow
        menuLabel.verticalAlignmentMode = .center
        menuLabel.name = "btn_menu"
        menuBtn.addChild(menuLabel)
        cameraNode2.addChild(menuBtn)
        
        let actionBtn = SKShapeNode(rectOf: CGSize(width: 50, height: 50), cornerRadius: 25)
        actionBtn.fillColor = SKColor(red: 0.8, green: 0.6, blue: 0.1, alpha: 0.8)
        actionBtn.strokeColor = .yellow
        actionBtn.lineWidth = 2
        actionBtn.position = CGPoint(x: size.width / 2 - 70, y: -(size.height / 2) + 80)
        actionBtn.name = "btn_action"
        actionBtn.zPosition = 100
        let actionLabel = SKLabelNode(fontNamed: "Courier-Bold")
        actionLabel.text = "A"
        actionLabel.fontSize = 22
        actionLabel.fontColor = .white
        actionLabel.verticalAlignmentMode = .center
        actionLabel.name = "btn_action"
        actionBtn.addChild(actionLabel)
        cameraNode2.addChild(actionBtn)
    }
    
    func updatePlayerPosition(animated: Bool) {
        let pos = CGPoint(
            x: CGFloat(playerX) * tileSize + tileSize / 2,
            y: CGFloat(mapData.count - 1 - playerY) * tileSize + tileSize / 2
        )
        let shadowPos = CGPoint(x: pos.x + 28, y: pos.y + 2)
        
        if animated {
            playerNode.run(.move(to: pos, duration: 0.15)) {
                self.isMoving = false
                self.checkTrigger()
            }
            childNode(withName: "playerShadow")?.run(.move(to: shadowPos, duration: 0.15))
        } else {
            playerNode.position = pos
            childNode(withName: "playerShadow")?.position = shadowPos
        }
    }
    
    func updateCamera(animated: Bool) {
        let pos = CGPoint(
            x: CGFloat(playerX) * tileSize + tileSize / 2,
            y: CGFloat(mapData.count - 1 - playerY) * tileSize + tileSize / 2
        )
        if animated {
            cameraNode2.run(.move(to: pos, duration: 0.15))
        } else {
            cameraNode2.position = pos
        }
    }
    
    func movePlayer(dx: Int, dy: Int) {
        guard !isMoving else { return }
        
        let newX = playerX + dx
        let newY = playerY + dy
        
        guard newY >= 0, newY < mapData.count,
              newX >= 0, newX < mapData[0].count else { return }
        
        let tile = MapTile(rawValue: mapData[newY][newX]) ?? .grass
        guard tile.walkable || tile == .npc || tile == .door || tile == .bridge else { return }
        
        isMoving = true
        playerX = newX
        playerY = newY
        updatePlayerPosition(animated: true)
        updateCamera(animated: true)
    }
    
    // MARK: - NPC Ambient Dialogue (DESIGN.md §3.1)

    /// One-line ambient text displayed near NPCs. Varies by chapter.
    var npcAmbientDialogue: [[String]] {
        switch chapterNumber {
        case 1: return [
            ["\"Have you heard the teacher from Nazareth?\""],
            ["\"The Romans tax us heavily... but something is changing.\""],
            ["\"He teaches with authority, not like the scribes.\""],
            ["\"My son was ill. Jesus touched him and he was healed.\""],
        ]
        case 2: return [
            ["\"They say a madman lives among the tombs across the sea.\""],
            ["\"No one could bind him. Not even chains.\""],
            ["\"The pigs ran into the sea. All of them.\""],
        ]
        case 3: return [
            ["\"There is a storm coming. I can feel it.\""],
            ["\"The fishermen know these waters. But this storm...\""],
        ]
        case 4: return [
            ["\"Jairus went to find the Teacher. His daughter is dying.\""],
            ["\"A woman in the crowd touched His robe and was healed.\""],
            ["\"The mourners are already gathered at Jairus's house.\""],
        ]
        case 5: return [
            ["\"We have been walking all day. Where will we find food?\""],
            ["\"Five thousand men — and that's not counting women and children.\""],
            ["\"Philip says two hundred denarii wouldn't be enough.\""],
            ["\"A boy shared his loaves. Can you imagine?\""],
        ]
        case 6: return [
            ["\"The disciples have been out on the water all night.\""],
            ["\"Did you see? He walked on the sea. Like it was dry land.\""],
        ]
        case 7: return [
            ["\"The scribes are arguing with His disciples again.\""],
            ["\"A father brought his son — the boy foams and convulses.\""],
            ["\"The disciples tried to cast it out. They couldn't.\""],
        ]
        case 8: return [
            ["\"Bartimaeus has sat by this road for years.\""],
            ["\"He called out 'Son of David!' The crowd hushed him.\""],
            ["\"But he kept calling. Louder.\""],
        ]
        case 9: return [
            ["\"Hosanna! Blessed is He who comes in the name of the Lord!\""],
            ["\"He is riding on a donkey. Like the prophecy of Zechariah.\""],
            ["\"The whole city has come out to greet Him.\""],
            ["\"But the Pharisees are watching. Very carefully.\""],
        ]
        case 10: return [
            ["\"He drove out the money-changers! Just overturned their tables.\""],
            ["\"'My house shall be a house of prayer.' He quoted Isaiah.\""],
            ["\"The scribes are furious. They want to arrest Him.\""],
        ]
        case 11: return [
            ["\"Be still. This place is holy.\""],
            ["\"The olive trees have stood here for generations.\""],
            ["\"A prayer is being prayed here tonight that will change everything.\""],
        ]
        case 12: return [
            ["\"It is the first day of the week. Before dawn.\""],
            ["\"Who will roll the stone away for us?\""],
            ["\"He is risen. He is not here.\""],
        ]
        default: return [["\"Have you heard the good news?\""]]
        }
    }

    /// Show a speech bubble near the closest NPC to the player.
    func updateNPCBubble() {
        removeChildren(in: children.filter { $0.name == "npc_bubble" })

        let dialogue = npcAmbientDialogue
        guard !dialogue.isEmpty else { return }

        // Find all NPC tiles within 3 tiles of the player
        let radius = 3
        var closest: (x: Int, y: Int, dist: Int)? = nil
        for dy in -radius...radius {
            for dx in -radius...radius {
                let cx = playerX + dx
                let cy = playerY + dy
                guard cy >= 0, cy < mapData.count, cx >= 0, cx < mapData[0].count else { continue }
                let tile = MapTile(rawValue: mapData[cy][cx])
                if tile == .npc {
                    let dist = abs(dx) + abs(dy)
                    if closest == nil || dist < closest!.dist {
                        closest = (cx, cy, dist)
                    }
                }
            }
        }

        guard let npc = closest, npc.dist <= 3 else { return }

        // Pick dialogue based on NPC position
        let diagIndex = (npc.x * 7 + npc.y * 13 + chapterNumber) % dialogue.count
        let lines = dialogue[diagIndex]
        let text = lines.first ?? ""

        let npcWorldPos = CGPoint(
            x: CGFloat(npc.x) * tileSize + tileSize / 2,
            y: CGFloat(mapData.count - 1 - npc.y) * tileSize + tileSize / 2
        )

        // Bubble background
        let bubbleBg = SKShapeNode(rectOf: CGSize(width: 180, height: 28), cornerRadius: 6)
        bubbleBg.fillColor = SKColor(red: 0.05, green: 0.05, blue: 0.15, alpha: 0.9)
        bubbleBg.strokeColor = SKColor(red: 0.8, green: 0.7, blue: 0.3, alpha: 0.8)
        bubbleBg.lineWidth = 1
        bubbleBg.position = CGPoint(x: npcWorldPos.x, y: npcWorldPos.y + 30)
        bubbleBg.zPosition = 15
        bubbleBg.name = "npc_bubble"

        let label = SKLabelNode(fontNamed: "Courier")
        label.text = text
        label.fontSize = 9
        label.fontColor = .white
        label.verticalAlignmentMode = .center
        label.horizontalAlignmentMode = .center
        label.numberOfLines = 2
        label.preferredMaxLayoutWidth = 160
        bubbleBg.addChild(label)

        addChild(bubbleBg)

        // Fade in/out
        bubbleBg.alpha = 0
        bubbleBg.run(.sequence([.fadeIn(withDuration: 0.3), .wait(forDuration: 3.0), .fadeOut(withDuration: 0.5), .removeFromParent()]))
    }

    func checkTrigger() {
        if playerX == triggerX && playerY == triggerY {
            overworldDelegate?.didTriggerEvent()
        }
        // Update NPC bubble whenever position changes
        updateNPCBubble()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: cameraNode2)
        let nodes = cameraNode2.nodes(at: location)
        
        for node in nodes {
            var dx = 0, dy = 0
            switch node.name {
            case "btn_up":    dy = -1
            case "btn_down":  dy =  1
            case "btn_left":  dx = -1
            case "btn_right": dx =  1
            case "btn_action":
                checkInteraction()
                return
            case "btn_menu":
                overworldDelegate?.didRequestMenu()
                return
            default:
                continue
            }
            
            // Move immediately on first tap
            movePlayer(dx: dx, dy: dy)
            activeMoveDir = (dx, dy)
            
            // Fix 2: Cancel any running timers
            moveTimerInitial?.invalidate()
            moveTimerInitial = nil
            moveTimer?.invalidate()
            moveTimer = nil
            
            // Fix 2: Hold-to-move with 0.35s initial delay then 0.18s repeat.
            // Uses Timer(timeInterval:repeats:block:) + RunLoop.main.add(forMode: .common)
            // so it keeps firing even during UITracking RunLoop mode (touch scroll).
            let initial = Timer(timeInterval: 0.35, repeats: false) { [weak self] _ in
                guard let self = self else { return }
                let repeat_ = Timer(timeInterval: 0.18, repeats: true) { [weak self] _ in
                    guard let self = self else { return }
                    self.movePlayer(dx: self.activeMoveDir.0, dy: self.activeMoveDir.1)
                }
                RunLoop.main.add(repeat_, forMode: .common)
                self.moveTimer = repeat_
                self.moveTimerInitial = nil
            }
            RunLoop.main.add(initial, forMode: .common)
            moveTimerInitial = initial
            return
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        moveTimerInitial?.invalidate()
        moveTimerInitial = nil
        moveTimer?.invalidate()
        moveTimer = nil
        activeMoveDir = (0, 0)
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        moveTimerInitial?.invalidate()
        moveTimerInitial = nil
        moveTimer?.invalidate()
        moveTimer = nil
        activeMoveDir = (0, 0)
    }
    
    func checkInteraction() {
        let adjacent = [(0,-1),(0,1),(-1,0),(1,0),(0,0)]
        for (dx, dy) in adjacent {
            let cx = playerX + dx
            let cy = playerY + dy
            if cy >= 0 && cy < mapData.count && cx >= 0 && cx < mapData[0].count {
                let tile = MapTile(rawValue: mapData[cy][cx]) ?? .grass
                if tile == .npc || tile == .door {
                    // Door tiles near the trigger position → trigger the main event
                    // NPC tiles → show NPC dialogue (handled by ambient bubble system)
                    let distToTrigger = abs(cx - triggerX) + abs(cy - triggerY)
                    if distToTrigger <= 2 {
                        overworldDelegate?.didTriggerEvent()
                    } else {
                        // Show a scripture scroll for other doors (DESIGN.md §3.1 interactable objects)
                        showScriptureScroll(forChapter: chapterNumber)
                    }
                    return
                }
            }
        }
    }

    // MARK: - Scripture Scroll (DESIGN.md §3.1 — interactable objects)

    func showScriptureScroll(forChapter chapter: Int) {
        removeChildren(in: children.filter { $0.name == "scripture_scroll" })

        let scrollData: [(String, String)] = {
            switch chapter {
            case 1:  return [("\"Come after me, and I will make you to become fishers of men.\"", "Mark 1:17 (DRB)")]
            case 2:  return [("\"Go into thy house to thy friends, and tell them how great things the Lord hath done for thee.\"", "Mark 5:19 (DRB)")]
            case 3:  return [("\"Peace, be still.\"", "Mark 4:39 (DRB)")]
            case 4:  return [("\"Fear not, only believe.\"", "Mark 5:36 (DRB)")]
            case 5:  return [("\"And they did all eat, and had their fill.\"", "Mark 6:42 (DRB)")]
            case 6:  return [("\"Have confidence, it is I, fear ye not.\"", "Mark 6:50 (DRB)")]
            case 7:  return [("\"If thou canst believe, all things are possible to him that believeth.\"", "Mark 9:23 (DRB)")]
            case 8:  return [("\"What wilt thou that I should do to thee?\"", "Mark 10:51 (DRB)")]
            case 9:  return [("\"Hosanna: Blessed is he that cometh in the name of the Lord.\"", "Mark 11:9 (DRB)")]
            case 10: return [("\"My house shall be called the house of prayer to all nations.\"", "Mark 11:17 (DRB)")]
            case 11: return [("\"Watch ye, and pray that ye enter not into temptation.\"", "Mark 14:38 (DRB)")]
            case 12: return [("\"Be not affrighted; he is risen, he is not here.\"", "Mark 16:6 (DRB)")]
            default: return [("\"The beginning of the gospel of Jesus Christ, the Son of God.\"", "Mark 1:1 (DRB)")]
            }
        }()

        guard let (text, ref) = scrollData.first else { return }

        let playerPos = CGPoint(
            x: CGFloat(playerX) * tileSize + tileSize / 2,
            y: CGFloat(mapData.count - 1 - playerY) * tileSize + tileSize / 2
        )

        let scrollBg = SKShapeNode(rectOf: CGSize(width: 260, height: 70), cornerRadius: 8)
        scrollBg.fillColor = SKColor(red: 0.12, green: 0.08, blue: 0.02, alpha: 0.95)
        scrollBg.strokeColor = SKColor(red: 0.85, green: 0.7, blue: 0.3, alpha: 0.9)
        scrollBg.lineWidth = 2
        scrollBg.position = CGPoint(x: playerPos.x, y: playerPos.y + 60)
        scrollBg.zPosition = 20
        scrollBg.name = "scripture_scroll"

        let verseLabel = SKLabelNode(fontNamed: "Courier")
        verseLabel.text = text
        verseLabel.fontSize = 9
        verseLabel.fontColor = SKColor(red: 0.95, green: 0.9, blue: 0.75, alpha: 1)
        verseLabel.verticalAlignmentMode = .center
        verseLabel.horizontalAlignmentMode = .center
        verseLabel.numberOfLines = 4
        verseLabel.preferredMaxLayoutWidth = 240
        verseLabel.position = CGPoint(x: 0, y: 10)
        scrollBg.addChild(verseLabel)

        let refLabel = SKLabelNode(fontNamed: "Courier-Bold")
        refLabel.text = ref
        refLabel.fontSize = 9
        refLabel.fontColor = SKColor(red: 0.85, green: 0.7, blue: 0.3, alpha: 1)
        refLabel.verticalAlignmentMode = .center
        refLabel.horizontalAlignmentMode = .center
        refLabel.position = CGPoint(x: 0, y: -20)
        scrollBg.addChild(refLabel)

        let bookIcon = SKLabelNode(fontNamed: "Courier-Bold")
        bookIcon.text = "📖"
        bookIcon.fontSize = 12
        bookIcon.position = CGPoint(x: -110, y: 10)
        scrollBg.addChild(bookIcon)

        addChild(scrollBg)
        scrollBg.alpha = 0
        scrollBg.run(.sequence([.fadeIn(withDuration: 0.3), .wait(forDuration: 4.0), .fadeOut(withDuration: 0.5), .removeFromParent()]))
    }
    
    // MARK: - Ambient Effects
    
    func setupAmbience() {
        let mapWidth = CGFloat(mapData[0].count) * tileSize
        let mapHeight = CGFloat(mapData.count) * tileSize
        
        let dustEmitter = SKEmitterNode()
        dustEmitter.particleBirthRate = 3
        dustEmitter.particleLifetime = 8
        dustEmitter.particleLifetimeRange = 4
        dustEmitter.particleSpeed = 8
        dustEmitter.particleSpeedRange = 5
        dustEmitter.emissionAngle = .pi / 2
        dustEmitter.emissionAngleRange = .pi
        dustEmitter.particleScale = 0.15
        dustEmitter.particleScaleRange = 0.1
        dustEmitter.particleAlpha = 0.4
        dustEmitter.particleAlphaRange = 0.2
        dustEmitter.particleAlphaSpeed = -0.05
        dustEmitter.particleSize = CGSize(width: 4, height: 4)
        dustEmitter.particleColor = SKColor(white: 1.0, alpha: 1)
        dustEmitter.particleColorBlendFactor = 1.0
        dustEmitter.position = CGPoint(x: mapWidth / 2, y: mapHeight / 2)
        dustEmitter.particlePositionRange = CGVector(dx: mapWidth, dy: mapHeight)
        dustEmitter.zPosition = 5
        addChild(dustEmitter)
        
        switch chapterNumber {
        case 2:
            let fog = SKEmitterNode()
            fog.particleBirthRate = 2
            fog.particleLifetime = 6
            fog.particleSpeed = 4
            fog.emissionAngle = 0
            fog.emissionAngleRange = .pi * 2
            fog.particleScale = 1.5
            fog.particleScaleRange = 0.5
            fog.particleAlpha = 0.15
            fog.particleAlphaSpeed = -0.02
            fog.particleSize = CGSize(width: 40, height: 20)
            fog.particleColor = SKColor(red: 0.5, green: 0.4, blue: 0.6, alpha: 1)
            fog.particleColorBlendFactor = 1.0
            fog.position = CGPoint(x: mapWidth / 2, y: mapHeight / 2)
            fog.particlePositionRange = CGVector(dx: mapWidth, dy: mapHeight)
            fog.zPosition = 4
            addChild(fog)
        case 4:
            let rain = SKEmitterNode()
            rain.particleBirthRate = 30
            rain.particleLifetime = 1.5
            rain.particleSpeed = 200
            rain.particleSpeedRange = 50
            rain.emissionAngle = -.pi / 2 - 0.2
            rain.particleScale = 0.1
            rain.particleScaleRange = 0.05
            rain.particleAlpha = 0.3
            rain.particleAlphaRange = 0.1
            rain.particleSize = CGSize(width: 2, height: 12)
            rain.particleColor = SKColor(red: 0.6, green: 0.7, blue: 0.9, alpha: 1)
            rain.particleColorBlendFactor = 1.0
            rain.position = CGPoint(x: mapWidth / 2, y: mapHeight + 20)
            rain.particlePositionRange = CGVector(dx: mapWidth * 1.5, dy: 0)
            rain.zPosition = 15
            addChild(rain)
        default:
            break
        }
        
        let vignetteSize = size
        let vignette = SKShapeNode(rectOf: CGSize(width: vignetteSize.width + 100, height: vignetteSize.height + 100))
        vignette.fillColor = .clear
        vignette.strokeColor = SKColor(white: 0, alpha: 0.4)
        vignette.lineWidth = 80
        vignette.zPosition = 50
        vignette.name = "vignette"
        cameraNode2.addChild(vignette)
    }
}
