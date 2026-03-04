import SwiftUI

struct DialogueView: View {
    let dialogue: [DialogueLine]
    let onComplete: () -> Void
    var onFaithDelta: ((Int) -> Void)? = nil   // Called when a choice affects Faith

    @State private var currentIndex = 0
    @State private var displayedText = ""
    @State private var isTyping = false
    @State private var timer: Timer?
    @State private var choiceMade: Bool = false
    @State private var insertedFollowUp: String? = nil
    @State private var chosenFaithDelta: Int = 0

    var currentLine: DialogueLine {
        dialogue[min(currentIndex, dialogue.count - 1)]
    }

    var hasChoices: Bool {
        !choiceMade && (currentLine.choices?.isEmpty == false)
    }

    var body: some View {
        ZStack {
            // Semi-transparent overlay
            Color.black.opacity(0.45)
                .ignoresSafeArea()

            VStack {
                Spacer()

                // Scripture reference banner
                if let ref = currentLine.scriptureRef {
                    HStack {
                        Image(systemName: "book.fill")
                            .foregroundColor(.yellow)
                        Text(ref)
                            .font(.custom("Courier-Bold", size: 14))
                            .foregroundColor(.yellow)
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 6)
                    .background(
                        RoundedRectangle(cornerRadius: 4)
                            .fill(Color(red: 0.15, green: 0.1, blue: 0.05))
                            .overlay(
                                RoundedRectangle(cornerRadius: 4)
                                    .stroke(Color.yellow.opacity(0.5), lineWidth: 1)
                            )
                    )
                    .padding(.bottom, 4)
                }

                // Main dialogue box
                VStack(alignment: .leading, spacing: 8) {
                    // Speaker name
                    Text(currentLine.speaker)
                        .font(.custom("Courier-Bold", size: 16))
                        .foregroundColor(Color(uiColor: currentLine.speakerColor))

                    // Typewriter text (or follow-up after choice)
                    if let followUp = insertedFollowUp {
                        Text(followUp)
                            .font(.custom("Courier", size: 14))
                            .foregroundColor(chosenFaithDelta >= 0 ? .green : .orange)
                            .lineSpacing(4)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .frame(minHeight: 40)
                    } else {
                        Text(displayedText)
                            .font(.custom("Courier", size: 15))
                            .foregroundColor(.white)
                            .lineSpacing(4)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .frame(minHeight: 60)
                    }

                    // Faith Choices (DESIGN.md §3.2)
                    if hasChoices && !isTyping, let choices = currentLine.choices {
                        VStack(spacing: 6) {
                            ForEach(choices) { choice in
                                Button {
                                    handleChoice(choice)
                                } label: {
                                    HStack {
                                        Text(choice.label)
                                            .font(.custom("Courier", size: 13))
                                            .foregroundColor(.white)
                                            .multilineTextAlignment(.leading)
                                        Spacer()
                                        if choice.faithDelta > 0 {
                                            Text("✨+\(choice.faithDelta)")
                                                .font(.custom("Courier-Bold", size: 11))
                                                .foregroundColor(.green)
                                        } else if choice.faithDelta < 0 {
                                            Text("💭\(choice.faithDelta)")
                                                .font(.custom("Courier-Bold", size: 11))
                                                .foregroundColor(.orange)
                                        }
                                    }
                                    .padding(.horizontal, 10)
                                    .padding(.vertical, 6)
                                    .background(
                                        RoundedRectangle(cornerRadius: 4)
                                            .fill(Color(red: 0.12, green: 0.08, blue: 0.22))
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 4)
                                                    .stroke(Color.yellow.opacity(0.4), lineWidth: 1)
                                            )
                                    )
                                }
                            }
                        }
                        .padding(.top, 4)
                    }

                    // Continue indicator (only when no choices pending)
                    if !isTyping && !hasChoices && insertedFollowUp == nil {
                        HStack {
                            Spacer()
                            Text(currentIndex < dialogue.count - 1 ? "▼ Tap to continue" : "▼ Tap to close")
                                .font(.custom("Courier", size: 12))
                                .foregroundColor(.yellow.opacity(0.7))
                        }
                    }

                    // After follow-up shown, tap to dismiss
                    if insertedFollowUp != nil {
                        HStack {
                            Spacer()
                            Text("▼ Tap to continue")
                                .font(.custom("Courier", size: 12))
                                .foregroundColor(.yellow.opacity(0.7))
                        }
                    }
                }
                .padding(16)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color(red: 0.08, green: 0.05, blue: 0.15, opacity: 0.95))
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(
                                    LinearGradient(
                                        colors: [.yellow.opacity(0.6), .orange.opacity(0.3)],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    ),
                                    lineWidth: 2
                                )
                        )
                )
                .padding(.horizontal, 12)
                .padding(.bottom, 30)
            }
        }
        .onTapGesture {
            handleTap()
        }
        .onAppear {
            startTyping()
        }
    }

    // MARK: - Choice Handler

    func handleChoice(_ choice: DialogueChoice) {
        choiceMade = true
        chosenFaithDelta = choice.faithDelta

        // Apply faith delta
        onFaithDelta?(choice.faithDelta)

        // Show follow-up text if present
        if let followUp = choice.followUpText {
            insertedFollowUp = followUp
        } else {
            // No follow-up; advance
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                advanceAfterChoice()
            }
        }
    }

    func advanceAfterChoice() {
        insertedFollowUp = nil
        choiceMade = false
        chosenFaithDelta = 0
        if currentIndex < dialogue.count - 1 {
            currentIndex += 1
            startTyping()
        } else {
            onComplete()
        }
    }

    // MARK: - Typing

    func startTyping() {
        displayedText = ""
        isTyping = true
        insertedFollowUp = nil
        choiceMade = false
        let fullText = currentLine.text
        var charIndex = 0

        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 0.03, repeats: true) { t in
            if charIndex < fullText.count {
                let index = fullText.index(fullText.startIndex, offsetBy: charIndex)
                displayedText += String(fullText[index])
                charIndex += 1
            } else {
                t.invalidate()
                isTyping = false
            }
        }
    }

    func handleTap() {
        if isTyping {
            // Skip to full text
            timer?.invalidate()
            displayedText = currentLine.text
            isTyping = false
        } else if insertedFollowUp != nil {
            // Dismiss follow-up
            advanceAfterChoice()
        } else if hasChoices {
            // Don't advance — choices must be chosen explicitly
            return
        } else if currentIndex < dialogue.count - 1 {
            currentIndex += 1
            startTyping()
        } else {
            onComplete()
        }
    }
}
