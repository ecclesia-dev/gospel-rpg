import SpriteKit

// MARK: - Abilities Database

struct AbilityDB {
    // Jesus's abilities
    static let rebuke = Ability(
        id: "rebuke", name: "Rebuke", description: "\"Be quiet! Come out of him!\"",
        element: .scripture, power: 30, mpCost: 5, targetsAll: false, heals: false,
        scriptureRef: "Mark 1:25"
    )
    static let prayerOfFaith = Ability(
        id: "prayer_faith", name: "Prayer of Faith", description: "A powerful prayer that heals all allies",
        element: .prayer, power: 40, mpCost: 8, targetsAll: true, heals: true,
        scriptureRef: "Mark 11:24"
    )
    static let castOut = Ability(
        id: "cast_out", name: "Cast Out", description: "\"Come out of this person, you impure spirit!\"",
        element: .faith, power: 50, mpCost: 10, targetsAll: false, heals: false,
        scriptureRef: "Mark 5:8"
    )
    static let wordOfGod = Ability(
        id: "word_of_god", name: "Word of God", description: "Speaks Scripture with divine authority",
        element: .scripture, power: 60, mpCost: 15, targetsAll: true, heals: false,
        scriptureRef: "Mark 1:27"
    )
    static let layingOnHands = Ability(
        id: "laying_hands", name: "Laying on Hands", description: "Heals one ally with a gentle touch",
        element: .layingHands, power: 50, mpCost: 6, targetsAll: false, heals: true,
        scriptureRef: "Mark 6:5"
    )
    static let holyWater = Ability(
        id: "holy_water", name: "Holy Water", description: "Splash purifying water on the enemy",
        element: .holyWater, power: 25, mpCost: 4, targetsAll: false, heals: false,
        scriptureRef: nil
    )
    
    // Apostle abilities
    static let pray = Ability(
        id: "pray", name: "Pray", description: "A heartfelt prayer for healing",
        element: .prayer, power: 20, mpCost: 4, targetsAll: false, heals: true,
        scriptureRef: "Mark 9:29"
    )
    static let castNet = Ability(
        id: "cast_net", name: "Cast Net", description: "Cast a net of faith to bind the enemy",
        element: .faith, power: 20, mpCost: 5, targetsAll: true, heals: false,
        scriptureRef: "Mark 1:17"
    )
    static let boldProclamation = Ability(
        id: "bold_proc", name: "Bold Proclamation", description: "Proclaim the good news boldly!",
        element: .scripture, power: 25, mpCost: 6, targetsAll: false, heals: false,
        scriptureRef: "Mark 3:14"
    )
    static let fishersOfMen = Ability(
        id: "fishers", name: "Fishers of Men", description: "Draw strength from your calling",
        element: .faith, power: 15, mpCost: 3, targetsAll: false, heals: true,
        scriptureRef: "Mark 1:17"
    )
    static let thunderCall = Ability(
        id: "thunder", name: "Thunder Call", description: "A son of thunder strikes!",
        element: .faith, power: 35, mpCost: 8, targetsAll: false, heals: false,
        scriptureRef: "Mark 3:17"
    )
    static let rockStand = Ability(
        id: "rock_stand", name: "Rock Stand", description: "Stand firm like the rock!",
        element: .faith, power: 15, mpCost: 4, targetsAll: false, heals: true,
        scriptureRef: "Mark 3:16"
    )
    static let splashHolyWater = Ability(
        id: "splash_hw", name: "Splash Holy Water", description: "Throws holy water at all enemies",
        element: .holyWater, power: 20, mpCost: 6, targetsAll: true, heals: false,
        scriptureRef: nil
    )
    
    // Storm abilities (for Ch4 Calming the Storm)
    static let crashingWave = Ability(
        id: "crashing_wave", name: "Crashing Wave", description: "A massive wave crashes over the boat!",
        element: .darkness, power: 20, mpCost: 0, targetsAll: true, heals: false,
        scriptureRef: "Mark 4:37"
    )
    static let howlingGale = Ability(
        id: "howling_gale", name: "Howling Gale", description: "A furious wind tears at the sails!",
        element: .darkness, power: 18, mpCost: 0, targetsAll: false, heals: false,
        scriptureRef: "Mark 4:37"
    )
    static let swallowingDeep = Ability(
        id: "swallowing_deep", name: "Swallowing Deep", description: "The sea tries to swallow the boat whole!",
        element: .darkness, power: 30, mpCost: 0, targetsAll: true, heals: false,
        scriptureRef: "Mark 4:37"
    )

