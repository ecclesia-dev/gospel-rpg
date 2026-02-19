import SwiftUI
import SpriteKit

struct TitleScreenView: View {
    @ObservedObject var gameState: GameState
    @State private var showTitle = false
    @State private var showSubtitle = false
    @State private var showButtons = false
    @State private var crossGlow: Double = 0.5
    
    var body: some View {
        ZStack {
            // Background
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(red: 0.05, green: 0.02, blue: 0.15),
                    Color(red: 0.1, green: 0.05, blue: 0.25),
                    Color(red: 0.05, green: 0.02, blue: 0.15)
                ]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            // Starfield
            StarFieldView()
            
            VStack(spacing: 0) {
                Spacer()
                
                // Cross symbol
                Text("✝")
                    .font(.system(size: 80))
                    .foregroundColor(.yellow)
                    .opacity(crossGlow)
                    .shadow(color: .yellow.opacity(0.6), radius: 20)
                    .onAppear {
                        withAnimation(.easeInOut(duration: 2.0).repeatForever(autoreverses: true)) {
                            crossGlow = 1.0
                        }
                    }
                
                // Title
                if showTitle {
                    VStack(spacing: 4) {
                        Text("GOSPEL QUEST")
                            .font(.custom("Courier-Bold", size: 36))
                            .foregroundColor(.white)
                            .shadow(color: .yellow.opacity(0.5), radius: 10)
                        
                        Text("THE MARK OF FAITH")
                            .font(.custom("Courier-Bold", size: 18))
                            .foregroundColor(Color(red: 0.9, green: 0.8, blue: 0.4))
                            .shadow(color: .orange.opacity(0.3), radius: 5)
                    }
                    .transition(.opacity)
                }
                
                Spacer().frame(height: 20)
                
                // Subtitle
                if showSubtitle {
                    VStack(spacing: 8) {
                        Text("\"He even gives orders to impure spirits")
                            .font(.custom("Courier", size: 13))
                            .foregroundColor(.gray)
                        Text("and they obey him.\"")
                            .font(.custom("Courier", size: 13))
                            .foregroundColor(.gray)
                        Text("— Mark 1:27")
                            .font(.custom("Courier-Bold", size: 12))
                            .foregroundColor(Color(red: 0.8, green: 0.7, blue: 0.4))
                    }
                    .transition(.opacity)
                    .padding(.horizontal, 40)
                }
                
                Spacer()
                
                // Buttons
                if showButtons {
                    VStack(spacing: 16) {
                        RPGButton(title: "NEW JOURNEY") {
                            startNewGame()
                        }
                        
                        if !gameState.chaptersCompleted.isEmpty {
                            RPGButton(title: "CONTINUE") {
                                gameState.currentScreen = .chapterIntro
                            }
                        }
                    }
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                }
                
                Spacer().frame(height: 60)
                
                Text("A Bible Learning Adventure")
                    .font(.custom("Courier", size: 11))
                    .foregroundColor(.gray.opacity(0.5))
                    .padding(.bottom, 20)
            }
        }
        .onAppear {
            withAnimation(.easeIn(duration: 1.0).delay(0.5)) { showTitle = true }
            withAnimation(.easeIn(duration: 1.0).delay(1.5)) { showSubtitle = true }
            withAnimation(.easeIn(duration: 0.8).delay(2.5)) { showButtons = true }
        }
    }
    
    func startNewGame() {
        gameState.party = [CharacterFactory.jesus(), CharacterFactory.simon()]
        gameState.currentChapter = 1
        gameState.chaptersCompleted = []
        gameState.inventory = Inventory()
        for item in ItemDB.starterItems {
            gameState.inventory.addItem(item)
        }
        // Auto-equip Jesus with starter gear
        _ = gameState.inventory.equipItem(ItemDB.shepherdStaff, on: "jesus")
        _ = gameState.inventory.equipItem(ItemDB.roughCloak, on: "jesus")
        _ = gameState.inventory.equipItem(ItemDB.leatherSandals, on: "simon")
        gameState.currentScreen = .chapterIntro
    }
}

// MARK: - RPG Button

struct RPGButton: View {
    let title: String
    let action: () -> Void
    @State private var isPressed = false
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.custom("Courier-Bold", size: 18))
                .foregroundColor(.white)
                .frame(width: 220, height: 44)
                .background(
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color(red: 0.2, green: 0.15, blue: 0.4))
                        .overlay(
                            RoundedRectangle(cornerRadius: 4)
                                .stroke(Color.yellow.opacity(0.6), lineWidth: 2)
                        )
                )
                .shadow(color: .yellow.opacity(0.2), radius: 5)
        }
        .scaleEffect(isPressed ? 0.95 : 1.0)
    }
}

// MARK: - Starfield

struct StarFieldView: View {
    @State private var stars: [(CGFloat, CGFloat, CGFloat, Double)] = {
        (0..<40).map { _ in
            (CGFloat.random(in: 0...1), CGFloat.random(in: 0...1),
             CGFloat.random(in: 1...3), Double.random(in: 0.3...1.0))
        }
    }()
    
    var body: some View {
        GeometryReader { geo in
            ForEach(0..<stars.count, id: \.self) { i in
                Circle()
                    .fill(Color.white)
                    .frame(width: stars[i].2, height: stars[i].2)
                    .position(x: stars[i].0 * geo.size.width, y: stars[i].1 * geo.size.height)
                    .opacity(stars[i].3)
            }
        }
    }
}
