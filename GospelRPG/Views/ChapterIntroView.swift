import SwiftUI

struct ChapterIntroView: View {
    let chapter: Chapter
    let onContinue: () -> Void
    
    @State private var showTitle = false
    @State private var showSubtitle = false
    @State private var showButton = false
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            VStack(spacing: 24) {
                Spacer()
                
                if showTitle {
                    VStack(spacing: 12) {
                        Text("CHAPTER \(chapter.number)")
                            .font(.custom("Courier-Bold", size: 16))
                            .foregroundColor(.yellow.opacity(0.7))
                        
                        Text(chapter.title)
                            .font(.custom("Courier-Bold", size: 28))
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                            .shadow(color: .yellow.opacity(0.3), radius: 10)
                    }
                    .transition(.opacity)
                }
                
                if showSubtitle {
                    VStack(spacing: 8) {
                        Text(chapter.subtitle)
                            .font(.custom("Courier-Bold", size: 14))
                            .foregroundColor(Color(red: 0.8, green: 0.7, blue: 0.4))
                        
                        // Decorative line
                        Rectangle()
                            .fill(Color.yellow.opacity(0.3))
                            .frame(width: 100, height: 1)
                        
                        Text("✝")
                            .font(.system(size: 30))
                            .foregroundColor(.yellow.opacity(0.5))
                    }
                    .transition(.opacity)
                }
                
                Spacer()
                
                if showButton {
                    RPGButton(title: "BEGIN") {
                        onContinue()
                    }
                    .transition(.opacity)
                }
                
                Spacer().frame(height: 40)
            }
        }
        .onAppear {
            withAnimation(.easeIn(duration: 1.0).delay(0.3)) { showTitle = true }
            withAnimation(.easeIn(duration: 1.0).delay(1.3)) { showSubtitle = true }
            withAnimation(.easeIn(duration: 0.5).delay(2.5)) { showButton = true }
        }
    }
}
