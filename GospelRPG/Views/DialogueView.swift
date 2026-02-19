import SwiftUI

struct DialogueView: View {
    let dialogue: [DialogueLine]
    let onComplete: () -> Void
    
    @State private var currentIndex = 0
    @State private var displayedText = ""
    @State private var isTyping = false
    @State private var timer: Timer?
    
    var currentLine: DialogueLine {
        dialogue[min(currentIndex, dialogue.count - 1)]
    }
    
    var body: some View {
        ZStack {
            // Dark overlay
            Color.black.opacity(0.7)
                .ignoresSafeArea()
            
            VStack {
                Spacer()
                
                // Scripture reference banner (if applicable)
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
                
                // Dialogue box
                VStack(alignment: .leading, spacing: 8) {
                    // Speaker name
                    Text(currentLine.speaker)
                        .font(.custom("Courier-Bold", size: 16))
                        .foregroundColor(Color(uiColor: currentLine.speakerColor))
                    
                    // Text with typewriter effect
                    Text(displayedText)
                        .font(.custom("Courier", size: 15))
                        .foregroundColor(.white)
                        .lineSpacing(4)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .frame(minHeight: 60)
                    
                    // Continue indicator
                    if !isTyping {
                        HStack {
                            Spacer()
                            Text(currentIndex < dialogue.count - 1 ? "▼ Tap to continue" : "▼ Tap to close")
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
    
    func startTyping() {
        displayedText = ""
        isTyping = true
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
        } else if currentIndex < dialogue.count - 1 {
            currentIndex += 1
            startTyping()
        } else {
            onComplete()
        }
    }
}
