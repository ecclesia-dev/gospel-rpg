import SwiftUI
import SpriteKit

struct OverworldView: View {
    @ObservedObject var gameState: GameState
    let chapter: Chapter
    let onTrigger: () -> Void
    let onMenu: () -> Void
    
    @State private var scene: OverworldScene?
    @State private var bridge: OverworldBridge?
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            if let scene = scene {
                SpriteView(scene: scene)
                    .ignoresSafeArea()
            }
            
            // Chapter header
            VStack {
                HStack {
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Chapter \(chapter.number)")
                            .font(.custom("Courier-Bold", size: 14))
                            .foregroundColor(.yellow)
                        Text(chapter.title)
                            .font(.custom("Courier", size: 11))
                            .foregroundColor(.white.opacity(0.7))
                    }
                    .padding(8)
                    .background(
                        RoundedRectangle(cornerRadius: 4)
                            .fill(Color.black.opacity(0.7))
                    )
                    Spacer()
                }
                .padding(.horizontal, 12)
                .padding(.top, 50)
                
                Spacer()
            }
        }
        .onAppear {
            setupScene()
        }
    }
    
    func setupScene() {
        let s = OverworldScene(size: UIScreen.main.bounds.size)
        s.scaleMode = .aspectFill
        s.mapData = MapData.mapForChapter(chapter.number)
        let start = MapData.startPosition(for: chapter.number)
        s.playerX = start.x
        s.playerY = start.y
        let trigger = MapData.triggerPosition(for: chapter.number)
        s.triggerX = trigger.x
        s.triggerY = trigger.y
        
        s.chapterNumber = chapter.number
        
        if let jesus = gameState.party.first {
            s.partyColor = jesus.primaryColor
            s.partySecondary = jesus.secondaryColor
        }
        
        let b = OverworldBridge(onTrigger: onTrigger, onMenu: onMenu)
        s.overworldDelegate = b
        bridge = b
        scene = s
    }
}

class OverworldBridge: NSObject, OverworldSceneDelegate {
    let onTrigger: () -> Void
    let onMenu: () -> Void
    
    init(onTrigger: @escaping () -> Void, onMenu: @escaping () -> Void) {
        self.onTrigger = onTrigger
        self.onMenu = onMenu
    }
    
    func didTriggerEvent() {
        onTrigger()
    }
    
    func didRequestMenu() {
        onMenu()
    }
}
