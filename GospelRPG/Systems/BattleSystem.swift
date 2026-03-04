import Foundation

// MARK: - Battle Effect Delegate
protocol BattleEffectDelegate: AnyObject {
    func triggerEffect(characterId: String, damage: Int, isEnemy: Bool)
    func triggerHeal(characterId: String, amount: Int, isEnemy: Bool)
}

// MARK: - Nature Miracle State (DESIGN.md §3.5)

struct NatureMiracleState {
    var stormPower: Int         // Starts at 100; reduce to 0 to win
    var turnsRemaining: Int     // When 0, Jesus calms it anyway (soft fail)
    var softFailed: Bool = false
}

// MARK: - Provision State (DESIGN.md §3.5 — Loaves & Fishes)

struct ProvisionState {
    var crowdHunger: Int        // Starts at 5000; reduce to 0 to win
    var foodMultiplier: Double  // Grows each turn as the food multiplies
}

// MARK: - Battle System

class BattleSystem: ObservableObject {
    @Published var party: [GameCharacter] = []
    @Published var enemies: [GameCharacter] = []
    @Published var battleLog: [String] = []
    @Published var currentTurnIndex: Int = 0
    @Published var turnOrder: [GameCharacter] = []
    @Published var isBattleOver: Bool = false
    @Published var isVictory: Bool = false
    @Published var isPlayerTurn: Bool = true
    @Published var showScripture: String? = nil
    @Published var selectedAbility: Ability? = nil

    // MARK: - Encounter Type state (DESIGN.md §3.5)
    @Published var encounterType: EncounterType = .exorcism
    @Published var natureState: NatureMiracleState? = nil
    @Published var provisionState: ProvisionState? = nil
    @Published var faithTrialPhase: Int = 0         // For two-phase encounters
    @Published var peterWalkingPhase: Bool = false  // Walking on Water Phase 2
    @Published var faithChoicesCorrect: Int = 0
    @Published var faithChoicesNeeded: Int = 3

    // MARK: - Story Mode (DESIGN.md §6.1)
    /// When true, enemy HP and ATK are halved on spawn.
    var storyMode: Bool = false

    var onBattleEnd: ((Bool) -> Void)?
    var onFaithGained: ((Int) -> Void)?   // Callback to update GameState.partyFaith
    
    weak var effectDelegate: BattleEffectDelegate?
    
    // MARK: - Reference to party-wide faith for scaling
    var partyFaith: Int = 0
    
    func startBattle(party: [GameCharacter], enemies: [GameCharacter],
                     type: EncounterType = .exorcism) {
        self.party = party
        self.encounterType = type

        // Story Mode: halve enemy HP and ATK
        let processedEnemies: [GameCharacter] = storyMode ? enemies.map { enemy in
            enemy.hp = max(1, enemy.maxHP / 2)
            enemy.maxHP = enemy.hp
            enemy.attack = max(1, enemy.attack / 2)
            return enemy
        } : enemies

        self.enemies = processedEnemies
        self.battleLog = ["⚔️ Battle Start!"]
        self.isBattleOver = false
        self.isVictory = false
        self.faithChoicesCorrect = 0

        // Setup encounter-specific state
        switch type {
        case .natureMiracle:
            natureState = NatureMiracleState(stormPower: 100, turnsRemaining: 8)
            battleLog.append("⛈️ The storm rages! Reduce its power before your faith gives out!")
        case .provision:
            provisionState = ProvisionState(crowdHunger: 5000, foodMultiplier: 1.0)
            battleLog.append("🍞 5,000 hungry souls wait. Pray, and watch the Lord multiply!")
        case .faithTrial:
            faithTrialPhase = 0
            battleLog.append("🙏 The disciples face an inner trial. Choose faith over fear.")
        case .healing:
            battleLog.append("🤲 Approach with prayer, compassion, and trust.")
        default:
            break
        }

        turnOrder = (party + processedEnemies).sorted { $0.speed > $1.speed }
        currentTurnIndex = 0
        advanceToNextLivingTurn()
    }
    
