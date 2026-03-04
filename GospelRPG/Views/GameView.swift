import SwiftUI

struct GameView: View {
    @StateObject private var gameState = GameState.load()
    @StateObject private var battleSystem = BattleSystem()

    @State private var currentDialogue: [DialogueLine]?
    @State private var dialogueCompletion: (() -> Void)?
    @State private var showMenu = false
    @State private var actTransitionAct: Int? = nil      // Which act is starting
    @State private var showScriptureMemory = false
    @State private var scripturePrompts: [ScripturePrompt] = []
    @State private var scriptureActNumber = 1
    @State private var showDiscipleCommentary = false
    @State private var discipleComment = ""
    @State private var showFaithGain = false
    @State private var faithGainAmount = 0

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

            case .actTransition:
                if let act = actTransitionAct {
                    ActTransitionView(act: act) {
                        actTransitionAct = nil
                        gameState.currentScreen = .chapterIntro
                    }
                }

            case .scriptureMemory:
                ScripturePromptView(
                    prompts: scripturePrompts,
                    actNumber: scriptureActNumber
                ) { correct, total in
                    // Faith +2 per correct answer (DESIGN.md §3.4)
                    let gain = correct * 2
                    gameState.adjustFaith(gain)
                    gameState.scriptureMemoryCorrect += correct
                    gameState.scriptureMemoryTotal += total
                    showScriptureMemory = false

                    // After Act I scripture memory → start Act II with transition
                    // After Act II scripture memory → start Act III with transition
                    let nextChapter = gameState.currentChapter
                    let nextScene = ChapterData.allChapters()[safe: nextChapter - 1]
                    let nextAct = nextScene?.act ?? 1
                    let previousScene = ChapterData.allChapters()[safe: nextChapter - 2]
                    let previousAct = previousScene?.act ?? 1

                    if nextAct > previousAct {
                        actTransitionAct = nextAct
                        gameState.currentScreen = .actTransition
                    } else {
                        gameState.currentScreen = .chapterIntro
                    }
                }

            case .chapterIntro:
                ChapterIntroView(chapter: currentChapter) {
                    currentDialogue = currentChapter.introDialogue
                    dialogueCompletion = {
                        currentDialogue = nil
                        if currentChapter.hasBattle {
                            gameState.currentScreen = .overworld
                        } else {
                            // No battle — show overworld for exploration, then
                            // trigger post-dialogue when player reaches the end.
                            // For now, show overworld and auto-complete via narrative handler.
                            gameState.currentScreen = .overworld
                        }
                    }
                }

            case .overworld:
                OverworldView(
                    gameState: gameState,
                    chapter: currentChapter,
                    onTrigger: {
                        if currentChapter.hasBattle {
                            gameState.currentScreen = .battle
                        } else {
                            // Narrative-only scene: skip battle, show conclusion
                            handleNarrativeScene()
                        }
                    },
                    onMenu: { showMenu = true }
                )

            case .dialogue:
                OverworldView(
                    gameState: gameState,
                    chapter: currentChapter,
                    onTrigger: {},
                    onMenu: {}
                )

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
                VictoryView(gameState: gameState, chapter: currentChapter) {
                    handleVictory()
                }

            case .gameOver:
                GameOverView(gameState: gameState)

            case .passionNarration:
                PassionNarrationView {
                    // currentChapter was already advanced to 12 before showing narration
                    // Just navigate to chapterIntro for scene 12
                    gameState.currentScreen = .chapterIntro
                }

            case .ending:
                EndingView(gameState: gameState)

