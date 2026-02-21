import SpriteKit

class BattleScene: SKScene {
    
    var battleSystem: BattleSystem!
    var partyNodes: [String: SKNode] = [:]
    var enemyNodes: [String: SKNode] = [:]
    var damageLabels: [SKLabelNode] = []
    var chapterNumber: Int = 1
    
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
        // Chapter-specific color palettes
        let (bgColor, tileColor1, tileColor2, skyColors): (SKColor, SKColor, SKColor, [SKColor]) = {
            switch chapterNumber {
            case 1: // Synagogue — warm interior
                return (
                    SKColor(red: 0.12, green: 0.08, blue: 0.06, alpha: 1),
                    SKColor(red: 0.2, green: 0.14, blue: 0.1, alpha: 1),
                    SKColor(red: 0.16, green: 0.1, blue: 0.07, alpha: 1),
                    [.yellow, .orange]
                )
            case 2: // Gerasene tombs — eerie
                return (
                    SKColor(red: 0.08, green: 0.05, blue: 0.12, alpha: 1),
                    SKColor(red: 0.12, green: 0.08, blue: 0.18, alpha: 1),
                    SKColor(red: 0.09, green: 0.06, blue: 0.14, alpha: 1),
                    [SKColor(red: 0.4, green: 0.1, blue: 0.5, alpha: 1), SKColor(red: 0.2, green: 0.0, blue: 0.3, alpha: 1)]
                )
            case 3: // Mountain — open sky
                return (
                    SKColor(red: 0.06, green: 0.08, blue: 0.15, alpha: 1),
                    SKColor(red: 0.15, green: 0.12, blue: 0.08, alpha: 1),
                    SKColor(red: 0.12, green: 0.1, blue: 0.06, alpha: 1),
                    [.white, SKColor(red: 0.8, green: 0.85, blue: 1.0, alpha: 1)]
                )
            case 4: // Sea storm — dark ocean
                return (
                    SKColor(red: 0.03, green: 0.05, blue: 0.12, alpha: 1),
                    SKColor(red: 0.05, green: 0.1, blue: 0.25, alpha: 1),
                    SKColor(red: 0.04, green: 0.08, blue: 0.2, alpha: 1),
                    [SKColor(red: 0.6, green: 0.7, blue: 0.9, alpha: 1)]
                )
            case 5: // Jairus' house — solemn interior
                return (
                    SKColor(red: 0.06, green: 0.04, blue: 0.08, alpha: 1),
                    SKColor(red: 0.12, green: 0.08, blue: 0.06, alpha: 1),
                    SKColor(red: 0.1, green: 0.06, blue: 0.05, alpha: 1),
                    [.yellow]
                )
            default:
                return (
                    SKColor(red: 0.05, green: 0.02, blue: 0.1, alpha: 1),
                    SKColor(red: 0.15, green: 0.1, blue: 0.25, alpha: 1),
                    SKColor(red: 0.12, green: 0.08, blue: 0.2, alpha: 1),
                    [.white]
                )
            }
        }()
        
        backgroundColor = bgColor
        
        // Tiled ground
        let tileSize: CGFloat = 32
        for x in stride(from: CGFloat(0), to: size.width, by: tileSize) {
            for y in stride(from: CGFloat(0), to: size.height * 0.4, by: tileSize) {
                let tile = SKSpriteNode(
                    color: (Int(x / tileSize) + Int(y / tileSize)) % 2 == 0 ? tileColor1 : tileColor2,
                    size: CGSize(width: tileSize, height: tileSize)
                )
                tile.position = CGPoint(x: x + tileSize/2, y: y + tileSize/2)
                addChild(tile)
            }
        }
        
        // Ground detail — scattered debris / texture
        for _ in 0..<15 {
            let debris = SKSpriteNode(
                color: SKColor(white: 0.3, alpha: 0.15),
                size: CGSize(width: CGFloat.random(in: 2...6), height: CGFloat.random(in: 1...3))
            )
            debris.position = CGPoint(
                x: CGFloat.random(in: 0...size.width),
                y: CGFloat.random(in: 0...size.height * 0.35)
            )
            debris.alpha = 0.3
            debris.zRotation = CGFloat.random(in: 0...(.pi * 2))
            addChild(debris)
        }
        
