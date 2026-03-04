import SpriteKit

// MARK: - Chapter Data (All 12 Scenes, Douay-Rheims Bible)
// Scene order follows DESIGN.md §2.2
// All Scripture in Douay-Rheims (DRB) per project requirement.

struct ChapterData {

    // MARK: - ACT I — GALILEE: Who Is This Man? (Scenes 1–5)

    // ─────────────────────────────────────────────
    // Scene 1: The Synagogue at Capernaum (Mark 1:21-28) — TUTORIAL
    // ─────────────────────────────────────────────
    static func chapter1() -> Chapter {
        Chapter(
            number: 1,
            title: "The Synagogue at Capernaum",
            subtitle: "Mark 1:21-28",
            scriptureRange: "Mark 1:21-28",
            act: 1, encounterType: .exorcism, hasBattle: true, showScriptureMemoryAfter: false,
            introDialogue: [
                DialogueLine(speaker: "Narrator", text: "And they entered into Capharnaum, and forthwith upon the sabbath days going into the synagogue, he taught them.", scriptureRef: "Mark 1:21 (DRB)"),
                DialogueLine(speaker: "Narrator", text: "And they were astonished at his doctrine. For he was teaching them as one having power, and not as the scribes.", scriptureRef: "Mark 1:22 (DRB)"),
                DialogueLine(speaker: "Simon Peter", text: "Master, look — the people are astonished! No one has ever spoken like this.", speakerColor: SKColor(red: 0.3, green: 0.3, blue: 0.8, alpha: 1)),
                DialogueLine(speaker: "Jesus", text: "\"The time is accomplished, and the kingdom of God is at hand: repent, and believe the gospel.\"", scriptureRef: "Mark 1:15 (DRB)", speakerColor: .white),
                DialogueLine(speaker: "Narrator", text: "And there was in their synagogue a man with an unclean spirit, and he cried out, saying...", scriptureRef: "Mark 1:23 (DRB)"),
                DialogueLine(speaker: "Unclean Spirit", text: "\"What have we to do with thee, Jesus of Nazareth? art thou come to destroy us? I know who thou art, the Holy One of God.\"", scriptureRef: "Mark 1:24 (DRB)", speakerColor: .red),
                DialogueLine(speaker: "Narrator", text: "Jesus turns to His disciples. They must stand firm as He confronts the unclean spirit."),
                DialogueLine(speaker: "Simon Peter", text: "(TUTORIAL) Attack the spirit with your abilities! Use Prayer to heal, and Rebuke to drive it out!", speakerColor: SKColor(red: 0.3, green: 0.3, blue: 0.8, alpha: 1)),
            ],
            battleEnemies: [CharacterFactory.synagogueSpirit()],
            postBattleDialogue: [
                DialogueLine(speaker: "Jesus", text: "\"Speak no more, and go out of the man.\"", scriptureRef: "Mark 1:25 (DRB)", speakerColor: .white),
                DialogueLine(speaker: "Narrator", text: "And the unclean spirit tearing him, and crying out with a loud voice, went out of him.", scriptureRef: "Mark 1:26 (DRB)"),
                DialogueLine(speaker: "Crowd", text: "\"What thing is this? what is this new doctrine? for with power he commandeth even the unclean spirits, and they obey him.\"", scriptureRef: "Mark 1:27 (DRB)"),
                DialogueLine(speaker: "Narrator", text: "And immediately his fame spread abroad into all the country of Galilee.", scriptureRef: "Mark 1:28 (DRB)"),
                DialogueLine(speaker: "Simon Peter", text: "Master, that spirit obeyed your very word! What authority is this?"),
                DialogueLine(speaker: "Narrator", text: "As He walked beside the Sea of Galilee, He saw Simon and his brother Andrew casting their nets.", scriptureRef: "Mark 1:16 (DRB)"),
                DialogueLine(speaker: "Jesus", text: "\"Come after me, and I will make you to become fishers of men.\"", scriptureRef: "Mark 1:17 (DRB)", speakerColor: .white),
                DialogueLine(speaker: "Andrew", text: "At once! Where you lead, I will follow.", speakerColor: SKColor(red: 0.2, green: 0.6, blue: 0.5, alpha: 1)),
                DialogueLine(speaker: "Narrator", text: "Andrew has joined the party! ⭐"),
                DialogueLine(speaker: "Narrator", text: "And going on a little further from thence, he saw James the son of Zebedee, and John his brother.", scriptureRef: "Mark 1:19 (DRB)"),
                DialogueLine(speaker: "James", text: "We saw what you did in the synagogue, Lord. We are yours.", speakerColor: SKColor(red: 0.7, green: 0.2, blue: 0.2, alpha: 1)),
                DialogueLine(speaker: "John", text: "Where you go, we will go.", speakerColor: SKColor(red: 0.2, green: 0.4, blue: 0.7, alpha: 1)),
                DialogueLine(speaker: "Narrator", text: "James has joined the party! ⭐ John has joined the party! ⭐"),
                DialogueLine(speaker: "Narrator", text: "And as he passed by, he saw Levi the son of Alpheus sitting at the receipt of custom.", scriptureRef: "Mark 2:14 (DRB)"),
                DialogueLine(speaker: "Jesus", text: "\"Follow me.\"", scriptureRef: "Mark 2:14 (DRB)", speakerColor: .white),
                DialogueLine(speaker: "Levi", text: "I... yes. Yes! A new life begins.", speakerColor: SKColor(red: 0.6, green: 0.5, blue: 0.2, alpha: 1)),
                DialogueLine(speaker: "Narrator", text: "Levi has joined the party! ⭐"),
            ],
            recruitableApostles: [CharacterFactory.andrew(), CharacterFactory.james(), CharacterFactory.john(), CharacterFactory.levi()],
            bossName: "Unclean Spirit",
            discipleCommentary: [
                "Andrew: \"Even the darkness obeys Him. I have never seen anything like this.\"",
                "James: \"He rebuked it with a word. One word!\"",
                "John: \"Even the spirits confess who He is. 'The Holy One of God' — they know before we do.\"",
            ],
            faithReward: 3
        )
    }