            case .menu:
                EmptyView()
            }

            // Dialogue overlay
            if let dialogue = currentDialogue {
                DialogueView(
                    dialogue: dialogue,
                    onComplete: { dialogueCompletion?() },
                    onFaithDelta: { delta in
                        gameState.adjustFaith(delta)
                        if delta != 0 {
                            faithGainAmount = delta
                            withAnimation { showFaithGain = true }
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                                withAnimation { showFaithGain = false }
                            }
                        }
                    }
                )
            }

            // Faith gain notification
            if showFaithGain {
                VStack {
                    HStack {
                        Spacer()
                        Text(faithGainAmount > 0 ? "✨ Faith +\(faithGainAmount)" : "💭 Faith \(faithGainAmount)")
                            .font(.custom("Courier-Bold", size: 14))
                            .foregroundColor(faithGainAmount > 0 ? .yellow : .orange)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(
                                Capsule()
                                    .fill(Color(red: 0.1, green: 0.05, blue: 0.2).opacity(0.9))
                            )
                            .padding(.trailing, 16)
                    }
                    .padding(.top, 60)
                    Spacer()
                }
                .transition(.move(edge: .top).combined(with: .opacity))
                .zIndex(10)
            }

            // Disciple commentary overlay
            if showDiscipleCommentary {
                VStack {
                    Spacer()
                    Text("💬 \(discipleComment)")
                        .font(.custom("Courier", size: 12))
                        .foregroundColor(.white.opacity(0.85))
                        .multilineTextAlignment(.center)
                        .padding(12)
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color(red: 0.08, green: 0.05, blue: 0.15).opacity(0.9))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(Color.yellow.opacity(0.3), lineWidth: 1)
                                )
                        )
                        .padding(.horizontal, 16)
                        .padding(.bottom, 20)
                }
                .transition(.move(edge: .bottom).combined(with: .opacity))
            }

            // Menu overlay
            if showMenu {
                MenuView(gameState: gameState) { showMenu = false }
                    .transition(.move(edge: .trailing))
            }
        }
        .animation(.easeInOut(duration: 0.3), value: gameState.currentScreen)
        .preferredColorScheme(.dark)
        .statusBarHidden(true)
        .onChange(of: gameState.currentScreen) { _, screen in
            switch screen {
            case .title:         MusicEngine.shared.play(theme: .title)
            case .overworld:     MusicEngine.shared.play(theme: .overworld)
            case .battle:        MusicEngine.shared.play(theme: .battle)
            case .victory:       MusicEngine.shared.play(theme: .victory)
            case .chapterIntro:  MusicEngine.shared.play(theme: .title)
            case .actTransition: MusicEngine.shared.play(theme: .title)
            case .passionNarration: MusicEngine.shared.stop()
            case .ending:        MusicEngine.shared.play(theme: .victory)
            case .gameOver:      MusicEngine.shared.stop()
            default: break
            }
        }
        .onAppear {
            MusicEngine.shared.play(theme: .title)
        }
        .onReceive(NotificationCenter.default.publisher(for: UIApplication.didEnterBackgroundNotification)) { _ in
            gameState.save()
        }
    }

    // MARK: - Narrative Scene (no battle)

    func handleNarrativeScene() {
        // Scene 9 (Triumphal Entry) and Scene 12 (Empty Tomb) have no battle
        // Show the scene briefly in overworld, then auto-complete after post-dialogue
        currentDialogue = currentChapter.postBattleDialogue
        dialogueCompletion = {
            currentDialogue = nil
            completeChapter()
        }
    }

    // MARK: - Victory Flow

    func handleVictory() {
        // Restore party
        for member in gameState.party { member.fullRestore() }

        // Apply faith reward for this scene
        let faithGain = currentChapter.faithReward
        gameState.adjustFaith(faithGain)

        // Award chapter rewards
        for item in ItemDB.rewardsForChapter(gameState.currentChapter) {
            gameState.inventory.addItem(item)
        }

        // Show disciple commentary (DESIGN.md §3.2)
        if let comment = currentChapter.discipleCommentary.randomElement(), !comment.isEmpty {
            discipleComment = comment
            withAnimation { showDiscipleCommentary = true }
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.5) {
                withAnimation { showDiscipleCommentary = false }
            }
        }

        // Show post-battle dialogue
        currentDialogue = currentChapter.postBattleDialogue
        dialogueCompletion = {
            currentDialogue = nil

            // Recruit apostles
            for apostle in currentChapter.recruitableApostles {
                if !gameState.party.contains(where: { $0.id == apostle.id }) {
                    gameState.party.append(apostle)
                }
            }

            // Mark complete and save
            if !gameState.chaptersCompleted.contains(gameState.currentChapter) {
                gameState.chaptersCompleted.append(gameState.currentChapter)
            }
            gameState.save()

            completeChapter()
        }
    }

    func completeChapter() {
        let chapters = ChapterData.allChapters()

        // Scripture Memory after Act I climax (Scene 5) and Act II climax (Scene 9)
        if currentChapter.showScriptureMemoryAfter {
            scriptureActNumber = currentChapter.act
            scripturePrompts = ScripturePromptData.promptsForAct(currentChapter.act)
            gameState.currentChapter += 1
            gameState.currentScreen = .scriptureMemory
            return
        }

        // Passion narration after Scene 11 (Gethsemane)
        if currentChapter.number == 11 {
            gameState.currentChapter += 1
            gameState.currentScreen = .passionNarration
            return
        }

        // Advance or end game
        if gameState.currentChapter < chapters.count {
            gameState.currentChapter += 1

            // Check if we're crossing an Act boundary (without scripture memory)
            let nextScene = chapters[safe: gameState.currentChapter - 1]
            let previousScene = chapters[safe: gameState.currentChapter - 2]
            if let nextAct = nextScene?.act, let prevAct = previousScene?.act, nextAct > prevAct {
                actTransitionAct = nextAct
                gameState.currentScreen = .actTransition
            } else {
                gameState.currentScreen = .chapterIntro
            }
        } else {
            // Game complete — show ending
            gameState.currentScreen = .ending
        }
    }

    func handleDefeat() {
        for member in gameState.party { member.fullRestore() }
        gameState.currentScreen = .gameOver
    }
}

