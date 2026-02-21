import SwiftUI
import SpriteKit

struct BattleView: View {
    @ObservedObject var battleSystem: BattleSystem
    @ObservedObject var gameState: GameState
    let chapter: Chapter
    let onBattleEnd: (Bool) -> Void
    
    @State private var battleScene: BattleScene?
    @State private var showAbilities = false
    @State private var selectedTarget: GameCharacter?
    @State private var selectingTarget = false
    @State private var pendingAbility: Ability?
    @State private var selectingHealTarget = false
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            VStack(spacing: 0) {
                // SpriteKit battle scene
                if let scene = battleScene {
                    SpriteView(scene: scene)
                        .frame(height: UIScreen.main.bounds.height * 0.45)
                        .ignoresSafeArea(edges: .top)
                }
                
                // Scripture display
                if let scripture = battleSystem.showScripture {
                    HStack {
                        Image(systemName: "book.fill")
                            .foregroundColor(.yellow)
                            .font(.system(size: 12))
                        Text(scripture)
                            .font(.custom("Courier", size: 12))
                            .foregroundColor(.yellow)
                            .lineLimit(2)
                    }
                    .padding(8)
                    .frame(maxWidth: .infinity)
                    .background(Color(red: 0.15, green: 0.1, blue: 0.05))
                }
                
                // Party HP/MP display
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        ForEach(battleSystem.party, id: \.id) { member in
                            PartyMemberHUD(character: member,
                                         isActive: battleSystem.currentCharacter?.id == member.id && battleSystem.isPlayerTurn)
                        }
                    }
                    .padding(.horizontal, 8)
                    .padding(.vertical, 6)
                }
                .background(Color(red: 0.05, green: 0.03, blue: 0.1))
                
                // Battle log
                ScrollViewReader { proxy in
                    ScrollView {
                        LazyVStack(alignment: .leading, spacing: 2) {
                            ForEach(Array(battleSystem.battleLog.suffix(5).enumerated()), id: \.offset) { i, log in
                                Text(log)
                                    .font(.custom("Courier", size: 11))
                                    .foregroundColor(.green.opacity(0.8))
                                    .id(i)
                            }
                        }
                        .padding(.horizontal, 8)
                    }
                    .frame(height: 60)
                    .background(Color.black)
                }
                
                // Action menu
                if !battleSystem.isBattleOver {
                    if battleSystem.isPlayerTurn {
                        if selectingTarget {
                            targetSelectionView
                        } else if showAbilities {
                            abilityMenuView
                        } else {
                            mainActionMenu
                        }
                    } else {
                        HStack {
                            Spacer()
                            Text("Enemy turn...")
                                .font(.custom("Courier", size: 16))
                                .foregroundColor(.red)
                            Spacer()
                        }
                        .padding()
                        .background(Color(red: 0.1, green: 0.05, blue: 0.05))
                    }
                } else {
                    // Battle over
                    VStack(spacing: 12) {
                        Text(battleSystem.isVictory ? "✨ VICTORY! ✨" : "💔 Defeated...")
                            .font(.custom("Courier-Bold", size: 24))
                            .foregroundColor(battleSystem.isVictory ? .yellow : .red)
                        
                        RPGButton(title: "Continue") {
                            onBattleEnd(battleSystem.isVictory)
                        }
                    }
                    .padding()
                    .background(Color(red: 0.08, green: 0.05, blue: 0.15))
                }
            }
        }
        .onAppear {
            setupBattle()
        }
    }
    
    var mainActionMenu: some View {
        HStack(spacing: 8) {
            actionButton("⚔️ Attack", color: .red) {
                pendingAbility = nil
                selectingTarget = true
                selectingHealTarget = false
            }
            actionButton("📖 Abilities", color: .blue) {
                showAbilities = true
            }
            actionButton("🛡️ Defend", color: .green) {
                if let current = battleSystem.currentCharacter {
                    battleSystem.executeDefend(source: current)
                }
            }
        }
        .padding(8)
        .background(Color(red: 0.08, green: 0.05, blue: 0.15))
    }
    
    var abilityMenuView: some View {
        VStack(spacing: 4) {
            HStack {
                Text("ABILITIES")
                    .font(.custom("Courier-Bold", size: 14))
                    .foregroundColor(.yellow)
                Spacer()
                Button("Back") { showAbilities = false }
                    .font(.custom("Courier", size: 12))
                    .foregroundColor(.gray)
            }
            .padding(.horizontal, 8)
            
            ScrollView {
                VStack(spacing: 4) {
                    if let current = battleSystem.currentCharacter {
                        ForEach(current.abilities, id: \.id) { ability in
                            Button {
                                pendingAbility = ability
                                showAbilities = false
                                if ability.targetsAll {
                                    battleSystem.executeAbility(source: current, ability: ability, target: battleSystem.enemies.first(where: { $0.isAlive }))
                                } else {
                                    selectingTarget = true
                                    selectingHealTarget = ability.heals
                                }
                            } label: {
                                HStack {
                                    VStack(alignment: .leading, spacing: 2) {
                                        Text(ability.name)
                                            .font(.custom("Courier-Bold", size: 13))
                                            .foregroundColor(.white)
                                        Text(ability.description)
                                            .font(.custom("Courier", size: 10))
                                            .foregroundColor(.gray)
                                            .lineLimit(1)
                                    }
                                    Spacer()
                                    Text("MP: \(ability.mpCost)")
                                        .font(.custom("Courier", size: 11))
                                        .foregroundColor(current.mp >= ability.mpCost ? .cyan : .red)
                                }
                                .padding(6)
                                .background(
                                    RoundedRectangle(cornerRadius: 4)
                                        .fill(Color(red: 0.12, green: 0.08, blue: 0.2))
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 4)
                                                .stroke(Color.white.opacity(0.2), lineWidth: 1)
                                        )
                                )
                            }
                            .disabled(current.mp < ability.mpCost)
                        }
                    }
                }
            }
            .frame(maxHeight: 150)
        }
        .padding(8)
        .background(Color(red: 0.08, green: 0.05, blue: 0.15))
    }
    
    var targetSelectionView: some View {
        VStack(spacing: 4) {
            HStack {
                Text(selectingHealTarget ? "SELECT ALLY" : "SELECT TARGET")
                    .font(.custom("Courier-Bold", size: 14))
                    .foregroundColor(.yellow)
                Spacer()
                Button("Back") {
                    selectingTarget = false
                    pendingAbility = nil
                }
                .font(.custom("Courier", size: 12))
                .foregroundColor(.gray)
            }
            .padding(.horizontal, 8)
            
            let targets = selectingHealTarget
                ? battleSystem.party.filter { $0.isAlive }
                : battleSystem.enemies.filter { $0.isAlive }
            
            HStack(spacing: 8) {
                ForEach(targets, id: \.id) { target in
                    Button {
                        executeOnTarget(target)
                    } label: {
                        VStack(spacing: 4) {
                            Text(target.name)
                                .font(.custom("Courier-Bold", size: 12))
                                .foregroundColor(.white)
                            Text("HP: \(target.hp)/\(target.maxHP)")
                                .font(.custom("Courier", size: 10))
                                .foregroundColor(selectingHealTarget ? .green : .red)
                        }
                        .padding(8)
                        .background(
                            RoundedRectangle(cornerRadius: 4)
                                .fill(Color(red: 0.15, green: 0.1, blue: 0.25))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 4)
                                        .stroke(Color.yellow.opacity(0.5), lineWidth: 1)
                                )
                        )
                    }
                }
            }
        }
        .padding(8)
        .background(Color(red: 0.08, green: 0.05, blue: 0.15))
    }
    
    func actionButton(_ title: String, color: Color, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Text(title)
                .font(.custom("Courier-Bold", size: 14))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 10)
                .background(
                    RoundedRectangle(cornerRadius: 4)
                        .fill(color.opacity(0.3))
                        .overlay(
                            RoundedRectangle(cornerRadius: 4)
                                .stroke(color.opacity(0.6), lineWidth: 1)
                        )
                )
        }
    }
    
    func executeOnTarget(_ target: GameCharacter) {
        guard let current = battleSystem.currentCharacter else { return }
        selectingTarget = false
        
        if let ability = pendingAbility {
            battleSystem.executeAbility(source: current, ability: ability, target: target)
        } else {
            battleSystem.executePlayerAttack(source: current, target: target)
        }
        pendingAbility = nil
        selectingHealTarget = false
    }
    
    func setupBattle() {
        let scene = BattleScene(size: CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 0.45))
        scene.scaleMode = .aspectFill
        scene.battleSystem = battleSystem
        scene.chapterNumber = chapter.number
        battleScene = scene
        
        battleSystem.inventory = gameState.inventory
        battleSystem.startBattle(party: gameState.party, enemies: chapter.battleEnemies)
        battleSystem.onBattleEnd = { victory in
            // handled by button
        }
    }
}

