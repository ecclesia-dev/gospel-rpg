import SpriteKit

struct ChapterData {
    
    static func chapter1() -> Chapter {
        Chapter(
            number: 1,
            title: "The Synagogue at Capernaum",
            subtitle: "Mark 1:21-28",
            scriptureRange: "Mark 1:21-28",
            introDialogue: [
                DialogueLine(speaker: "Narrator", text: "Jesus and His disciples went to Capernaum, and when the Sabbath came, He entered the synagogue and began to teach.", scriptureRef: "Mark 1:21"),
                DialogueLine(speaker: "Narrator", text: "The people were amazed at His teaching, because He taught them as one who had authority, not as the teachers of the law.", scriptureRef: "Mark 1:22"),
                DialogueLine(speaker: "Simon Peter", text: "Master, the people are astonished by your words!", speakerColor: SKColor(red: 0.3, green: 0.3, blue: 0.8, alpha: 1)),
                DialogueLine(speaker: "Jesus", text: "The time has come. The kingdom of God has come near. Repent and believe the good news!", scriptureRef: "Mark 1:15", speakerColor: .white),
                DialogueLine(speaker: "Narrator", text: "Just then, a man in the synagogue who was possessed by an impure spirit cried out...", scriptureRef: "Mark 1:23"),
                DialogueLine(speaker: "Unclean Spirit", text: "\"What do you want with us, Jesus of Nazareth? Have you come to destroy us? I know who you are—the Holy One of God!\"", scriptureRef: "Mark 1:24", speakerColor: .red),
                DialogueLine(speaker: "Jesus", text: "We must free this man from the spirit's grip. Stand firm in faith!", speakerColor: .white),
            ],
            battleEnemies: [CharacterFactory.synagogueSpirit()],
            postBattleDialogue: [
                DialogueLine(speaker: "Jesus", text: "\"Be quiet! Come out of him!\"", scriptureRef: "Mark 1:25", speakerColor: .white),
                DialogueLine(speaker: "Narrator", text: "The impure spirit shook the man violently and came out of him with a shriek.", scriptureRef: "Mark 1:26"),
                DialogueLine(speaker: "Crowd", text: "\"What is this? A new teaching—and with authority! He even gives orders to impure spirits and they obey him.\"", scriptureRef: "Mark 1:27"),
                DialogueLine(speaker: "Narrator", text: "News about Jesus spread quickly over the whole region of Galilee.", scriptureRef: "Mark 1:28"),
                DialogueLine(speaker: "Simon Peter", text: "That was incredible, Master! The spirit obeyed your command!"),
                DialogueLine(speaker: "Narrator", text: "Earlier, as Jesus walked beside the Sea of Galilee, He saw Simon and his brother Andrew casting a net into the lake, for they were fishermen.", scriptureRef: "Mark 1:16"),
                DialogueLine(speaker: "Andrew", text: "Brother! Jesus called us to follow Him. I am here!", speakerColor: SKColor(red: 0.2, green: 0.6, blue: 0.5, alpha: 1)),
                DialogueLine(speaker: "Jesus", text: "\"Come, follow me, and I will send you out to fish for people.\"", scriptureRef: "Mark 1:17", speakerColor: .white),
                DialogueLine(speaker: "Narrator", text: "Andrew has joined the party! ⭐"),
                DialogueLine(speaker: "Narrator", text: "When He had gone a little farther, He saw James son of Zebedee and his brother John in a boat, preparing their nets.", scriptureRef: "Mark 1:19"),
                DialogueLine(speaker: "James", text: "We saw what you did in the synagogue, Teacher. We will follow you!", speakerColor: SKColor(red: 0.7, green: 0.2, blue: 0.2, alpha: 1)),
                DialogueLine(speaker: "John", text: "My brother speaks for us both. Where you go, we will go.", speakerColor: SKColor(red: 0.2, green: 0.4, blue: 0.7, alpha: 1)),
                DialogueLine(speaker: "Narrator", text: "Without delay, He called them, and they left their father Zebedee in the boat with the hired men and followed Him.", scriptureRef: "Mark 1:20"),
                DialogueLine(speaker: "Narrator", text: "James has joined the party! ⭐"),
                DialogueLine(speaker: "Narrator", text: "John has joined the party! ⭐"),
            ],
            recruitableApostles: [CharacterFactory.andrew(), CharacterFactory.james(), CharacterFactory.john()],
            bossName: "Unclean Spirit"
        )
    }
    