    // ─────────────────────────────────────────────
    // Scene 2: The Gerasene Demoniac (Mark 5:1-20)
    // ─────────────────────────────────────────────
    static func chapter2() -> Chapter {
        Chapter(
            number: 2,
            title: "The Gerasene Demoniac",
            subtitle: "Mark 5:1-20",
            scriptureRange: "Mark 5:1-20",
            act: 1, encounterType: .exorcism, hasBattle: true, showScriptureMemoryAfter: false,
            introDialogue: [
                DialogueLine(speaker: "Narrator", text: "And they came over the strait of the sea into the country of the Gerasens.", scriptureRef: "Mark 5:1 (DRB)"),
                DialogueLine(speaker: "Narrator", text: "And as he went out of the ship, immediately there met him out of the monuments a man with an unclean spirit.", scriptureRef: "Mark 5:2 (DRB)"),
                DialogueLine(speaker: "Narrator", text: "Who had his dwelling in the tombs, and no man now could bind him, not even with chains.", scriptureRef: "Mark 5:3 (DRB)"),
                DialogueLine(speaker: "Simon Peter", text: "That poor man... he's been tormented for years. No chain has held him."),
                DialogueLine(speaker: "Andrew", text: "He cries night and day. What kind of spirit has such power?", speakerColor: SKColor(red: 0.2, green: 0.6, blue: 0.5, alpha: 1)),
                DialogueLine(speaker: "Narrator", text: "And seeing Jesus afar off, he ran and adored him.", scriptureRef: "Mark 5:6 (DRB)"),
                DialogueLine(speaker: "Legion", text: "\"What have I to do with thee, Jesus the Son of the most high God? I adjure thee by God that thou torment me not.\"", scriptureRef: "Mark 5:7 (DRB)", speakerColor: .red),
                DialogueLine(speaker: "Jesus", text: "\"What is thy name?\"", scriptureRef: "Mark 5:9 (DRB)", speakerColor: .white),
                DialogueLine(speaker: "Legion", text: "\"My name is Legion, for we are many.\"", scriptureRef: "Mark 5:9 (DRB)", speakerColor: .red),
                DialogueLine(speaker: "Narrator", text: "Target Legion first — he is the chief spirit. The lesser demons will falter when he falls."),
            ],
            battleEnemies: [CharacterFactory.legion(), CharacterFactory.lesserDemon(), CharacterFactory.lesserDemon()],
            postBattleDialogue: [
                DialogueLine(speaker: "Jesus", text: "\"Go out of the man, thou unclean spirit.\"", scriptureRef: "Mark 5:8 (DRB)", speakerColor: .white),
                DialogueLine(speaker: "Narrator", text: "The demons begged Jesus to send them into a herd of swine nearby. He gave them leave. And the herd of about two thousand rushed down a steep place into the sea.", scriptureRef: "Mark 5:12-13 (DRB)"),
                DialogueLine(speaker: "Narrator", text: "The man who had been possessed sat there, clothed and in his right mind.", scriptureRef: "Mark 5:15 (DRB)"),
                DialogueLine(speaker: "Healed Man", text: "Lord... I am free. For the first time in years, I am free. Let me come with you!"),
                DialogueLine(speaker: "Jesus", text: "\"Go into thy house to thy friends, and tell them how great things the Lord hath done for thee, and hath had mercy on thee.\"", scriptureRef: "Mark 5:19 (DRB)", speakerColor: .white),
                DialogueLine(speaker: "Narrator", text: "And he went his way, and began to publish in Decapolis how great things Jesus had done for him.", scriptureRef: "Mark 5:20 (DRB)"),
                DialogueLine(speaker: "Simon Peter", text: "Not everyone is called to follow in the same way. He was sent home — to be a witness there."),
                DialogueLine(speaker: "Narrator", text: "Bartholomew, the Honest One, witnessed everything. He came and joined the company.", scriptureRef: "cf. Mark 3:18 (DRB)"),
                DialogueLine(speaker: "Narrator", text: "Bartholomew has joined the party! ⭐"),
            ],
            recruitableApostles: [CharacterFactory.bartholomew()],
            bossName: "Legion",
            discipleCommentary: [
                "Bartholomew: \"Even thousands of demons could not stand before one word from Jesus.\"",
                "John: \"He wept in the tombs for years. Now he goes home to tell them. That is already a mission.\"",
                "Andrew: \"The man wanted to follow. Jesus sent him away — and made him an evangelist to ten cities.\"",
            ],
            faithReward: 4
        )
    }

    // ─────────────────────────────────────────────
    // Scene 3: Peace, Be Still! (Mark 4:35-41) — was Ch4
    // ─────────────────────────────────────────────
    static func chapter3() -> Chapter {
        Chapter(
            number: 3,
            title: "Peace, Be Still!",
            subtitle: "Mark 4:35-41",
            scriptureRange: "Mark 4:35-41",
            act: 1, encounterType: .natureMiracle, hasBattle: true, showScriptureMemoryAfter: false,
            introDialogue: [
                DialogueLine(speaker: "Narrator", text: "And he saith to them that day, when evening was come: Let us pass over to the other side.", scriptureRef: "Mark 4:35 (DRB)"),
                DialogueLine(speaker: "Jesus", text: "\"Let us pass over to the other side.\"", scriptureRef: "Mark 4:35 (DRB)", speakerColor: .white),
                DialogueLine(speaker: "Simon Peter", text: "The sky is darkening. My fisherman's blood says a storm is coming...", speakerColor: SKColor(red: 0.3, green: 0.3, blue: 0.8, alpha: 1)),
                DialogueLine(speaker: "Narrator", text: "And there arose a great storm of wind, and the waves beat into the ship, so that the ship was filled.", scriptureRef: "Mark 4:37 (DRB)"),
                DialogueLine(speaker: "Andrew", text: "We're taking on water! The waves are enormous!", speakerColor: SKColor(red: 0.2, green: 0.6, blue: 0.5, alpha: 1)),
                DialogueLine(speaker: "James", text: "Where is the Master?!", speakerColor: SKColor(red: 0.7, green: 0.2, blue: 0.2, alpha: 1)),
                DialogueLine(speaker: "Narrator", text: "And he was in the hinder part of the ship, sleeping upon a pillow.", scriptureRef: "Mark 4:38 (DRB)"),
                DialogueLine(speaker: "Simon Peter", text: "Master, doth it not concern thee that we perish?", scriptureRef: "Mark 4:38 (DRB)"),
                DialogueLine(speaker: "Narrator", text: "⛈️ NATURE MIRACLE: Pray and use Faith abilities to reduce the storm's power before it overwhelms the boat! (8 turns)"),
            ],
            battleEnemies: [CharacterFactory.theGreatStorm(), CharacterFactory.ragingWind(), CharacterFactory.ragingWind()],
            postBattleDialogue: [
                DialogueLine(speaker: "Narrator", text: "And rising up, he rebuked the wind, and said to the sea:", scriptureRef: "Mark 4:39 (DRB)"),
                DialogueLine(speaker: "Jesus", text: "\"Peace, be still.\"", scriptureRef: "Mark 4:39 (DRB)", speakerColor: .white),
                DialogueLine(speaker: "Narrator", text: "And the wind ceased: and there was made a great calm.", scriptureRef: "Mark 4:39 (DRB)"),
                DialogueLine(speaker: "Jesus", text: "\"Why are you fearful? have you not faith yet?\"", scriptureRef: "Mark 4:40 (DRB)", speakerColor: .white),
                DialogueLine(
                    speaker: "Simon Peter",
                    text: "What do you say in your heart?",
                    choices: [
                        DialogueChoice(id: "c3_a", label: "\"Who is this... even wind and sea obey him?\" (Mark 4:41)", faithDelta: 2,
                                      followUpText: "✨ +2 Faith — The question that leads to deeper understanding.", scriptureRef: "Mark 4:41 (DRB)"),
                        DialogueChoice(id: "c3_b", label: "\"We almost died — where was He?\"", faithDelta: -1,
                                      followUpText: "He was there all along. He is never absent — only waiting for us to ask.", scriptureRef: nil),
                        DialogueChoice(id: "c3_c", label: "\"He slept through a storm. I don't understand.\"", faithDelta: 0,
                                      followUpText: "That honest confusion is a beginning. Keep following and watching.", scriptureRef: nil),
                    ]
                ),
                DialogueLine(speaker: "Narrator", text: "And they feared exceedingly: and they said one to another: Who is this (thinkest thou) that both wind and sea obey him?", scriptureRef: "Mark 4:41 (DRB)"),
            ],
            recruitableApostles: [],
            bossName: "The Great Storm",
            discipleCommentary: [
                "Simon Peter: \"He rebuked the wind. As though it were a naughty child. And it obeyed.\"",
                "John: \"He was asleep because He trusted His Father. We panicked because we did not.\"",
                "Andrew: \"'Have you not faith yet?' That question cut me deeply. I have seen so much — and still I fear.\"",
            ],
            faithReward: 3
        )
    }

