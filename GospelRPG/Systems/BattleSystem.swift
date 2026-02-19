import Foundation

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
    
    var onBattleEnd: ((Bool) -> Void)?
    
    func startBattle(party: [GameCharacter], enemies: [GameCharacter]) {
        self.party = party
        self.enemies = enemies
        self.battleLog = ["⚔️ Battle Start!"]
        self.isBattleOver = false
        self.isVictory = false
        
        // Build turn order by speed
        turnOrder = (party + enemies).sorted { $0.speed > $1.speed }
        currentTurnIndex = 0
        advanceToNextLivingTurn()
    }
    
    func advanceToNextLivingTurn() {
        guard !isBattleOver else { return }
        
        // Find next living character
        var attempts = 0
        while attempts < turnOrder.count {
            let current = turnOrder[currentTurnIndex % turnOrder.count]
            if current.isAlive {
                isPlayerTurn = current.characterClass != .demon
                if !isPlayerTurn {
                    // Auto-execute enemy turn after a small delay
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
        target.takeDamage(damage)
        battleLog.append("\(source.name) strikes \(target.name) for \(damage) damage!")
        
        checkBattleEnd()
        if !isBattleOver {
            nextTurn()
        }
    }
    
    func executeAbility(source: GameCharacter, ability: Ability, target: GameCharacter?) {
        guard source.useMP(ability.mpCost) else {
            battleLog.append("\(source.name) doesn't have enough MP!")
            return
        }
        
        // Show scripture reference
        if let ref = ability.scriptureRef {
            showScripture = "\(ref): \(ability.description)"
        }
        
        if ability.heals {
            if ability.targetsAll {
                let healAmount = ability.power + source.faith / 2
                for member in party where member.isAlive {
                    member.heal(healAmount)
                }
                battleLog.append("\(source.name) uses \(ability.name)! Party healed for \(healAmount) HP!")
            } else if let target = target {
                let healAmount = ability.power + source.faith / 2
                target.heal(healAmount)
                battleLog.append("\(source.name) uses \(ability.name) on \(target.name)! Healed \(healAmount) HP!")
            }
        } else {
            let faithBonus = source.faith / 3
            if ability.targetsAll {
                for enemy in enemies where enemy.isAlive {
                    let damage = calculateDamage(attacker: source, defender: enemy, power: ability.power + faithBonus)
                    enemy.takeDamage(damage)
                    battleLog.append("\(ability.name) hits \(enemy.name) for \(damage)!")
                }
            } else if let target = target {
                let damage = calculateDamage(attacker: source, defender: target, power: ability.power + faithBonus)
                target.takeDamage(damage)
                battleLog.append("\(source.name): \"\(ability.description)\" — \(damage) damage to \(target.name)!")
            }
        }
        
        checkBattleEnd()
        if !isBattleOver {
            // Clear scripture after a moment
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                self.showScripture = nil
            }
            nextTurn()
        }
    }
    
    func executeDefend(source: GameCharacter) {
        source.defense += 5
        battleLog.append("\(source.name) defends! Defense increased.")
        nextTurn()
    }
    
    // MARK: - Enemy AI
    
    func executeEnemyTurn(enemy: GameCharacter) {
        guard enemy.isAlive, !isBattleOver else {
            nextTurn()
            return
        }
        
        let livingParty = party.filter { $0.isAlive }
        guard !livingParty.isEmpty else { return }
        
        // Pick a random ability
        let ability = enemy.abilities.randomElement()!
        
        if ability.targetsAll {
            for member in livingParty {
                let damage = calculateDamage(attacker: enemy, defender: member, power: ability.power)
                member.takeDamage(damage)
            }
            battleLog.append("\(enemy.name) uses \(ability.name)! Hits all party members!")
        } else {
            let target = livingParty.randomElement()!
            let damage = calculateDamage(attacker: enemy, defender: target, power: ability.power)
            target.takeDamage(damage)
            battleLog.append("\(enemy.name) uses \(ability.name) on \(target.name) for \(damage) damage!")
        }
        
        checkBattleEnd()
        if !isBattleOver {
            nextTurn()
        }
    }
    
    // MARK: - Helpers
    
    /// Reference to inventory for equipment bonuses (set before battle)
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
        if currentTurnIndex >= turnOrder.count * 100 {
            currentTurnIndex = 0 // Prevent overflow
        }
        advanceToNextLivingTurn()
    }
    
    func checkBattleEnd() {
        let allEnemiesDead = enemies.allSatisfy { !$0.isAlive }
        let allPartyDead = party.allSatisfy { !$0.isAlive }
        
        if allEnemiesDead {
            isBattleOver = true
            isVictory = true
            let messages = [
                "✨ Victory! \"Submit yourselves to God. Resist the devil, and he will flee from you.\" — James 4:7",
                "✨ Victory! The power of God prevails! \"No weapon formed against you shall prosper.\" — Isaiah 54:17",
                "✨ Victory! \"Thanks be to God! He gives us the victory through our Lord Jesus Christ.\" — 1 Cor 15:57",
            ]
            battleLog.append(messages.randomElement()!)
            onBattleEnd?(true)
        } else if allPartyDead {
            isBattleOver = true
            isVictory = false
            battleLog.append("💔 The party has fallen... \"Be strong and courageous, for the Lord your God is with you.\" — Joshua 1:9")
            onBattleEnd?(false)
        }
    }
}
