import SwiftUI

struct ChapterIntroView: View {
    let chapter: Chapter
    let onContinue: () -> Void
    
    @State private var showTitle = false
    @State private var showSubtitle = false
    @State private var showButton = false
    
    var actGradient: LinearGradient {
        let colors: [Color]
        switch chapter.act {
        case 1:   // Act I — Galilee — warm dawn
            colors = [Color(red: 0.05, green: 0.1, blue: 0.25), Color(red: 0.15, green: 0.08, blue: 0.35)]
        case 2:   // Act II — The Road — deeper, graver
            colors = [Color(red: 0.08, green: 0.04, blue: 0.18), Color(red: 0.18, green: 0.1, blue: 0.28)]
        default:  // Act III — Jerusalem — dark, with dawn breaking at scene 12
            colors = chapter.number == 12 ?
                [Color(red: 0.3, green: 0.2, blue: 0.05), Color(red: 0.15, green: 0.08, blue: 0.02)] :
                [Color(red: 0.04, green: 0.02, blue: 0.1), Color(red: 0.1, green: 0.05, blue: 0.18)]
        }
        return LinearGradient(gradient: Gradient(colors: colors), startPoint: .top, endPoint: .bottom)
    }

    var actLabel: String {
        switch chapter.act {
        case 1: return "ACT I — GALILEE"
        case 2: return "ACT II — THE ROAD"
        default: return "ACT III — JERUSALEM"
        }
    }

    var body: some View {
        ZStack {
            actGradient.ignoresSafeArea()
            StarFieldView()
            
            VStack(spacing: 24) {
                Spacer()
                
                if showTitle {
                    VStack(spacing: 12) {
                        Text(actLabel)
                            .font(.custom("Courier", size: 12))
                            .foregroundColor(.gray.opacity(0.6))
                        Text("SCENE \(chapter.number)")
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