    static func chapter2() -> Chapter {
        Chapter(
            number: 2,
            title: "The Gerasene Demoniac",
            subtitle: "Mark 5:1-20",
            scriptureRange: "Mark 5:1-20",
            introDialogue: [
                DialogueLine(speaker: "Narrator", text: "They went across the Sea of Galilee to the region of the Gerasenes.", scriptureRef: "Mark 5:1"),
                DialogueLine(speaker: "Narrator", text: "When Jesus got out of the boat, a man with an impure spirit came from the tombs to meet Him.", scriptureRef: "Mark 5:2"),
                DialogueLine(speaker: "Narrator", text: "This man lived among the tombs, and no one could bind him anymore, not even with a chain.", scriptureRef: "Mark 5:3"),
                DialogueLine(speaker: "Narrator", text: "Night and day among the tombs and in the hills he would cry out and cut himself with stones.", scriptureRef: "Mark 5:5"),
                DialogueLine(speaker: "Simon Peter", text: "Master, look! That poor man... he's tormented terribly!"),
                DialogueLine(speaker: "Andrew", text: "No chains can hold him. What manner of spirit possesses him?"),
                DialogueLine(speaker: "Narrator", text: "When the man saw Jesus from a distance, he ran and fell on his knees in front of Him.", scriptureRef: "Mark 5:6"),
                DialogueLine(speaker: "Legion", text: "\"What do you want with me, Jesus, Son of the Most High God? In God's name don't torture me!\"", scriptureRef: "Mark 5:7", speakerColor: .red),
                DialogueLine(speaker: "Jesus", text: "\"What is your name?\"", scriptureRef: "Mark 5:9", speakerColor: .white),
                DialogueLine(speaker: "Legion", text: "\"My name is Legion, for we are many.\"", scriptureRef: "Mark 5:9", speakerColor: .red),
                DialogueLine(speaker: "Jesus", text: "This is a powerful spirit. Everyone, prepare yourselves!", speakerColor: .white),
            ],
            battleEnemies: [CharacterFactory.legion(), CharacterFactory.lesserDemon(), CharacterFactory.lesserDemon()],
            postBattleDialogue: [
                DialogueLine(speaker: "Jesus", text: "\"Come out of this man, you impure spirit!\"", scriptureRef: "Mark 5:8", speakerColor: .white),
                DialogueLine(speaker: "Narrator", text: "The demons begged Jesus to send them into a herd of pigs nearby. He gave them permission.", scriptureRef: "Mark 5:12-13"),
                DialogueLine(speaker: "Narrator", text: "The herd, about two thousand in number, rushed down the steep bank into the sea and were drowned.", scriptureRef: "Mark 5:13"),
                DialogueLine(speaker: "Narrator", text: "The man who had been possessed was now sitting there, dressed and in his right mind.", scriptureRef: "Mark 5:15"),
                DialogueLine(speaker: "Healed Man", text: "Thank you, Lord! Please, let me go with you!"),
                DialogueLine(speaker: "Jesus", text: "\"Go home to your own people and tell them how much the Lord has done for you, and how He has had mercy on you.\"", scriptureRef: "Mark 5:19", speakerColor: .white),
                DialogueLine(speaker: "Narrator", text: "So the man went away and told everyone in the Decapolis how much Jesus had done for him. And all the people were amazed.", scriptureRef: "Mark 5:20"),
                DialogueLine(speaker: "Narrator", text: "As Jesus walked along, He saw Levi son of Alphaeus sitting at the tax collector's booth.", scriptureRef: "Mark 2:14"),
                DialogueLine(speaker: "Levi", text: "Teacher, I have heard of your deeds. Even a tax collector may follow?", speakerColor: SKColor(red: 0.6, green: 0.5, blue: 0.2, alpha: 1)),
                DialogueLine(speaker: "Jesus", text: "\"Follow me.\" And Levi got up and followed Him.", scriptureRef: "Mark 2:14", speakerColor: .white),
                DialogueLine(speaker: "Narrator", text: "Levi has joined the party! ⭐"),
            ],
            recruitableApostles: [CharacterFactory.levi()],
            bossName: "Legion"
        )
    }
    
