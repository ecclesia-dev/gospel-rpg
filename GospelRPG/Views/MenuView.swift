import SwiftUI

struct MenuView: View {
    @ObservedObject var gameState: GameState
    let onClose: () -> Void
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.85)
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Header
                HStack {
                    Text("📜 PARTY STATUS")
                        .font(.custom("Courier-Bold", size: 20))
                        .foregroundColor(.yellow)
                    Spacer()
                    Button(action: onClose) {
                        Text("✕")
                            .font(.system(size: 24))
                            .foregroundColor(.gray)
                    }
                }
                .padding()
                
                // Chapter info
                HStack {
                    Text("Chapter \(gameState.currentChapter)")
                        .font(.custom("Courier", size: 14))
                        .foregroundColor(.white.opacity(0.7))
                    Spacer()
                }
                .padding(.horizontal)
                
                Divider().background(Color.yellow.opacity(0.3))
                    .padding(.vertical, 8)
                
                // Party members
                ScrollView {
                    VStack(spacing: 12) {
                        ForEach(gameState.party, id: \.id) { member in
                            PartyMemberCard(character: member, inventory: gameState.inventory)
                        }

                        // Inventory section
                        if !gameState.inventory.items.isEmpty {
                            Divider().background(Color.yellow.opacity(0.3))
                                .padding(.vertical, 4)

                            HStack {
                                Text("🎒 INVENTORY")
                                    .font(.custom("Courier-Bold", size: 16))
                                    .foregroundColor(.yellow)
                                Spacer()
                            }

                            ForEach(gameState.inventory.items, id: \.id) { item in
                                InventoryItemRow(item: item, gameState: gameState)
                            }
                        }
                    }
                    .padding(.horizontal)
                }
                
                Spacer()
                
                // Scripture of encouragement
                VStack(spacing: 4) {
                    Text("\"For I am convinced that neither death nor life,")
                        .font(.custom("Courier", size: 11))
                        .foregroundColor(.gray)
                    Text("neither angels nor demons... will be able to separate")
                        .font(.custom("Courier", size: 11))
                        .foregroundColor(.gray)
                    Text("us from the love of God.\"")
                        .font(.custom("Courier", size: 11))
                        .foregroundColor(.gray)
                    Text("— Romans 8:38-39")
                        .font(.custom("Courier-Bold", size: 11))
                        .foregroundColor(.yellow.opacity(0.7))
                }
                .padding()
            }
        }
    }
}

// MARK: - Inventory Item Row

struct InventoryItemRow: View {
    let item: Item
    @ObservedObject var gameState: GameState
    @State private var showEquipPicker = false

    var body: some View {
        HStack(spacing: 8) {
            Text(item.icon)
                .font(.system(size: 20))
            VStack(alignment: .leading, spacing: 2) {
                Text(item.name)
                    .font(.custom("Courier-Bold", size: 13))
                    .foregroundColor(.white)
                Text(item.description)
                    .font(.custom("Courier", size: 10))
                    .foregroundColor(.gray)
                    .lineLimit(1)
            }
            Spacer()
            if item.slot != nil {
                Text(item.slot!.rawValue)
                    .font(.custom("Courier", size: 9))
                    .foregroundColor(.cyan.opacity(0.7))
            } else if item.healAmount > 0 {
                Text("+\(item.healAmount) HP")
                    .font(.custom("Courier", size: 10))
                    .foregroundColor(.green)
            }
        }
        .padding(8)
        .background(
            RoundedRectangle(cornerRadius: 4)
                .fill(Color(red: 0.1, green: 0.07, blue: 0.2))
                .overlay(
                    RoundedRectangle(cornerRadius: 4)
                        .stroke(Color.white.opacity(0.15), lineWidth: 1)
                )
        )
    }
}

struct PartyMemberCard: View {
    @ObservedObject var character: GameCharacter
    var inventory: Inventory? = nil
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                // Color indicator
                RoundedRectangle(cornerRadius: 2)
                    .fill(Color(character.primaryColor))
                    .frame(width: 8, height: 40)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(character.name)
                        .font(.custom("Courier-Bold", size: 16))
                        .foregroundColor(.white)
                    Text(character.title)
                        .font(.custom("Courier", size: 12))
                        .foregroundColor(.yellow.opacity(0.7))
                }
                
                Spacer()
                
                Text("Lv. \(character.level)")
                    .font(.custom("Courier-Bold", size: 14))
                    .foregroundColor(.white)
            }
            
            // Stats
            HStack(spacing: 16) {
                statView("HP", current: character.hp, max: character.maxHP, color: .green)
                statView("MP", current: character.mp, max: character.maxMP, color: .blue)
            }
            
            HStack(spacing: 12) {
                miniStat("ATK", value: character.attack)
                miniStat("DEF", value: character.defense)
                miniStat("SPD", value: character.speed)
                miniStat("FTH", value: character.faith)
            }
            
            // Equipment
            if let inv = inventory {
                let loadout = inv.loadout(for: character.id)
                let equipped = [loadout.weapon, loadout.body, loadout.feet, loadout.accessory].compactMap { $0 }
                if !equipped.isEmpty {
                    HStack(spacing: 4) {
                        ForEach(equipped, id: \.id) { item in
                            Text("\(item.icon)\(item.name)")
                                .font(.custom("Courier", size: 9))
                                .foregroundColor(.yellow.opacity(0.8))
                                .padding(.horizontal, 4)
                                .padding(.vertical, 2)
                                .background(
                                    RoundedRectangle(cornerRadius: 2)
                                        .stroke(Color.yellow.opacity(0.3), lineWidth: 1)
                                )
                        }
                    }
                }
            }

            // Abilities
            HStack(spacing: 4) {
                ForEach(character.abilities, id: \.id) { ability in
                    Text(ability.name)
                        .font(.custom("Courier", size: 9))
                        .foregroundColor(.cyan.opacity(0.7))
                        .padding(.horizontal, 4)
                        .padding(.vertical, 2)
                        .background(
                            RoundedRectangle(cornerRadius: 2)
                                .stroke(Color.cyan.opacity(0.3), lineWidth: 1)
                        )
                }
            }
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 6)
                .fill(Color(red: 0.1, green: 0.07, blue: 0.2))
                .overlay(
                    RoundedRectangle(cornerRadius: 6)
                        .stroke(Color.white.opacity(0.15), lineWidth: 1)
                )
        )
    }
    
    func statView(_ label: String, current: Int, max: Int, color: Color) -> some View {
        VStack(alignment: .leading, spacing: 2) {
            Text("\(label): \(current)/\(max)")
                .font(.custom("Courier", size: 11))
                .foregroundColor(.white)
            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    Rectangle().fill(Color.gray.opacity(0.3))
                    Rectangle().fill(color)
                        .frame(width: geo.size.width * CGFloat(current) / CGFloat(Swift.max(1, max)))
                }
            }
            .frame(height: 5)
            .cornerRadius(2)
        }
        .frame(maxWidth: .infinity)
    }
    
    func miniStat(_ label: String, value: Int) -> some View {
        VStack(spacing: 1) {
            Text(label)
                .font(.custom("Courier", size: 9))
                .foregroundColor(.gray)
            Text("\(value)")
                .font(.custom("Courier-Bold", size: 12))
                .foregroundColor(.white)
        }
    }
}
