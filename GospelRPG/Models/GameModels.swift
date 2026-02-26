import Foundation
import SpriteKit

// MARK: - Character Types

enum CharacterClass: String, Codable {
    case messiah = "Messiah"
    case apostle = "Apostle"
    case demon = "Unclean Spirit"
    case obstacle = "Obstacle"
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
    @Published var faith: Int
    
    var abilities: [Ability]
    var isAlive: Bool { hp > 0 }
    
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

// MARK: - GameCharacter + Codable (Fix 5)
// SKColor is not Codable; we encode its RGBA components as Double.

extension GameCharacter: Codable {
    enum CodingKeys: String, CodingKey {
        case id, name, characterClass, title
        case level, hp, maxHP, mp, maxMP
        case attack, defense, speed, faith
        case abilities
        case primaryRed, primaryGreen, primaryBlue, primaryAlpha
        case secondaryRed, secondaryGreen, secondaryBlue, secondaryAlpha
    }
    
    convenience init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        let id           = try c.decode(String.self,         forKey: .id)
        let name         = try c.decode(String.self,         forKey: .name)
        let charClass    = try c.decode(CharacterClass.self, forKey: .characterClass)
        let title        = try c.decode(String.self,         forKey: .title)
        let maxHP        = try c.decode(Int.self,            forKey: .maxHP)
        let maxMP        = try c.decode(Int.self,            forKey: .maxMP)
        let level        = try c.decode(Int.self,            forKey: .level)
        let attack       = try c.decode(Int.self,            forKey: .attack)
        let defense      = try c.decode(Int.self,            forKey: .defense)
        let speed        = try c.decode(Int.self,            forKey: .speed)
        let faith        = try c.decode(Int.self,            forKey: .faith)
        let abilities    = try c.decode([Ability].self,      forKey: .abilities)
        
        let pr = try c.decode(Double.self, forKey: .primaryRed)
        let pg = try c.decode(Double.self, forKey: .primaryGreen)
        let pb = try c.decode(Double.self, forKey: .primaryBlue)
        let pa = try c.decode(Double.self, forKey: .primaryAlpha)
        let sr = try c.decode(Double.self, forKey: .secondaryRed)
        let sg = try c.decode(Double.self, forKey: .secondaryGreen)
        let sb = try c.decode(Double.self, forKey: .secondaryBlue)
        let sa = try c.decode(Double.self, forKey: .secondaryAlpha)
        
        let primaryColor   = SKColor(red: CGFloat(pr), green: CGFloat(pg), blue: CGFloat(pb), alpha: CGFloat(pa))
        let secondaryColor = SKColor(red: CGFloat(sr), green: CGFloat(sg), blue: CGFloat(sb), alpha: CGFloat(sa))
        
        // Init sets hp = maxHP; we'll override with the saved current hp below.
        self.init(id: id, name: name, characterClass: charClass, title: title,
                  level: level, hp: maxHP, mp: maxMP,
                  attack: attack, defense: defense, speed: speed, faith: faith,
                  abilities: abilities, primaryColor: primaryColor, secondaryColor: secondaryColor)
        
        // Restore current hp/mp (may differ from max after damage)
        self.hp = try c.decode(Int.self, forKey: .hp)
        self.mp = try c.decode(Int.self, forKey: .mp)
    }
    