    // ─────────────────────────────────────────────
    // Scene 4: Talitha Cumi (Mark 5:21-43) — was Ch5
    // ─────────────────────────────────────────────
    static func chapter4() -> Chapter {
        Chapter(
            number: 4,
            title: "Talitha Cumi",
            subtitle: "Mark 5:21-43",
            scriptureRange: "Mark 5:21-43",
            act: 1, encounterType: .faithTrial, hasBattle: true, showScriptureMemoryAfter: false,
            introDialogue: [
                DialogueLine(speaker: "Narrator", text: "And when Jesus had passed again in the ship over the strait, a great multitude assembled together unto him.", scriptureRef: "Mark 5:21 (DRB)"),
                DialogueLine(speaker: "Narrator", text: "And there cometh one of the rulers of the synagogue named Jairus: and seeing him, he fell down at his feet.", scriptureRef: "Mark 5:22 (DRB)"),
                DialogueLine(speaker: "Jairus", text: "\"My daughter is at the point of death. Come, lay thy hand upon her, that she may be safe, and may live.\"", scriptureRef: "Mark 5:23 (DRB)"),
                DialogueLine(speaker: "Jesus", text: "\"Fear not, only believe.\"", scriptureRef: "Mark 5:36 (DRB)", speakerColor: .white),
                DialogueLine(speaker: "Narrator", text: "On the way, a woman who had suffered bleeding for twelve years touched the hem of His garment. She was healed instantly.", scriptureRef: "Mark 5:25-29 (DRB)"),
                DialogueLine(speaker: "Jesus", text: "\"Daughter, thy faith hath made thee whole: go in peace, and be thou whole of thy plague.\"", scriptureRef: "Mark 5:34 (DRB)", speakerColor: .white),
                DialogueLine(speaker: "Messenger", text: "\"Thy daughter is dead: why dost thou trouble the master any further?\"", scriptureRef: "Mark 5:35 (DRB)"),
                DialogueLine(speaker: "Jesus", text: "\"Fear not, only believe.\"", scriptureRef: "Mark 5:36 (DRB)", speakerColor: .white),
                DialogueLine(speaker: "Narrator", text: "At the house, the mourners wept and wailed. The air was heavy with grief and doubt."),
                DialogueLine(speaker: "Narrator", text: "🙏 FAITH TRIAL: The disciples face an inner trial — Grief & Despair, Doubt & Fear. Choose faith over fear."),
            ],
            battleEnemies: [CharacterFactory.griefAndDespair(), CharacterFactory.doubtAndFear()],
            postBattleDialogue: [
                DialogueLine(speaker: "Jesus", text: "\"Why make you this ado, and weep? the damsel is not dead, but sleepeth.\"", scriptureRef: "Mark 5:39 (DRB)", speakerColor: .white),
                DialogueLine(speaker: "Narrator", text: "And they laughed him to scorn. But he, having put them all out, taketh the father and the mother of the damsel, and them that were with him.", scriptureRef: "Mark 5:40 (DRB)"),
                DialogueLine(speaker: "Jesus", text: "\"Talitha cumi, which is, being interpreted: Damsel (I say to thee) arise.\"", scriptureRef: "Mark 5:41 (DRB)", speakerColor: .white),
                DialogueLine(speaker: "Narrator", text: "And immediately the damsel rose up, and walked: and she was twelve years old: and they were astonished with a great astonishment.", scriptureRef: "Mark 5:42 (DRB)"),
                DialogueLine(speaker: "Jesus", text: "\"Give her to eat.\" And He charged them strictly that no man should know it.", scriptureRef: "Mark 5:43 (DRB)", speakerColor: .white),
                DialogueLine(speaker: "Jairus", text: "She lives! My daughter lives! Praise be to God..."),
                DialogueLine(speaker: "Simon Peter", text: "He wept. Jesus wept with the mourners before He raised her. He went through the grief with us."),
            ],
            recruitableApostles: [],
            bossName: "Grief & Despair",
            discipleCommentary: [
                "John: \"He put the mourners out of the room. Not out of cruelty — He didn't need their unbelief in the room.\"",
                "James: \"'Talitha cumi.' He spoke so gently. As if waking a sleeping child. Which is what He said she was.\"",
                "Andrew: \"She was twelve years old — the same number of years the other woman had suffered. Nothing is coincidence with Him.\"",
            ],
            faithReward: 4
        )
    }