// MARK: - Party Member HUD

struct PartyMemberHUD: View {
    @ObservedObject var character: GameCharacter
    let isActive: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 3) {
            HStack(spacing: 4) {
                if isActive {
                    Text("▶")
                        .font(.system(size: 10))
                        .foregroundColor(.yellow)
                }
                Text(character.name)
                    .font(.custom("Courier-Bold", size: 12))
                    .foregroundColor(character.isAlive ? .white : .gray)
            }
            
            // HP bar
            HStack(spacing: 4) {
                Text("HP")
                    .font(.custom("Courier", size: 9))
                    .foregroundColor(.gray)
                GeometryReader { geo in
                    ZStack(alignment: .leading) {
                        Rectangle()
                            .fill(Color.gray.opacity(0.3))
                        Rectangle()
                            .fill(hpColor)
                            .frame(width: geo.size.width * CGFloat(character.hp) / CGFloat(max(1, character.maxHP)))
                    }
                }
                .frame(width: 60, height: 6)
                .cornerRadius(2)
                Text("\(character.hp)")
                    .font(.custom("Courier", size: 9))
                    .foregroundColor(.white)
                    .frame(width: 30, alignment: .trailing)
            }
            
            // MP bar
            HStack(spacing: 4) {
                Text("MP")
                    .font(.custom("Courier", size: 9))
                    .foregroundColor(.gray)
                GeometryReader { geo in
                    ZStack(alignment: .leading) {
                        Rectangle()
                            .fill(Color.gray.opacity(0.3))
                        Rectangle()
                            .fill(Color.blue)
                            .frame(width: geo.size.width * CGFloat(character.mp) / CGFloat(max(1, character.maxMP)))
                    }
                }
                .frame(width: 60, height: 6)
                .cornerRadius(2)
                Text("\(character.mp)")
                    .font(.custom("Courier", size: 9))
                    .foregroundColor(.white)
                    .frame(width: 30, alignment: .trailing)
            }
        }
        .padding(6)
        .background(
            RoundedRectangle(cornerRadius: 4)
                .fill(isActive ? Color(red: 0.15, green: 0.1, blue: 0.3) : Color(red: 0.08, green: 0.05, blue: 0.15))
                .overlay(
                    RoundedRectangle(cornerRadius: 4)
                        .stroke(isActive ? Color.yellow.opacity(0.6) : Color.clear, lineWidth: 1)
                )
        )
    }
    
    var hpColor: Color {
        let ratio = Double(character.hp) / Double(max(1, character.maxHP))
        if ratio > 0.5 { return .green }
        if ratio > 0.25 { return .yellow }
        return .red
    }
}