    static func chapter3() -> Chapter {
        Chapter(
            number: 3,
            title: "The Boy with an Unclean Spirit",
            subtitle: "Mark 9:14-29",
            scriptureRange: "Mark 9:14-29",
            introDialogue: [
                DialogueLine(speaker: "Narrator", text: "When they came to the other disciples, they saw a large crowd around them and the teachers of the law arguing with them.", scriptureRef: "Mark 9:14"),
                DialogueLine(speaker: "Father", text: "\"Teacher, I brought you my son, who is possessed by a spirit that has robbed him of speech.\"", scriptureRef: "Mark 9:17"),
                DialogueLine(speaker: "Father", text: "\"Whenever it seizes him, it throws him to the ground. He foams at the mouth, gnashes his teeth and becomes rigid.\"", scriptureRef: "Mark 9:18"),
                DialogueLine(speaker: "Father", text: "\"I asked your disciples to drive out the spirit, but they could not.\"", scriptureRef: "Mark 9:18"),
                DialogueLine(speaker: "Jesus", text: "\"You unbelieving generation, how long shall I stay with you? How long shall I put up with you? Bring the boy to me.\"", scriptureRef: "Mark 9:19", speakerColor: .white),
                DialogueLine(speaker: "Narrator", text: "When the spirit saw Jesus, it immediately threw the boy into a convulsion. He fell to the ground and rolled around, foaming at the mouth.", scriptureRef: "Mark 9:20"),
                DialogueLine(speaker: "Jesus", text: "\"How long has he been like this?\"", scriptureRef: "Mark 9:21", speakerColor: .white),
                DialogueLine(speaker: "Father", text: "\"From childhood. It has often thrown him into fire or water to kill him. But if you can do anything, take pity on us and help us.\"", scriptureRef: "Mark 9:21-22"),
                DialogueLine(speaker: "Jesus", text: "\"'If you can'? Everything is possible for one who believes.\"", scriptureRef: "Mark 9:23", speakerColor: .white),
                DialogueLine(speaker: "Father", text: "\"I do believe; help me overcome my unbelief!\"", scriptureRef: "Mark 9:24"),
                DialogueLine(speaker: "Jesus", text: "Now we face the deaf and mute spirit. Remember: this kind can come out only by prayer!", scriptureRef: "Mark 9:29", speakerColor: .white),
            ],
            battleEnemies: [CharacterFactory.deafMuteSpirit(), CharacterFactory.lesserDemon()],
            postBattleDialogue: [
                DialogueLine(speaker: "Jesus", text: "\"You deaf and mute spirit, I command you, come out of him and never enter him again!\"", scriptureRef: "Mark 9:25", speakerColor: .white),
                DialogueLine(speaker: "Narrator", text: "The spirit shrieked, convulsed the boy violently and came out. The boy looked so much like a corpse that many said, 'He's dead.'", scriptureRef: "Mark 9:26"),
                DialogueLine(speaker: "Narrator", text: "But Jesus took him by the hand and lifted him to his feet, and he stood up.", scriptureRef: "Mark 9:27"),
                DialogueLine(speaker: "Simon Peter", text: "Master, why couldn't we drive it out?"),
                DialogueLine(speaker: "Jesus", text: "\"This kind can come out only by prayer.\"", scriptureRef: "Mark 9:29", speakerColor: .white),
                DialogueLine(speaker: "Narrator", text: "The disciples learned an important lesson: faith and prayer are the keys to overcoming even the most powerful evil."),
                DialogueLine(speaker: "Narrator", text: "🎉 Congratulations! You have completed the Gospel of Mark: Exorcism chapters!"),
                DialogueLine(speaker: "Narrator", text: "Remember: Jesus has authority over all evil. Through faith and prayer, nothing is impossible!"),
                DialogueLine(speaker: "Narrator", text: "\"For God has not given us a spirit of fear, but of power and of love and of a sound mind.\" — 2 Timothy 1:7"),
            ],
            recruitableApostles: [],
            bossName: "Deaf & Mute Spirit"
        )
    }
    
