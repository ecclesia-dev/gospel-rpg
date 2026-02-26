import SpriteKit

class BattleScene: SKScene {
    
    var battleSystem: BattleSystem!
    var partyNodes: [String: SKNode] = [:]
    var enemyNodes: [String: SKNode] = [:]
    var damageLabels: [SKLabelNode] = []
    var chapterNumber: Int = 1
    
    private var backgroundNode: SKSpriteNode!
    
    override func didMove(to view: SKView) {
        backgroundColor = SKColor(red: 0.05, green: 0.02, blue: 0.1, alpha: 1)
        setupBackground()
        setupCharacterSprites()
    }
    
    // MARK: - Asset helpers
    
    /// Try to load an image from xcassets; returns nil if not present.
    private func tryTexture(named name: String) -> SKTexture? {
        #if canImport(UIKit)
        guard UIImage(named: name) != nil else { return nil }
        #endif
        return SKTexture(imageNamed: name)
    }
    
    /// Map a character to its xcassets image name.
    private func imageNameForCharacter(_ character: GameCharacter) -> String? {
        switch character.id {
        case "jesus":               return "jesus"
        case "simon":               return "peter"
        case "andrew":              return "andrew"
        case "james":               return "james"
        case "john":                return "john"
        default:
            // Wildcard IDs (lesser_demon_*, raging_wind_*, etc.)
            if character.id.hasPrefix("lesser_demon") || character.id.hasPrefix("raging_wind") {
                return "enemy_demon"
            }
            switch character.characterClass {
            case .messiah:   return "jesus"
            case .apostle:   return "disciple"
            case .demon:     return "enemy_demon"
            case .obstacle:  return "enemy_pharisee"
            }
        }
    }
    
