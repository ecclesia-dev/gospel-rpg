import SpriteKit

class BattleScene: SKScene {
    
    var battleSystem: BattleSystem!
    var partyNodes: [String: SKNode] = [:]
    var enemyNodes: [String: SKNode] = [:]
    var damageLabels: [SKLabelNode] = []
    
    private var backgroundNode: SKSpriteNode!
    private var lastEnemyHP: [String: Int] = [:]
    private var lastPartyHP: [String: Int] = [:]
    
    override func didMove(to view: SKView) {
        backgroundColor = SKColor(red: 0.05, green: 0.02, blue: 0.1, alpha: 1)
        setupBackground()
        setupCharacterSprites()
        
        // Track HP for damage animations
        for e in battleSystem.enemies { lastEnemyHP[e.id] = e.hp }
        for p in battleSystem.party { lastPartyHP[p.id] = p.hp }
    }
    
    func setupBackground() {
        // Tiled ground
        let tileSize: CGFloat = 32
        for x in stride(from: CGFloat(0), to: size.width, by: tileSize) {
            for y in stride(from: CGFloat(0), to: size.height * 0.4, by: tileSize) {
                let tile = SKSpriteNode(
                    color: (Int(x / tileSize) + Int(y / tileSize)) % 2 == 0
                        ? SKColor(red: 0.15, green: 0.1, blue: 0.25, alpha: 1)
                        : SKColor(red: 0.12, green: 0.08, blue: 0.2, alpha: 1),
                    size: CGSize(width: tileSize, height: tileSize)
                )
                tile.position = CGPoint(x: x + tileSize/2, y: y + tileSize/2)
                addChild(tile)
            }
        }
        
        // Stars in background
        for _ in 0..<20 {
            let star = SKSpriteNode(color: .white, size: CGSize(width: 2, height: 2))
            star.position = CGPoint(
                x: CGFloat.random(in: 0...size.width),
                y: CGFloat.random(in: size.height * 0.5...size.height)
            )
            star.alpha = CGFloat.random(in: 0.3...1.0)
            addChild(star)
            star.run(.repeatForever(.sequence([
                .fadeAlpha(to: 0.2, duration: Double.random(in: 0.5...2.0)),
                .fadeAlpha(to: 1.0, duration: Double.random(in: 0.5...2.0))
            ])))
        }
    }
    
    func setupCharacterSprites() {
        // Position enemies at top
        let enemyY = size.height * 0.65
        let enemySpacing = size.width / CGFloat(battleSystem.enemies.count + 1)
        
        for (i, enemy) in battleSystem.enemies.enumerated() {
            let sprite = PixelArtRenderer.drawCharacter(
                primary: enemy.primaryColor,
                secondary: enemy.secondaryColor,
                isEnemy: true
            )
            sprite.setScale(3.0)
            sprite.position = CGPoint(x: enemySpacing * CGFloat(i + 1), y: enemyY)
            addChild(sprite)
            enemyNodes[enemy.id] = sprite
            PixelArtRenderer.addIdleAnimation(to: sprite)
            
            // Name label
            let nameLabel = SKLabelNode(fontNamed: "Courier-Bold")
            nameLabel.text = enemy.name
            nameLabel.fontSize = 12
            nameLabel.fontColor = .red
            nameLabel.position = CGPoint(x: 0, y: -20)
            sprite.addChild(nameLabel)
        }
        
        // Position party at bottom
        let partyY = size.height * 0.25
        let partySpacing = size.width / CGFloat(battleSystem.party.count + 1)
        
        for (i, member) in battleSystem.party.enumerated() {
            let sprite = PixelArtRenderer.drawCharacter(
                primary: member.primaryColor,
                secondary: member.secondaryColor,
                isEnemy: false
            )
            sprite.setScale(3.0)
            sprite.position = CGPoint(x: partySpacing * CGFloat(i + 1), y: partyY)
            addChild(sprite)
            partyNodes[member.id] = sprite
            PixelArtRenderer.addIdleAnimation(to: sprite)
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Check for damage and show effects
        for enemy in battleSystem.enemies {
            if let lastHP = lastEnemyHP[enemy.id], enemy.hp < lastHP {
                if let node = enemyNodes[enemy.id] {
                    PixelArtRenderer.createHolyBurst(at: node.position, in: self)
                    showDamageNumber(lastHP - enemy.hp, at: node.position)
                    PixelArtRenderer.flashDamage(node: node)
                }
                lastEnemyHP[enemy.id] = enemy.hp
            }
            // Fade dead enemies
            if !enemy.isAlive, let node = enemyNodes[enemy.id], node.alpha > 0.1 {
                node.run(.fadeAlpha(to: 0, duration: 0.5))
            }
        }
        
        for member in battleSystem.party {
            if let lastHP = lastPartyHP[member.id], member.hp < lastHP {
                if let node = partyNodes[member.id] {
                    PixelArtRenderer.createDarkBurst(at: node.position, in: self)
                    showDamageNumber(lastHP - member.hp, at: node.position)
                    PixelArtRenderer.flashDamage(node: node)
                }
                lastPartyHP[member.id] = member.hp
            }
            // Dim fallen party members
            if !member.isAlive, let node = partyNodes[member.id], node.alpha > 0.3 {
                node.run(.fadeAlpha(to: 0.3, duration: 0.5))
            }
        }
    }
    
    func showDamageNumber(_ amount: Int, at position: CGPoint) {
        let label = SKLabelNode(fontNamed: "Courier-Bold")
        label.text = "\(amount)"
        label.fontSize = 20
        label.fontColor = .white
        label.position = position
        label.zPosition = 100
        addChild(label)
        
        let moveUp = SKAction.moveBy(x: 0, y: 60, duration: 0.8)
        let fadeOut = SKAction.fadeAlpha(to: 0, duration: 0.8)
        label.run(.group([moveUp, fadeOut])) {
            label.removeFromParent()
        }
    }
    
    // Highlight current character
    func highlightCharacter(_ character: GameCharacter) {
        // Remove old highlights
        enumerateChildNodes(withName: "highlight") { node, _ in
            node.removeFromParent()
        }
        
        let node = partyNodes[character.id] ?? enemyNodes[character.id]
        if let node = node {
            let highlight = SKShapeNode(rectOf: CGSize(width: 50, height: 60), cornerRadius: 4)
            highlight.strokeColor = .yellow
            highlight.lineWidth = 2
            highlight.name = "highlight"
            highlight.position = node.position
            highlight.zPosition = -1
            highlight.run(.repeatForever(.sequence([
                .fadeAlpha(to: 0.3, duration: 0.5),
                .fadeAlpha(to: 1.0, duration: 0.5)
            ])))
            addChild(highlight)
        }
    }
}