    // ─────────────────────────────────────────────
    // Scene 5: Loaves and Fishes (Mark 6:30-44) — ACT I CLIMAX
    // ─────────────────────────────────────────────
    static func chapter5() -> Chapter {
        Chapter(
            number: 5,
            title: "Loaves and Fishes",
            subtitle: "Mark 6:30-44",
            scriptureRange: "Mark 6:30-44",
            act: 1, encounterType: .provision, hasBattle: true, showScriptureMemoryAfter: true,
            introDialogue: [
                DialogueLine(speaker: "Narrator", text: "And the apostles coming together unto Jesus, related to him all things that they had done and taught.", scriptureRef: "Mark 6:30 (DRB)"),
                DialogueLine(speaker: "Jesus", text: "\"Come apart into a desert place, and rest a little.\"", scriptureRef: "Mark 6:31 (DRB)", speakerColor: .white),
                DialogueLine(speaker: "Narrator", text: "A great multitude saw them going and ran before them to meet them. Jesus had compassion on them.", scriptureRef: "Mark 6:33-34 (DRB)"),
                DialogueLine(speaker: "Simon Peter", text: "Master, it is getting late. Send the people away so they can buy bread in the villages."),
                DialogueLine(speaker: "Jesus", text: "\"Give you them to eat.\"", scriptureRef: "Mark 6:37 (DRB)", speakerColor: .white),
                DialogueLine(speaker: "Philip", text: "Two hundred pennyworth of bread is not sufficient! How shall we feed five thousand men?", speakerColor: SKColor(red: 0.5, green: 0.35, blue: 0.7, alpha: 1)),
                DialogueLine(speaker: "Jesus", text: "\"How many loaves have you? Go and see.\"", scriptureRef: "Mark 6:38 (DRB)", speakerColor: .white),
                DialogueLine(speaker: "Andrew", text: "Five loaves. Two fish. That's all we found.", speakerColor: SKColor(red: 0.2, green: 0.6, blue: 0.5, alpha: 1)),
                DialogueLine(speaker: "Jesus", text: "\"Make all sit down by companies upon the green grass.\"", scriptureRef: "Mark 6:39 (DRB)", speakerColor: .white),
                DialogueLine(speaker: "Narrator", text: "🍞 PROVISION MIRACLE: Use 'Give Thanks & Distribute' to multiply the loaves and fish. Feed all 5,000 souls!"),
                DialogueLine(speaker: "Narrator", text: "Philip has joined the party! ⭐"),
            ],
            battleEnemies: [CharacterFactory.spiritOfHunger()],
            postBattleDialogue: [
                DialogueLine(speaker: "Narrator", text: "And he, taking the five loaves and the two fishes, looking up to heaven, blessed, and broke the loaves, and gave them to his disciples to set before them.", scriptureRef: "Mark 6:41 (DRB)"),
                DialogueLine(speaker: "Narrator", text: "And they did all eat, and had their fill. And they took up the leavings, twelve full baskets of fragments, and of the fishes.", scriptureRef: "Mark 6:42-43 (DRB)"),
                DialogueLine(speaker: "Simon Peter", text: "Twelve baskets. One for each of us. He gave us more than we could carry."),
                DialogueLine(speaker: "Philip", text: "I said two hundred pennyworth was not enough. I was thinking about money. He was thinking about abundance.", speakerColor: SKColor(red: 0.5, green: 0.35, blue: 0.7, alpha: 1)),
                DialogueLine(speaker: "Narrator", text: "The twelve baskets are added to your inventory — blessed provision that restores HP and MP."),
                DialogueLine(speaker: "Narrator", text: "🎉 ACT I COMPLETE — \"The beginning of the gospel of Jesus Christ, the Son of God.\" — Mark 1:1 (DRB)"),
                DialogueLine(speaker: "Narrator", text: "You've witnessed Jesus' authority over demons, storm, death, and hunger. Who is this man?"),
            ],
            recruitableApostles: [CharacterFactory.philip()],
            bossName: "Spirit of Hunger",
            discipleCommentary: [
                "Philip: \"I calculated. I said it was impossible. I was wrong. I will not make that mistake again.\"",
                "Andrew: \"I found the boy with the loaves. I almost didn't mention it — it seemed too little. Always bring what you have.\"",
                "John: \"He looked up to heaven before He broke them. He thanked the Father first. That is the order of everything.\"",
            ],
            faithReward: 5
        )
    }

    // MARK: - ACT II — THE ROAD: The Cost of Following (Scenes 6–9)

    // ─────────────────────────────────────────────
    // Scene 6: Walking on Water (Matthew 14:22-33 + Mark 6:45-52)
    // ─────────────────────────────────────────────
    static func chapter6() -> Chapter {
        Chapter(
            number: 6,
            title: "Walking on Water",
            subtitle: "Matthew 14:22-33",
            scriptureRange: "Matthew 14:22-33",
            act: 2, encounterType: .natureMiracle, hasBattle: true, showScriptureMemoryAfter: false,
            introDialogue: [
                DialogueLine(speaker: "Narrator", text: "And forthwith Jesus obliged his disciples to go up into the boat, and to go before him over the water, till he dismissed the people.", scriptureRef: "Mark 6:45 (DRB)"),
                DialogueLine(speaker: "Narrator", text: "The sea arose, by reason of a great wind that blew. And in the fourth watch of the night, he came to them walking upon the sea.", scriptureRef: "Matthew 14:24-25 (DRB)"),
                DialogueLine(speaker: "Simon Peter", text: "A ghost! It's a ghost!", speakerColor: SKColor(red: 0.3, green: 0.3, blue: 0.8, alpha: 1)),
                DialogueLine(speaker: "Jesus", text: "\"Have confidence, it is I, fear ye not.\"", scriptureRef: "Mark 6:50 (DRB)", speakerColor: .white),
                DialogueLine(speaker: "Simon Peter", text: "\"Lord, if it be thou, bid me come to thee upon the waters.\"", scriptureRef: "Matthew 14:28 (DRB)", speakerColor: SKColor(red: 0.3, green: 0.3, blue: 0.8, alpha: 1)),
                DialogueLine(speaker: "Jesus", text: "\"Come.\"", scriptureRef: "Matthew 14:29 (DRB)", speakerColor: .white),
                DialogueLine(speaker: "Narrator", text: "⛈️ Phase 1: Hold out for 5 turns as the storm rages. Keep your eyes on Jesus — He is coming."),
            ],
            battleEnemies: [CharacterFactory.nightStorm(), CharacterFactory.doubtAndFearWater()],
            postBattleDialogue: [
                DialogueLine(speaker: "Narrator", text: "And Peter going down out of the boat, walked upon the water to come to Jesus. But seeing the wind strong, he was afraid: and when he began to sink, he cried out.", scriptureRef: "Matthew 14:29-30 (DRB)"),
                DialogueLine(speaker: "Simon Peter", text: "\"Lord, save me!\"", scriptureRef: "Matthew 14:30 (DRB)", speakerColor: SKColor(red: 0.3, green: 0.3, blue: 0.8, alpha: 1)),
                DialogueLine(speaker: "Jesus", text: "\"O thou of little faith, why didst thou doubt?\"", scriptureRef: "Matthew 14:31 (DRB)", speakerColor: .white),
                DialogueLine(
                    speaker: "Simon Peter",
                    text: "He was sinking. What would you say to yourself in that moment?",
                    choices: [
                        DialogueChoice(id: "c6_a", label: "\"I took my eyes off Him. That was my mistake.\"", faithDelta: 2,
                                      followUpText: "✨ +2 Faith — Peter's lesson. Keep your eyes on Jesus, not the waves.", scriptureRef: nil),
                        DialogueChoice(id: "c6_b", label: "\"The waves were too big. Anyone would have sunk.\"", faithDelta: -1,
                                      followUpText: "Peter was walking on the water until he looked at the waves. The problem was not the waves.", scriptureRef: nil),
                        DialogueChoice(id: "c6_c", label: "\"I don't know. It all happened so fast.\"", faithDelta: 0,
                                      followUpText: "Honesty is a start. Peter didn't know either — but he cried out to the Lord, and that was enough.", scriptureRef: nil),
                    ]
                ),
                DialogueLine(speaker: "Narrator", text: "And immediately Jesus stretching forth his hand took hold of him, and said to him: O thou of little faith, why didst thou doubt?", scriptureRef: "Matthew 14:31 (DRB)"),
                DialogueLine(speaker: "John", text: "He caught him. Immediately. He did not let him sink further.", speakerColor: SKColor(red: 0.2, green: 0.4, blue: 0.7, alpha: 1)),
            ],
            recruitableApostles: [],
            bossName: "Night Storm",
            discipleCommentary: [
                "Simon Peter: \"I was walking on water. I was actually walking on water. And then I looked down.\"",
                "John: \"'O thou of little faith.' He said it with love, not anger. That made it worse and better at once.\"",
                "Andrew: \"The other disciples stayed in the boat. Peter at least got out. There is something to that.\"",
            ],
            faithReward: 3
        )
    }