        // Stars / sky particles
        let starCount = chapterNumber == 4 ? 5 : 20  // Fewer stars during storm
        for _ in 0..<starCount {
            let star = SKSpriteNode(color: skyColors.randomElement()!, size: CGSize(width: 2, height: 2))
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
        
        // Chapter-specific battle atmosphere
        if chapterNumber == 4 {
            // Lightning flashes
            let lightning = SKSpriteNode(color: .white, size: size)
            lightning.position = CGPoint(x: size.width / 2, y: size.height / 2)
            lightning.alpha = 0
            lightning.zPosition = 2
            addChild(lightning)
            lightning.run(.repeatForever(.sequence([
                .wait(forDuration: Double.random(in: 3...8)),
                .fadeAlpha(to: 0.3, duration: 0.05),
                .fadeAlpha(to: 0, duration: 0.1),
                .wait(forDuration: 0.1),
                .fadeAlpha(to: 0.15, duration: 0.05),
                .fadeAlpha(to: 0, duration: 0.2),
            ])))
            
            // Rain
            let rain = SKEmitterNode()
            rain.particleBirthRate = 40
            rain.particleLifetime = 0.8
            rain.particleSpeed = 300
            rain.emissionAngle = -.pi / 2 - 0.3
            rain.particleScale = 0.08
            rain.particleAlpha = 0.25
            rain.particleSize = CGSize(width: 2, height: 14)
            rain.particleColor = SKColor(red: 0.6, green: 0.7, blue: 0.9, alpha: 1)
            rain.particleColorBlendFactor = 1.0
            rain.position = CGPoint(x: size.width / 2, y: size.height + 10)
            rain.particlePositionRange = CGVector(dx: size.width * 1.5, dy: 0)
            rain.zPosition = 3
            addChild(rain)
        } else if chapterNumber == 1 || chapterNumber == 5 {
            // Warm interior candlelight flicker
            for i in 0..<3 {
                let glow = SKShapeNode(circleOfRadius: 30)
                glow.fillColor = SKColor(red: 1, green: 0.8, blue: 0.3, alpha: 0.06)
                glow.strokeColor = .clear
                glow.position = CGPoint(
                    x: size.width * CGFloat(i + 1) / 4,
                    y: size.height * 0.7
                )
                glow.zPosition = 1
                addChild(glow)
                glow.run(.repeatForever(.sequence([
                    .fadeAlpha(to: 0.02, duration: Double.random(in: 1...3)),
                    .fadeAlpha(to: 0.08, duration: Double.random(in: 1...3))
                ])))
            }
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
            PixelArtRenderer.addShadow(to: sprite)
            PixelArtRenderer.addIdleAnimation(to: sprite)
            
            // Dark aura for enemies
            let aura = SKShapeNode(circleOfRadius: 18)
            aura.fillColor = SKColor(red: 0.5, green: 0, blue: 0.3, alpha: 0.1)
            aura.strokeColor = SKColor(red: 0.8, green: 0, blue: 0.4, alpha: 0.2)
            aura.lineWidth = 1
            aura.position = CGPoint(x: 16, y: 20)
            aura.zPosition = -1
            sprite.addChild(aura)
            aura.run(.repeatForever(.sequence([
                .scale(to: 1.3, duration: 1.0),
                .scale(to: 1.0, duration: 1.0)
            ])))
            
            // Name label
            let nameLabel = SKLabelNode(fontNamed: "Courier-Bold")
            nameLabel.text = enemy.name
            nameLabel.fontSize = 12
            nameLabel.fontColor = .red
            nameLabel.position = CGPoint(x: 16, y: -25)
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
            PixelArtRenderer.addShadow(to: sprite)
            if member.id == "jesus" {
                PixelArtRenderer.addHaloGlow(to: sprite)
            }
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
