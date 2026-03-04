# Gospel Quest: The Mark of Faith — Game Design Document

**Author:** Philip Neri (🎭 Game Designer, Ecclesia Dev)
**Version:** 1.0
**Date:** 2026-03-03
**Status:** Pending Bellarmine theology review → Augustine implementation

---

## Table of Contents

1. [Vision](#1-vision)
2. [Narrative Structure](#2-narrative-structure)
3. [Mechanics](#3-mechanics)
4. [Level Design](#4-level-design)
5. [Characters](#5-characters)
6. [Balance](#6-balance)
7. [Theological Guardrails](#7-theological-guardrails)
8. [Implementation Priorities](#8-implementation-priorities-what-augustine-builds-next)

---

## 1. Vision

Gospel Quest is a SNES-style RPG that teaches the Gospel of Mark through play. The player walks alongside Jesus as one of the Twelve, witnessing miracles, confronting spiritual darkness, and growing in faith — from the banks of Galilee to the empty tomb.

**Core promise:** A child who finishes this game will want to open the Gospel of Mark and read it for themselves.

**Design pillars:**
- **Faithful** — Every scene, line of dialogue, and ability cites Scripture. Nothing is invented that contradicts the text.
- **Accessible** — Playable by a 9-year-old; not patronizing to an adult. Simple inputs, clear objectives, meaningful choices.
- **Reverent** — Jesus is portrayed with authority and compassion. The Passion is handled with gravity. Miracles are not "power-ups" — they are signs of who Jesus is.
- **SNES soul** — Tile-based overworld, turn-based encounters, pixel art, chiptune music. The aesthetic communicates warmth and nostalgia, not irony.

---

## 2. Narrative Structure

### 2.1 Three-Act Arc (following Mark's Gospel)

The Gospel of Mark divides naturally into three movements. The game mirrors this:

| Act | Mark Chapters | Theme | Scenes |
|-----|---------------|-------|--------|
| **I — Galilee: Who Is This Man?** | 1–5 | Jesus reveals authority over demons, disease, nature, death. Disciples are called and begin to follow. | Scenes 1–5 |
| **II — The Road: The Cost of Following** | 6–10 | Opposition grows. Jesus teaches what discipleship costs. Faith is tested. Peter confesses. | Scenes 6–9 |
| **III — Jerusalem: The Cross and the Empty Tomb** | 11–16 | Triumphal entry, conflict with authorities, betrayal, crucifixion, resurrection. | Scenes 10–12 |

### 2.2 Sequence of Play

```
Title Screen
  → NEW JOURNEY / CONTINUE JOURNEY
  → Prologue text: "The beginning of the good news about Jesus the Messiah..." (Mark 1:1)

ACT I — GALILEE
  Scene 1: The Synagogue at Capernaum (Mark 1:21-28) — TUTORIAL
  Scene 2: The Gerasene Demoniac (Mark 5:1-20)
  Scene 3: Peace, Be Still! (Mark 4:35-41)
  Scene 4: Talitha Cumi (Mark 5:21-43)
  Scene 5: Loaves and Fishes (Mark 6:30-44) — ACT I CLIMAX

ACT II — THE ROAD
  Scene 6: Walking on Water (Mark 6:45-52)
  Scene 7: The Boy with an Unclean Spirit (Mark 9:14-29)
  Scene 8: Blind Bartimaeus (Mark 10:46-52)
  Scene 9: The Triumphal Entry (Mark 11:1-11) — ACT II CLIMAX

ACT III — JERUSALEM
  Scene 10: The Temple (Mark 11:15-18, 12:28-34)
  Scene 11: Gethsemane (Mark 14:32-50) — THE PASSION
  Scene 12: The Empty Tomb (Mark 16:1-8) — EPILOGUE

  → Credits with Mark 16:15 "Go into all the world..."
```

**Note on scene order:** Scenes 3 and 4 (Mark 4–5) are placed after Scene 2 (Mark 5:1-20) because the existing implementation groups the Gerasene chapter early. The narrative flow (sea → storm → healing) works thematically even out of strict verse order. Bellarmine should confirm this is acceptable.

### 2.3 Act Transitions

Between acts, the game shows a brief interstitial:
- **Act I → II:** "And He began to teach them that the Son of Man must suffer many things..." (Mark 8:31). Tone shifts from wonder to gravity.
- **Act II → III:** "They were on their way up to Jerusalem, with Jesus leading the way, and the disciples were astonished..." (Mark 10:32). Music shifts to a minor key.

---

## 3. Mechanics

### 3.1 Movement and Exploration

**Already implemented:** D-pad tile movement, 20×15 maps, collision, camera follow.

**Additions needed:**

- **Interactable objects.** Chests, scrolls, and glowing tiles on the overworld. Walking into them triggers an item pickup or a short Scripture reading. This rewards exploration and embeds verses organically.
- **NPC townspeople.** 2–4 non-story NPCs per map who give one-line dialogue grounding the setting ("The Romans tax us heavily..." / "Have you heard the teacher from Nazareth?"). These do not trigger encounters — they add atmosphere.
- **Map variety.** Later scenes should use larger maps (25×20 for Jerusalem scenes) with multiple paths or optional areas. The Triumphal Entry map should have a linear "procession" path. Gethsemane should be dark, with restricted visibility.

### 3.2 NPC Dialogue System

**Already implemented:** Linear typewriter dialogue with speaker colors, Scripture references inline.

**Additions needed:**

- **Dialogue choices (Faith Responses).** At key story moments, the player is presented with 2–3 response options. These are not branching narrative — the story proceeds the same way — but the player's choice affects their **Faith** stat. This teaches discernment.

  Example (Scene 8, Blind Bartimaeus):
  > Bartimaeus cries out: "Jesus, Son of David, have mercy on me!"
  > The crowd rebukes him. What do you do?
  > - **[A] Tell him to be quiet** (crowd pressure — Faith −1)
  > - **[B] Say nothing** (neutral — Faith +0)
  > - **[C] Encourage him: "Take heart! He's calling you."** (Mark 10:49 — Faith +2)

  Jesus always acts the same regardless of player choice. The point is that the player *witnesses* Jesus's response and sees whether their instinct aligned with His.

- **Disciple commentary.** After major events, party members offer a one-line reaction in-character. Simon Peter says bold, impulsive things. John reflects quietly. This makes the party feel alive.

### 3.3 Faith Mechanic

**Faith** is the central stat of the game. It is NOT a currency to spend. It is a measure of the player's growing understanding.

**How Faith works:**

| Source | Faith Change | Example |
|--------|-------------|---------|
| Dialogue choice (faithful) | +1 to +3 | Encouraging Bartimaeus |
| Dialogue choice (fearful/worldly) | −1 to −2 | Telling Bartimaeus to be quiet |
| Winning an encounter | +1 | Defeating the Unclean Spirit |
| Scripture Memory prompt (correct) | +2 | Completing a verse correctly |
| Scripture Memory prompt (incorrect) | +0 | No penalty — encouragement instead |
| Story milestone | +3 to +5 | Peter's Confession, the Resurrection |

**What Faith affects:**

- **Ability power.** All apostle abilities scale with Faith. A party with high Faith hits harder in encounters. This is thematic: "If you have faith as small as a mustard seed..." (not Mark, but the game cites the Markan parallels).
- **Dialogue unlocks.** At high Faith thresholds (e.g., Faith ≥ 30), optional disciple dialogue lines appear that offer deeper theological insight. These are rewards for engagement, not gameplay-critical.
- **Ending variation.** The epilogue (Scene 12) has three versions based on total party Faith:
  - **Low Faith (< 20):** The women flee the tomb, afraid. "They said nothing to anyone, because they were afraid." (Mark 16:8) — The game gently encourages: "Will you be afraid, or will you tell others what you've seen?"
  - **Mid Faith (20–40):** The women and disciples marvel. "He has risen! He is not here." (Mark 16:6)
  - **High Faith (> 40):** Full commissioning. "Go into all the world and preach the gospel to all creation." (Mark 16:15)

  All three endings are faithful to the text. There is no "bad ending" — only different levels of readiness.

**Faith is per-party, not per-character.** The whole group grows together.

### 3.4 Scripture Memory Prompts

Between scenes (during act transitions or before boss encounters), the game presents a **Scripture Memory** mini-game:

**Format:** A verse from the previous scene is shown with 1–3 key words blanked out. The player selects from 4 multiple-choice options.

**Example (after Scene 1):**
> "What is this? A new _______ — and with authority!" — Mark 1:27
> [A] teaching ✓ [B] power [C] miracle [D] rule

**Rules:**
- Correct answer: Faith +2, brief affirmation ("That's right! The people were amazed at Jesus's teaching.")
- Incorrect answer: Faith +0, the correct verse is shown in full. No punishment — this is a learning tool, not a test.
- Prompts are always optional (player can skip), but skipping grants no Faith.

**Implementation:** A new `ScripturePromptView` with verse text, blank positions, and multiple-choice buttons. Data stored in `ScripturePromptData.swift` alongside `ChapterData`.

### 3.5 Encounter System (not "Combat")

**Already implemented:** Turn-based battle with Attack/Ability/Defend, speed-based turns, damage calculation, MP costs.

**Reframing:** The game does NOT have "combat" in a violent sense. Every encounter represents a **spiritual confrontation**: casting out demons, calming storms, overcoming fear and doubt. The player is never fighting *people* — only spiritual forces of darkness, natural chaos, or inner struggles.

**Encounter types (expanding beyond the current single type):**

| Type | Description | Scenes Used |
|------|-------------|-------------|
| **Exorcism** | Cast out demons. Standard turn-based: use Rebuke, Prayer, Word of God. Demons resist, attack with Fear/Doubt/Accusation. | 1, 2, 7 |
| **Nature miracle** | Calm a storm, walk on water. Turn-limited: the party must use faith-based abilities to reduce the storm's power before a timer runs out. If the timer expires, the boat sinks (soft fail — Jesus calms it anyway, but Faith gain is lower). | 3, 6 |
| **Healing encounter** | Not a "fight." The player selects the right sequence of actions (Pray → Lay Hands → Speak Word) to heal an NPC. Wrong order doesn't fail — it delays. Jesus always heals. The encounter teaches the *process*: prayer, faith, obedience. | 4, 8 |
| **Faith trial** | No enemies. The player's party faces an internal challenge (fear, doubt, grief). Each round, a party member is "tested" with a dialogue prompt. Faithful answers resolve the trial; fearful answers prolong it. | 5, 10, 11 |
| **Provision miracle** | Unique to Scene 5 (Loaves and Fishes). The player must distribute items to a crowd counter. Each turn, the party prays and the items multiply. The encounter ends when the crowd is fed. Teaches abundance through faith. | 5 |

**Enemy ability flavour:** Enemies do not deal "damage" in a physical sense. Their attacks are named: Whisper of Doubt, Accusation, Spirit of Fear, Chains of Darkness. HP loss represents the disciples' wavering resolve. When HP hits 0, a disciple is "overcome with fear" (not dead, not injured). Jesus restores them.

### 3.6 Existing Mechanics — Preserved

The following systems are already well-implemented and should be preserved as-is:

- **Party recruitment** — Apostles join at defined story points
- **Equipment and inventory** — Biblical-themed items with stat bonuses
- **Overworld tile maps** — 20×15 grids with collision
- **Typewriter dialogue** — With speaker colours and Scripture refs
- **Procedural music** — 4 SNES-style themes
- **Save/load** — JSON persistence to Documents

---

## 4. Level Design

### Scene 1: The Synagogue at Capernaum ✅ (Exists)

- **Setting:** Capernaum — stone buildings, dusty paths, the synagogue
- **Gospel passage:** Mark 1:21-28
- **Core mechanic:** TUTORIAL. Introduces movement, dialogue, turn-based encounters
- **Encounter type:** Exorcism (Unclean Spirit)
- **Party:** Jesus + Simon Peter. Recruits: Andrew, James, John, Levi
- **Win condition:** Defeat the Unclean Spirit using Rebuke
- **Fail condition:** All apostles overcome (Jesus revives them; encounter restarts with a hint)
- **Teaching moment:** "Even the unclean spirits obey Him." Jesus's authority is established.
- **Estimated playtime:** 10–12 minutes (includes tutorial prompts)

### Scene 2: The Gerasene Demoniac ✅ (Exists)

- **Setting:** Country of the Gerasenes — tombs, cliffs, the sea shore
- **Gospel passage:** Mark 5:1-20
- **Core mechanic:** Multi-enemy exorcism. Legion is a boss with lesser demons. Teaches target selection.
- **Encounter type:** Exorcism (Legion + 2 Lesser Demons)
- **Party:** Existing party. Recruits: Bartholomew
- **Win condition:** Defeat Legion
- **Fail condition:** Standard (restart encounter)
- **Teaching moment:** The healed man wants to follow Jesus, but Jesus sends him home to testify. Not everyone is called the same way.
- **Estimated playtime:** 12–15 minutes

### Scene 3: Peace, Be Still! ✅ (Exists — currently Chapter 4)

- **Setting:** The Sea of Galilee — open water, a boat, dark storm clouds
- **Gospel passage:** Mark 4:35-41
- **Core mechanic:** Nature miracle. The storm has a "rage meter" that climbs each turn. The party must use Prayer and faith abilities to reduce it. Turn-limited (8 turns).
- **Encounter type:** Nature miracle (The Great Storm + 2 Raging Winds)
- **Win condition:** Reduce the storm's power to 0, OR survive 8 turns (Jesus calms the storm either way)
- **Fail condition:** Soft fail only — if the boat "sinks," Jesus still saves them, but the disciples' dialogue is more fearful and Faith gain is lower (+1 instead of +3)
- **Teaching moment:** "Why are you so afraid? Do you still have no faith?" (Mark 4:40). The question lingers.
- **Estimated playtime:** 8–10 minutes

### Scene 4: Talitha Cumi ✅ (Exists — currently Chapter 5)

- **Setting:** Jairus's house — a village on the lakeshore, mourners outside, a quiet room inside
- **Gospel passage:** Mark 5:21-43
- **Core mechanic:** Healing encounter + Faith trial. First, the player navigates through the crowd (Overworld). Then a Faith trial: Grief & Despair and Doubt & Fear challenge the party with accusatory dialogue ("She's already dead. Why bother the teacher?"). The player must choose faith-filled responses.
- **Encounter type:** Faith trial (Grief & Despair, Doubt & Fear)
- **Win condition:** Overcome doubt through faithful dialogue choices
- **Fail condition:** Soft fail — Jesus raises the girl regardless. Faith gain varies by player responses.
- **Teaching moment:** "Don't be afraid; just believe." (Mark 5:36). The moment Jesus takes only Peter, James, and John into the room.
- **Estimated playtime:** 12–15 minutes

### Scene 5: Loaves and Fishes 🆕 (New)

- **Setting:** A remote hillside near Bethsaida — green grass, large crowd sprites, the lake in the distance
- **Gospel passage:** Mark 6:30-44
- **Core mechanic:** Provision miracle. Unique encounter type. The party has 5 loaves and 2 fish. A "Crowd Hunger" meter shows 5,000. Each turn, the party prays (costs MP), and the food multiplies. The player chooses which apostle distributes (each has a different crowd-reach radius). The encounter ends when the crowd is fed.
- **Encounter type:** Provision miracle
- **Map:** 25×15 — larger map. The crowd is represented by NPC clusters. The player walks through them to reach Jesus at the center, triggering the encounter.
- **Win condition:** Feed the crowd (Crowd Hunger reaches 0). Cannot truly fail — the food always multiplies sufficiently — but efficiency determines Faith bonus.
- **Fail condition:** None. The miracle always works. The lesson is abundance.
- **Post-encounter:** "They all ate and were satisfied, and the disciples picked up twelve basketfuls of broken pieces." (Mark 6:42-43). The party receives 12 baskets as inventory items (consumables that restore HP/MP).
- **Teaching moment:** God provides more than enough. Trust precedes abundance.
- **Act I climax.** Scripture Memory prompt after this scene covers all Act I verses.
- **Estimated playtime:** 10–12 minutes

### Scene 6: Walking on Water 🆕 (New)

- **Setting:** The Sea of Galilee at night — dark water, stars, wind
- **Gospel passage:** Mark 6:45-52
- **Core mechanic:** Nature miracle (variant). The storm rages again, but this time Jesus is not in the boat — He walks on the water toward them. The party must hold out (Defend, Pray) for 5 turns until Jesus arrives. Then Peter asks to walk on the water — a Faith trial: the player controls Peter stepping onto the sea. Each turn, a fear prompt appears; faithful choices keep Peter walking, fearful choices cause him to sink (Jesus catches him).
- **Encounter type:** Nature miracle → Faith trial (two-phase)
- **Map:** 20×15 — The boat, dark water. Minimal land tiles. The overworld segment is short; the encounter is the centrepiece.
- **Win condition:** Phase 1: Survive 5 turns. Phase 2: Reach Jesus (3 faithful choices in a row)
- **Fail condition:** Phase 2 soft fail — Peter sinks, Jesus lifts him up. "You of little faith, why did you doubt?" Faith gain reduced.
- **Teaching moment:** Keeping your eyes on Jesus vs. looking at the waves. Fear is natural; faith is a choice.
- **Estimated playtime:** 10–12 minutes

### Scene 7: The Boy with an Unclean Spirit ✅ (Exists — currently Chapter 3)

- **Setting:** At the foot of a mountain — a crowd, arguing scribes, a desperate father
- **Gospel passage:** Mark 9:14-29
- **Core mechanic:** Exorcism, but harder. The Deaf & Mute Spirit resists standard abilities. The player must discover that only Prayer (a specific ability) works — other abilities deal reduced damage. This teaches: "This kind can come out only by prayer." (Mark 9:29)
- **Encounter type:** Exorcism (Deaf & Mute Spirit + 1 Lesser Demon)
- **Win condition:** Use Prayer ability to weaken the spirit, then Cast Out to finish
- **Fail condition:** Standard (restart with hint: "Have you tried praying?")
- **Teaching moment:** The father's cry: "I believe; help my unbelief!" (Mark 9:24). One of the most honest prayers in Scripture.
- **Estimated playtime:** 12–15 minutes

### Scene 8: Blind Bartimaeus 🆕 (New)

- **Setting:** The road out of Jericho — a dusty road, palm trees, a crowd walking with Jesus, a blind man by the roadside
- **Gospel passage:** Mark 10:46-52
- **Core mechanic:** Healing encounter. This is a non-combat scene focused entirely on dialogue choices. Bartimaeus calls out. The crowd tells him to be quiet. The player chooses whether to support Bartimaeus or side with the crowd (Faith check). Jesus calls Bartimaeus forward. The player-as-disciple helps guide him (overworld navigation — the player walks Bartimaeus to Jesus). Then the healing: not a battle, but a scripted moment where Jesus says "Go, your faith has healed you."
- **Encounter type:** Healing encounter (dialogue-driven)
- **Map:** 20×15 — Linear road from Jericho. Bartimaeus is at one end, Jesus at the other. Crowd NPCs line the road.
- **Win condition:** Guide Bartimaeus to Jesus. Always succeeds — Faith gain varies by dialogue choices.
- **Fail condition:** None. Jesus always heals.
- **Teaching moment:** Faith is persistent. Bartimaeus didn't care what the crowd thought. "What do you want me to do for you?" — Jesus asks the obvious question because He wants us to ask.
- **Estimated playtime:** 8–10 minutes

### Scene 9: The Triumphal Entry 🆕 (New)

- **Setting:** The Mount of Olives → Jerusalem — palm branches, crowds, the city gate, the Temple in the distance
- **Gospel passage:** Mark 11:1-11
- **Core mechanic:** No encounter. This is a procession scene — the player walks with Jesus into Jerusalem. The map is a long, narrow path (30×10) from the Mount of Olives to the city gate. Crowd NPCs wave palms and shout "Hosanna!" The player can interact with crowd members who quote Mark 11:9-10. At the gate, Jesus pauses and looks at the Temple. A somber musical shift. Brief dialogue: "He looked around at everything, but since it was already late, he went out to Bethany..." (Mark 11:11).
- **Encounter type:** None — narrative/exploration only
- **Map:** 30×10 — Elongated procession path. Palm branches as terrain decoration. The city gate is the destination.
- **Win condition:** Reach the Temple entrance
- **Fail condition:** None
- **Teaching moment:** The contrast between the crowd's praise and what is about to happen. The player should feel the shift from celebration to foreboding. This is the Act II climax.
- **Post-scene:** Act transition interstitial. Scripture Memory covers Act II verses.
- **Estimated playtime:** 6–8 minutes

### Scene 10: The Temple 🆕 (New)

- **Setting:** The Temple courts in Jerusalem — columns, merchants, money-changers, then an inner court for teaching
- **Gospel passage:** Mark 11:15-18 (cleansing) + Mark 12:28-34 (greatest commandment)
- **Core mechanic:** Two-part scene. **Part 1:** Jesus overturns the tables — this is NOT a player action. It is a scripted event the player witnesses. The player's role is to observe and respond in dialogue. ("What just happened?" → Dialogue choice reflecting understanding.) **Part 2:** A scribe asks Jesus about the greatest commandment. This becomes a Faith trial: the player must answer correctly from memory (multiple choice). "Love the Lord your God with all your heart..." (Mark 12:30).
- **Encounter type:** Faith trial (dialogue-based, no enemies)
- **Map:** 25×20 — Larger map. Outer court with merchant NPCs, inner court for the teaching scene.
- **Win condition:** Answer the commandment question correctly
- **Fail condition:** Incorrect answer → Jesus still teaches the answer. Faith gain reduced.
- **Teaching moment:** "My house will be called a house of prayer for all nations" (Mark 11:17). Religion without relationship is empty. The greatest commandment is love.
- **Estimated playtime:** 12–15 minutes

### Scene 11: Gethsemane 🆕 (New)

- **Setting:** The Garden of Gethsemane at night — olive trees, darkness, torchlight approaching
- **Gospel passage:** Mark 14:32-50
- **Core mechanic:** The hardest scene emotionally. **Phase 1 — The Prayer:** Jesus asks Peter, James, and John to keep watch. The player controls Peter. A "Wakefulness" meter drains over time. The player must tap "Pray" to stay awake. Three times, the player falls asleep. Three times, Jesus returns and finds them sleeping. The player cannot succeed at staying awake — this is scripted. The lesson is human weakness. **Phase 2 — The Arrest:** Judas arrives with a crowd. A brief Faith trial: "Do you flee or stay?" All the disciples flee (Mark 14:50). The player has no choice — the party scatters. This is the lowest point.
- **Encounter type:** Faith trial (scripted failure — the point is the experience)
- **Map:** 20×15 — Dark map. Very few lit tiles. Olive trees everywhere. Torches appear in Phase 2.
- **Win condition:** There is no "win." The player experiences the disciples' failure. This IS the lesson.
- **Fail condition:** N/A — the scene is designed around failure and grace
- **Teaching moment:** "The spirit is willing, but the flesh is weak." (Mark 14:38). The disciples fail. Jesus goes to the cross anyway. Grace is not earned.
- **Post-scene:** A brief, reverent text passage covers the trial, crucifixion, and burial (Mark 14:53–15:47). These events are narrated, not played. The player reads, not acts. The screen dims. Solemn music.
- **Estimated playtime:** 12–15 minutes (including Passion narrative text)

### Scene 12: The Empty Tomb 🆕 (New)

- **Setting:** Early morning — the garden tomb, a stone rolled away, dawn light
- **Gospel passage:** Mark 16:1-8 (and 16:15 for high-Faith ending)
- **Core mechanic:** Epilogue. The player controls Mary Magdalene (a temporary guest character, not a permanent party member). She walks to the tomb. The stone is rolled away. Inside, a young man in white says: "Don't be alarmed. You are looking for Jesus the Nazarene, who was crucified. He has risen! He is not here." (Mark 16:6). The ending varies by total party Faith (see §3.3). No encounter. Pure narrative.
- **Encounter type:** None — narrative resolution
- **Map:** 15×15 — Small, intimate. The garden. Dawn colours. The open tomb.
- **Win condition:** Reach the tomb
- **Fail condition:** None
- **Teaching moment:** He is risen. The whole Gospel has been leading here. The question for the player: "Will you go and tell?"
- **Post-scene:** Credits roll over Mark 16:15. Party Faith total displayed. Scripture Memory summary of all verses encountered.
- **Estimated playtime:** 5–8 minutes

### Playtime Summary

| Scene | Est. Time | Cumulative |
|-------|-----------|------------|
| 1. Capernaum | 10–12 min | 10–12 min |
| 2. Gerasene | 12–15 min | 22–27 min |
| 3. Peace, Be Still! | 8–10 min | 30–37 min |
| 4. Talitha Cumi | 12–15 min | 42–52 min |
| 5. Loaves & Fishes | 10–12 min | 52–64 min |
| 6. Walking on Water | 10–12 min | 62–76 min |
| 7. Boy with Spirit | 12–15 min | 74–91 min |
| 8. Bartimaeus | 8–10 min | 82–101 min |
| 9. Triumphal Entry | 6–8 min | 88–109 min |
| 10. The Temple | 12–15 min | 100–124 min |
| 11. Gethsemane | 12–15 min | 112–139 min |
| 12. Empty Tomb | 5–8 min | 117–147 min |
| **Total** | | **~2 to 2.5 hours** |

---

## 5. Characters

### 5.1 Jesus (The Messiah)

**Role:** AI companion. Present in every scene. Never controlled directly by the player.

**Portrayal rules:**
- Jesus initiates action. He calls the disciples, rebukes the spirits, calms the storm. The player follows and assists — they do not command Him.
- In encounters, Jesus acts autonomously. The BattleSystem selects His abilities automatically (always the most appropriate for the situation). The player never chooses Jesus's actions.
- Jesus cannot be defeated. His HP cannot reach 0. If all apostles fall, Jesus restores them. He is the constant.
- Jesus speaks with authority but also warmth. His dialogue lines should be direct Scripture quotes or very close paraphrases. He never speaks casually or humorously.
- Jesus asks questions. "Who do you say I am?" "Why are you afraid?" "Do you believe?" These are addressed to the party but felt by the player.

**Stats:** Level 5, HP 200, MP 100, ATK 25, DEF 20, SPD 15, Faith 50. Does not level up — He is already who He is.

### 5.2 Player Character

The player controls **Simon Peter** as the primary viewpoint character. Peter is the most prominent disciple in Mark — impulsive, bold, flawed, and deeply human. The player sees the Gospel through Peter's eyes.

**Why Peter, not a custom character:**
- Mark's Gospel is traditionally associated with Peter's testimony. Playing as Peter is playing *the* witness.
- Peter's arc (bold confession → denial → restoration) mirrors the player's journey from confidence through failure to grace.
- A custom avatar would distance the player from the text. Peter is specific, biblical, and known.

**Peter's character beats across the game:**
- Scenes 1–5: Eager, excited, a bit reckless. "I'll follow you anywhere!"
- Scenes 6–7: Tested. Walking on water and failing. Starting to understand the cost.
- Scenes 8–9: Growing understanding. Peter's confession (referenced in Act II transition).
- Scene 11: The failure in Gethsemane. Cannot stay awake. Will later deny Jesus (narrated, not played).
- Scene 12: Not present at the tomb, but the angel says: "Go, tell his disciples *and Peter*" (Mark 16:7). Peter is named individually. He is not forgotten. Grace.

### 5.3 Recruitable Apostles

| Character | Title | Recruited | Role in Party | Personality in Dialogue |
|-----------|-------|-----------|---------------|------------------------|
| **Andrew** | Fisher of Men | Scene 1 | Support (healing/buffs) | Practical, steady, bridge-builder |
| **James** | Son of Thunder | Scene 1 | Attacker (high damage) | Fiery, passionate, protective |
| **John** | The Beloved | Scene 1 | Healer/Support (high Faith) | Reflective, gentle, perceptive |
| **Levi (Matthew)** | The Tax Collector | Scene 1 | Balanced (good MP pool) | Detail-oriented, grateful for second chances |
| **Bartholomew** | The Honest One | Scene 2 | Tank (high DEF) | Straightforward, skeptical-then-convinced |
| **Philip** | Seeker of Truth | Scene 5 | Support (crowd abilities) | Curious, always asking questions |
| **Thomas** | The Questioner | Scene 7 | Attacker (grows stronger with Faith) | Doubting but honest — his doubt leads to deeper faith |

**Note:** Thomas is a key addition. His mechanical identity (attack power scaling with Faith) makes him weak early and strong late — mirroring his Gospel arc.

### 5.4 Key NPCs

| NPC | Scene(s) | Role |
|-----|----------|------|
| **The Gerasene man** | 2 | Healed demoniac. After the encounter, he asks to follow. Jesus sends him home. Brief but powerful. |
| **Jairus** | 4 | Desperate father. His dialogue should be raw and emotional. "My little daughter is dying. Please come." |
| **The father of the boy** | 7 | "I believe; help my unbelief!" The most relatable NPC in the game. |
| **Blind Bartimaeus** | 8 | Persistent, faith-filled, joyful after healing. A model of simple, bold faith. |
| **The Scribe** | 10 | Not hostile. Genuinely seeking. Jesus tells him: "You are not far from the kingdom of God." (Mark 12:34). Shows that not all religious leaders opposed Jesus. |
| **Mary Magdalene** | 12 | Temporary playable character for the epilogue. Brave, devoted, the first witness. |
| **Pharisees** | 7, 10 | Present as antagonists in dialogue, but never as battle enemies. They are misguided people, not demons. The game must distinguish between human opponents and spiritual evil. |
| **Judas** | 11 | Appears in Gethsemane. His betrayal is shown, not sensationalised. One line: "The one I kiss is the man; arrest him." (Mark 14:44). No villain monologue. |
| **Crowd NPCs** | Various | Villagers, fishermen, merchants, mourners. 1-line dialogue. Ground each setting in its time and place. |

### 5.5 Enemies (Spiritual Forces)

Enemies are NEVER human. They are:

| Enemy | Type | Scenes |
|-------|------|--------|
| Unclean Spirit | Demon | 1 |
| Legion | Demon (boss) | 2 |
| Lesser Demons | Demon (minion) | 2, 7 |
| The Great Storm | Nature/chaos | 3, 6 |
| Raging Wind | Nature (minion) | 3, 6 |
| Grief & Despair | Inner struggle | 4 |
| Doubt & Fear | Inner struggle | 4, 6 |
| Deaf & Mute Spirit | Demon | 7 |
| Spirit of Hunger | Abstract challenge | 5 |
| Spirit of Darkness | Abstract | 11 |

**The Pharisees, Roman soldiers, and Judas are NEVER battle enemies.** They are people. The game confronts spiritual evil, not human enemies.

---

## 6. Balance

### 6.1 Difficulty Curve

The game targets children aged 8–14 as the primary audience, with adults as a secondary audience. The difficulty should feel like a gentle upward slope, not a cliff.

**Principles:**
- **No game-overs.** When the party falls, Jesus restores them and the encounter restarts. The player can retry indefinitely. Failure costs time, not progress.
- **Hints on retry.** After a failed encounter, a hint appears: "Try using Prayer" or "Focus your abilities on Legion first." This teaches without punishing.
- **Soft fail states.** Most scenes have a "Jesus does it anyway" fallback. The player's performance affects Faith gain, not story progression. Everyone reaches the Empty Tomb.
- **Accessibility option: Story Mode.** A toggle on the title screen that reduces encounter difficulty by 50% (enemy HP/ATK halved). For younger children or players who want the story without challenge.

**Per-act difficulty:**

| Act | Encounter Difficulty | Dialogue Complexity | New Mechanics Introduced |
|-----|---------------------|--------------------|-----------------------|
| I (Scenes 1–5) | Easy. Enemies have low HP. Tutorials active. | Simple choices. Clear right answers. | Movement, encounters, dialogue choices, Scripture Memory, Faith stat |
| II (Scenes 6–9) | Medium. Enemies hit harder. Phase-based encounters. | Nuanced choices. Less obvious "right" answer. | Two-phase encounters, healing encounters, procession scenes |
| III (Scenes 10–12) | Emotional, not mechanical. Encounters are Faith trials, not stat checks. | Deep. Gethsemane is about experiencing failure. | Scripted failure, narrated Passion, ending variation |

### 6.2 Stat Scaling

Characters do not currently level up. The design introduces a simple Faith-based scaling:

- **Base stats** are fixed per character (as currently implemented)
- **Faith bonus** applies a multiplier to all ability power: `effectivePower = basePower × (1 + partyFaith / 100)`
  - At Faith 0: abilities deal base damage
  - At Faith 20: abilities deal 1.2× damage
  - At Faith 50: abilities deal 1.5× damage
- **Enemy HP scales per scene** (already roughly implemented — later bosses have more HP)
- **No grinding.** There are no random encounters. Every fight is a set-piece. This prevents the player from out-leveling content.

### 6.3 Estimated Total Playtime

- **First playthrough:** 2–2.5 hours
- **Per session:** Each scene is 8–15 minutes. Natural stopping points between scenes. Ideal for short play sessions.
- **Completionist (all Faith, all Scripture Memory correct):** 2.5–3 hours

### 6.4 Replayability

What brings players back:

1. **Faith score.** Players can replay to get the highest Faith and unlock the fullest ending. The game shows their Faith total at the end — a natural "high score."
2. **Scripture Memory mastery.** The end-credits summary shows which verses the player got right. Completionists will want 100%.
3. **Dialogue exploration.** Different dialogue choices in the Faith Response moments. Players may want to see all options.
4. **Party composition.** With 7+ recruitable apostles and limited active party slots, players can replay with different party members to see their unique commentary.
5. **Story Mode toggle.** A player who found it challenging can replay on Story Mode to focus on the narrative. A player who found it easy can replay on normal to optimize Faith.

---

## 7. Theological Guardrails

### 7.1 MUST NOT (Non-Negotiable)

These rules are absolute. Bellarmine must verify compliance before any build ships.

1. **Jesus is NEVER a stat block to be optimised.** He is not "the best party member." He is the Lord. His presence in the party is a narrative reality, not a gameplay resource. The player cannot equip Him, level Him up, or choose His actions.

2. **Jesus is NEVER defeated, weakened, or shown as insufficient.** His HP cannot reach 0. He does not "fail" encounters. If the party falls, He restores them. This is not a gameplay convenience — it is theology.

3. **Miracles are NEVER "power-ups."** They are signs revealing who Jesus is. The feeding of the 5,000 is not a "resource generation mechanic" — it is an encounter with divine abundance. The calming of the storm is not a "debuff" — it is the Creator commanding His creation. Design language must reflect this.

4. **The Passion is NEVER gamified.** The trial, scourging, crucifixion, and burial are NARRATED (text on screen with solemn music), not played. The player does not control any aspect of Jesus's suffering. There is no "crucifixion level." There is no QTE. There is no score. The player reads, in silence.

5. **No human enemies.** Pharisees, scribes, Roman soldiers, and Judas are people — flawed, but people. They appear in dialogue, not in the encounter system. The game fights spiritual evil (demons, storms, fear, doubt), never people.

6. **No theological invention.** Every line Jesus speaks must be Scripture or a direct paraphrase of Scripture (cited). Disciple dialogue can be original but must be consistent with their biblical characterisation. No "what if" scenarios. No fan fiction.

7. **No prosperity gospel.** Faith is not a currency that "buys" better outcomes. High Faith affects ability scaling and unlocks deeper dialogue, but the story always progresses. The game must not teach that more faith = more material blessing. The disciples with the highest faith in Mark end up fleeing Gethsemane.

8. **No trivialisation of suffering.** The Gerasene demoniac's torment is real. The father's desperation is real. Jairus's grief is real. Bartimaeus's blindness is real. These are not "quest hooks." They are human beings in pain, and Jesus meets them there.

9. **Death is treated with gravity.** When Jairus's daughter dies, the game does not rush past it. The mourners mourn. Jesus weeps with those who weep before He raises her. The resurrection is joy, but it passes through real grief.

10. **The Resurrection is not a "twist ending."** It is the point of everything. The empty tomb scene should feel like dawn breaking after the longest night. The music should lift. The colours should warm. The player should feel the weight of what has happened.

### 7.2 Portrayal Guidelines

**Jesus:**
- Speaks in Scripture or close paraphrase
- Initiates — never reactive to the player
- Shows authority AND compassion (both are essential to Mark's portrait)
- Asks piercing questions
- Is physically present in every scene until the arrest

**The Disciples:**
- Flawed. They misunderstand. They argue about who is greatest. They fall asleep. They flee.
- Growing. They also leave everything to follow. They are brave. They try.
- The game should make the player love them despite their failures — because we see ourselves in them.

**The Pharisees:**
- Not cartoon villains. They are religious men who believe they are right. Some (like the scribe in Mark 12:28-34) are genuinely seeking.
- Their opposition is theological, not personal malice (in this game's portrayal)
- They are NEVER encounter enemies

**Demons/Spiritual Forces:**
- Clearly evil. No ambiguity. No sympathy.
- They recognise Jesus: "I know who you are — the Holy One of God!" (Mark 1:24)
- They are afraid of Him, not the other way around
- Their defeat is inevitable — the question is only whether the disciples will trust Jesus enough to stand firm

### 7.3 Bellarmine Review Checklist

Before implementation begins, Bellarmine should verify:

- [ ] All Jesus dialogue lines are Scripture or faithful paraphrase (with citations)
- [ ] No scene portrays Jesus as controllable, defeatable, or insufficient
- [ ] The Passion sequence is narrated, not gamified
- [ ] No human characters appear as encounter enemies
- [ ] Faith mechanic does not imply prosperity theology
- [ ] Suffering and death are treated with appropriate gravity
- [ ] The Resurrection is portrayed with reverence and joy
- [ ] Disciple characterisations are consistent with their biblical portrayals
- [ ] All Scripture references are accurate (correct book, chapter, verse)
- [ ] The three ending variations (low/mid/high Faith) are all theologically sound

---

## 8. Implementation Priorities (What Augustine Builds Next)

### 8.1 Phase 1 — Core Systems (Highest Priority)

These are engine-level features needed before new content can work:

| # | Task | Description | Complexity |
|---|------|-------------|------------|
| 1 | **Faith system** | Add `partyFaith: Int` to GameState. Track Faith gain/loss from dialogue choices and encounters. Apply Faith scaling to ability power. | Medium |
| 2 | **Dialogue choices** | Extend DialogueLine model with optional `choices: [DialogueChoice]`. Each choice has label text, Faith delta, and a follow-up line. DialogueView renders choice buttons when present. | Medium |
| 3 | **New encounter types** | Refactor BattleSystem to support encounter variants: timed (nature miracles), healing (scripted sequence), faith trial (dialogue-driven), provision (crowd-feeding). Current exorcism type becomes one variant. | High |
| 4 | **Scripture Memory prompts** | New `ScripturePromptView` and `ScripturePromptData`. Shown between scenes. Verse with blanks, 4 multiple-choice options. | Low |
| 5 | **Scene reordering** | Reorder existing chapters to match the 12-scene structure. Current Ch3 (Boy with Spirit) moves to Scene 7. Current Ch4 (Storm) becomes Scene 3. Current Ch5 (Talitha Cumi) becomes Scene 4. | Low |

### 8.2 Phase 2 — New Content

| # | Task | Description | Complexity |
|---|------|-------------|------------|
| 6 | **Scene 5: Loaves & Fishes** | New chapter data, map, dialogue, provision encounter. Recruit Philip. | Medium |
| 7 | **Scene 6: Walking on Water** | New chapter data, map, two-phase encounter (nature + faith trial). | Medium |
| 8 | **Scene 8: Blind Bartimaeus** | New chapter data, map, healing encounter (dialogue-driven). | Low |
| 9 | **Scene 9: Triumphal Entry** | New chapter data, elongated map (30×10), procession mechanic (no encounter). | Low |
| 10 | **Scene 10: The Temple** | New chapter data, larger map (25×20), two-part Faith trial. | Medium |
| 11 | **Scene 11: Gethsemane** | New chapter data, dark map, wakefulness mechanic, scripted failure, Passion narration. | High |
| 12 | **Scene 12: The Empty Tomb** | New chapter data, small map, epilogue, three ending variations, credits. | Medium |
| 13 | **Recruit Thomas** | Add Thomas to CharacterFactory. Unique scaling mechanic (ATK grows with Faith). Joins in Scene 7. | Low |

### 8.3 Phase 3 — Polish

| # | Task | Description | Complexity |
|---|------|-------------|------------|
| 14 | **Act transition interstitials** | Between Acts I→II and II→III, show Scripture quote with tonal shift. | Low |
| 15 | **Overworld NPCs** | Add 2–4 non-story NPCs per map with ambient dialogue. | Low |
| 16 | **Interactable objects** | Chests and scrolls on overworld maps. Item pickups and short Scripture readings. | Low |
| 17 | **Story Mode toggle** | Title screen option. Halves enemy stats. | Low |
| 18 | **Disciple commentary** | Post-encounter one-liners from party members, varying by character. | Low |
| 19 | **Ending & credits** | Faith total display, Scripture Memory summary, Mark 16:15 closing, credits scroll. | Medium |
| 20 | **Sound effects** | SFX for ability use, damage, healing, encounter transitions. Extend MusicEngine. | Medium |

### 8.4 Assets Giotto Needs to Create

| Asset | Type | Priority | Notes |
|-------|------|----------|-------|
| **Philip sprite** | Character PNG | Phase 2 | Match existing apostle style |
| **Thomas sprite** | Character PNG | Phase 2 | Match existing apostle style |
| **Mary Magdalene sprite** | Character PNG | Phase 2 | For Scene 12 only (temporary) |
| **Bartimaeus sprite** | NPC PNG | Phase 2 | Blind man with staff and cloak |
| **Jairus sprite** | NPC PNG | Phase 2 | Synagogue ruler, dignified but desperate |
| **Scribe sprite** | NPC PNG | Phase 2 | For Scene 10. Not a villain — thoughtful |
| **Judas sprite** | NPC PNG | Phase 2 | For Scene 11. Brief appearance. |
| **Crowd NPC variants** | NPC PNGs (3–4) | Phase 3 | Men/women/children for ambient population |
| **Hillside map tiles** | Terrain PNGs | Phase 2 | Green grass, wildflowers for Scene 5 |
| **Night map tiles** | Terrain PNGs | Phase 2 | Dark versions of grass/tree/path for Scenes 6, 11 |
| **Jerusalem map tiles** | Terrain PNGs | Phase 2 | City walls, gates, columns, market stalls |
| **Tomb entrance tile** | Terrain PNG | Phase 2 | Rolled-away stone for Scene 12 |
| **Palm branch decoration** | Terrain PNG | Phase 2 | For Scene 9 procession |
| **Passion narration background** | UI PNG | Phase 2 | Dark, solemn backdrop for text narration |
| **Dawn/resurrection background** | UI PNG | Phase 2 | Warm, golden light for Scene 12 |
| **Gethsemane music theme** | Procedural audio | Phase 2 | Minor key, slow, aching. Extend MusicEngine. |
| **Resurrection music theme** | Procedural audio | Phase 2 | Dawn breaking. Major key, building. |

---

## Appendix A: Scripture Reference Index

Every verse cited in the game, organized by scene:

| Scene | Verses | Usage |
|-------|--------|-------|
| 1 | Mark 1:21-28 | Synagogue exorcism. "Be quiet! Come out of him!" |
| 2 | Mark 5:1-20 | Gerasene demoniac. "Go home to your own people and tell them." |
| 3 | Mark 4:35-41 | Storm calmed. "Why are you so afraid? Do you still have no faith?" |
| 4 | Mark 5:21-43 | Jairus's daughter. "Don't be afraid; just believe." / "Talitha cumi!" |
| 5 | Mark 6:30-44 | Feeding 5,000. "You give them something to eat." |
| 6 | Mark 6:45-52 | Walking on water. "Take courage! It is I. Don't be afraid." |
| 7 | Mark 9:14-29 | Boy with spirit. "I believe; help my unbelief!" / "This kind can come out only by prayer." |
| 8 | Mark 10:46-52 | Bartimaeus. "What do you want me to do for you?" / "Your faith has healed you." |
| 9 | Mark 11:1-11 | Triumphal entry. "Hosanna! Blessed is he who comes in the name of the Lord!" |
| 10 | Mark 11:15-18, 12:28-34 | Temple. "My house will be called a house of prayer for all nations." / "Love the Lord your God with all your heart..." |
| 11 | Mark 14:32-50 | Gethsemane. "The spirit is willing, but the flesh is weak." |
| — | Mark 14:53–15:47 | Passion narration (text only). |
| 12 | Mark 16:1-8, 16:15 | Resurrection. "He has risen! He is not here." / "Go into all the world..." |

---

*"The beginning of the good news about Jesus the Messiah, the Son of God." — Mark 1:1*