    // ─────────────────────────────────────────────
    // Scene 7: The Boy with an Unclean Spirit (Mark 9:14-29) — was Ch3
    // ─────────────────────────────────────────────
    static func chapter7() -> Chapter {
        Chapter(
            number: 7,
            title: "The Boy with an Unclean Spirit",
            subtitle: "Mark 9:14-29",
            scriptureRange: "Mark 9:14-29",
            act: 2, encounterType: .exorcism, hasBattle: true, showScriptureMemoryAfter: false,
            introDialogue: [
                DialogueLine(speaker: "Narrator", text: "And coming to his disciples, he saw a great multitude about them, and the scribes disputing with them.", scriptureRef: "Mark 9:14 (DRB)"),
                DialogueLine(speaker: "Father", text: "\"Master, I have brought my son to thee, having a dumb spirit.\"", scriptureRef: "Mark 9:17 (DRB)"),
                DialogueLine(speaker: "Father", text: "\"Wheresoever he taketh him, he throweth him down, and he foameth, and gnasheth with the teeth... and I asked thy disciples to cast him out, and they could not.\"", scriptureRef: "Mark 9:18 (DRB)"),
                DialogueLine(speaker: "Jesus", text: "\"O incredulous generation, how long shall I be with you? how long shall I suffer you? Bring him unto me.\"", scriptureRef: "Mark 9:19 (DRB)", speakerColor: .white),
                DialogueLine(speaker: "Jesus", text: "\"If thou canst believe, all things are possible to him that believeth.\"", scriptureRef: "Mark 9:23 (DRB)", speakerColor: .white),
                DialogueLine(speaker: "Father", text: "\"I do believe, Lord: help my unbelief.\"", scriptureRef: "Mark 9:24 (DRB)"),
                DialogueLine(speaker: "Jesus", text: "\"This kind can go out by nothing, but by prayer and fasting.\"", scriptureRef: "Mark 9:29 (DRB)", speakerColor: .white),
                DialogueLine(speaker: "Narrator", text: "⚔️ This spirit resists normal attacks. Use the PRAY ability — it deals triple damage to this spirit. \"This kind can go out by nothing, but by prayer.\""),
                DialogueLine(speaker: "Narrator", text: "Thomas the Questioner joins — his Doubt Turned Faith ability is especially effective!"),
                DialogueLine(speaker: "Narrator", text: "Thomas has joined the party! ⭐"),
            ],
            battleEnemies: [CharacterFactory.deafMuteSpirit(), CharacterFactory.lesserDemon()],
            postBattleDialogue: [
                DialogueLine(speaker: "Jesus", text: "\"Thou deaf and dumb spirit, I command thee, go out of him; and enter not any more into him.\"", scriptureRef: "Mark 9:25 (DRB)", speakerColor: .white),
                DialogueLine(speaker: "Narrator", text: "And crying out, and greatly tearing him, he went out of him, and he became as dead, so that many said: He is dead.", scriptureRef: "Mark 9:26 (DRB)"),
                DialogueLine(speaker: "Narrator", text: "But Jesus taking him by the hand, lifted him up, and he arose.", scriptureRef: "Mark 9:27 (DRB)"),
                DialogueLine(speaker: "Simon Peter", text: "Lord, why could we not cast him out?"),
                DialogueLine(speaker: "Jesus", text: "\"This kind can go out by nothing, but by prayer and fasting.\"", scriptureRef: "Mark 9:29 (DRB)", speakerColor: .white),
                DialogueLine(speaker: "Thomas", text: "\"I do believe, Lord: help my unbelief.\" That father said what I think every day. And the Lord helped him anyway.", speakerColor: SKColor(red: 0.6, green: 0.4, blue: 0.2, alpha: 1)),
            ],
            recruitableApostles: [CharacterFactory.thomas()],
            bossName: "Deaf & Mute Spirit",
            discipleCommentary: [
                "Thomas: \"The father's honesty moved me. He didn't pretend to have perfect faith. He told the truth. And Jesus healed his son.\"",
                "Simon Peter: \"We tried and failed. I hate that. But He taught us — prayer, not just effort.\"",
                "John: \"Doubt and faith can exist in the same heart. The prayer is: help me with the part I'm still working on.\"",
            ],
            faithReward: 4
        )
    }

