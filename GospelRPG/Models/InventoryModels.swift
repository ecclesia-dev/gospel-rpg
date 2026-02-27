import Foundation

// MARK: - Equipment Slot

enum EquipmentSlot: String, Codable, CaseIterable {
    case weapon = "Weapon"
    case body = "Body"
    case feet = "Feet"
    case accessory = "Accessory"
}

// MARK: - Item

struct Item: Identifiable, Codable, Equatable {
    let id: String
    let name: String
    let description: String
    let scriptureRef: String?
    let slot: EquipmentSlot?        // nil = consumable
    let attackBonus: Int
    let defenseBonus: Int
    let faithBonus: Int
    let hpBonus: Int
    let mpBonus: Int
    let healAmount: Int             // >0 means consumable heal
    let icon: String                // emoji icon

    static func == (lhs: Item, rhs: Item) -> Bool { lhs.id == rhs.id }
}

// MARK: - Equipment Loadout

struct EquipmentLoadout: Codable {
    var weapon: Item?
    var body: Item?
    var feet: Item?
    var accessory: Item?

    mutating func equip(_ item: Item) -> Item? {
        guard let slot = item.slot else { return nil }
        var old: Item?
        switch slot {
        case .weapon:    old = weapon;    weapon = item
        case .body:      old = body;      body = item
        case .feet:      old = feet;      feet = item
        case .accessory: old = accessory; accessory = item
        }
        return old
    }

    func totalAttack() -> Int  { [weapon, body, feet, accessory].compactMap(\.self).reduce(0) { $0 + $1.attackBonus } }
    func totalDefense() -> Int { [weapon, body, feet, accessory].compactMap(\.self).reduce(0) { $0 + $1.defenseBonus } }
    func totalFaith() -> Int   { [weapon, body, feet, accessory].compactMap(\.self).reduce(0) { $0 + $1.faithBonus } }
    func totalHP() -> Int      { [weapon, body, feet, accessory].compactMap(\.self).reduce(0) { $0 + $1.hpBonus } }
    func totalMP() -> Int      { [weapon, body, feet, accessory].compactMap(\.self).reduce(0) { $0 + $1.mpBonus } }
}

// MARK: - Inventory

class Inventory: ObservableObject {
    @Published var items: [Item] = []
    @Published var equipment: [String: EquipmentLoadout] = [:] // keyed by character id

    func addItem(_ item: Item) {
        items.append(item)
    }

    func removeItem(_ item: Item) {
        if let idx = items.firstIndex(where: { $0.id == item.id }) {
            items.remove(at: idx)
        }
    }

    func equipItem(_ item: Item, on characterId: String) -> Item? {
        guard item.slot != nil else { return nil }
        var loadout = equipment[characterId] ?? EquipmentLoadout()
        let old = loadout.equip(item)
        equipment[characterId] = loadout
        removeItem(item)
        if let old = old { addItem(old) }
        return old
    }

    func loadout(for characterId: String) -> EquipmentLoadout {
        equipment[characterId] ?? EquipmentLoadout()
    }

    func useConsumable(_ item: Item, on character: GameCharacter) -> Bool {
        guard item.healAmount > 0, item.slot == nil else { return false }
        removeItem(item)
        character.heal(item.healAmount)
        return true
    }
}

// MARK: - Item Database

struct ItemDB {
    // Weapons
    static let shepherdStaff = Item(
        id: "shepherd_staff", name: "Shepherd's Staff",
        description: "A humble staff, strong in faith.",
        scriptureRef: "Psalm 23:4", slot: .weapon,
        attackBonus: 5, defenseBonus: 2, faithBonus: 3, hpBonus: 0, mpBonus: 0, healAmount: 0, icon: "🪄"
    )
    static let fishermanRod = Item(
        id: "fisherman_rod", name: "Fisherman's Rod",
        description: "Cast your net upon the waters.",
        scriptureRef: "Luke 5:4", slot: .weapon,
        attackBonus: 4, defenseBonus: 0, faithBonus: 2, hpBonus: 0, mpBonus: 5, healAmount: 0, icon: "🎣"
    )
    static let swordOfTheSpirit = Item(
        id: "sword_spirit", name: "Sword of the Spirit",
        description: "The Word of God, sharper than any two-edged sword. (Scriptural equipment from the Pauline letters.)",
        scriptureRef: "Ephesians 6:17", slot: .weapon,
        attackBonus: 12, defenseBonus: 0, faithBonus: 8, hpBonus: 0, mpBonus: 5, healAmount: 0, icon: "⚔️"
    )
    static let sling = Item(
        id: "sling", name: "Sling of David",
        description: "Small but mighty in the Lord's hands.",
        scriptureRef: "1 Samuel 17:50", slot: .weapon,
        attackBonus: 8, defenseBonus: 0, faithBonus: 5, hpBonus: 0, mpBonus: 0, healAmount: 0, icon: "🪨"
    )

