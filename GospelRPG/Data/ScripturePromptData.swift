import Foundation

// MARK: - Scripture Memory Prompt (DESIGN.md §3.4)

struct ScripturePrompt: Identifiable {
    let id: String
    let verse: String           // Full verse text with _____ for the blank(s)
    let reference: String       // e.g. "Mark 1:27 (DRB)"
    let correctAnswer: String
    let wrongAnswers: [String]  // 3 wrong options
    let affirmation: String     // Shown on correct answer
    let actNumber: Int          // 1, 2, or 3 — which Act this covers
}

struct ScripturePromptData {

    // MARK: - Act I Prompts (after Scene 5 — Loaves & Fishes)

    static let actOnePrompts: [ScripturePrompt] = [
        ScripturePrompt(
            id: "smp_mark1_27",
            verse: "\"What thing is this? what is this new _____? for with power he commandeth even the unclean spirits, and they obey him.\"",
            reference: "Mark 1:27 (DRB)",
            correctAnswer: "doctrine",
            wrongAnswers: ["power", "miracle", "command"],
            affirmation: "The people were amazed — Jesus taught with an authority no one had seen before.",
            actNumber: 1
        ),
        ScripturePrompt(
            id: "smp_mark4_40",
            verse: "\"Why are you _____? have you not faith yet?\"",
            reference: "Mark 4:40 (DRB)",
            correctAnswer: "fearful",
            wrongAnswers: ["sleeping", "weeping", "doubting"],
            affirmation: "Jesus asked this after calming the storm. Fear and faith cannot fill the same heart at once.",
            actNumber: 1
        ),
        ScripturePrompt(
            id: "smp_mark5_36",
            verse: "\"Fear not, only _____.\"",
            reference: "Mark 5:36 (DRB)",
            correctAnswer: "believe",
            wrongAnswers: ["pray", "trust", "hope"],
            affirmation: "When news came that Jairus's daughter had died, Jesus said this. The simplest and most powerful command.",
            actNumber: 1
        ),
        ScripturePrompt(
            id: "smp_mark5_41",
            verse: "\"Talitha _____, which is, being interpreted: Damsel (I say to thee) arise.\"",
            reference: "Mark 5:41 (DRB)",
            correctAnswer: "cumi",
            wrongAnswers: ["koum", "rise", "veni"],
            affirmation: "Jesus spoke Aramaic — the language of the people. Talitha cumi: Little girl, get up.",
            actNumber: 1
        ),
        ScripturePrompt(
            id: "smp_mark6_42",
            verse: "\"And they all did eat, and had their fill. And they took up the leavings, twelve full _____ of fragments.\"",
            reference: "Mark 6:42-43 (DRB)",
            correctAnswer: "baskets",
            wrongAnswers: ["loaves", "jars", "sacks"],
            affirmation: "Five loaves and two fish fed five thousand, with twelve baskets left over. God always provides more than enough.",
            actNumber: 1
        ),
    ]

    // MARK: - Act II Prompts (after Scene 9 — Triumphal Entry)