    // ─────────────────────────────────────────────
    // Scene 8: Blind Bartimaeus (Mark 10:46-52) — dialogue-driven healing
    // ─────────────────────────────────────────────
    static func chapter8() -> Chapter {
        Chapter(
            number: 8,
            title: "Blind Bartimaeus",
            subtitle: "Mark 10:46-52",
            scriptureRange: "Mark 10:46-52",
            act: 2, encounterType: .healing, hasBattle: true, showScriptureMemoryAfter: false,
            introDialogue: [
                DialogueLine(speaker: "Narrator", text: "And they came to Jericho: and as he went out of Jericho with his disciples, and a very great multitude, Bartimaeus the blind man, the son of Timaeus, sat by the way side begging.", scriptureRef: "Mark 10:46 (DRB)"),
                DialogueLine(speaker: "Bartimaeus", text: "\"Jesus, son of David, have mercy on me!\"", scriptureRef: "Mark 10:47 (DRB)"),
                DialogueLine(speaker: "Crowd Member", text: "Silence! You're disturbing everyone. Be quiet!"),
                DialogueLine(
                    speaker: "Narrator",
                    text: "The crowd rebukes the blind man. What do you do?",
                    choices: [
                        DialogueChoice(id: "c8_a", label: "[C] Encourage him: \"Take courage! He's calling thee!\" (Mark 10:49)", faithDelta: 2,
                                      followUpText: "✨ +2 Faith — You choose compassion over the crowd's pressure. Bartimaeus is heard.", scriptureRef: "Mark 10:49 (DRB)"),
                        DialogueChoice(id: "c8_b", label: "[B] Say nothing — let him keep crying out.", faithDelta: 0,
                                      followUpText: "Silence. Bartimaeus cries out again — and Jesus hears him.", scriptureRef: nil),
                        DialogueChoice(id: "c8_c", label: "[A] Tell him to be quiet — it's disruptive.", faithDelta: -1,
                                      followUpText: "You bow to the crowd's pressure. But Bartimaeus cries out again, and Jesus stops anyway.", scriptureRef: nil),
                    ]
                ),
                DialogueLine(speaker: "Narrator", text: "And Jesus, standing still, commanded him to be called. And they call the blind man, saying to him:", scriptureRef: "Mark 10:49 (DRB)"),
                DialogueLine(speaker: "Narrator", text: "\"Have a good heart, arise, he calleth thee.\"", scriptureRef: "Mark 10:49 (DRB)"),
                DialogueLine(speaker: "Narrator", text: "🤲 HEALING ENCOUNTER: Guide Bartimaeus through the crowd to Jesus. The healing has already been decided — faith is what brings him there."),
            ],
            battleEnemies: [CharacterFactory.spiritOfBlindness()],
            postBattleDialogue: [
                DialogueLine(speaker: "Jesus", text: "\"What wilt thou that I should do to thee?\"", scriptureRef: "Mark 10:51 (DRB)", speakerColor: .white),
                DialogueLine(speaker: "Bartimaeus", text: "\"Rabboni, that I may see.\"", scriptureRef: "Mark 10:51 (DRB)"),
                DialogueLine(speaker: "Jesus", text: "\"Go thy way, thy faith hath made thee whole.\"", scriptureRef: "Mark 10:52 (DRB)", speakerColor: .white),
                DialogueLine(speaker: "Narrator", text: "And immediately he saw, and followed him in the way.", scriptureRef: "Mark 10:52 (DRB)"),
                DialogueLine(speaker: "Thomas", text: "He asked the obvious question. A blind man wants to see. But Jesus asked him to say it. Why?", speakerColor: SKColor(red: 0.6, green: 0.4, blue: 0.2, alpha: 1)),
                DialogueLine(speaker: "John", text: "Because He wants us to ask. He already knows what we need — He wants us to bring it to Him.", speakerColor: SKColor(red: 0.2, green: 0.4, blue: 0.7, alpha: 1)),
                DialogueLine(speaker: "Simon Peter", text: "He didn't care what the crowd thought. He just kept calling out. That's faith."),
            ],
            recruitableApostles: [],
            bossName: "Spirit of Blindness",
            discipleCommentary: [
                "Bartimaeus: \"Thy faith hath made thee whole. Not my pity, not my command — his faith. Faith is active.\"",
                "Thomas: \"He threw off his cloak when Jesus called him. He left it behind. He wasn't going back to begging.\"",
                "Andrew: \"The crowd told him to be quiet. He cried out more. Don't let the crowd silence your prayer.\"",
            ],
            faithReward: 3
        )
    }

    // ─────────────────────────────────────────────
    // Scene 9: The Triumphal Entry (Mark 11:1-11) — ACT II CLIMAX, no encounter
    // ─────────────────────────────────────────────
    static func chapter9() -> Chapter {
        Chapter(
            number: 9,
            title: "The Triumphal Entry",
            subtitle: "Mark 11:1-11",
            scriptureRange: "Mark 11:1-11",
            act: 2, encounterType: .none, hasBattle: false, showScriptureMemoryAfter: true,
            introDialogue: [
                DialogueLine(speaker: "Narrator", text: "And when they were drawing near to Jerusalem, unto Bethphage and Bethania unto the mount of Olives, he sendeth two of his disciples.", scriptureRef: "Mark 11:1 (DRB)"),
                DialogueLine(speaker: "Jesus", text: "\"Go into the village that is over against you, and immediately at your coming in thither, you shall find a colt tied, upon which no man yet hath sat: loose him, and bring him.\"", scriptureRef: "Mark 11:2 (DRB)", speakerColor: .white),
                DialogueLine(speaker: "Narrator", text: "And many spread their garments in the way: and others cut down boughs from the trees, and strewed them in the way.", scriptureRef: "Mark 11:8 (DRB)"),
                DialogueLine(speaker: "Crowd", text: "\"Hosanna: Blessed is he that cometh in the name of the Lord. Blessed be the kingdom of our father David that cometh: Hosanna in the highest.\"", scriptureRef: "Mark 11:9-10 (DRB)"),
                DialogueLine(speaker: "Philip", text: "The whole city is crying out! 'Son of David' — they call Him king!", speakerColor: SKColor(red: 0.5, green: 0.35, blue: 0.7, alpha: 1)),
                DialogueLine(speaker: "Simon Peter", text: "This is the moment. Jerusalem. The time is coming."),
                DialogueLine(speaker: "Narrator", text: "Walk with the procession to the Temple gates. Speak to the crowd — they are welcoming their King."),
            ],
            battleEnemies: [],
            postBattleDialogue: [
                DialogueLine(speaker: "Narrator", text: "And he entered into Jerusalem into the temple: and having viewed all things round about, when now the eventide was come, he went out to Bethania with the twelve.", scriptureRef: "Mark 11:11 (DRB)"),
                DialogueLine(speaker: "Narrator", text: "He looked at everything. And then He left quietly."),
                DialogueLine(speaker: "John", text: "The people cheered 'Hosanna' — save us! But they meant something different than what He was about to do.", speakerColor: SKColor(red: 0.2, green: 0.4, blue: 0.7, alpha: 1)),
                DialogueLine(
                    speaker: "Narrator",
                    text: "The crowds praised Him as a king. What do you expect from Him?",
                    choices: [
                        DialogueChoice(id: "c9_a", label: "\"He will overthrow the Romans and restore David's throne.\"", faithDelta: 0,
                                      followUpText: "That was what most expected. They were wrong — and right in a deeper way than they knew.", scriptureRef: nil),
                        DialogueChoice(id: "c9_b", label: "\"I don't know. I just know He is more than I can understand.\"", faithDelta: 2,
                                      followUpText: "✨ +2 Faith — Honest unknowing is the beginning of real faith. He will show you who He is.", scriptureRef: nil),
                        DialogueChoice(id: "c9_c", label: "\"Whatever He does, I will follow Him.\"", faithDelta: 1,
                                      followUpText: "✨ +1 Faith — That commitment is what discipleship is. The understanding will come.", scriptureRef: nil),
                    ]
                ),
                DialogueLine(speaker: "Narrator", text: "The music shifts. A shadow falls over Jerusalem. Something is coming."),
                DialogueLine(speaker: "Narrator", text: "🎉 ACT II COMPLETE — \"And they were in the way going up to Jerusalem.\" — Mark 10:32 (DRB)"),
            ],
            recruitableApostles: [],
            bossName: "",
            discipleCommentary: [
                "Philip: \"The whole city came out. They cut palms. They threw their cloaks on the road. And He looked at everything, and left quietly. What does that mean?\"",
                "Thomas: \"'Hosanna' means 'save us now.' They were right to cry it — they just didn't know what saving would look like.\"",
                "Simon Peter: \"He rode in on a young donkey. Not a war horse. Not a chariot. A donkey. That tells you something.\"",
            ],
            faithReward: 3
        )
    }

