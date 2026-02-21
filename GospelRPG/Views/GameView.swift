import SwiftUI

struct GameView: View {
    @StateObject private var gameState = GameState()
    @StateObject private var battleSystem = BattleSystem()
    
    @State private var currentDialogue: [DialogueLine]?
    @State private var dialogueCompletion: (() -> Void)?
    @State private var showMenu = false
    @State private var overworldBridge: OverworldBridge?
    
    var currentChapter: Chapter {
        let chapters = ChapterData.allChapters()
        let idx = min(gameState.currentChapter - 1, chapters.count - 1)
        return chapters[max(0, idx)]
    }
    
    var body: some View {
        ZStack {
            switch gameState.currentScreen {
            case .title:
                TitleScreenView(gameState: gameState)
                
            case .chapterIntro:
                ChapterIntroView(chapter: currentChapter) {
                    // Show intro dialogue
                    currentDialogue = currentChapter.introDialogue
                    dialogueCompletion = {
                        currentDialogue = nil
                        gameState.currentScreen = .overworld
                    }
                    gameState.currentScreen = .dialogue
                }
                
            case .overworld:
                OverworldView(
                    gameState: gameState,
                    chapter: currentChapter,
                    onTrigger: {
                        // Start battle
                        gameState.currentScreen = .battle
                    },
                    onMenu: {
                        showMenu = true
                    }
                )
                
            case .dialogue:
                if let dialogue = currentDialogue {
                    // Show a dark background behind dialogue
                    Color.black.ignoresSafeArea()
                    DialogueView(dialogue: dialogue) {
                        dialogueCompletion?()
                    }
                }
                
            case .battle:
                BattleView(
                    battleSystem: battleSystem,
                    gameState: gameState,
                    chapter: currentChapter
                ) { victory in
                    if victory {
                        handleVictory()
                    } else {
                        handleDefeat()
                    }
                }
                
            case .victory:
                // Victory celebration screen
                ZStack {
                    LinearGradient(
                        gradient: Gradient(colors: [
                            Color(red: 0.05, green: 0.02, blue: 0.15),
                            Color(red: 0.15, green: 0.1, blue: 0.3),
                            Color(red: 0.05, green: 0.02, blue: 0.15)
                        ]),
                        startPoint: .top,
                        endPoint: .bottom
                    )
                    .ignoresSafeArea()

                    VStack(spacing: 20) {
                        Spacer()
                        Text("✝")
                            .font(.system(size: 60))
                            .foregroundColor(.yellow)
                            .shadow(color: .yellow.opacity(0.6), radius: 20)
                        Text("GLORY TO GOD!")
                            .font(.custom("Courier-Bold", size: 28))
                            .foregroundColor(.yellow)
                        Text("Chapter \(gameState.currentChapter) Complete")
                            .font(.custom("Courier", size: 16))
                            .foregroundColor(.white.opacity(0.7))
                        Spacer()
                        RPGButton(title: "CONTINUE") {
                            handleVictory()
                        }
                        Spacer().frame(height: 60)
                    }
                }
                
            case .gameOver:
                GameOverView(gameState: gameState)
                
            case .menu:
                EmptyView()
            }
            
            // Menu overlay
            if showMenu {
                MenuView(gameState: gameState) {
                    showMenu = false
                }
                .transition(.move(edge: .trailing))
            }
        }
        .animation(.easeInOut(duration: 0.3), value: gameState.currentScreen)
        .preferredColorScheme(.dark)
        .statusBarHidden(true)
    }
    
    func handleVictory() {
        // Heal party
        for member in gameState.party {
            member.fullRestore()
        }

        // Award chapter rewards
        for item in ItemDB.rewardsForChapter(gameState.currentChapter) {
            gameState.inventory.addItem(item)
        }

        // Show post-battle dialogue
        currentDialogue = currentChapter.postBattleDialogue
        dialogueCompletion = {
            currentDialogue = nil
            
            // Recruit apostles if available
            for apostle in currentChapter.recruitableApostles {
                gameState.party.append(apostle)
            }
            
            // Mark chapter complete
            if !gameState.chaptersCompleted.contains(gameState.currentChapter) {
                gameState.chaptersCompleted.append(gameState.currentChapter)
            }
            
            // Advance to next chapter or end
            let chapters = ChapterData.allChapters()
            if gameState.currentChapter < chapters.count {
                gameState.currentChapter += 1
                gameState.currentScreen = .chapterIntro
            } else {
                // Game complete!
                gameState.currentScreen = .title
            }
        }
        gameState.currentScreen = .dialogue
    }
    
    func handleDefeat() {
        // Restore party and let them retry
        for member in gameState.party {
            member.fullRestore()
        }
        gameState.currentScreen = .gameOver
    }
}

// MARK: - Game Over View

struct GameOverView: View {
    @ObservedObject var gameState: GameState
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            VStack(spacing: 24) {
                Spacer()
                
                Text("💔")
                    .font(.system(size: 60))
                
                Text("The party has fallen...")
                    .font(.custom("Courier-Bold", size: 22))
                    .foregroundColor(.red)
                
                Text("But God's plan cannot be stopped!")
                    .font(.custom("Courier", size: 16))
                    .foregroundColor(.white)
                
                VStack(spacing: 4) {
                    Text("\"Be strong and courageous.")
                        .font(.custom("Courier", size: 13))
                        .foregroundColor(.gray)
                    Text("Do not be afraid; do not be discouraged,")
                        .font(.custom("Courier", size: 13))
                        .foregroundColor(.gray)
                    Text("for the Lord your God will be with you")
                        .font(.custom("Courier", size: 13))
                        .foregroundColor(.gray)
                    Text("wherever you go.\"")
                        .font(.custom("Courier", size: 13))
                        .foregroundColor(.gray)
                    Text("— Joshua 1:9")
                        .font(.custom("Courier-Bold", size: 12))
                        .foregroundColor(.yellow)
                }
                .padding(.vertical)
                
                Spacer()
                
                RPGButton(title: "TRY AGAIN") {
                    gameState.currentScreen = .chapterIntro
                }
                
                RPGButton(title: "TITLE SCREEN") {
                    gameState.currentScreen = .title
                }
                
                Spacer().frame(height: 40)
            }
        }
    }
}
