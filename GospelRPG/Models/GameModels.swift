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
    case blessing = "Blessing"
    case layingHands = "Laying on Hands"
    case faith = "Faith"
    case darkness = "Darkness"
}

// MARK: - Encounter Type (DESIGN.md §3.5)

enum EncounterType: String, Codable {
    case exorcism       // Standard turn-based: cast out demons
    case natureMiracle  // Timed: reduce storm power before timer
    case healing        // Scripted sequence: pray → lay hands → word
    case faithTrial     // Dialogue-driven: no enemies, inner struggle
    case provision      // Loaves & fishes: feed the crowd
    case none           // Narrative/exploration only — no encounter
}

// MARK: - Dialogue Choice (DESIGN.md §3.2)

struct DialogueChoice: Identifiable {
    let id: String
    let label: String
    let faithDelta: Int          // Positive = gain, negative = loss
    let followUpText: String?    // Optional line shown after choice
    let scriptureRef: String?
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
    /// Jesus (Messiah) is never defeated — He is immune to the KO state.
    var isAlive: Bool {
        if characterClass == .messiah { return true }
        return hp > 0
    }
    
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
        // Jesus (Messiah) cannot fall below 1 HP — He is never defeated.
        let floor = (characterClass == .messiah) ? 1 : 0
        hp = max(floor, hp - amount)
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

    // MARK: - Codable support
    enum CodingKeys: String, CodingKey {
        case id, name, characterClass, title
        case level, hp, maxHP, mp, maxMP
        case attack, defense, speed, faith
        case abilities
        case primaryRed, primaryGreen, primaryBlue, primaryAlpha
        case secondaryRed, secondaryGreen, secondaryBlue, secondaryAlpha
    }
    
    required convenience init(from decoder: Decoder) throws {
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
        
        self.init(id: id, name: name, characterClass: charClass, title: title,
                  level: level, hp: maxHP, mp: maxMP,
                  attack: attack, defense: defense, speed: speed, faith: faith,
                  abilities: abilities, primaryColor: primaryColor, secondaryColor: secondaryColor)
        
        self.hp = try c.decode(Int.self, forKey: .hp)
        self.mp = try c.decode(Int.self, forKey: .mp)
    }
}

// MARK: - GameCharacter + Codable
// SKColor is not Codable; encode its RGBA components as Double.

extension GameCharacter: Codable {
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
    /// Optional faith-response choices (DESIGN.md §3.2)
    let choices: [DialogueChoice]?
    
    init(speaker: String, text: String, scriptureRef: String? = nil,
         speakerColor: SKColor = .white, choices: [DialogueChoice]? = nil) {
        self.speaker = speaker
        self.text = text
        self.scriptureRef = scriptureRef
        self.speakerColor = speakerColor
        self.choices = choices
    }
}

// MARK: - Chapter

struct Chapter {
    let number: Int
    let title: String
    let subtitle: String
    let scriptureRange: String
    let act: Int                            // 1, 2, or 3
    let encounterType: EncounterType
    let hasBattle: Bool                     // false for narrative-only scenes
    let showScriptureMemoryAfter: Bool      // true after Acts I and II climaxes
    let introDialogue: [DialogueLine]
    let battleEnemies: [GameCharacter]
    let postBattleDialogue: [DialogueLine]
    let recruitableApostles: [GameCharacter]
    let bossName: String
    let discipleCommentary: [String]        // Post-encounter one-liners (DESIGN.md §3.2)
    let faithReward: Int                    // Faith gained on completion

    // Convenience init with defaults for backward compatibility
    init(number: Int, title: String, subtitle: String, scriptureRange: String,
         act: Int = 1, encounterType: EncounterType = .exorcism,
         hasBattle: Bool = true, showScriptureMemoryAfter: Bool = false,
         introDialogue: [DialogueLine], battleEnemies: [GameCharacter],
         postBattleDialogue: [DialogueLine], recruitableApostles: [GameCharacter],
         bossName: String, discipleCommentary: [String] = [], faithReward: Int = 3) {
        self.number = number
        self.title = title
        self.subtitle = subtitle
        self.scriptureRange = scriptureRange
        self.act = act
        self.encounterType = encounterType
        self.hasBattle = hasBattle
        self.showScriptureMemoryAfter = showScriptureMemoryAfter
        self.introDialogue = introDialogue
        self.battleEnemies = battleEnemies
        self.postBattleDialogue = postBattleDialogue
        self.recruitableApostles = recruitableApostles
        self.bossName = bossName
        self.discipleCommentary = discipleCommentary
        self.faithReward = faithReward
    }
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
    case darkGrass = 10     // For night scenes (Gethsemane, Walking on Water)
    case stone = 11          // Jerusalem / Temple courts
    case palmBranch = 12    // Triumphal Entry decoration
    