    // MARK: - ACT III — JERUSALEM: The Cross and the Empty Tomb (Scenes 10–12)

    // ─────────────────────────────────────────────
    // Scene 10: The Temple (Mark 11:15-18, 12:28-34)
    // ─────────────────────────────────────────────
    static func chapter10() -> Chapter {
        Chapter(
            number: 10,
            title: "The Temple",
            subtitle: "Mark 11:15-18; 12:28-34",
            scriptureRange: "Mark 11:15-18; 12:28-34",
            act: 3, encounterType: .faithTrial, hasBattle: true, showScriptureMemoryAfter: false,
            introDialogue: [
                DialogueLine(speaker: "Narrator", text: "And they came to Jerusalem. And when he was entered into the temple, he began to cast out them that sold and bought in the temple.", scriptureRef: "Mark 11:15 (DRB)"),
                DialogueLine(speaker: "Narrator", text: "And he overthrew the tables of the moneychangers, and the chairs of them that sold doves.", scriptureRef: "Mark 11:15 (DRB)"),
                DialogueLine(speaker: "Jesus", text: "\"Is it not written: My house shall be called the house of prayer to all nations? But you have made it a den of thieves.\"", scriptureRef: "Mark 11:17 (DRB)", speakerColor: .white),
                DialogueLine(speaker: "Simon Peter", text: "That was... I have never seen Him like that. A holy anger. Not rage — something much colder and truer."),
                DialogueLine(speaker: "Narrator", text: "And there came one of the scribes... and asked him: Which is the first commandment of all?", scriptureRef: "Mark 12:28 (DRB)"),
                DialogueLine(speaker: "Scribe", text: "\"Which is the first commandment of all?\"", scriptureRef: "Mark 12:28 (DRB)"),
                DialogueLine(speaker: "Narrator", text: "🙏 FAITH TRIAL: Can you answer the greatest commandment correctly? Choose wisely — this is what everything hangs on."),
            ],
            battleEnemies: [CharacterFactory.spiritOfCommerce()],
            postBattleDialogue: [
                DialogueLine(speaker: "Jesus", text: "\"The first commandment of all is, Hear, O Israel: the Lord thy God is one God. And thou shalt love the Lord thy God with thy whole heart, and with thy whole soul, and with thy whole mind, and with thy whole strength.\"", scriptureRef: "Mark 12:29-30 (DRB)", speakerColor: .white),
                DialogueLine(speaker: "Jesus", text: "\"This is the first commandment. And the second is like to it: Thou shalt love thy neighbour as thyself. There is no other commandment greater than these.\"", scriptureRef: "Mark 12:31 (DRB)", speakerColor: .white),
                DialogueLine(speaker: "Scribe", text: "\"Well, Master, thou hast said in truth that there is one God, and there is no other besides him.\"", scriptureRef: "Mark 12:32 (DRB)"),
                DialogueLine(speaker: "Jesus", text: "\"Thou art not far from the kingdom of God.\"", scriptureRef: "Mark 12:34 (DRB)", speakerColor: .white),
                DialogueLine(speaker: "Thomas", text: "He told the scribe: 'Not far from the kingdom.' Not in it yet — but not far. There is hope for everyone who seeks honestly.", speakerColor: SKColor(red: 0.6, green: 0.4, blue: 0.2, alpha: 1)),
                DialogueLine(speaker: "Simon Peter", text: "The whole law hanging on love. Everything else flows from that."),
            ],
            recruitableApostles: [],
            bossName: "Spirit of Commerce",
            discipleCommentary: [
                "Thomas: \"Love God. Love your neighbour. Two commandments. The whole law. I need a lifetime to understand this.\"",
                "John: \"The scribe was genuinely seeking. Jesus honoured that. He did not drive him away.\"",
                "Simon Peter: \"My house shall be called a house of prayer. The temple had become a marketplace. Religion without prayer is empty noise.\"",
            ],
            faithReward: 4
        )
    }

