# ✝️ Gospel Quest: The Mark of Faith

An SNES Final Fantasy-style RPG that teaches Bible stories from the Gospel of Mark. Built with SwiftUI + SpriteKit for iOS.

**Target Audience:** Kids learning Bible stories through interactive gameplay.

## 📖 Chapters

| # | Title | Scripture | Boss |
|---|-------|-----------|------|
| 1 | The Synagogue at Capernaum | Mark 1:21-28 | Unclean Spirit |
| 2 | The Gerasene Demoniac | Mark 5:1-20 | Legion |
| 3 | The Boy with an Unclean Spirit | Mark 9:14-29 | Deaf & Mute Spirit |
| 4 | Peace, Be Still! | Mark 4:35-41 | The Great Storm |
| 5 | Talitha Cumi | Mark 5:21-43 | Spirit of Death |

## ⚔️ Features

- **Turn-based combat** with SNES RPG feel (SpriteKit pixel art sprites)
- **Party system** — recruit apostles (Simon Peter, Andrew, James, John, Levi, Bartholomew)
- **Abilities** rooted in Scripture (each ability shows its Bible reference)
- **Equipment system** — biblical items (Shepherd's Staff, Armor of God, Gospel Sandals, Mustard Seed...)
- **Inventory** with consumables (Bread of Life, Blessed Fish, New Wine)
- **Overworld exploration** with tile-based maps and D-pad controls
- **Typewriter dialogue** with Scripture references displayed inline
- **Victory messages** with encouraging Bible verses

## 🎮 How to Play

1. **NEW JOURNEY** starts with Jesus and Simon Peter
2. Walk the overworld using the D-pad; find the **!** marker to trigger the story
3. Read the dialogue (tap to advance), then fight the boss in turn-based combat
4. Use **Attack**, **Abilities** (MP-based, faith-powered), or **Defend**
5. After victory, a new apostle joins your party and you receive loot
6. Open **MENU** to view party stats, equipment, and inventory

## 🛠 Setup

### Requirements
- **Xcode 15+** (Swift 5.9+)
- **iOS 17.0+** target
- No external dependencies — pure SwiftUI + SpriteKit

### Build & Run
1. Open `GospelRPG.xcodeproj` in Xcode
2. Select an iOS Simulator or device (iPhone recommended)
3. Press **⌘R** to build and run
4. No signing team needed for simulator; set your team for device builds

### Project Structure
```
GospelRPG/
├── GospelRPGApp.swift          # App entry point
├── Models/
│   ├── GameModels.swift        # Core types (Character, Ability, Chapter, GameState)
│   └── InventoryModels.swift   # Items, Equipment, Inventory system
├── Data/
│   ├── CharacterData.swift     # Ability DB + Character factory (heroes & enemies)
│   ├── ChapterData.swift       # All 5 chapter scripts with dialogue
│   └── MapData.swift           # Tile maps for each chapter's overworld
├── Views/
│   ├── GameView.swift          # Main game router
│   ├── TitleScreenView.swift   # Title screen with starfield
│   ├── ChapterIntroView.swift  # Chapter title cards
│   ├── DialogueView.swift      # Typewriter dialogue system
│   ├── BattleView.swift        # Battle UI (actions, HUD, targets)
│   ├── OverworldView.swift     # Overworld wrapper
│   └── MenuView.swift          # Party status, equipment, inventory
├── Scenes/
│   ├── BattleScene.swift       # SpriteKit battle rendering
│   └── OverworldScene.swift    # SpriteKit overworld + D-pad
└── Systems/
    ├── BattleSystem.swift      # Turn-based battle engine
    └── PixelArtRenderer.swift  # Pixel art sprite generation + effects
```

## 📜 Scripture References

Every ability, dialogue line, and story beat cites its source verse from the Bible. The game is designed to make kids curious about reading the actual Gospel of Mark.

## 🎨 Art Style

All sprites are generated procedurally with SpriteKit — no external assets needed. Characters are 8×12 pixel art rendered at 4× scale. Enemies have horns, wings, and tails; heroes wear robes and sandals.

## Built by

Crafted by the [ecclesia-dev](https://github.com/ecclesia-dev) agent team.

---

*"He even gives orders to impure spirits and they obey him."* — Mark 1:27