    static func chapter4() -> Chapter {
        Chapter(
            number: 4,
            title: "Peace, Be Still!",
            subtitle: "Mark 4:35-41",
            scriptureRange: "Mark 4:35-41",
            introDialogue: [
                DialogueLine(speaker: "Narrator", text: "That day when evening came, Jesus said to His disciples, \"Let us go over to the other side.\"", scriptureRef: "Mark 4:35"),
                DialogueLine(speaker: "Jesus", text: "Come, let us cross the sea. I have much to teach you about the Kingdom of God.", speakerColor: .white),
                DialogueLine(speaker: "Narrator", text: "Leaving the crowd behind, they took Him along, just as He was, in the boat.", scriptureRef: "Mark 4:36"),
                DialogueLine(speaker: "Simon Peter", text: "The sky grows dark, Master. The fisherman in me says a storm is coming...", speakerColor: SKColor(red: 0.3, green: 0.3, blue: 0.8, alpha: 1)),
                DialogueLine(speaker: "Narrator", text: "A furious squall came up, and the waves broke over the boat, so that it was nearly swamped.", scriptureRef: "Mark 4:37"),
                DialogueLine(speaker: "Andrew", text: "We're taking on water! The waves are enormous!", speakerColor: SKColor(red: 0.2, green: 0.6, blue: 0.5, alpha: 1)),
                DialogueLine(speaker: "James", text: "I've never seen a storm this fierce! Where is the Master?!", speakerColor: SKColor(red: 0.7, green: 0.2, blue: 0.2, alpha: 1)),
                DialogueLine(speaker: "Narrator", text: "Jesus was in the stern, sleeping on a cushion.", scriptureRef: "Mark 4:38"),
                DialogueLine(speaker: "Simon Peter", text: "Teacher, don't you care if we drown?!", scriptureRef: "Mark 4:38"),
                DialogueLine(speaker: "Narrator", text: "The storm rages with supernatural fury! The disciples must hold fast until Jesus acts!"),
            ],
            battleEnemies: [CharacterFactory.theGreatStorm(), CharacterFactory.ragingWind(), CharacterFactory.ragingWind()],
            postBattleDialogue: [
                DialogueLine(speaker: "Narrator", text: "Jesus got up and rebuked the wind and said to the waves:", scriptureRef: "Mark 4:39"),
                DialogueLine(speaker: "Jesus", text: "\"Quiet! Be still!\"", scriptureRef: "Mark 4:39", speakerColor: .white),
                DialogueLine(speaker: "Narrator", text: "Then the wind died down and it was completely calm.", scriptureRef: "Mark 4:39"),
                DialogueLine(speaker: "Jesus", text: "\"Why are you so afraid? Do you still have no faith?\"", scriptureRef: "Mark 4:40", speakerColor: .white),
                DialogueLine(speaker: "Simon Peter", text: "...Who is this? Even the wind and the waves obey Him!", scriptureRef: "Mark 4:41"),
                DialogueLine(speaker: "Narrator", text: "They were terrified and asked each other, \"Who is this? Even the wind and the waves obey Him!\"", scriptureRef: "Mark 4:41"),
            ],
            recruitableApostles: [],
            bossName: "The Great Storm"
        )
    }