    func advanceToNextLivingTurn() {
        guard !isBattleOver else { return }
        
        // Nature miracle / provision: check timer/counter
        if let ns = natureState {
            if ns.turnsRemaining <= 0 {
                // Soft fail: Jesus calms it anyway
                endNatureMiracleSoftFail()
                return
            }
            if ns.stormPower <= 0 {
                endVictory()
                return
            }
        }
        if let ps = provisionState {
            if ps.crowdHunger <= 0 {
                endVictory()
                return
            }
        }

        var attempts = 0
        while attempts < turnOrder.count {
            let current = turnOrder[currentTurnIndex % turnOrder.count]
            if current.isAlive {
                isPlayerTurn = current.characterClass != .demon && current.characterClass != .obstacle
                if !isPlayerTurn {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                        self.executeEnemyTurn(enemy: current)
                    }
                }
                return
            }
            currentTurnIndex += 1
            attempts += 1
        }
    }
    
    var currentCharacter: GameCharacter? {
        guard !turnOrder.isEmpty else { return nil }
        return turnOrder[currentTurnIndex % turnOrder.count]
    }
    
    // MARK: - Player Actions
    
    func executePlayerAttack(source: GameCharacter, target: GameCharacter) {
        let damage = calculateDamage(attacker: source, defender: target, power: source.attack)
        let isEnemy = enemies.contains { $0.id == target.id }
        target.takeDamage(damage)
        effectDelegate?.triggerEffect(characterId: target.id, damage: damage, isEnemy: isEnemy)
        battleLog.append("\(source.name) strikes \(target.name) for \(damage) damage!")
        
        // Nature miracle: attacking reduces storm power
        if encounterType == .natureMiracle {
            applyStormReduction(amount: damage / 5 + 5)
        }

        checkBattleEnd()
        if !isBattleOver { nextTurn() }
    }
    
    func executeAbility(source: GameCharacter, ability: Ability, target: GameCharacter?) {
        guard source.useMP(ability.mpCost) else {
            battleLog.append("\(source.name) doesn't have enough MP!")
            return
        }
        
        if let ref = ability.scriptureRef {
            showScripture = "\(ref): \(ability.description)"
        }

        // Faith-scaling (DESIGN.md §3.3): effectivePower = basePower × (1 + partyFaith/100)
        let faithMultiplier = 1.0 + Double(partyFaith) / 100.0
        
        if ability.heals {
            if ability.targetsAll {
                let base = ability.power + source.faith / 2
                let healAmount = Int(Double(base) * faithMultiplier)
                for member in party where member.isAlive {
                    member.heal(healAmount)
                    effectDelegate?.triggerHeal(characterId: member.id, amount: healAmount, isEnemy: false)
                }
                battleLog.append("\(source.name) uses \(ability.name)! Party healed for \(healAmount) HP!")
            } else if let target = target {
                let base = ability.power + source.faith / 2
                let healAmount = Int(Double(base) * faithMultiplier)
                let isEnemy = enemies.contains { $0.id == target.id }
                target.heal(healAmount)
                effectDelegate?.triggerHeal(characterId: target.id, amount: healAmount, isEnemy: isEnemy)
                battleLog.append("\(source.name) uses \(ability.name) on \(target.name)! Healed \(healAmount) HP!")
            }
        } else {
            let faithBonus = source.faith / 3
            let scaledPower = Int(Double(ability.power + faithBonus) * faithMultiplier)
            if ability.targetsAll {
                for enemy in enemies where enemy.isAlive {
                    let damage = calculateDamage(attacker: source, defender: enemy, power: scaledPower)
                    enemy.takeDamage(damage)
                    effectDelegate?.triggerEffect(characterId: enemy.id, damage: damage, isEnemy: true)
                    battleLog.append("\(ability.name) hits \(enemy.name) for \(damage)!")
                }
            } else if let target = target {
                let isEnemy = enemies.contains { $0.id == target.id }
                let damage = calculateDamage(attacker: source, defender: target, power: scaledPower)
                target.takeDamage(damage)
                effectDelegate?.triggerEffect(characterId: target.id, damage: damage, isEnemy: isEnemy)
                battleLog.append("\(source.name): \"\(ability.description)\" — \(damage) damage to \(target.name)!")
            }
        }

        // Special: Prayer ability in nature miracle reduces storm faster
        if encounterType == .natureMiracle && (ability.element == .prayer || ability.element == .scripture) {
            let reduction = 15 + partyFaith / 5
            applyStormReduction(amount: reduction)
        }

        // Special: Prayer in provision multiplies food
        if encounterType == .provision && ability.element == .prayer {
            applyProvisionTurn()
        }
        
        checkBattleEnd()
        if !isBattleOver {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { self.showScripture = nil }
            nextTurn()
        }
    }
    
    func executeDefend(source: GameCharacter) {
        source.defense += 5
        battleLog.append("\(source.name) defends in prayer! Defense increased.")

        // In nature miracle, defending also reduces storm slightly
        if encounterType == .natureMiracle {
            applyStormReduction(amount: 5)
        }
        nextTurn()
    }

    // MARK: - Nature Miracle helpers

    func applyStormReduction(amount: Int) {
        guard var ns = natureState else { return }
        ns.stormPower = max(0, ns.stormPower - amount)
        ns.turnsRemaining -= 1
        natureState = ns
        battleLog.append("⛈️ Storm power: \(ns.stormPower)/100 | Turns left: \(ns.turnsRemaining)")
        if ns.stormPower <= 0 {
            endVictory()
        } else if ns.turnsRemaining <= 0 {
            endNatureMiracleSoftFail()
        }
    }

    func endNatureMiracleSoftFail() {
        guard var ns = natureState else { return }
        ns.softFailed = true
        natureState = ns
        battleLog.append("🌊 The disciples' strength fails... but Jesus rises and speaks.")
        battleLog.append("\"Peace, be still.\" — Mark 4:39 (DRB)")
        isBattleOver = true
        isVictory = true // Still a win — Jesus always calms the storm
        onFaithGained?(1) // Reduced faith gain for soft fail
        onBattleEnd?(true)
    }

    // MARK: - Provision helpers (Loaves & Fishes)

    func applyProvisionTurn() {
        guard var ps = provisionState else { return }
        ps.foodMultiplier += 0.3
        let fed = Int(500.0 * ps.foodMultiplier)
        ps.crowdHunger = max(0, ps.crowdHunger - fed)
        provisionState = ps
        battleLog.append("🍞 The food multiplies! \(fed) souls fed. Hunger remaining: \(ps.crowdHunger)")
        if ps.crowdHunger <= 0 {
            battleLog.append("\"And they did all eat, and had their fill.\" — Mark 6:42 (DRB)")
            endVictory()
        }
    }

    // MARK: - Faith Trial helper (dialogue-driven, called from UI)

    func recordFaithChoice(correct: Bool) {
        if correct {
            faithChoicesCorrect += 1
            battleLog.append("✨ A faithful choice! Faith grows stronger.")
        } else {
            battleLog.append("💭 The disciples hesitate... but Jesus is patient.")
        }
        faithTrialPhase += 1
        if faithChoicesCorrect >= faithChoicesNeeded || faithTrialPhase >= 4 {
            endVictory()
        }
    }

    // MARK: - Enemy AI
    
    func executeEnemyTurn(enemy: GameCharacter) {
        guard enemy.isAlive, !isBattleOver else { nextTurn(); return }
        
        let livingParty = party.filter { $0.isAlive }
        guard !livingParty.isEmpty else { return }
        
        let ability = enemy.abilities.randomElement()!
        
        if ability.targetsAll {
            for member in livingParty {
                let damage = calculateDamage(attacker: enemy, defender: member, power: ability.power)
                member.takeDamage(damage)
                effectDelegate?.triggerEffect(characterId: member.id, damage: damage, isEnemy: false)
            }
            battleLog.append("\(enemy.name) uses \(ability.name)! Hits all party members!")
        } else {
            let target = livingParty.randomElement()!
            let damage = calculateDamage(attacker: enemy, defender: target, power: ability.power)
            target.takeDamage(damage)
            effectDelegate?.triggerEffect(characterId: target.id, damage: damage, isEnemy: false)
            battleLog.append("\(enemy.name) uses \(ability.name) on \(target.name) for \(damage) damage!")
        }

        // Nature miracle: enemy (storm) also reduces turns
        if encounterType == .natureMiracle {
            if var ns = natureState {
                ns.turnsRemaining -= 1
                natureState = ns
                if ns.turnsRemaining <= 0 {
                    endNatureMiracleSoftFail()
                    return
                }
            }
        }
        
        checkBattleEnd()
        if !isBattleOver { nextTurn() }
    }
    
    // MARK: - Helpers
    
    var inventory: Inventory?

    func calculateDamage(attacker: GameCharacter, defender: GameCharacter, power: Int) -> Int {
        var atkBonus = 0
        var defBonus = 0
        if let inv = inventory {
            atkBonus = inv.loadout(for: attacker.id).totalAttack()
            defBonus = inv.loadout(for: defender.id).totalDefense()
        }
        let base = Double(power + (attacker.attack + atkBonus) / 2)
        let defense = Double(defender.defense + defBonus) * 0.5
        let variance = Double.random(in: 0.85...1.15)
        let damage = max(1, Int((base - defense) * variance))
        return damage
    }
    
    func nextTurn() {
        currentTurnIndex += 1
        if currentTurnIndex >= turnOrder.count * 100 { currentTurnIndex = 0 }
        advanceToNextLivingTurn()
    }
    
    func checkBattleEnd() {
        // For non-standard encounters, end conditions are handled above
        guard encounterType == .exorcism || encounterType == .healing else { return }

        let allEnemiesDead = enemies.allSatisfy { !$0.isAlive }
        let allApostlesDead = party.filter { $0.characterClass == .apostle }.allSatisfy { !$0.isAlive }

        if allEnemiesDead {
            endVictory()
        } else if allApostlesDead {
            isBattleOver = true
            isVictory = false
            battleLog.append("💔 The disciples' faith has faltered... \"Fear not, only believe.\" — Mark 5:36 (DRB)")
            onBattleEnd?(false)
        }
    }

    private func endVictory() {
        isBattleOver = true
        isVictory = true
        let messages = [
            "✨ \"No man can enter into the house of the strong man, and rob him of his goods, unless he first bind the strong man.\" — Mark 3:27 (DRB)",
            "✨ Victory through faith! \"Have faith in God.\" — Mark 11:22 (DRB)",
            "✨ \"He is risen, he is not here.\" — Mark 16:6 (DRB)",
        ]
        battleLog.append(messages.randomElement()!)
        onFaithGained?(1) // Base faith reward — GameView adds scene-specific bonus
        onBattleEnd?(true)
    }
}