// MARK: - Victory Screen

struct VictoryView: View {
    @ObservedObject var gameState: GameState
    let chapter: Chapter
    let onContinue: () -> Void

    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(red: 0.05, green: 0.02, blue: 0.15),
                    Color(red: 0.15, green: 0.1, blue: 0.3),
                    Color(red: 0.05, green: 0.02, blue: 0.15)
                ]),
                startPoint: .top, endPoint: .bottom
            )
            .ignoresSafeArea()

            VStack(spacing: 16) {
                Spacer()
                Text("✝")
                    .font(.system(size: 60))
                    .foregroundColor(.yellow)
                    .shadow(color: .yellow.opacity(0.6), radius: 20)
                Text("GLORY TO GOD!")
                    .font(.custom("Courier-Bold", size: 28))
                    .foregroundColor(.yellow)
                Text("Scene \(chapter.number) Complete")
                    .font(.custom("Courier", size: 16))
                    .foregroundColor(.white.opacity(0.7))

                // Faith display
                HStack(spacing: 8) {
                    Image(systemName: "star.fill")
                        .foregroundColor(.yellow)
                    Text("Party Faith: \(gameState.partyFaith)")
                        .font(.custom("Courier-Bold", size: 14))
                        .foregroundColor(.yellow)
                }
                .padding(.vertical, 4)

                Spacer()
                RPGButton(title: "CONTINUE") { onContinue() }
                Spacer().frame(height: 60)
            }
        }
    }
}

// MARK: - Act Transition Interstitial (DESIGN.md §2.3)

struct ActTransitionView: View {
    let act: Int
    let onContinue: () -> Void

    @State private var showContent = false

    var quoteText: String {
        switch act {
        case 2: return "\"And he began to teach them, that the Son of man must suffer many things... and be killed, and after three days rise again.\""
        case 3: return "\"And they were in the way going up to Jerusalem: and Jesus went before them, and they were astonished, and following were afraid.\""
        default: return "\"The beginning of the gospel of Jesus Christ, the Son of God.\""
        }
    }

    var quoteRef: String {
        switch act {
        case 2: return "— Mark 8:31 (DRB)"
        case 3: return "— Mark 10:32 (DRB)"
        default: return "— Mark 1:1 (DRB)"
        }
    }

    var actTitle: String {
        switch act {
        case 2: return "ACT II — THE ROAD\nThe Cost of Following"
        case 3: return "ACT III — JERUSALEM\nThe Cross and the Empty Tomb"
        default: return "ACT I — GALILEE\nWho Is This Man?"
        }
    }

