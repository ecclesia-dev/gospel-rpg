import SwiftUI

// MARK: - Scripture Memory Mini-Game (DESIGN.md §3.4)

struct ScripturePromptView: View {
    let prompts: [ScripturePrompt]
    let actNumber: Int
    let onComplete: (Int, Int) -> Void   // (correct, total) → updates GameState

    @State private var currentIndex = 0
    @State private var answered = false
    @State private var selectedAnswer: String? = nil
    @State private var shuffledOptions: [String] = []
    @State private var correctCount = 0
    @State private var showAffirmation = false
    @State private var canSkip = false

    var currentPrompt: ScripturePrompt? {
        guard currentIndex < prompts.count else { return nil }
        return prompts[currentIndex]
    }

    var body: some View {
        ZStack {
            // Background — dark parchment
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(red: 0.08, green: 0.05, blue: 0.12),
                    Color(red: 0.12, green: 0.08, blue: 0.18),
                    Color(red: 0.08, green: 0.05, blue: 0.12),
                ]),
                startPoint: .top, endPoint: .bottom
            )
            .ignoresSafeArea()

            VStack(spacing: 0) {

                // Header
                VStack(spacing: 6) {
                    Text("📖 SCRIPTURE MEMORY")
                        .font(.custom("Courier-Bold", size: 14))
                        .foregroundColor(.yellow.opacity(0.8))
                    Text("Act \(actToRomanNumeral(actNumber)) Review")
                        .font(.custom("Courier", size: 12))
                        .foregroundColor(.gray)
                    
                    // Progress dots
                    HStack(spacing: 8) {
                        ForEach(0..<prompts.count, id: \.self) { i in
                            Circle()
                                .fill(i < currentIndex ? Color.green : (i == currentIndex ? Color.yellow : Color.gray.opacity(0.4)))
                                .frame(width: 8, height: 8)
                        }
                    }
                    .padding(.top, 4)
                }
                .padding(.top, 50)
                .padding(.bottom, 20)

                Spacer()

                if let prompt = currentPrompt {
                    VStack(spacing: 20) {

                        // Verse with blanks
                        VStack(spacing: 10) {
                            Text(prompt.verse)
                                .font(.custom("Courier", size: 15))
                                .foregroundColor(.white)
                                .multilineTextAlignment(.center)
                                .lineSpacing(6)
                                .padding(.horizontal, 20)

                            Text(prompt.reference)
                                .font(.custom("Courier-Bold", size: 12))
                                .foregroundColor(Color(red: 0.8, green: 0.7, blue: 0.4))
                        }
                        .padding(16)
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color(red: 0.1, green: 0.07, blue: 0.18))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(Color.yellow.opacity(0.3), lineWidth: 1)
                                )
                        )
                        .padding(.horizontal, 16)

                        // Affirmation (shown after correct answer)
                        if showAffirmation {
                            VStack(spacing: 6) {
                                HStack {
                                    Image(systemName: selectedAnswer == prompt.correctAnswer ? "checkmark.circle.fill" : "info.circle.fill")
                                        .foregroundColor(selectedAnswer == prompt.correctAnswer ? .green : .yellow)
                                    Text(selectedAnswer == prompt.correctAnswer ? "Correct!" : "The answer is: \"\(prompt.correctAnswer)\"")
                                        .font(.custom("Courier-Bold", size: 13))
                                        .foregroundColor(selectedAnswer == prompt.correctAnswer ? .green : .yellow)
                                }
                                Text(prompt.affirmation)
                                    .font(.custom("Courier", size: 12))
                                    .foregroundColor(.white.opacity(0.8))
                                    .multilineTextAlignment(.center)
                                    .lineSpacing(4)
                                    .padding(.horizontal, 16)
                            }
                            .padding(12)
                            .background(
                                RoundedRectangle(cornerRadius: 6)
                                    .fill(Color(red: 0.05, green: 0.15, blue: 0.08))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 6)
                                            .stroke(Color.green.opacity(0.4), lineWidth: 1)
                                    )
                            )
                            .padding(.horizontal, 16)
                            .transition(.opacity.combined(with: .scale))
                        }

                        // Answer buttons
                        if !answered {
                            VStack(spacing: 8) {
                                ForEach(shuffledOptions, id: \.self) { option in
                                    Button {
                                        selectAnswer(option, for: prompt)
                                    } label: {
                                        Text(option)
                                            .font(.custom("Courier", size: 14))
                                            .foregroundColor(.white)
                                            .frame(maxWidth: .infinity)
                                            .padding(.vertical, 12)
                                            .background(
                                                RoundedRectangle(cornerRadius: 6)
                                                    .fill(Color(red: 0.15, green: 0.1, blue: 0.28))
                                                    .overlay(
                                                        RoundedRectangle(cornerRadius: 6)
                                                            .stroke(Color.yellow.opacity(0.4), lineWidth: 1)
                                                    )
                                            )
                                    }
                                }
                            }
                            .padding(.horizontal, 20)
                        } else if showAffirmation {
                            // Next button
                            RPGButton(title: currentIndex < prompts.count - 1 ? "NEXT VERSE" : "CONTINUE") {
                                advanceOrComplete()
                            }
                            .padding(.top, 8)
                        }
                    }
                }

                Spacer()

                // Skip option
                Button("Skip (no Faith bonus)") {
                    onComplete(correctCount, prompts.count)
                }
                .font(.custom("Courier", size: 11))
                .foregroundColor(.gray.opacity(0.5))
                .padding(.bottom, 40)
            }
        }
        .onAppear {
            setupCurrentPrompt()
        }
    }

    // MARK: - Helpers

    func actToRomanNumeral(_ act: Int) -> String {
        switch act {
        case 1: return "I"
        case 2: return "II"
        case 3: return "III"
        default: return "\(act)"
        }
    }

    func setupCurrentPrompt() {
        guard let prompt = currentPrompt else { return }
        answered = false
        showAffirmation = false
        selectedAnswer = nil
        shuffledOptions = ([prompt.correctAnswer] + prompt.wrongAnswers).shuffled()
    }

    func selectAnswer(_ answer: String, for prompt: ScripturePrompt) {
        selectedAnswer = answer
        answered = true
        let isCorrect = answer == prompt.correctAnswer
        if isCorrect { correctCount += 1 }
        withAnimation(.easeIn(duration: 0.3)) { showAffirmation = true }
    }

    func advanceOrComplete() {
        if currentIndex < prompts.count - 1 {
            currentIndex += 1
            withAnimation { setupCurrentPrompt() }
        } else {
            onComplete(correctCount, prompts.count)
        }
    }
}