    func encode(to encoder: Encoder) throws {
        var c = encoder.container(keyedBy: CodingKeys.self)
        try c.encode(id,            forKey: .id)
        try c.encode(name,          forKey: .name)
        try c.encode(characterClass, forKey: .characterClass)
        try c.encode(title,         forKey: .title)
        try c.encode(level,         forKey: .level)
        try c.encode(hp,            forKey: .hp)
        try c.encode(maxHP,         forKey: .maxHP)
        try c.encode(mp,            forKey: .mp)
        try c.encode(maxMP,         forKey: .maxMP)
        try c.encode(attack,        forKey: .attack)
        try c.encode(defense,       forKey: .defense)
        try c.encode(speed,         forKey: .speed)
        try c.encode(faith,         forKey: .faith)
        try c.encode(abilities,     forKey: .abilities)
        
        var r: CGFloat = 0, g: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
        primaryColor.getRed(&r, green: &g, blue: &b, alpha: &a)
        try c.encode(Double(r), forKey: .primaryRed)
        try c.encode(Double(g), forKey: .primaryGreen)
        try c.encode(Double(b), forKey: .primaryBlue)
        try c.encode(Double(a), forKey: .primaryAlpha)
        
        secondaryColor.getRed(&r, green: &g, blue: &b, alpha: &a)
        try c.encode(Double(r), forKey: .secondaryRed)
        try c.encode(Double(g), forKey: .secondaryGreen)
        try c.encode(Double(b), forKey: .secondaryBlue)
        try c.encode(Double(a), forKey: .secondaryAlpha)
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
    let recruitableApostles: [GameCharacter]
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
        case .grass:    return SKColor(red: 0.2, green: 0.6, blue: 0.2, alpha: 1)
        case .water:    return SKColor(red: 0.1, green: 0.3, blue: 0.8, alpha: 1)
        case .sand:     return SKColor(red: 0.85, green: 0.75, blue: 0.5, alpha: 1)
        case .path:     return SKColor(red: 0.65, green: 0.55, blue: 0.35, alpha: 1)
        case .building: return SKColor(red: 0.6, green: 0.4, blue: 0.3, alpha: 1)
        case .tree:     return SKColor(red: 0.1, green: 0.45, blue: 0.1, alpha: 1)
        case .mountain: return SKColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 1)
        case .bridge:   return SKColor(red: 0.55, green: 0.35, blue: 0.15, alpha: 1)
        case .door:     return SKColor(red: 0.8, green: 0.6, blue: 0.1, alpha: 1)
        case .npc:      return SKColor(red: 0.9, green: 0.2, blue: 0.2, alpha: 1)
        }
    }
    
    var walkable: Bool {
        switch self {
        case .water, .mountain, .building: return false
        default: return true
        }
    }
}

// MARK: - Game Screen

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

// MARK: - Persistence helpers (Fix 5)

/// Flat, Codable snapshot of the inventory used for save/load.
struct InventorySave: Codable {
    var items: [Item]
    var equipment: [String: EquipmentLoadout]
}

/// Codable snapshot of the full game state.
struct GameStateSave: Codable {
    var currentChapter: Int
    var gold: Int
    var chaptersCompleted: [Int]
    var playerMapX: Int
    var playerMapY: Int
    var party: [GameCharacter]
    var inventorySave: InventorySave
}

// MARK: - Game State

class GameState: ObservableObject {
    @Published var currentScreen: GameScreen = .title
    @Published var currentChapter: Int = 1
    @Published var party: [GameCharacter] = []
    @Published var gold: Int = 0
    @Published var chaptersCompleted: [Int] = []
    @Published var playerMapX: Int = 5
    @Published var playerMapY: Int = 5
    @Published var inventory: Inventory = Inventory()
    
    // Fix 4: Removed `static let shared = GameState()`.
    // GameView uses @StateObject private var gameState = GameState.load()
    // to create exactly one instance, initialized from saved data.
    
    // MARK: - Fix 5: Persistence
    
    private static let saveKey = "gospel_rpg_save_v1"
    
    private static func saveFileURL() -> URL {
        let docs = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        return docs.appendingPathComponent("gospel_rpg_save.json")
    }
    
    /// Persist the current game state to Documents/gospel_rpg_save.json.
    func save() {
        let invSave = InventorySave(
            items: inventory.items,
            equipment: inventory.equipment
        )
        let snap = GameStateSave(
            currentChapter: currentChapter,
            gold: gold,
            chaptersCompleted: chaptersCompleted,
            playerMapX: playerMapX,
            playerMapY: playerMapY,
            party: party,
            inventorySave: invSave
        )
        do {
            let data = try JSONEncoder().encode(snap)
            try data.write(to: GameState.saveFileURL(), options: .atomic)
        } catch {
            print("[GameState] save failed: \(error)")
        }
    }
    
    /// Load a GameState from disk, or return a fresh default state.
    static func load() -> GameState {
        let state = GameState()
        let url = saveFileURL()
        guard FileManager.default.fileExists(atPath: url.path),
              let data = try? Data(contentsOf: url),
              let snap = try? JSONDecoder().decode(GameStateSave.self, from: data) else {
            return state
        }
        state.currentChapter = snap.currentChapter
        state.gold = snap.gold
        state.chaptersCompleted = snap.chaptersCompleted
        state.playerMapX = snap.playerMapX
        state.playerMapY = snap.playerMapY
        state.party = snap.party
        state.inventory.items = snap.inventorySave.items
        state.inventory.equipment = snap.inventorySave.equipment
        return state
    }
}