    var body: some View {
        ZStack {
            Color(red: 0.04, green: 0.02, blue: 0.1).ignoresSafeArea()

            VStack(spacing: 30) {
                Spacer()

                if showContent {
                    Text(actTitle)
                        .font(.custom("Courier-Bold", size: 22))
                        .foregroundColor(.yellow)
                        .multilineTextAlignment(.center)
                        .transition(.opacity)

                    Rectangle()
                        .fill(Color.yellow.opacity(0.4))
                        .frame(width: 80, height: 1)
                        .transition(.opacity)

                    VStack(spacing: 8) {
                        Text(quoteText)
                            .font(.custom("Courier", size: 14))
                            .foregroundColor(.white.opacity(0.85))
                            .multilineTextAlignment(.center)
                            .lineSpacing(6)
                            .padding(.horizontal, 30)
                        Text(quoteRef)
                            .font(.custom("Courier-Bold", size: 13))
                            .foregroundColor(Color(red: 0.8, green: 0.7, blue: 0.4))
                    }
                    .transition(.opacity)

                    Spacer()

                    RPGButton(title: "CONTINUE") { onContinue() }
                        .transition(.opacity)
                }

                Spacer().frame(height: 60)
            }
        }
        .onAppear {
            withAnimation(.easeIn(duration: 1.2).delay(0.5)) { showContent = true }
        }
    }
}

// MARK: - Passion Narration (DESIGN.md §4 Scene 11)
// The trial, scourging, crucifixion, and burial — narrated, not played.

struct PassionNarrationView: View {
    let onComplete: () -> Void

    @State private var currentPage = 0
    @State private var showContent = false

    let pages: [(String, String)] = [
        ("\"And they led Jesus away to the high priest; and all the priests and the scribes and the ancients assembled together.\"",
         "Mark 14:53 (DRB)"),
        ("And Peter denied Him. Three times. Before the cock crowed twice, as Jesus had foretold.\n\n\"And he fell to weeping.\"",
         "Mark 14:72 (DRB)"),
        ("Pilate asked the crowd: \"What will you that I do with the king of the Jews?\" And they cried out again: \"Crucify him.\"",
         "Mark 15:12-13 (DRB)"),
        ("\"And when the sixth hour was come, there was darkness over the whole earth until the ninth hour.\"",
         "Mark 15:33 (DRB)"),
        ("\"And at the ninth hour, Jesus cried out with a loud voice, saying: Eloi, Eloi, lamma sabacthani? Which is, being interpreted, My God, my God, why hast thou forsaken me?\"",
         "Mark 15:34 (DRB)"),
        ("\"And Jesus having cried out with a loud voice, gave up the ghost. And the veil of the temple was rent in two, from the top to the bottom.\"",
         "Mark 15:37-38 (DRB)"),
        ("\"And the centurion who stood over against him, seeing that crying out in this manner he had given up the ghost, said: Indeed this man was the Son of God.\"",
         "Mark 15:39 (DRB)"),
        ("Joseph of Arimathea went to Pilate and begged for the body of Jesus. He wrapped Him in linen and laid Him in a tomb hewn from rock. The stone was rolled over the entrance.\n\nNight fell.",
         "Mark 15:43-46 (DRB)"),
    ]

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            VStack(spacing: 0) {
                // Header
                Text("✝  THE PASSION  ✝")
                    .font(.custom("Courier-Bold", size: 14))
                    .foregroundColor(.gray.opacity(0.6))
                    .padding(.top, 60)

                Spacer()

                if showContent, currentPage < pages.count {
                    VStack(spacing: 20) {
                        Text(pages[currentPage].0)
                            .font(.custom("Courier", size: 16))
                            .foregroundColor(.white.opacity(0.85))
                            .multilineTextAlignment(.center)
                            .lineSpacing(8)
                            .padding(.horizontal, 30)
                            .transition(.opacity)

                        Text(pages[currentPage].1)
                            .font(.custom("Courier-Bold", size: 12))
                            .foregroundColor(Color(red: 0.6, green: 0.55, blue: 0.4))
                            .transition(.opacity)
                    }
                    .id(currentPage)
                    .transition(.opacity)
                }

                Spacer()

                // Navigation
                HStack {
                    if currentPage > 0 {
                        Button("← Back") {
                            withAnimation { currentPage -= 1 }
                        }
                        .font(.custom("Courier", size: 13))
                        .foregroundColor(.gray)
                    }
                    Spacer()
                    if currentPage < pages.count - 1 {
                        Button("Continue →") {
                            withAnimation { currentPage += 1 }
                        }
                        .font(.custom("Courier", size: 13))
                        .foregroundColor(.white.opacity(0.7))
                    } else {
                        Button("Go to Scene 12 →") {
                            onComplete()
                        }
                        .font(.custom("Courier-Bold", size: 14))
                        .foregroundColor(Color(red: 0.8, green: 0.7, blue: 0.4))
                    }
                }
                .padding(.horizontal, 30)
                .padding(.bottom, 50)

                // Page indicator
                HStack(spacing: 6) {
                    ForEach(0..<pages.count, id: \.self) { i in
                        Circle()
                            .fill(i == currentPage ? Color.white.opacity(0.6) : Color.white.opacity(0.15))
                            .frame(width: 5, height: 5)
                    }
                }
                .padding(.bottom, 20)
            }
        }
        .onAppear {
            withAnimation(.easeIn(duration: 1.0).delay(0.5)) { showContent = true }
        }
    }
}