    func setupBackground() {
        let (bgColor, tileColor1, tileColor2, skyColors): (SKColor, SKColor, SKColor, [SKColor]) = {
            switch chapterNumber {
            case 1:
                return (
                    SKColor(red: 0.12, green: 0.08, blue: 0.06, alpha: 1),
                    SKColor(red: 0.2, green: 0.14, blue: 0.1, alpha: 1),
                    SKColor(red: 0.16, green: 0.1, blue: 0.07, alpha: 1),
                    [.yellow, .orange]
                )
            case 2:
                return (
                    SKColor(red: 0.08, green: 0.05, blue: 0.12, alpha: 1),
                    SKColor(red: 0.12, green: 0.08, blue: 0.18, alpha: 1),
                    SKColor(red: 0.09, green: 0.06, blue: 0.14, alpha: 1),
                    [SKColor(red: 0.4, green: 0.1, blue: 0.5, alpha: 1), SKColor(red: 0.2, green: 0.0, blue: 0.3, alpha: 1)]
                )
            case 3:
                return (
                    SKColor(red: 0.06, green: 0.08, blue: 0.15, alpha: 1),
                    SKColor(red: 0.15, green: 0.12, blue: 0.08, alpha: 1),
                    SKColor(red: 0.12, green: 0.1, blue: 0.06, alpha: 1),
                    [.white, SKColor(red: 0.8, green: 0.85, blue: 1.0, alpha: 1)]
                )
            case 4:
                return (
                    SKColor(red: 0.03, green: 0.05, blue: 0.12, alpha: 1),
                    SKColor(red: 0.05, green: 0.1, blue: 0.25, alpha: 1),
                    SKColor(red: 0.04, green: 0.08, blue: 0.2, alpha: 1),
                    [SKColor(red: 0.6, green: 0.7, blue: 0.9, alpha: 1)]
                )
            case 5:
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
        
        // Try loading a chapter-specific battle background from xcassets
        let bgNames: [Int: String] = [
            1: "bg_temple",
            2: "bg_village",
            3: "bg_mountain",
            4: "bg_lakeshore",
            5: "bg_temple"
        ]
        if let bgName = bgNames[chapterNumber], let bgTex = tryTexture(named: bgName) {
            let bgSprite = SKSpriteNode(texture: bgTex, size: size)
            bgSprite.position = CGPoint(x: size.width / 2, y: size.height / 2)
            bgSprite.alpha = 0.5
            bgSprite.zPosition = -2
            addChild(bgSprite)
        }
        
        // Tiled ground (always draw for atmosphere)
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
        
        let starCount = chapterNumber == 4 ? 5 : 20
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
        
        if chapterNumber == 4 {
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
        let enemyY = size.height * 0.65
        let enemySpacing = size.width / CGFloat(battleSystem.enemies.count + 1)
        
        for (i, enemy) in battleSystem.enemies.enumerated() {
            let sprite: SKSpriteNode
            
            // Fix 1: Load PNG asset for enemy; fall back to procedural renderer
            if let imgName = imageNameForCharacter(enemy), let tex = tryTexture(named: imgName) {
                sprite = SKSpriteNode(texture: tex, size: CGSize(width: 24, height: 32))
                sprite.setScale(3.0)
                // Flip horizontally so enemy faces left (toward player)
                sprite.xScale = -3.0
            } else {
                let node = PixelArtRenderer.drawCharacter(
                    primary: enemy.primaryColor,
                    secondary: enemy.secondaryColor,
                    isEnemy: true
                )
                node.setScale(3.0)
                // Wrap in a container so enemyNodes dict stays consistent
                let container = SKSpriteNode()
                container.addChild(node)
                sprite = container
            }
            
            sprite.position = CGPoint(x: enemySpacing * CGFloat(i + 1), y: enemyY)
            addChild(sprite)
            enemyNodes[enemy.id] = sprite
            PixelArtRenderer.addShadow(to: sprite)
            PixelArtRenderer.addIdleAnimation(to: sprite)
            
            let aura = SKShapeNode(circleOfRadius: 18)
            aura.fillColor = SKColor(red: 0.5, green: 0, blue: 0.3, alpha: 0.1)
            aura.strokeColor = SKColor(red: 0.8, green: 0, blue: 0.4, alpha: 0.2)
            aura.lineWidth = 1
            aura.position = CGPoint(x: 0, y: 20)
            aura.zPosition = -1
            sprite.addChild(aura)
            aura.run(.repeatForever(.sequence([
                .scale(to: 1.3, duration: 1.0),
                .scale(to: 1.0, duration: 1.0)
            ])))
            
            let nameLabel = SKLabelNode(fontNamed: "Courier-Bold")
            nameLabel.text = enemy.name
            nameLabel.fontSize = 12
            nameLabel.fontColor = .red
            nameLabel.position = CGPoint(x: 0, y: -40)
            nameLabel.xScale = sprite.xScale < 0 ? -1.0 : 1.0  // un-mirror the label
            sprite.addChild(nameLabel)
        }
        
        let partyY = size.height * 0.25
        let partySpacing = size.width / CGFloat(battleSystem.party.count + 1)
        
        for (i, member) in battleSystem.party.enumerated() {
            let sprite: SKSpriteNode
            
            // Fix 1: Load PNG asset for party member; fall back to procedural renderer
            if let imgName = imageNameForCharacter(member), let tex = tryTexture(named: imgName) {
                sprite = SKSpriteNode(texture: tex, size: CGSize(width: 24, height: 32))
                sprite.setScale(3.0)
            } else {
                let node = PixelArtRenderer.drawCharacter(
                    primary: member.primaryColor,
                    secondary: member.secondaryColor,
                    isEnemy: false
                )
                node.setScale(3.0)
                let container = SKSpriteNode()
                container.addChild(node)
                sprite = container
            }
            
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
    
    // MARK: - Fix 3: Delegate-driven effect triggers (replaces frame polling)
    
    /// Called by BattleSystem directly when a character takes damage.
    func triggerEffect(characterId: String, damage: Int, isEnemy: Bool) {
        if isEnemy, let node = enemyNodes[characterId] {
            PixelArtRenderer.createHolyBurst(at: node.position, in: self)
            showDamageNumber(damage, at: node.position)
            PixelArtRenderer.flashDamage(node: node)
        } else if !isEnemy, let node = partyNodes[characterId] {
            PixelArtRenderer.createDarkBurst(at: node.position, in: self)
            showDamageNumber(damage, at: node.position)
            PixelArtRenderer.flashDamage(node: node)
        }
    }
    
    /// Called by BattleSystem directly when a character is healed.
    func triggerHeal(characterId: String, amount: Int, isEnemy: Bool) {
        let node = isEnemy ? enemyNodes[characterId] : partyNodes[characterId]
        if let node = node {
            let label = SKLabelNode(fontNamed: "Courier-Bold")
            label.text = "+\(amount)"
            label.fontSize = 18
            label.fontColor = .green
            label.position = node.position
            label.zPosition = 100
            addChild(label)
            let moveUp = SKAction.moveBy(x: 0, y: 55, duration: 0.8)
            let fadeOut = SKAction.fadeAlpha(to: 0, duration: 0.8)
            label.run(.group([moveUp, fadeOut])) { label.removeFromParent() }
        }
    }
    
    // MARK: - update: only maintains visual state for dead entities (no HP polling)
    
    override func update(_ currentTime: TimeInterval) {
        // Fix 3: HP changes are now event-driven via BattleEffectDelegate.
        // update() only handles persistent visual state: fading dead characters.
        for enemy in battleSystem.enemies {
            if !enemy.isAlive, let node = enemyNodes[enemy.id], node.alpha > 0.1 {
                node.run(.fadeAlpha(to: 0, duration: 0.5))
            }
        }
        for member in battleSystem.party {
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

// MARK: - Fix 3: BattleScene adopts BattleEffectDelegate

extension BattleScene: BattleEffectDelegate {}