    // Death/sickness abilities (for Ch5 Jairus)
    static let graspOfDeath = Ability(
        id: "grasp_death", name: "Grasp of Death", description: "An icy hand reaches for the living!",
        element: .darkness, power: 25, mpCost: 0, targetsAll: false, heals: false,
        scriptureRef: nil
    )
    static let wailOfDespair = Ability(
        id: "wail_despair", name: "Wail of Despair", description: "\"She is dead! Why bother the teacher?\"",
        element: .darkness, power: 15, mpCost: 0, targetsAll: true, heals: false,
        scriptureRef: "Mark 5:35"
    )
    static let spiritOfInfirmity = Ability(
        id: "spirit_infirmity", name: "Spirit of Infirmity", description: "Twelve years of suffering drain your strength!",
        element: .darkness, power: 22, mpCost: 0, targetsAll: false, heals: false,
        scriptureRef: "Mark 5:25"
    )

    // Jesus calming storm ability
    static let peaceBeStill = Ability(
        id: "peace_be_still", name: "Peace, Be Still!", description: "\"Quiet! Be still!\" — and the wind dies down.",
        element: .scripture, power: 55, mpCost: 12, targetsAll: true, heals: false,
        scriptureRef: "Mark 4:39"
    )
    static let talithaCumi = Ability(
        id: "talitha_cumi", name: "Talitha Cumi", description: "\"Little girl, I say to you, get up!\"",
        element: .faith, power: 60, mpCost: 15, targetsAll: false, heals: true,
        scriptureRef: "Mark 5:41"
    )

    // Demon abilities
    static let darkCry = Ability(
        id: "dark_cry", name: "Dark Cry", description: "A terrible shriek of darkness",
        element: .darkness, power: 15, mpCost: 0, targetsAll: false, heals: false,
        scriptureRef: nil
    )
    static let torment = Ability(
        id: "torment", name: "Torment", description: "Inflicts spiritual torment",
        element: .darkness, power: 20, mpCost: 0, targetsAll: false, heals: false,
        scriptureRef: nil
    )
    static let possession = Ability(
        id: "possession", name: "Possession", description: "Attempts to possess a target",
        element: .darkness, power: 30, mpCost: 0, targetsAll: false, heals: false,
        scriptureRef: nil
    )
    static let legionSwarm = Ability(
        id: "legion_swarm", name: "Legion Swarm", description: "\"We are many!\" Attacks all party members",
        element: .darkness, power: 25, mpCost: 0, targetsAll: true, heals: false,
        scriptureRef: "Mark 5:9"
    )
    static let convulse = Ability(
        id: "convulse", name: "Convulse", description: "Shakes the victim violently",
        element: .darkness, power: 18, mpCost: 0, targetsAll: false, heals: false,
        scriptureRef: nil
    )
    static let deafeningScream = Ability(
        id: "deaf_scream", name: "Deafening Scream", description: "A horrible scream that hurts all",
        element: .darkness, power: 22, mpCost: 0, targetsAll: true, heals: false,
        scriptureRef: nil
    )
}

// MARK: - Character Factory

struct CharacterFactory {
    
    // MARK: Heroes
    
    static func jesus() -> GameCharacter {
        GameCharacter(
            id: "jesus", name: "Jesus", characterClass: .messiah,
            title: "Son of God",
            level: 5, hp: 200, mp: 100, attack: 25, defense: 20, speed: 15, faith: 50,
            abilities: [.basicAttack, AbilityDB.rebuke, AbilityDB.castOut, AbilityDB.prayerOfFaith,
                       AbilityDB.layingOnHands, AbilityDB.wordOfGod],
            primaryColor: .white, secondaryColor: SKColor(red: 0.9, green: 0.85, blue: 0.5, alpha: 1)
        )
    }
    