    static let actTwoPrompts: [ScripturePrompt] = [
        ScripturePrompt(
            id: "smp_mark6_50",
            verse: "\"Have _____, it is I, fear ye not.\"",
            reference: "Mark 6:50 (DRB)",
            correctAnswer: "confidence",
            wrongAnswers: ["faith", "courage", "patience"],
            affirmation: "Jesus said this as He walked on the water toward the frightened disciples in the boat.",
            actNumber: 2
        ),
        ScripturePrompt(
            id: "smp_mark9_24",
            verse: "\"I do believe, Lord: help my _____.\"",
            reference: "Mark 9:24 (DRB)",
            correctAnswer: "unbelief",
            wrongAnswers: ["weakness", "fear", "doubt"],
            affirmation: "The most honest prayer in the Gospel. The father of the suffering boy said this to Jesus — and Jesus healed his son anyway.",
            actNumber: 2
        ),
        ScripturePrompt(
            id: "smp_mark9_29",
            verse: "\"This kind can go out by nothing, but by _____ and fasting.\"",
            reference: "Mark 9:29 (DRB)",
            correctAnswer: "prayer",
            wrongAnswers: ["faith", "fasting", "scripture"],
            affirmation: "The disciples asked why they couldn't cast it out. Jesus taught them that some battles require deeper prayer.",
            actNumber: 2
        ),
        ScripturePrompt(
            id: "smp_mark10_52",
            verse: "\"Go thy way, thy _____ hath made thee whole.\"",
            reference: "Mark 10:52 (DRB)",
            correctAnswer: "faith",
            wrongAnswers: ["love", "prayer", "persistence"],
            affirmation: "Bartimaeus would not be silenced. His bold, persistent faith is what Jesus honoured.",
            actNumber: 2
        ),
        ScripturePrompt(
            id: "smp_mark11_9",
            verse: "\"Hosanna: Blessed is he that cometh in the _____ of the Lord.\"",
            reference: "Mark 11:9 (DRB)",
            correctAnswer: "name",
            wrongAnswers: ["power", "glory", "light"],
            affirmation: "Hosanna means 'Save us!' The crowd greeted Jesus as their king — though they didn't yet understand what kind of king He was.",
            actNumber: 2
        ),
    ]

    // MARK: - Act III Prompts (end credits summary)

    static let actThreePrompts: [ScripturePrompt] = [
        ScripturePrompt(
            id: "smp_mark11_17",
            verse: "\"My house shall be called the house of _____ to all nations.\"",
            reference: "Mark 11:17 (DRB)",
            correctAnswer: "prayer",
            wrongAnswers: ["worship", "teaching", "peace"],
            affirmation: "Jesus drove out those who had turned the Temple into a marketplace. Religion without prayer is empty.",
            actNumber: 3
        ),
        ScripturePrompt(
            id: "smp_mark12_30",
            verse: "\"Thou shalt love the Lord thy God with thy whole _____, and with thy whole soul, and with thy whole mind, and with thy whole strength.\"",
            reference: "Mark 12:30 (DRB)",
            correctAnswer: "heart",
            wrongAnswers: ["being", "will", "life"],
            affirmation: "The greatest commandment. Everything else flows from this total love.",
            actNumber: 3
        ),
        ScripturePrompt(
            id: "smp_mark14_38",
            verse: "\"Watch ye, and pray that ye enter not into temptation. The spirit indeed is willing, but the _____ is weak.\"",
            reference: "Mark 14:38 (DRB)",
            correctAnswer: "flesh",
            wrongAnswers: ["heart", "mind", "will"],
            affirmation: "Jesus said this to Peter in Gethsemane — the night the disciples fell asleep. He understands our weakness.",
            actNumber: 3
        ),
        ScripturePrompt(
            id: "smp_mark16_6",
            verse: "\"Be not affrighted; you seek Jesus of Nazareth, who was crucified: he is risen, he is not here, behold the place where they _____ him.\"",
            reference: "Mark 16:6 (DRB)",
            correctAnswer: "laid",
            wrongAnswers: ["buried", "left", "placed"],
            affirmation: "The angel's words at the empty tomb. He is not there. He is risen. The whole Gospel has been building to this.",
            actNumber: 3
        ),
        ScripturePrompt(
            id: "smp_mark16_15",
            verse: "\"Go ye into the whole _____, and preach the gospel to every creature.\"",
            reference: "Mark 16:15 (DRB)",
            correctAnswer: "world",
            wrongAnswers: ["land", "nation", "city"],
            affirmation: "The Great Commission. Not just for the Apostles — for every baptised soul. Go and tell.",
            actNumber: 3
        ),
    ]

    static func promptsForAct(_ act: Int) -> [ScripturePrompt] {
        switch act {
        case 1: return actOnePrompts.shuffled().prefix(3).map { $0 }
        case 2: return actTwoPrompts.shuffled().prefix(3).map { $0 }
        default: return actThreePrompts.shuffled().prefix(3).map { $0 }
        }
    }

    /// All prompts for the end-credits summary
    static var allPrompts: [ScripturePrompt] {
        actOnePrompts + actTwoPrompts + actThreePrompts
    }
}
