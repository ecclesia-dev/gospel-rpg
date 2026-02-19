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
    
    override func didMove(to view: SKView) {
        backgroundColor = .black
        setupMap()
        setupPlayer()
        setupCamera()
        setupControls()
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
                if tileType == .tree {
                    let trunk = SKSpriteNode(color: .brown, size: CGSize(width: 6, height: 10))
                    trunk.position = CGPoint(x: 0, y: -6)
                    tile.addChild(trunk)
                    let canopy = SKSpriteNode(color: SKColor(red: 0.15, green: 0.5, blue: 0.15, alpha: 1), size: CGSize(width: 20, height: 16))
                    canopy.position = CGPoint(x: 0, y: 4)
                    tile.addChild(canopy)
                } else if tileType == .building {
                    let roof = SKSpriteNode(color: SKColor(red: 0.5, green: 0.2, blue: 0.1, alpha: 1), size: CGSize(width: 28, height: 8))
                    roof.position = CGPoint(x: 0, y: 8)
                    tile.addChild(roof)
                } else if tileType == .door {
                    let doorFrame = SKSpriteNode(color: .brown, size: CGSize(width: 16, height: 24))
                    tile.addChild(doorFrame)
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
}
