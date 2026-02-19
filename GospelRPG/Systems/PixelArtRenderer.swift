import SpriteKit

// MARK: - Pixel Art Character Renderer

class PixelArtRenderer {
    
    static let pixelSize: CGFloat = 4
    
    // Draw a simple 8x12 pixel character sprite
    static func drawCharacter(primary: SKColor, secondary: SKColor, isEnemy: Bool = false) -> SKNode {
        let container = SKNode()
        let p = pixelSize
        
        if isEnemy {
            // Demon sprite - more angular, spiky
            let demonPixels: [(Int, Int, SKColor)] = [
                // Horns
                (1,0,primary), (6,0,primary),
                (2,1,primary), (5,1,primary),
                // Head
                (2,2,primary), (3,2,primary), (4,2,primary), (5,2,primary),
                (1,3,primary), (2,3,secondary), (3,3,primary), (4,3,primary), (5,3,secondary), (6,3,primary),
                (2,4,primary), (3,4,secondary), (4,4,secondary), (5,4,primary),
                // Body
                (2,5,primary), (3,5,primary), (4,5,primary), (5,5,primary),
                (1,6,secondary), (2,6,primary), (3,6,primary), (4,6,primary), (5,6,primary), (6,6,secondary),
                (1,7,secondary), (2,7,primary), (3,7,primary), (4,7,primary), (5,7,primary), (6,7,secondary),
                (2,8,primary), (3,8,primary), (4,8,primary), (5,8,primary),
                // Wings
                (0,5,secondary), (7,5,secondary), (0,6,secondary), (7,6,secondary),
                // Legs
                (2,9,primary), (3,9,primary), (4,9,primary), (5,9,primary),
                (2,10,primary), (3,10,primary), (4,10,primary), (5,10,primary),
                // Tail
                (6,9,secondary), (7,10,secondary),
            ]
            for (x, y, color) in demonPixels {
                let pixel = SKSpriteNode(color: color, size: CGSize(width: p, height: p))
                pixel.position = CGPoint(x: CGFloat(x) * p, y: CGFloat(11 - y) * p)
                container.addChild(pixel)
            }
        } else {
            // Hero sprite - humanoid, robed figure
            let heroPixels: [(Int, Int, SKColor)] = [
                // Head / hair
                (3,0,secondary), (4,0,secondary),
                (2,1,secondary), (3,1,primary), (4,1,primary), (5,1,secondary),
                (2,2,primary), (3,2,.brown), (4,2,.brown), (5,2,primary),
                (2,3,primary), (3,3,primary), (4,3,primary), (5,3,primary),
                // Body / robe
                (2,4,secondary), (3,4,secondary), (4,4,secondary), (5,4,secondary),
                (1,5,secondary), (2,5,primary), (3,5,primary), (4,5,primary), (5,5,primary), (6,5,secondary),
                (1,6,primary), (2,6,primary), (3,6,primary), (4,6,primary), (5,6,primary), (6,6,primary),
                (2,7,primary), (3,7,primary), (4,7,primary), (5,7,primary),
                (2,8,primary), (3,8,secondary), (4,8,secondary), (5,8,primary),
                // Legs / sandals
                (2,9,primary), (3,9,primary), (4,9,primary), (5,9,primary),
                (2,10,.brown), (3,10,.brown), (4,10,.brown), (5,10,.brown),
                // Hands
                (0,6,primary), (7,6,primary),
            ]
            for (x, y, color) in heroPixels {
                let pixel = SKSpriteNode(color: color, size: CGSize(width: p, height: p))
                pixel.position = CGPoint(x: CGFloat(x) * p, y: CGFloat(11 - y) * p)
                container.addChild(pixel)
            }
        }
        
        return container
    }
    
    // Draw a simple cross symbol
    static func drawCross(color: SKColor = .yellow, scale: CGFloat = 1.0) -> SKNode {
        let container = SKNode()
        let p = pixelSize * scale
        let crossPixels: [(Int, Int)] = [
            (2,0), (2,1), (1,2), (2,2), (3,2), (2,3), (2,4), (2,5)
        ]
        for (x, y) in crossPixels {
            let pixel = SKSpriteNode(color: color, size: CGSize(width: p, height: p))
            pixel.position = CGPoint(x: CGFloat(x) * p, y: CGFloat(5 - y) * p)
            container.addChild(pixel)
        }
        return container
    }
    
    // Battle effect: radiant burst
    static func createHolyBurst(at position: CGPoint, in scene: SKScene) {
        let emitter = SKEmitterNode()
        emitter.particleBirthRate = 80
        emitter.numParticlesToEmit = 40
        emitter.particleLifetime = 0.8
        emitter.particleSpeed = 100
        emitter.particleSpeedRange = 50
        emitter.emissionAngleRange = .pi * 2
        emitter.particleScale = 0.3
        emitter.particleScaleRange = 0.2
        emitter.particleColor = .yellow
        emitter.particleColorBlendFactor = 1.0
        emitter.particleAlphaSpeed = -1.0
        emitter.position = position
        emitter.particleSize = CGSize(width: 6, height: 6)
        scene.addChild(emitter)
        emitter.run(.sequence([.wait(forDuration: 1.0), .removeFromParent()]))
    }
    
    // Battle effect: dark burst
    static func createDarkBurst(at position: CGPoint, in scene: SKScene) {
        let emitter = SKEmitterNode()
        emitter.particleBirthRate = 60
        emitter.numParticlesToEmit = 30
        emitter.particleLifetime = 0.6
        emitter.particleSpeed = 80
        emitter.particleSpeedRange = 40
        emitter.emissionAngleRange = .pi * 2
        emitter.particleScale = 0.4
        emitter.particleScaleRange = 0.2
        emitter.particleColor = SKColor(red: 0.5, green: 0, blue: 0.5, alpha: 1)
        emitter.particleColorBlendFactor = 1.0
        emitter.particleAlphaSpeed = -1.2
        emitter.position = position
        emitter.particleSize = CGSize(width: 8, height: 8)
        scene.addChild(emitter)
        emitter.run(.sequence([.wait(forDuration: 0.8), .removeFromParent()]))
    }
    
    // Animate idle bob
    static func addIdleAnimation(to node: SKNode) {
        let bob = SKAction.sequence([
            .moveBy(x: 0, y: 4, duration: 0.6),
            .moveBy(x: 0, y: -4, duration: 0.6)
        ])
        node.run(.repeatForever(bob))
    }
    
    // Flash damage
    static func flashDamage(node: SKNode) {
        let flash = SKAction.sequence([
            .colorize(with: .red, colorBlendFactor: 0.8, duration: 0.1),
            .colorize(withColorBlendFactor: 0, duration: 0.1)
        ])
        // For container nodes, flash children
        for child in node.children {
            if let sprite = child as? SKSpriteNode {
                sprite.run(.repeat(flash, count: 3))
            }
        }
    }
}