    var color: SKColor {
        switch self {
        case .grass:       return SKColor(red: 0.2, green: 0.6, blue: 0.2, alpha: 1)
        case .water:       return SKColor(red: 0.1, green: 0.3, blue: 0.8, alpha: 1)
        case .sand:        return SKColor(red: 0.85, green: 0.75, blue: 0.5, alpha: 1)
        case .path:        return SKColor(red: 0.65, green: 0.55, blue: 0.35, alpha: 1)
        case .building:    return SKColor(red: 0.6, green: 0.4, blue: 0.3, alpha: 1)
        case .tree:        return SKColor(red: 0.1, green: 0.45, blue: 0.1, alpha: 1)
        case .mountain:    return SKColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 1)
        case .bridge:      return SKColor(red: 0.55, green: 0.35, blue: 0.15, alpha: 1)
        case .door:        return SKColor(red: 0.8, green: 0.6, blue: 0.1, alpha: 1)
        case .npc:         return SKColor(red: 0.9, green: 0.2, blue: 0.2, alpha: 1)
        case .darkGrass:   return SKColor(red: 0.05, green: 0.15, blue: 0.05, alpha: 1)
        case .stone:       return SKColor(red: 0.55, green: 0.52, blue: 0.48, alpha: 1)
        case .palmBranch:  return SKColor(red: 0.3, green: 0.55, blue: 0.1, alpha: 1)
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
    case actTransition   // Between Acts I→II and II→III (DESIGN.md §2.3)
    case scriptureMemory // Scripture Memory mini-game (DESIGN.md §3.4)
    case passionNarration // Solemn text narration of the Passion (DESIGN.md §4 Scene 11)
    case ending          // Final epilogue scene with faith-based ending
}

// MARK: - Persistence helpers

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
    var partyFaith: Int
    var storyMode: Bool
    var scriptureMemoryCorrect: Int
    var scriptureMemoryTotal: Int
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

    // MARK: - Faith System (DESIGN.md §3.3)
    /// Party-wide Faith score. Affects ability power scaling and endings.
    @Published var partyFaith: Int = 0

    // MARK: - Story Mode (DESIGN.md §6.1)
    /// When true, enemy HP and ATK are halved. For younger players.
    @Published var storyMode: Bool = false

    // MARK: - Scripture Memory tracking (DESIGN.md §3.4)
    @Published var scriptureMemoryCorrect: Int = 0
    @Published var scriptureMemoryTotal: Int = 0

    /// Add or remove party Faith, clamped to 0...100.
    func adjustFaith(_ delta: Int) {
        partyFaith = max(0, min(100, partyFaith + delta))
    }

    // MARK: - Persistence
    
    private static let saveKey = "gospel_rpg_save_v2"
    
    private static func saveFileURL() -> URL {
        let docs = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        return docs.appendingPathComponent("gospel_rpg_save_v2.json")
    }
    
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
            inventorySave: invSave,
            partyFaith: partyFaith,
            storyMode: storyMode,
            scriptureMemoryCorrect: scriptureMemoryCorrect,
            scriptureMemoryTotal: scriptureMemoryTotal
        )
        do {
            let data = try JSONEncoder().encode(snap)
            try data.write(to: GameState.saveFileURL(), options: .atomic)
        } catch {
            print("[GameState] save failed: \(error)")
        }
    }
    
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
        state.partyFaith = snap.partyFaith
        state.storyMode = snap.storyMode
        state.scriptureMemoryCorrect = snap.scriptureMemoryCorrect
        state.scriptureMemoryTotal = snap.scriptureMemoryTotal
        return state
    }
}