    // Body
    static let roughCloak = Item(
        id: "rough_cloak", name: "Rough Cloak",
        description: "A simple cloak of camel hair.",
        scriptureRef: "Mark 1:6", slot: .body,
        attackBonus: 0, defenseBonus: 4, faithBonus: 1, hpBonus: 10, mpBonus: 0, healAmount: 0, icon: "🧥"
    )
    static let priestlyRobe = Item(
        id: "priestly_robe", name: "Priestly Robe",
        description: "White linen garments of holiness.",
        scriptureRef: "Exodus 28:2", slot: .body,
        attackBonus: 0, defenseBonus: 6, faithBonus: 5, hpBonus: 15, mpBonus: 10, healAmount: 0, icon: "👘"
    )
    static let armorOfGod = Item(
        id: "armor_god", name: "Armor of God",
        description: "Put on the full armor of God! (Scriptural equipment from the Pauline letters.)",
        scriptureRef: "Ephesians 6:11", slot: .body,
        attackBonus: 3, defenseBonus: 10, faithBonus: 8, hpBonus: 20, mpBonus: 5, healAmount: 0, icon: "🛡️"
    )

    // Feet
    static let leatherSandals = Item(
        id: "leather_sandals", name: "Leather Sandals",
        description: "Sturdy sandals for the journey ahead.",
        scriptureRef: "Mark 6:9", slot: .feet,
        attackBonus: 0, defenseBonus: 2, faithBonus: 0, hpBonus: 0, mpBonus: 0, healAmount: 0, icon: "👡"
    )
    static let gospelSandals = Item(
        id: "gospel_sandals", name: "Gospel Sandals",
        description: "Fitted with readiness from the gospel of peace. (Scriptural equipment from the Pauline letters.)",
        scriptureRef: "Ephesians 6:15", slot: .feet,
        attackBonus: 0, defenseBonus: 4, faithBonus: 4, hpBonus: 5, mpBonus: 5, healAmount: 0, icon: "🥿"
    )

    // Accessories
    static let mustardSeed = Item(
        id: "mustard_seed", name: "Mustard Seed",
        description: "Faith as small as a mustard seed can move mountains.",
        scriptureRef: "Matthew 17:20", slot: .accessory,
        attackBonus: 0, defenseBonus: 0, faithBonus: 10, hpBonus: 0, mpBonus: 10, healAmount: 0, icon: "🌱"
    )
    static let shieldOfFaith = Item(
        id: "shield_faith", name: "Shield of Faith",
        description: "Extinguish all the flaming arrows of the evil one. (Scriptural equipment from the Pauline letters.)",
        scriptureRef: "Ephesians 6:16", slot: .accessory,
        attackBonus: 0, defenseBonus: 8, faithBonus: 6, hpBonus: 10, mpBonus: 0, healAmount: 0, icon: "🛡️"
    )
    static let prayerShawl = Item(
        id: "prayer_shawl", name: "Prayer Shawl",
        description: "A sacred tallit for communion with God.",
        scriptureRef: nil, slot: .accessory,
        attackBonus: 0, defenseBonus: 2, faithBonus: 5, hpBonus: 5, mpBonus: 8, healAmount: 0, icon: "🧣"
    )

    // Consumables
    static let bread = Item(
        id: "bread", name: "Bread of Life",
        description: "Restores 50 HP. Jesus is the bread of life.",
        scriptureRef: "John 6:35", slot: nil,
        attackBonus: 0, defenseBonus: 0, faithBonus: 0, hpBonus: 0, mpBonus: 0, healAmount: 50, icon: "🍞"
    )
    static let fish = Item(
        id: "fish", name: "Blessed Fish",
        description: "Restores 30 HP. From the Sea of Galilee.",
        scriptureRef: "Mark 6:41", slot: nil,
        attackBonus: 0, defenseBonus: 0, faithBonus: 0, hpBonus: 0, mpBonus: 0, healAmount: 30, icon: "🐟"
    )
    static let wine = Item(
        id: "wine", name: "New Wine",
        description: "Restores 40 HP. New wine for new wineskins.",
        scriptureRef: "Mark 2:22", slot: nil,
        attackBonus: 0, defenseBonus: 0, faithBonus: 0, hpBonus: 0, mpBonus: 0, healAmount: 40, icon: "🍷"
    )

    /// Starting items given at new game
    static var starterItems: [Item] {
        [shepherdStaff, roughCloak, leatherSandals, bread, bread, fish]
    }

    /// Reward items per chapter
    static func rewardsForChapter(_ chapter: Int) -> [Item] {
        switch chapter {
        case 1: return [fishermanRod, leatherSandals, bread, fish]
        case 2: return [sling, roughCloak, mustardSeed, bread, bread]
        case 3: return [priestlyRobe, prayerShawl, wine, bread]
        case 4: return [gospelSandals, shieldOfFaith, bread, fish, wine]
        case 5: return [swordOfTheSpirit, armorOfGod, bread, bread, wine]
        default: return [bread]
        }
    }
}
