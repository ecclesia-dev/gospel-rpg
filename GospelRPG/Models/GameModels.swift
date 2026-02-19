import Foundation
import SpriteKit

// MARK: - Character Types

enum CharacterClass: String, Codable {
    case messiah = "Messiah"
    case apostle = "Apostle"
    case demon = "Unclean Spirit"
}

enum Element: String, Codable {
    case prayer = "Prayer"
    case scripture = "Scripture"
    case holyWater = "Holy Water"
    case layingHands = "Laying on Hands"
    case faith = "Faith"
    case darkness = "Darkness"
}

// MARK: - Ability

struct Ability: Identifiable, Codable {
    let id: String
    let name: String
    let description: String
    let element: Element
    let power: Int
    let mpCost: Int
    let targetsAll: Bool
    let heals: Bool
    let scriptureRef: String?
    
    static let basicAttack = Ability(
        id: "basic", name: "Strike", description: "A basic attack",
        element: .faith, power: 10, mpCost: 0, targetsAll: false, heals: false, scriptureRef: nil
    )
}

// MARK: - Character

class GameCharacter: Identifiable, ObservableObject {
    let id: String
    let name: String
    let characterClass: CharacterClass
    let title: String
    
    @Published var level: Int
    @Published var hp: Int
    @Published var maxHP: Int
    @Published var mp: Int
    @Published var maxMP: Int
    @Published var attack: Int
    @Published var defense: Int
    @Published var speed: Int
    @Published var faith: Int // Special stat - boosts holy abilities
    
    var abilities: [Ability]
    var isAlive: Bool { hp > 0 }
    
    // Pixel art color scheme
    let primaryColor: SKColor
    let secondaryColor: SKColor
    
    init(id: String, name: String, characterClass: CharacterClass, title: String,
         level: Int, hp: Int, mp: Int, attack: Int, defense: Int, speed: Int, faith: Int,
         abilities: [Ability], primaryColor: SKColor, secondaryColor: SKColor) {
        self.id = id
        self.name = name
        self.characterClass = characterClass
        self.title = title
        self.level = level
        self.hp = hp
        self.maxHP = hp
        self.mp = mp
        self.maxMP = mp
        self.attack = attack
        self.defense = defense
        self.speed = speed
        self.faith = faith
        self.abilities = abilities
        self.primaryColor = primaryColor
        self.secondaryColor = secondaryColor
    }
    
    func takeDamage(_ amount: Int) {
        hp = max(0, hp - amount)
    }
    
    func heal(_ amount: Int) {
        hp = min(maxHP, hp + amount)
    }
    
    func useMP(_ cost: Int) -> Bool {
        guard mp >= cost else { return false }
        mp -= cost
        return true
    }
    
    func restoreMP(_ amount: Int) {
        mp = min(maxMP, mp + amount)
    }
    
    func fullRestore() {
        hp = maxHP
        mp = maxMP
    }
}

// MARK: - Battle Action

enum BattleAction {
    case attack(source: GameCharacter, target: GameCharacter)
    case ability(source: GameCharacter, ability: Ability, target: GameCharacter?)
    case defend(source: GameCharacter)
    case flee
}

// MARK: - Dialogue

struct DialogueLine {
    let speaker: String
    let text: String
    let scriptureRef: String?
    let speakerColor: SKColor
    
    init(speaker: String, text: String, scriptureRef: String? = nil, speakerColor: SKColor = .white) {
        self.speaker = speaker
        self.text = text
        self.scriptureRef = scriptureRef
        self.speakerColor = speakerColor
    }
}

// MARK: - Chapter

struct Chapter {
    let number: Int
    let title: String
    let subtitle: String
    let scriptureRange: String
    let introDialogue: [DialogueLine]
    let battleEnemies: [GameCharacter]
    let postBattleDialogue: [DialogueLine]
    let recruitableApostle: GameCharacter?
    let bossName: String
}

// MARK: - Map Tile

enum MapTile: Int {
    case grass = 0
    case water = 1
    case sand = 2
    case path = 3
    case building = 4
    case tree = 5
    case mountain = 6
    case bridge = 7
    case door = 8
    case npc = 9
    
    var color: SKColor {
        switch self {
        case .grass: return SKColor(red: 0.2, green: 0.6, blue: 0.2, alpha: 1)
        case .water: return SKColor(red: 0.1, green: 0.3, blue: 0.8, alpha: 1)
        case .sand: return SKColor(red: 0.85, green: 0.75, blue: 0.5, alpha: 1)
        case .path: return SKColor(red: 0.65, green: 0.55, blue: 0.35, alpha: 1)
        case .building: return SKColor(red: 0.6, green: 0.4, blue: 0.3, alpha: 1)
        case .tree: return SKColor(red: 0.1, green: 0.45, blue: 0.1, alpha: 1)
        case .mountain: return SKColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 1)
        case .bridge: return SKColor(red: 0.55, green: 0.35, blue: 0.15, alpha: 1)
        case .door: return SKColor(red: 0.8, green: 0.6, blue: 0.1, alpha: 1)
        case .npc: return SKColor(red: 0.9, green: 0.2, blue: 0.2, alpha: 1)
        }
    }
    
    var walkable: Bool {
        switch self {
        case .water, .mountain, .building: return false
        default: return true
        }
    }
}

// MARK: - Game State

enum GameScreen {
    case title
    case overworld
    case battle
    case dialogue
    case chapterIntro
    case victory
    case gameOver
    case menu
}

class GameState: ObservableObject {
    @Published var currentScreen: GameScreen = .title
    @Published var currentChapter: Int = 1
    @Published var party: [GameCharacter] = []
    @Published var gold: Int = 0
    @Published var chaptersCompleted: [Int] = []
    @Published var playerMapX: Int = 5
    @Published var playerMapY: Int = 5
    @Published var inventory: Inventory = Inventory()
    
    static let shared = GameState()
}