    static func chapter5() -> Chapter {
        Chapter(
            number: 5,
            title: "Talitha Cumi",
            subtitle: "Mark 5:21-43",
            scriptureRange: "Mark 5:21-43",
            introDialogue: [
                DialogueLine(speaker: "Narrator", text: "When Jesus had crossed over by boat, a large crowd gathered around Him by the lake.", scriptureRef: "Mark 5:21"),
                DialogueLine(speaker: "Narrator", text: "Then one of the synagogue leaders, named Jairus, came, and when he saw Jesus, he fell at His feet.", scriptureRef: "Mark 5:22"),
                DialogueLine(speaker: "Jairus", text: "\"My little daughter is dying. Please come and put your hands on her so that she will be healed and live.\"", scriptureRef: "Mark 5:23"),
                DialogueLine(speaker: "Jesus", text: "Let us go to her. Have faith.", speakerColor: .white),
                DialogueLine(speaker: "Narrator", text: "On the way, a woman who had been subject to bleeding for twelve years came up behind Jesus in the crowd and touched His cloak.", scriptureRef: "Mark 5:25-27"),
                DialogueLine(speaker: "Woman", text: "\"If I just touch his clothes, I will be healed.\"", scriptureRef: "Mark 5:28"),
                DialogueLine(speaker: "Jesus", text: "\"Who touched my clothes?\"", scriptureRef: "Mark 5:30", speakerColor: .white),
                DialogueLine(speaker: "Woman", text: "She fell at His feet, trembling with fear, and told Him the whole truth.", scriptureRef: "Mark 5:33"),
                DialogueLine(speaker: "Jesus", text: "\"Daughter, your faith has healed you. Go in peace and be freed from your suffering.\"", scriptureRef: "Mark 5:34", speakerColor: .white),
                DialogueLine(speaker: "Messenger", text: "\"Your daughter is dead. Why bother the teacher anymore?\"", scriptureRef: "Mark 5:35"),
                DialogueLine(speaker: "Jesus", text: "\"Don't be afraid; just believe.\"", scriptureRef: "Mark 5:36", speakerColor: .white),
                DialogueLine(speaker: "Narrator", text: "At the house, people were crying and wailing loudly. Grief and despair fill the air..."),
            ],
            battleEnemies: [CharacterFactory.griefAndDespair(), CharacterFactory.doubtAndFear()],
            postBattleDialogue: [
                DialogueLine(speaker: "Jesus", text: "\"Why all this commotion and wailing? The child is not dead but asleep.\"", scriptureRef: "Mark 5:39", speakerColor: .white),
                DialogueLine(speaker: "Narrator", text: "They laughed at Him. But He put them all out, took the child's father and mother and went in where the child was.", scriptureRef: "Mark 5:40"),
                DialogueLine(speaker: "Jesus", text: "\"Talitha cumi!\" — which means, \"Little girl, I say to you, get up!\"", scriptureRef: "Mark 5:41", speakerColor: .white),
                DialogueLine(speaker: "Narrator", text: "Immediately the girl stood up and began to walk around! She was twelve years old. They were completely astonished.", scriptureRef: "Mark 5:42"),
                DialogueLine(speaker: "Jesus", text: "\"Give her something to eat.\" And He gave strict orders not to tell anyone about this.", scriptureRef: "Mark 5:43", speakerColor: .white),
                DialogueLine(speaker: "Jairus", text: "Thank you, Master... my daughter lives! Praise God!"),
                DialogueLine(speaker: "Bartholomew", text: "I am Bartholomew. I have seen you give life to the dead! I must follow you, Teacher.", speakerColor: SKColor(red: 0.4, green: 0.6, blue: 0.3, alpha: 1)),
                DialogueLine(speaker: "Jesus", text: "Come, Bartholomew. There is much work yet to do.", speakerColor: .white),
                DialogueLine(speaker: "Narrator", text: "Bartholomew has joined the party! ⭐"),
                DialogueLine(speaker: "Narrator", text: "🎉 Congratulations! You have completed all 5 chapters of Gospel Quest: The Mark of Faith!"),
                DialogueLine(speaker: "Narrator", text: "You've witnessed Jesus' authority over demons, nature, sickness, and even death itself."),
                DialogueLine(speaker: "Narrator", text: "\"For God so loved the world that He gave His one and only Son, that whoever believes in Him shall not perish but have eternal life.\" — John 3:16"),
            ],
            recruitableApostles: [CharacterFactory.bartholomew()],
            bossName: "Spirit of Death"
        )
    }

    static func allChapters() -> [Chapter] {
        [chapter1(), chapter2(), chapter3(), chapter4(), chapter5()]
    }
}