    static func simon() -> GameCharacter {
        GameCharacter(
            id: "simon", name: "Simon Peter", characterClass: .apostle,
            title: "The Rock",
            level: 3, hp: 120, mp: 40, attack: 20, defense: 18, speed: 10, faith: 25,
            abilities: [.basicAttack, AbilityDB.rockStand, AbilityDB.pray, AbilityDB.boldProclamation],
            primaryColor: SKColor(red: 0.3, green: 0.3, blue: 0.8, alpha: 1),
            secondaryColor: SKColor(red: 0.6, green: 0.5, blue: 0.3, alpha: 1)
        )
    }
    
    static func andrew() -> GameCharacter {
        GameCharacter(
            id: "andrew", name: "Andrew", characterClass: .apostle,
            title: "Fisher of Men",
            level: 3, hp: 100, mp: 50, attack: 15, defense: 14, speed: 12, faith: 30,
            abilities: [.basicAttack, AbilityDB.castNet, AbilityDB.fishersOfMen, AbilityDB.holyWater],
            primaryColor: SKColor(red: 0.2, green: 0.6, blue: 0.5, alpha: 1),
            secondaryColor: SKColor(red: 0.5, green: 0.4, blue: 0.3, alpha: 1)
        )
    }
    
    static func james() -> GameCharacter {
        GameCharacter(
            id: "james", name: "James", characterClass: .apostle,
            title: "Son of Thunder",
            level: 3, hp: 110, mp: 45, attack: 22, defense: 15, speed: 11, faith: 28,
            abilities: [.basicAttack, AbilityDB.thunderCall, AbilityDB.pray, AbilityDB.splashHolyWater],
            primaryColor: SKColor(red: 0.7, green: 0.2, blue: 0.2, alpha: 1),
            secondaryColor: SKColor(red: 0.8, green: 0.7, blue: 0.1, alpha: 1)
        )
    }
    
    static func john() -> GameCharacter {
        GameCharacter(
            id: "john", name: "John", characterClass: .apostle,
            title: "The Beloved",
            level: 3, hp: 90, mp: 60, attack: 14, defense: 12, speed: 14, faith: 35,
            abilities: [.basicAttack, AbilityDB.pray, AbilityDB.boldProclamation, AbilityDB.holyWater],
            primaryColor: SKColor(red: 0.2, green: 0.4, blue: 0.7, alpha: 1),
            secondaryColor: .white
        )
    }
    
    static func levi() -> GameCharacter {
        GameCharacter(
            id: "levi", name: "Levi", characterClass: .apostle,
            title: "The Tax Collector",
            level: 3, hp: 95, mp: 55, attack: 13, defense: 11, speed: 13, faith: 32,
            abilities: [.basicAttack, AbilityDB.pray, AbilityDB.boldProclamation, AbilityDB.fishersOfMen],
            primaryColor: SKColor(red: 0.6, green: 0.5, blue: 0.2, alpha: 1),
            secondaryColor: SKColor(red: 0.4, green: 0.3, blue: 0.1, alpha: 1)
        )
    }

    static func bartholomew() -> GameCharacter {
        GameCharacter(
            id: "bartholomew", name: "Bartholomew", characterClass: .apostle,
            title: "The Honest One",
            level: 3, hp: 105, mp: 45, attack: 16, defense: 16, speed: 10, faith: 26,
            abilities: [.basicAttack, AbilityDB.rockStand, AbilityDB.pray, AbilityDB.splashHolyWater],
            primaryColor: SKColor(red: 0.4, green: 0.6, blue: 0.3, alpha: 1),
            secondaryColor: SKColor(red: 0.3, green: 0.4, blue: 0.2, alpha: 1)
        )
    }

    // MARK: Enemies
    
    static func synagogueSpirit() -> GameCharacter {
        GameCharacter(
            id: "synagogue_spirit", name: "Unclean Spirit", characterClass: .demon,
            title: "Spirit of the Synagogue",
            level: 3, hp: 150, mp: 99, attack: 15, defense: 10, speed: 8, faith: 0,
            abilities: [AbilityDB.darkCry, AbilityDB.convulse],
            primaryColor: SKColor(red: 0.4, green: 0.1, blue: 0.5, alpha: 1),
            secondaryColor: SKColor(red: 0.6, green: 0.0, blue: 0.0, alpha: 1)
        )
    }
    