// MARK: - Ending View (DESIGN.md §3.3 — three Faith-based endings)

struct EndingView: View {
    @ObservedObject var gameState: GameState
    @State private var showContent = false
    @State private var showCredits = false

    var endingTier: Int {
        if gameState.partyFaith < 20 { return 1 }
        if gameState.partyFaith <= 40 { return 2 }
        return 3
    }

    var endingText: String {
        switch endingTier {
        case 1:
            return "\"And going out, they fled from the sepulchre, for a trembling and fear had seized them: and they said nothing to any man; for they were afraid.\"\n— Mark 16:8 (DRB)\n\nThe women left in fear. But fear is not the end of the story.\n\nWill you be afraid, or will you tell others what you have seen?"
        case 2:
            return "\"He is risen, he is not here, behold the place where they laid him.\"\n— Mark 16:6 (DRB)\n\nHe is risen. The disciples marvelled. The world was changed forever.\n\nGo and tell someone what you have witnessed."
        default:
            return "\"Go ye into the whole world, and preach the gospel to every creature.\"\n— Mark 16:15 (DRB)\n\nYou have walked from Galilee to the empty tomb. You have seen who Jesus is.\n\nNow go. Tell them. The whole world is waiting."
        }
    }

    var endingTitle: String {
        switch endingTier {
        case 1: return "\"They were afraid.\""
        case 2: return "\"He is risen!\""
        default: return "\"Go into all the world.\""
        }
    }

    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: endingTier == 3 ?
                    [Color(red: 0.6, green: 0.4, blue: 0.1), Color(red: 0.3, green: 0.2, blue: 0.05)] :
                    [Color(red: 0.05, green: 0.02, blue: 0.15), Color(red: 0.1, green: 0.07, blue: 0.25)]),
                startPoint: .top, endPoint: .bottom
            )
            .ignoresSafeArea()

            if !showCredits {
                VStack(spacing: 24) {
                    Spacer()

                    Text("✝")
                        .font(.system(size: 70))
                        .foregroundColor(endingTier == 3 ? Color(red: 0.95, green: 0.85, blue: 0.4) : .white)
                        .shadow(color: .yellow.opacity(0.5), radius: 20)

                    if showContent {
                        Text(endingTitle)
                            .font(.custom("Courier-Bold", size: 22))
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 20)
                            .transition(.opacity)

                        Text(endingText)
                            .font(.custom("Courier", size: 14))
                            .foregroundColor(.white.opacity(0.85))
                            .multilineTextAlignment(.center)
                            .lineSpacing(6)
                            .padding(.horizontal, 24)
                            .transition(.opacity)

                        Spacer()

                        // Faith score summary
                        VStack(spacing: 6) {
                            Text("Party Faith: \(gameState.partyFaith)")
                                .font(.custom("Courier-Bold", size: 16))
                                .foregroundColor(.yellow)
                            Text("Scripture Memory: \(gameState.scriptureMemoryCorrect)/\(gameState.scriptureMemoryTotal)")
                                .font(.custom("Courier", size: 13))
                                .foregroundColor(.white.opacity(0.7))
                        }
                        .padding(.bottom, 20)
                        .transition(.opacity)

                        RPGButton(title: "CREDITS") { withAnimation { showCredits = true } }
                            .transition(.opacity)
                    }

                    Spacer().frame(height: 40)
                }
                .transition(.opacity)
            } else {
                CreditsView(gameState: gameState)
                    .transition(.opacity)
            }
        }
        .onAppear {
            withAnimation(.easeIn(duration: 1.5).delay(1.0)) { showContent = true }
        }
    }
}

// MARK: - Credits View

