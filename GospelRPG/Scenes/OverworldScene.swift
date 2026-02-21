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
    
    var chapterNumber: Int = 1
    
    override func didMove(to view: SKView) {
        backgroundColor = SKColor(red: 0.08, green: 0.12, blue: 0.06, alpha: 1)
        setupMap()
        setupPlayer()
        setupCamera()
        setupControls()
        setupAmbience()
    }
    
    func setupMap() {
        tileNodes = []
        for y in 0..<mapData.count {
            var row: [SKSpriteNode] = []
            for x in 0..<mapData[y].count {
                let tileType = MapTile(rawValue: mapData[y][x]) ?? .grass
                let tile = SKSpriteNode(
                    color: tileType.color,
                    size: CGSize(width: tileSize, height: tileSize)
                )
                tile.position = CGPoint(
                    x: CGFloat(x) * tileSize + tileSize / 2,
                    y: CGFloat(mapData.count - 1 - y) * tileSize + tileSize / 2
                )
                
                // Add detail to some tiles
                if tileType == .grass {
                    // Random grass tufts for visual variety
                    if (x + y * 3) % 5 == 0 {
                        let tuft = SKSpriteNode(color: SKColor(red: 0.15, green: 0.5, blue: 0.15, alpha: 0.6), size: CGSize(width: 4, height: 6))
                        tuft.position = CGPoint(x: CGFloat.random(in: -8...8), y: CGFloat.random(in: -8...8))
                        tile.addChild(tuft)
                    }
                    // Occasional flowers
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
                    // Tree shadow
                    let shadow = SKSpriteNode(color: SKColor(white: 0, alpha: 0.15), size: CGSize(width: 18, height: 6))
                    shadow.position = CGPoint(x: 4, y: -12)
                    tile.addChild(shadow)
                } else if tileType == .mountain {
                    // Mountain peak triangle effect
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
                    // Snow cap
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
                    // Sand grain dots
                    if (x + y * 2) % 3 == 0 {
                        let dot = SKSpriteNode(color: SKColor(red: 0.75, green: 0.65, blue: 0.4, alpha: 0.5), size: CGSize(width: 2, height: 2))
                        dot.position = CGPoint(x: CGFloat.random(in: -8...8), y: CGFloat.random(in: -8...8))
                        tile.addChild(dot)
                    }
                } else if tileType == .path {
                    // Path edge marks
                    let border = SKSpriteNode(color: SKColor(red: 0.55, green: 0.45, blue: 0.25, alpha: 0.3), size: CGSize(width: tileSize, height: 2))
                    border.position = CGPoint(x: 0, y: -tileSize/2 + 1)
                    tile.addChild(border)
                } else if tileType == .bridge {
                    // Bridge planks
                    for i in 0..<3 {
                        let plank = SKSpriteNode(color: SKColor(red: 0.45, green: 0.3, blue: 0.1, alpha: 1), size: CGSize(width: 28, height: 2))
                        plank.position = CGPoint(x: 0, y: CGFloat(i) * 10 - 10)
                        tile.addChild(plank)
                    }
                    // Side rails
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
                    // Window
                    let window = SKSpriteNode(color: SKColor(red: 0.9, green: 0.8, blue: 0.3, alpha: 0.6), size: CGSize(width: 6, height: 6))
                    window.position = CGPoint(x: 0, y: -2)
                    tile.addChild(window)
                    // Warm glow animation
                    window.run(.repeatForever(.sequence([
                        .fadeAlpha(to: 0.3, duration: 2.0),
                        .fadeAlpha(to: 0.6, duration: 2.0)
                    ])))
                } else if tileType == .door {
                    let doorFrame = SKSpriteNode(color: .brown, size: CGSize(width: 16, height: 24))
                    tile.addChild(doorFrame)
                    // Door handle
                    let handle = SKSpriteNode(color: .yellow, size: CGSize(width: 3, height: 3))
                    handle.position = CGPoint(x: 5, y: 0)
                    doorFrame.addChild(handle)
                } else if tileType == .npc {
                    // NPC marker - glowing indicator
                    tile.color = MapTile.grass.color
                    let npcMarker = SKShapeNode(circleOfRadius: 8)
                    npcMarker.fillColor = .yellow
                    npcMarker.strokeColor = .orange
                    npcMarker.lineWidth = 2
                    tile.addChild(npcMarker)
                    npcMarker.run(.repeatForever(.sequence([
                        .scale(to: 1.3, duration: 0.5),
                        .scale(to: 1.0, duration: 0.5)
                    ])))
                    // Exclamation mark
                    let excl = SKLabelNode(fontNamed: "Courier-Bold")
                    excl.text = "!"
                    excl.fontSize = 16
                    excl.fontColor = .red
                    excl.position = CGPoint(x: 0, y: 16)
                    tile.addChild(excl)
                } else if tileType == .water {
                    // Animate water
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
        playerNode = PixelArtRenderer.drawCharacter(primary: partyColor, secondary: partySecondary)
        playerNode.setScale(2.0)
        playerNode.zPosition = 10
        updatePlayerPosition(animated: false)
        addChild(playerNode)
        PixelArtRenderer.addHaloGlow(to: playerNode)
        PixelArtRenderer.addShadow(to: playerNode)
        PixelArtRenderer.addIdleAnimation(to: playerNode)
    }
    
    func setupCamera() {
        cameraNode2 = SKCameraNode()
        camera = cameraNode2
        addChild(cameraNode2)
        updateCamera(animated: false)
    }
    
    func setupControls() {
        // D-pad overlay
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
        
        // Position d-pad bottom-left
        let offsetX = -(size.width / 2) + 80
        let offsetY = -(size.height / 2) + 80
        dpadContainer.position = CGPoint(x: offsetX, y: offsetY)
        
        // Menu button
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
        
        // Action button
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
        if animated {
            playerNode.run(.move(to: pos, duration: 0.15)) {
                self.isMoving = false
                self.checkTrigger()
            }
        } else {
            playerNode.position = pos
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
    
    func checkTrigger() {
        if playerX == triggerX && playerY == triggerY {
            overworldDelegate?.didTriggerEvent()
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: cameraNode2)
        let nodes = cameraNode2.nodes(at: location)
        
        for node in nodes {
            switch node.name {
            case "btn_up": movePlayer(dx: 0, dy: -1)
            case "btn_down": movePlayer(dx: 0, dy: 1)
            case "btn_left": movePlayer(dx: -1, dy: 0)
            case "btn_right": movePlayer(dx: 1, dy: 0)
            case "btn_action": checkInteraction()
            case "btn_menu": overworldDelegate?.didRequestMenu()
            default: break
            }
        }
    }
    
    func checkInteraction() {
        // Check adjacent tiles for NPCs/doors
        let adjacent = [(0,-1),(0,1),(-1,0),(1,0),(0,0)]
        for (dx, dy) in adjacent {
            let cx = playerX + dx
            let cy = playerY + dy
            if cy >= 0 && cy < mapData.count && cx >= 0 && cx < mapData[0].count {
                let tile = MapTile(rawValue: mapData[cy][cx]) ?? .grass
                if tile == .npc || tile == .door {
                    overworldDelegate?.didTriggerEvent()
                    return
                }
            }
        }
    }
    
    // MARK: - Ambient Effects
    
    func setupAmbience() {
        let mapWidth = CGFloat(mapData[0].count) * tileSize
        let mapHeight = CGFloat(mapData.count) * tileSize
        
        // Floating dust motes / pollen particles
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
        
        // Chapter-specific atmosphere
        switch chapterNumber {
        case 2:
            // Gerasene tombs — eerie fog
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
            // Sea — rain effect
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
        
        // Subtle vignette overlay on camera
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