    static func legion() -> GameCharacter {
        GameCharacter(
            id: "legion", name: "Legion", characterClass: .demon,
            title: "\"We Are Many\"",
            level: 8, hp: 400, mp: 99, attack: 25, defense: 15, speed: 12, faith: 0,
            abilities: [AbilityDB.legionSwarm, AbilityDB.torment, AbilityDB.possession, AbilityDB.darkCry],
            primaryColor: SKColor(red: 0.3, green: 0.0, blue: 0.3, alpha: 1),
            secondaryColor: SKColor(red: 0.8, green: 0.0, blue: 0.0, alpha: 1)
        )
    }
    
    static func deafMuteSpirit() -> GameCharacter {
        GameCharacter(
            id: "deaf_mute", name: "Deaf & Mute Spirit", characterClass: .demon,
            title: "Spirit of Affliction",
            level: 10, hp: 350, mp: 99, attack: 22, defense: 18, speed: 10, faith: 0,
            abilities: [AbilityDB.convulse, AbilityDB.deafeningScream, AbilityDB.torment],
            primaryColor: SKColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 1),
            secondaryColor: SKColor(red: 0.5, green: 0.0, blue: 0.5, alpha: 1)
        )
    }
    
    // Chapter 4 enemies
    static func theGreatStorm() -> GameCharacter {
        GameCharacter(
            id: "great_storm", name: "The Great Storm", characterClass: .demon,
            title: "Furious Squall",
            level: 6, hp: 300, mp: 99, attack: 20, defense: 12, speed: 14, faith: 0,
            abilities: [AbilityDB.crashingWave, AbilityDB.howlingGale, AbilityDB.swallowingDeep],
            primaryColor: SKColor(red: 0.1, green: 0.2, blue: 0.5, alpha: 1),
            secondaryColor: SKColor(red: 0.6, green: 0.7, blue: 0.9, alpha: 1)
        )
    }

    static func ragingWind() -> GameCharacter {
        GameCharacter(
            id: "raging_wind_\(Int.random(in: 1000...9999))", name: "Raging Wind", characterClass: .demon,
            title: "Storm Servant",
            level: 4, hp: 80, mp: 99, attack: 14, defense: 5, speed: 16, faith: 0,
            abilities: [AbilityDB.howlingGale, AbilityDB.darkCry],
            primaryColor: SKColor(red: 0.3, green: 0.4, blue: 0.6, alpha: 1),
            secondaryColor: SKColor(red: 0.5, green: 0.6, blue: 0.8, alpha: 1)
        )
    }

    // Chapter 5 enemies — these are not demons but obstacles of grief and doubt
    static func griefAndDespair() -> GameCharacter {
        GameCharacter(
            id: "grief_despair", name: "Grief & Despair", characterClass: .obstacle,
            title: "The Mourners' Wailing",
            level: 9, hp: 350, mp: 99, attack: 24, defense: 16, speed: 10, faith: 0,
            abilities: [AbilityDB.graspOfDeath, AbilityDB.wailOfDespair],
            primaryColor: SKColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 1),
            secondaryColor: SKColor(red: 0.3, green: 0.3, blue: 0.4, alpha: 1)
        )
    }

    static func doubtAndFear() -> GameCharacter {
        GameCharacter(
            id: "doubt_fear", name: "Doubt & Fear", characterClass: .obstacle,
            title: "\"Why bother the teacher?\"",
            level: 7, hp: 200, mp: 99, attack: 18, defense: 10, speed: 8, faith: 0,
            abilities: [AbilityDB.wailOfDespair, AbilityDB.spiritOfInfirmity],
            primaryColor: SKColor(red: 0.4, green: 0.3, blue: 0.1, alpha: 1),
            secondaryColor: SKColor(red: 0.6, green: 0.4, blue: 0.2, alpha: 1)
        )
    }

    static func lesserDemon() -> GameCharacter {
        GameCharacter(
            id: "lesser_demon_\(Int.random(in: 1000...9999))", name: "Evil Spirit", characterClass: .demon,
            title: "Minor Demon",
            level: 2, hp: 60, mp: 99, attack: 10, defense: 6, speed: 9, faith: 0,
            abilities: [AbilityDB.darkCry, AbilityDB.convulse],
            primaryColor: SKColor(red: 0.5, green: 0.1, blue: 0.1, alpha: 1),
            secondaryColor: SKColor(red: 0.3, green: 0.0, blue: 0.3, alpha: 1)
        )
    }
}