struct CreditsView: View {
    @ObservedObject var gameState: GameState
    @State private var scrollOffset: CGFloat = 800

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            ScrollView {
                VStack(spacing: 20) {
                    Spacer().frame(height: 100)

                    Text("GOSPEL QUEST")
                        .font(.custom("Courier-Bold", size: 32))
                        .foregroundColor(.yellow)
                    Text("The Mark of Faith")
                        .font(.custom("Courier-Bold", size: 18))
                        .foregroundColor(Color(red: 0.8, green: 0.7, blue: 0.4))

                    Rectangle()
                        .fill(Color.yellow.opacity(0.4))
                        .frame(width: 100, height: 1)

                    VStack(spacing: 6) {
                        Text("\"Go ye into the whole world,")
                            .font(.custom("Courier", size: 14))
                            .foregroundColor(.white.opacity(0.8))
                        Text("and preach the gospel to every creature.\"")
                            .font(.custom("Courier", size: 14))
                            .foregroundColor(.white.opacity(0.8))
                        Text("— Mark 16:15 (DRB)")
                            .font(.custom("Courier-Bold", size: 13))
                            .foregroundColor(Color(red: 0.8, green: 0.7, blue: 0.4))
                    }

                    Spacer().frame(height: 20)

                    creditSection("GAME DESIGN", "Philip Neri")
                    creditSection("ENGINEERING", "Augustine (Engineering Director)")
                    creditSection("IMPLEMENTATION", "Luke (iOS Developer)")
                    creditSection("THEOLOGY REVIEW", "Bellarmine (Theologian)")
                    creditSection("ART DIRECTION", "Giotto")
                    creditSection("SACRED MUSIC DIRECTION", "Palestrina")
                    creditSection("QUALITY ASSURANCE", "Cyprian")
                    creditSection("SECURITY REVIEW", "Athanasius")
                    creditSection("PROJECT OVERSIGHT", "Polycarp")
                    creditSection("SCRIPTURE", "The Douay-Rheims Bible (1899 American Edition)")

                    Spacer().frame(height: 20)

                    VStack(spacing: 6) {
                        Text("Your Scripture Memory Score:")
                            .font(.custom("Courier", size: 13))
                            .foregroundColor(.gray)
                        Text("\(gameState.scriptureMemoryCorrect) / \(gameState.scriptureMemoryTotal) correct")
                            .font(.custom("Courier-Bold", size: 16))
                            .foregroundColor(.yellow)
                        Text("Party Faith: \(gameState.partyFaith)")
                            .font(.custom("Courier-Bold", size: 14))
                            .foregroundColor(.green)
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.yellow.opacity(0.3), lineWidth: 1)
                    )

                    Spacer().frame(height: 20)

                    Text("Ad maiorem Dei gloriam")
                        .font(.custom("Courier", size: 12))
                        .foregroundColor(.gray.opacity(0.6))
                        .italic()

                    Spacer().frame(height: 100)
                }
                .frame(maxWidth: .infinity)
            }
        }
    }

    func creditSection(_ role: String, _ name: String) -> some View {
        VStack(spacing: 2) {
            Text(role)
                .font(.custom("Courier", size: 11))
                .foregroundColor(.gray)
            Text(name)
                .font(.custom("Courier-Bold", size: 14))
                .foregroundColor(.white)
        }
        .padding(.vertical, 4)
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

                Text("The disciples' faith has faltered...")
                    .font(.custom("Courier-Bold", size: 22))
                    .foregroundColor(.red)

                Text("But the Lord's power is never diminished!")
                    .font(.custom("Courier", size: 16))
                    .foregroundColor(.white)

                VStack(spacing: 4) {
                    Text("\"Fear not, only believe.\"")
                        .font(.custom("Courier", size: 13))
                        .foregroundColor(.gray)
                    Text("— Mark 5:36 (DRB)")
                        .font(.custom("Courier-Bold", size: 12))
                        .foregroundColor(.yellow)
                }
                .padding(.vertical)

                Spacer()

                RPGButton(title: "TRY AGAIN") {
                    for member in gameState.party { member.fullRestore() }
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

// MARK: - Safe Collection Subscript

extension Array {
    subscript(safe index: Int) -> Element? {
        guard index >= 0, index < count else { return nil }
        return self[index]
    }
}