    // ─────────────────────────────────────────────
    // Scene 11: Gethsemane (Mark 14:32-50) — THE PASSION
    // ─────────────────────────────────────────────
    static func chapter11() -> Chapter {
        Chapter(
            number: 11,
            title: "Gethsemane",
            subtitle: "Mark 14:32-50",
            scriptureRange: "Mark 14:32-50",
            act: 3, encounterType: .faithTrial, hasBattle: true, showScriptureMemoryAfter: false,
            introDialogue: [
                DialogueLine(speaker: "Narrator", text: "And they came to a farm called Gethsemani. And he saith to his disciples: Sit you here, while I pray.", scriptureRef: "Mark 14:32 (DRB)"),
                DialogueLine(speaker: "Jesus", text: "\"My soul is sorrowful even unto death: stay you here, and watch.\"", scriptureRef: "Mark 14:34 (DRB)", speakerColor: .white),
                DialogueLine(speaker: "Narrator", text: "And going forward a little, he fell flat on the ground, and he prayed...", scriptureRef: "Mark 14:35 (DRB)"),
                DialogueLine(speaker: "Jesus", text: "\"Abba, Father, all things are possible to thee: remove this chalice from me; but not what I will, but what thou wilt.\"", scriptureRef: "Mark 14:36 (DRB)", speakerColor: .white),
                DialogueLine(speaker: "Narrator", text: "The garden is dark. The darkness itself seems alive — pressing in. Peter, James, and John struggle to keep watch."),
                DialogueLine(speaker: "Narrator", text: "🌑 GETHSEMANE: Keep watch with prayer. The disciples fall asleep three times — this is the design. Experience their weakness, not your failure."),
                DialogueLine(speaker: "Narrator", text: "Even now, Judas approaches with soldiers. The hour has come."),
            ],
            battleEnemies: [CharacterFactory.spiritOfDarkness()],
            postBattleDialogue: [
                DialogueLine(speaker: "Jesus", text: "\"Watch ye, and pray that ye enter not into temptation. The spirit indeed is willing, but the flesh is weak.\"", scriptureRef: "Mark 14:38 (DRB)", speakerColor: .white),
                DialogueLine(speaker: "Narrator", text: "He came again and found them sleeping, for their eyes were heavy, and they knew not what to answer him.", scriptureRef: "Mark 14:40 (DRB)"),
                DialogueLine(speaker: "Narrator", text: "Then came Judas, one of the twelve, and with him a great multitude with swords and clubs."),
                DialogueLine(speaker: "Judas", text: "\"Whomsoever I shall kiss, that is he: lay hold on him, and lead him away carefully.\"", scriptureRef: "Mark 14:44 (DRB)"),
                DialogueLine(speaker: "Narrator", text: "Then all his disciples leaving him, fled.", scriptureRef: "Mark 14:50 (DRB)"),
                DialogueLine(speaker: "Narrator", text: "They all fled. The party scatters. This is not failure of the game — this is the truth of the Gospel. The disciples abandoned Him, and He went to the Cross anyway."),
                DialogueLine(speaker: "Narrator", text: "\"The spirit indeed is willing, but the flesh is weak.\" — Mark 14:38 (DRB)"),
                DialogueLine(speaker: "Narrator", text: "📖 The trial, the scourging, the crucifixion, and the burial of our Lord — Mark 14:53–15:47. Read in silence.", scriptureRef: "Mark 14:53–15:47 (DRB)"),
                DialogueLine(speaker: "Narrator", text: "\"And when the sixth hour was come, there was darkness over the whole earth until the ninth hour. And at the ninth hour, Jesus cried out with a loud voice, saying: Eloi, Eloi, lamma sabacthani?\"", scriptureRef: "Mark 15:33-34 (DRB)"),
                DialogueLine(speaker: "Narrator", text: "\"Which is, being interpreted, My God, my God, why hast thou forsaken me?\"", scriptureRef: "Mark 15:34 (DRB)"),
                DialogueLine(speaker: "Narrator", text: "\"And Jesus having cried out with a loud voice, gave up the ghost.\"", scriptureRef: "Mark 15:37 (DRB)"),
                DialogueLine(speaker: "Narrator", text: "\"And the veil of the temple was rent in two, from the top to the bottom.\"", scriptureRef: "Mark 15:38 (DRB)"),
                DialogueLine(speaker: "Narrator", text: "\"And the centurion who stood over against him, seeing that crying out in this manner he had given up the ghost, said: Indeed this man was the Son of God.\"", scriptureRef: "Mark 15:39 (DRB)"),
                DialogueLine(speaker: "Narrator", text: "He was laid in the tomb. The stone was rolled over the entrance. Night fell on Jerusalem."),
            ],
            recruitableApostles: [],
            bossName: "Spirit of Darkness",
            discipleCommentary: [
                "Simon Peter: \"I could not even stay awake. And later that night... you know what I did. God forgive me.\"",
                "John: \"He prayed 'not my will, but thine.' That is the hardest prayer ever prayed. He prayed it for us.\"",
                "Thomas: \"The centurion said it at the Cross: 'Indeed this man was the Son of God.' A Roman soldier saw what the crowds missed.\"",
            ],
            faithReward: 5
        )
    }

    // ─────────────────────────────────────────────
    // Scene 12: The Empty Tomb (Mark 16:1-8) — EPILOGUE
    // ─────────────────────────────────────────────
    static func chapter12() -> Chapter {
        Chapter(
            number: 12,
            title: "The Empty Tomb",
            subtitle: "Mark 16:1-8",
            scriptureRange: "Mark 16:1-8",
            act: 3, encounterType: .none, hasBattle: false, showScriptureMemoryAfter: false,
            introDialogue: [
                DialogueLine(speaker: "Narrator", text: "The third day. Early morning. The sun not yet risen."),
                DialogueLine(speaker: "Narrator", text: "And when the sabbath was past, Mary Magdalen, and Mary the mother of James, and Salome, bought sweet spices, that coming, they might anoint Jesus.", scriptureRef: "Mark 16:1 (DRB)"),
                DialogueLine(speaker: "Mary Magdalene", text: "Who shall roll us back the stone from the door of the sepulchre?", scriptureRef: "Mark 16:3 (DRB)", speakerColor: SKColor(red: 0.8, green: 0.3, blue: 0.5, alpha: 1)),
                DialogueLine(speaker: "Narrator", text: "And looking, they saw the stone was rolled back. For it was very great.", scriptureRef: "Mark 16:4 (DRB)"),
                DialogueLine(speaker: "Narrator", text: "Walk to the tomb, Mary. The answer is already there."),
            ],
            battleEnemies: [],
            postBattleDialogue: [
                DialogueLine(speaker: "Narrator", text: "And entering into the sepulchre, they saw a young man sitting on the right side, clothed with a white robe: and they were astonished.", scriptureRef: "Mark 16:5 (DRB)"),
                DialogueLine(speaker: "Angel", text: "\"Be not affrighted; you seek Jesus of Nazareth, who was crucified: he is risen, he is not here, behold the place where they laid him.\"", scriptureRef: "Mark 16:6 (DRB)", speakerColor: SKColor(red: 0.95, green: 0.95, blue: 0.8, alpha: 1)),
                DialogueLine(speaker: "Angel", text: "\"But go, tell his disciples and Peter that he goeth before you into Galilee; there you shall see him, as he told you.\"", scriptureRef: "Mark 16:7 (DRB)", speakerColor: SKColor(red: 0.95, green: 0.95, blue: 0.8, alpha: 1)),
                DialogueLine(speaker: "Narrator", text: "And Peter — named individually. Not forgotten. The one who denied Him three times is named first. Grace."),
                DialogueLine(speaker: "Mary Magdalene", text: "He is risen. He is not here. He is... risen.", speakerColor: SKColor(red: 0.8, green: 0.3, blue: 0.5, alpha: 1)),
                DialogueLine(speaker: "Narrator", text: "He is risen. He is risen indeed. ✝"),
                DialogueLine(speaker: "Narrator", text: "\"Go ye into the whole world, and preach the gospel to every creature.\" — Mark 16:15 (DRB)"),
            ],
            recruitableApostles: [],
            bossName: "",
            discipleCommentary: [
                "Mary Magdalene: \"He is risen. I have seen the place where they laid Him. It is empty. He is risen.\"",
                "Simon Peter: \"The angel said 'and Peter.' He named me. After everything — He named me. He did not forget me.\"",
            ],
            faithReward: 5
        )
    }

    // MARK: - All Chapters in narrative order

    static func allChapters() -> [Chapter] {
        [
            chapter1(),   // Scene 1: Synagogue
            chapter2(),   // Scene 2: Gerasene
            chapter3(),   // Scene 3: Peace, Be Still (was Ch4)
            chapter4(),   // Scene 4: Talitha Cumi (was Ch5)
            chapter5(),   // Scene 5: Loaves & Fishes (NEW)
            chapter6(),   // Scene 6: Walking on Water (NEW)
            chapter7(),   // Scene 7: Boy with Unclean Spirit (was Ch3)
            chapter8(),   // Scene 8: Blind Bartimaeus (NEW)
            chapter9(),   // Scene 9: Triumphal Entry (NEW)
            chapter10(),  // Scene 10: The Temple (NEW)
            chapter11(),  // Scene 11: Gethsemane (NEW)
            chapter12(),  // Scene 12: The Empty Tomb (NEW)
        ]
    }
}
