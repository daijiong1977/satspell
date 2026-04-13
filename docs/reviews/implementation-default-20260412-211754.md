# 🤖 Copilot CLI Session

> [!NOTE]
> - **Session ID:** `2012ac6c-b938-4ad4-bfaa-bb495e708de5`  
> - **Started:** 4/12/2026, 9:17:55 PM  
> - **Duration:** 6m 4s  
> - **Exported:** 4/12/2026, 9:24:00 PM  

---

<sub>⏱️ 2s</sub>

### 👤 User

Read the Swift source files in ios/SATVocabApp/Sources/ and compare against docs/ui-design-spec.md.

You are reviewing implementation code against the design specification. Check:
1. Does the code match the spec's screen inventory?
2. Are button actions implemented as specified?
3. Are edge cases (pause, resume, recovery) handled?
4. Does the data model match what the spec requires?

Write your review to docs/reviews/implementation-review-default-20260412-211754.md. Be specific — reference file names and line numbers.

---

<sub>⏱️ 13s</sub>

### ✅ `skill`

**using-superpowers**

<details>
<summary>Arguments</summary>

```json
{
  "skill": "using-superpowers"
}
```

</details>

```
Skill "using-superpowers" loaded successfully. Follow the instructions in the skill context.
```


---

<sub>⏱️ 22s</sub>

### ✅ `skill`

**writing-plans**

<details>
<summary>Arguments</summary>

```json
{
  "skill": "writing-plans"
}
```

</details>

```
Skill "writing-plans" loaded successfully. Follow the instructions in the skill context.
```


---

<sub>⏱️ 35s</sub>

### 💬 Copilot

I’m using the loaded planning workflow only as a quick fit-check; for this task the real work is a spec-to-implementation review, so I’m moving into code/spec analysis and writing the report directly.

---

<sub>⏱️ 35s</sub>

### ✅ `view`

**view the file at /Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/.**

/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/

```
SATVocabApp
```


---

<sub>⏱️ 35s</sub>

### ✅ `view`

**view the file at /Users/jiong/myprojects/satspell/docs/ui-design-spec.md.**

/Users/jiong/myprojects/satspell/docs/ui-design-spec.md (lines 1-260)

<details>
<summary>260 lines</summary>

````
1. # SAT Vocab V1 — UI Design Specification
2. 
3. ## Overview
4. 
5. This document is the complete UI specification for SAT Vocab V1. It defines every screen, every button action, every state, and every edge case. The learning model (`docs/learning-model-design.md`) defines **what** happens to the data; this document defines **what the student sees and does**.
6. 
7. This spec is the V1 target. Values marked with ⚙️ are **provisional** and configurable via `AppConfig` — they may be tuned after initial testing without changing the UI structure.
8. 
9. ---
10. 
11. ## 1. App Structure
12. 
13. ### 1.1 Tab Bar (4 tabs)
14. 
15. | Tab | Icon | Label | Primary Purpose |
16. |-----|------|-------|----------------|
17. | 1 | 🗺️ | Map | Adventure progress, zone navigation |
18. | 2 | 📝 | Practice | Daily sessions (primary daily screen) |
19. | 3 | 📊 | Stats | Progress visualization, word mastery |
20. | 4 | 👤 | Profile | Settings, parent report, account |
21. 
22. **Removed from current app:** Tasks tab, Games tab.
23. 
24. **Tab bar behavior:**
25. - Hidden during active sessions (flashcard, game, SAT, recall)
26. - Visible on all 4 main tab screens
27. - Active tab: green (#58CC02) label + dot indicator
28. - Inactive tab: gray (#AFAFAF) label
29. 
30. ### 1.2 Design System
31. 
32. **Colors (Duolingo palette):**
33. 
34. | Token | Hex | Usage |
35. |-------|-----|-------|
36. | primary | #58CC02 | Correct, progress, completed, CTA |
37. | primary-pressed | #58A700 | 3D button bottom border |
38. | gold | #FFC800 | XP, current day, streak, resume |
39. | gold-pressed | #E5AC00 | Gold button bottom border |
40. | orange | #FF9600 | Streaks, SAT questions, warnings |
41. | red | #FF4B4B | Wrong, review needed, hearts |
42. | red-pressed | #EA2B2B | Red button bottom border |
43. | blue | #1CB0F6 | Selected option, info |
44. | blue-pressed | #1899D6 | Blue button bottom border |
45. | purple | #CE82FF | Quick recall, bonus |
46. | text-primary | #4B4B4B | Headings, body text |
47. | text-secondary | #AFAFAF | Subtitles, labels |
48. | border | #E5E5E5 | Card borders, dividers |
49. | bg-light | #F7F7F7 | Section backgrounds |
50. 
51. **3D Button pattern (all major buttons):**
52. - `border-radius: 14px`
53. - `border-bottom: 4px solid [pressed-color]`
54. - `font-weight: 800`
55. - `font-size: 13-15px`
56. - `padding: 12-14px`
57. - `text-transform: uppercase` for action buttons
58. - `letter-spacing: 0.3-0.5px`
59. 
60. **Card pattern:**
61. - `border: 2px solid #E5E5E5`
62. - `border-bottom: 4px solid #E5E5E5`
63. - `border-radius: 14px`
64. - Active/selected: border color changes to relevant color
65. 
66. **Progress bar:**
67. - Height: 7px
68. - Background: #E5E5E5
69. - Fill: rounded, color matches context (green for learning, orange for SAT, purple for recall)
70. 
71. **Typography:** SF Pro (system). Headings: 800 weight. Body: 500-600. Labels: 600, 10px, uppercase, letter-spacing 0.5px.
72. 
73. **Spacing:** 8pt grid (8, 12, 14, 16, 20, 24px).
74. 
75. **Responsive layout rules:**
76. - Use `GeometryReader` proportional sizing, not fixed pt values
77. - SAT passage area: min 35%, max 45% of available height
78. - Image game image: min 40%, max 55% of available height
79. - All interactive elements: minimum 44x44pt touch target
80. - Support Dynamic Type for body text (headings can be fixed)
81. 
82. ### 1.3 Voice & Microcopy
83. 
84. **Tone:** Smart friend + sharp SAT coach. Playful and energetic, but not childish. Quick, witty, slightly self-aware. The app should feel like a study buddy who's genuinely good at SAT vocab, not a generic educational tool.
85. 
86. **Microcopy examples by context:**
87. 
88. | Context | Example Copy |
89. |---------|-------------|
90. | Correct answer | "Nailed it." · "That one's yours now." · "Clean." |
91. | Wrong answer | "That word is fighting back." · "Not yet — you'll get it." · "Tricky one. It'll stick next time." |
92. | Streak maintained | "5 days strong. Keep building." · "Consistency wins." |
93. | Streak broken | "Streaks reset. Knowledge doesn't. Let's go." |
94. | Almost done with step | "3 left. You're cruising." · "Almost there — finish strong." |
95. | Session complete | "Done. Your brain just leveled up." · "See you tonight — let it sink in." |
96. | Stubborn word | "This one keeps coming back. Let's try a new angle." |
97. | Zone unlocked | "Zone 2 unlocked. New territory." · "Cloud Realm awaits." |
98. | Comeback after missed day | "Welcome back. Pick up where you left off." |
99. | Bonus practice | "Extra reps? That's how you get ahead." |
100. | Rush detection | "Slow down — your brain needs a second." |
101. | Evening locked | "Let it marinate. Come back at 5 PM." |
102. | Final day | "372 words. 20 days. Let's see what stuck." |
103. 
104. **Rules:**
105. - No emoji in microcopy text (emoji live in icons/badges, not in sentences)
106. - Max 8 words per line where possible
107. - Never condescending, never fake-enthusiastic
108. - Rotate variants — don't show the same line twice in a session
109. 
110. ### 1.4 Provisional Values ⚙️
111. 
112. These values are configurable in `AppConfig` and may be tuned after initial testing:
113. 
114. | Value | Default | Where Used |
115. |-------|---------|-----------|
116. | Morning new words | 11 ⚙️ | Session 1 flashcard count |
117. | Evening new words | 10 ⚙️ | Session 2 flashcard count |
118. | Image game rounds (morning) | 12 (8 new + 4 review) ⚙️ | Step 2 |
119. | Image game rounds (evening) | 12 (6 new + 6 review) ⚙️ | Step 3 |
120. | SAT questions (morning) | 3 ⚙️ | Step 3 |
121. | SAT questions (evening) | 2 ⚙️ | Step 4 |
122. | Evening unlock gap | 4 hours ⚙️ | Lock timer |
123. | Evening unlock fallback | 5:00 PM ⚙️ | Lock timer |
124. | Back-pressure: reduce threshold | 18 overdue ⚙️ | New word reduction |
125. | Back-pressure: stop threshold | 30 overdue ⚙️ | Review-only day |
126. | Back-pressure: reduced count | 12 new ⚙️ | Reduced day |
127. | Zone test pass threshold | 80% ⚙️ | Zone unlock |
128. | Rush detection: flashcard min | 3 seconds ⚙️ | Toast trigger |
129. | Rush detection: game min | 1 second ⚙️ | Toast trigger |
130. | Background resume threshold | 30 minutes ⚙️ | Resume vs in-place |
131. 
132. ---
133. 
134. ## 2. Tab 1: Adventure Map
135. 
136. ### 2.1 Screen Layout
137. 
138. ```
139. ┌──────────────────────────────┐
140. │ [🔥5]    SAT Vocab     [⚡1.2k] │  ← Header: streak + XP badges
141. │                                │
142. │   🌿 ZONE 1 — Foundation      │  ← Zone title pill
143. │   ████████░░ 49/75 familiar+   │  ← Zone word progress bar
144. │                                │
145. │         [✓] Day 1              │  ← Completed node
146. │         ☀️🌙                    │  ← Session indicators
147. │                                │
148. │            [✓] Day 2           │
149. │            ☀️🌙                 │
150. │                                │
151. │      [☀️] Day 3                │  ← Half state (morning done)
152. │      ☀️ 🌙                     │  ← Morning filled, evening dim
153. │                                │
154. │         [🏆] Test              │  ← Zone test (distinct icon)
155. │                                │
156. │    [ START EVENING SESSION ]   │  ← Context-aware CTA
157. │                                │
158. │  🗺️    📝    📊    👤          │  ← Tab bar
159. └──────────────────────────────┘
160. ```
161. 
162. ### 2.2 Day Node States
163. 
164. | State | Visual | Session Dots | Condition |
165. |-------|--------|-------------|-----------|
166. | Completed | Green circle, ✓, 3D border | ☀️🌙 (both filled) | Both sessions done |
167. | Morning done | Green/Gold split circle, ☀️ icon | ☀️ filled, 🌙 dim | Morning done, evening pending |
168. | Current (not started) | Gold circle, ⭐, pulse glow | Neither filled | Next day to do, morning not started |
169. | Available | Green circle, smaller | Neither filled | Zone unlocked, day accessible |
170. | Locked | Gray circle, 🔒 | Hidden | Zone not unlocked |
171. 
172. ### 2.3 Zone Test Node
173. 
174. - Icon: 🏆 (not ⭐)
175. - Label: "TEST" (not "Day 4")
176. - Color: indigo/purple when available, gray when locked
177. - Tap action: navigate to zone test session
178. 
179. ### 2.4 Zone Navigation
180. 
181. - Left/right chevron buttons to switch zones
182. - Zone background: illustrated image per zone (generated separately)
183. - Zone title pill: semi-transparent, backdrop blur, zone emoji + name
184. - Zone word progress bar: thin bar below title, shows familiar+ word count
185. 
186. ### 2.5 Map Button Actions
187. 
188. | Element | Tap Action |
189. |---------|-----------|
190. | Day node (any state except locked) | Switch to Practice tab with that day selected |
191. | Day node (locked) | Disabled, no action |
192. | Zone test node | Navigate to zone test session |
193. | Zone chevrons | Switch displayed zone |
194. | START button | Navigate to Practice tab, start appropriate session |
195. 
196. ### 2.6 Map CTA Button (context-aware)
197. 
198. | Context | Button Text | Style |
199. |---------|------------|-------|
200. | Morning session available | "START MORNING SESSION" | Green 3D |
201. | Morning done, evening locked | "LET IT MARINATE. BACK AT 5 PM." | Gray 3D |
202. | Evening session available | "START EVENING SESSION" | Green 3D |
203. | Both done today | "DAY COMPLETE ✓" | Green 3D (disabled) |
204. | Session paused | "RESUME SESSION" | Gold 3D |
205. | Recovery needed | "START RECOVERY" | Orange 3D |
206. | Zone locked | "🔒 LOCKED" | Gray 3D (disabled) |
207. 
208. ---
209. 
210. ## 3. Tab 2: Practice (Daily Hub)
211. 
212. This is the primary screen students interact with daily.
213. 
214. ### 3.1 Header
215. 
216. ```
217. Day 5                          🔥5  ⚡1.2k
218. Zone 2 · Cloud Realm
219. SAT Reading & Writing Score Builder
220. ```
221. 
222. - Day number: 18px, weight 800
223. - Zone info: 11px, secondary color
224. - Streak badge: orange background pill
225. - XP badge: gold background pill
226. 
227. ### 3.2 Practice Tab States
228. 
229. The Practice tab has **10 possible states**. Each state shows different cards.
230. 
231. #### State A: Morning Available, Evening Locked
232. 
233. ```
234. ┌─ Morning Session Card (active, green border) ──┐
235. │ ☀️ Morning Session                              │
236. │ Learn 11 new words · ~16 min                    │
237. │ [📚 Flashcards] [🎮 Image Game] [📝 SAT]       │
238. │ [ START ]                                       │
239. └─────────────────────────────────────────────────┘
240. 
241. ┌─ Evening Session Card (dimmed, locked) ─────────┐
242. │ 🌙 Evening Session                    🔒        │
243. │ Review & strengthen · ~17 min                    │
244. │ ┌─────────────────────────────────┐              │
245. │ │ Let it marinate. Back at 5 PM.  │              │
246. │ └─────────────────────────────────┘              │
247. └─────────────────────────────────────────────────┘
248. 
249. Reviews due today: 12 words
250. ```
251. 
252. #### State B: Morning In Progress (Paused)
253. 
254. ```
255. ┌─ Resume Card (gold border) ─────────────────────┐
256. │ ▶️ Continue Morning Session                      │
257. │ Paused at Step 1: Flashcards · 3/11             │
258. │ [███░░░░░░░]                                     │
259. │ [📚 8 left] [🎮 Image Game] [📝 SAT]            │
260. │ [ RESUME ]                                       │
````

</details>


---

<sub>⏱️ 36s</sub>

### ✅ `bash`

**List Swift sources and repo status**

$ cd /Users/jiong/myprojects/satspell && git --no-pager status --short && find ios/SATVocabApp/Sources -type f \( -name '*.swift' -o -name '*.swiftui' \) | sort

<details>
<summary>105 lines</summary>

```
M ios/SATVocabApp/SATVocabApp.xcodeproj/project.pbxproj
 M ios/SATVocabApp/Sources/SATVocabApp/Data/LocalIdentity.swift
 M ios/SATVocabApp/Sources/SATVocabApp/Data/SQLite.swift
 M ios/SATVocabApp/Sources/SATVocabApp/Data/SessionStateStore.swift
 M ios/SATVocabApp/Sources/SATVocabApp/ViewModels/SessionFlowViewModel.swift
 M ios/SATVocabApp/Sources/SATVocabApp/Views/Flashcard/FlashcardStepView.swift
 M ios/SATVocabApp/Sources/SATVocabApp/Views/Game/ImageGameStepView.swift
 M ios/SATVocabApp/Sources/SATVocabApp/Views/Game/ImageGameView.swift
 M ios/SATVocabApp/Sources/SATVocabApp/Views/Game/QuickRecallStepView.swift
 M ios/SATVocabApp/Sources/SATVocabApp/Views/Game/SATQuestionStepView.swift
 M ios/SATVocabApp/Sources/SATVocabApp/Views/Game/SATQuestionView.swift
 M ios/SATVocabApp/Sources/SATVocabApp/Views/Practice/DayCompleteSummary.swift
 M ios/SATVocabApp/Sources/SATVocabApp/Views/Practice/EveningCompleteCard.swift
 M ios/SATVocabApp/Sources/SATVocabApp/Views/Practice/EveningSessionCard.swift
 M ios/SATVocabApp/Sources/SATVocabApp/Views/Practice/MorningCompleteCard.swift
 M ios/SATVocabApp/Sources/SATVocabApp/Views/Practice/MorningSessionCard.swift
 M ios/SATVocabApp/Sources/SATVocabApp/Views/Practice/PracticeStateResolver.swift
 M ios/SATVocabApp/Sources/SATVocabApp/Views/Practice/PracticeTabView.swift
 M ios/SATVocabApp/Sources/SATVocabApp/Views/Practice/ResumeCard.swift
 M ios/SATVocabApp/Sources/SATVocabApp/Views/ProfileView.swift
 M ios/SATVocabApp/Sources/SATVocabApp/Views/Session/SessionCompleteView.swift
 M ios/SATVocabApp/Sources/SATVocabApp/Views/Session/SessionFlowView.swift
 M ios/SATVocabApp/Sources/SATVocabApp/Views/Session/SessionHeaderView.swift
 M ios/SATVocabApp/project.yml
?? ios/SATVocabApp/Tests/SATVocabAppTests/Logic/
?? ios/SATVocabApp/Tests/SATVocabAppUITests/
?? ios/SATVocabApp/build/Build/
?? ios/SATVocabApp/build/CompilationCache.noindex/
?? ios/SATVocabApp/build/Index.noindex/
?? ios/SATVocabApp/build/Logs/
?? ios/SATVocabApp/build/ModuleCache.noindex/
?? ios/SATVocabApp/build/SDKStatCaches.noindex/
?? ios/SATVocabApp/build/info.plist
ios/SATVocabApp/Sources/SATVocabApp/Data/AdventureProgressStore.swift
ios/SATVocabApp/Sources/SATVocabApp/Data/AppConfig.swift
ios/SATVocabApp/Sources/SATVocabApp/Data/ContentImporter.swift
ios/SATVocabApp/Sources/SATVocabApp/Data/DatabasePaths.swift
ios/SATVocabApp/Sources/SATVocabApp/Data/DataManager.swift
ios/SATVocabApp/Sources/SATVocabApp/Data/LiveActivityManager.swift
ios/SATVocabApp/Sources/SATVocabApp/Data/LocalIdentity.swift
ios/SATVocabApp/Sources/SATVocabApp/Data/ReviewLogger.swift
ios/SATVocabApp/Sources/SATVocabApp/Data/SchemaV2.swift
ios/SATVocabApp/Sources/SATVocabApp/Data/SessionStateStore.swift
ios/SATVocabApp/Sources/SATVocabApp/Data/SQLite.swift
ios/SATVocabApp/Sources/SATVocabApp/Data/StatsStore.swift
ios/SATVocabApp/Sources/SATVocabApp/Data/TaskProgressStore.swift
ios/SATVocabApp/Sources/SATVocabApp/Data/WordStateStore.swift
ios/SATVocabApp/Sources/SATVocabApp/Data/ZoneStore.swift
ios/SATVocabApp/Sources/SATVocabApp/Models/AdventureSchedule.swift
ios/SATVocabApp/Sources/SATVocabApp/Models/Enums.swift
ios/SATVocabApp/Sources/SATVocabApp/Models/Models.swift
ios/SATVocabApp/Sources/SATVocabApp/SATVocabAppApp.swift
ios/SATVocabApp/Sources/SATVocabApp/Utils/TextFill.swift
ios/SATVocabApp/Sources/SATVocabApp/Utils/TextHighlight.swift
ios/SATVocabApp/Sources/SATVocabApp/ViewModels/AppBootstrap.swift
ios/SATVocabApp/Sources/SATVocabApp/ViewModels/FlashcardSessionViewModel.swift
ios/SATVocabApp/Sources/SATVocabApp/ViewModels/GameSessionViewModel.swift
ios/SATVocabApp/Sources/SATVocabApp/ViewModels/PracticeTabViewModel.swift
ios/SATVocabApp/Sources/SATVocabApp/ViewModels/SessionFlowViewModel.swift
ios/SATVocabApp/Sources/SATVocabApp/ViewModels/ZoneReviewSessionViewModel.swift
ios/SATVocabApp/Sources/SATVocabApp/Views/AdventureMapView.swift
ios/SATVocabApp/Sources/SATVocabApp/Views/ClozeRoundView.swift
ios/SATVocabApp/Sources/SATVocabApp/Views/Components/Button3D.swift
ios/SATVocabApp/Sources/SATVocabApp/Views/Components/ComboCalloutView.swift
ios/SATVocabApp/Sources/SATVocabApp/Views/Components/WordStrengthMeter.swift
ios/SATVocabApp/Sources/SATVocabApp/Views/Components/XPChipView.swift
ios/SATVocabApp/Sources/SATVocabApp/Views/Flashcard/FlashcardBackView.swift
ios/SATVocabApp/Sources/SATVocabApp/Views/Flashcard/FlashcardCardView.swift
ios/SATVocabApp/Sources/SATVocabApp/Views/Flashcard/FlashcardFrontView.swift
ios/SATVocabApp/Sources/SATVocabApp/Views/Flashcard/FlashcardStepView.swift
ios/SATVocabApp/Sources/SATVocabApp/Views/FlashcardSessionView.swift
ios/SATVocabApp/Sources/SATVocabApp/Views/FlashcardView.swift
ios/SATVocabApp/Sources/SATVocabApp/Views/Game/AnswerFeedbackView.swift
ios/SATVocabApp/Sources/SATVocabApp/Views/Game/ImageGameStepView.swift
ios/SATVocabApp/Sources/SATVocabApp/Views/Game/ImageGameView.swift
ios/SATVocabApp/Sources/SATVocabApp/Views/Game/QuickRecallStepView.swift
ios/SATVocabApp/Sources/SATVocabApp/Views/Game/QuickRecallView.swift
ios/SATVocabApp/Sources/SATVocabApp/Views/Game/SATQuestionStepView.swift
ios/SATVocabApp/Sources/SATVocabApp/Views/Game/SATQuestionView.swift
ios/SATVocabApp/Sources/SATVocabApp/Views/GameSessionView.swift
ios/SATVocabApp/Sources/SATVocabApp/Views/ImageResolver.swift
ios/SATVocabApp/Sources/SATVocabApp/Views/Map/MapDayNode.swift
ios/SATVocabApp/Sources/SATVocabApp/Views/Map/ZoneProgressBar.swift
ios/SATVocabApp/Sources/SATVocabApp/Views/Practice/DayCompleteSummary.swift
ios/SATVocabApp/Sources/SATVocabApp/Views/Practice/EveningCompleteCard.swift
ios/SATVocabApp/Sources/SATVocabApp/Views/Practice/EveningSessionCard.swift
ios/SATVocabApp/Sources/SATVocabApp/Views/Practice/MorningCompleteCard.swift
ios/SATVocabApp/Sources/SATVocabApp/Views/Practice/MorningSessionCard.swift
ios/SATVocabApp/Sources/SATVocabApp/Views/Practice/PracticeHeader.swift
ios/SATVocabApp/Sources/SATVocabApp/Views/Practice/PracticeStateResolver.swift
ios/SATVocabApp/Sources/SATVocabApp/Views/Practice/PracticeTabView.swift
ios/SATVocabApp/Sources/SATVocabApp/Views/Practice/ResumeCard.swift
ios/SATVocabApp/Sources/SATVocabApp/Views/Practice/ReviewsDueRow.swift
ios/SATVocabApp/Sources/SATVocabApp/Views/ProfileView.swift
ios/SATVocabApp/Sources/SATVocabApp/Views/Report/ReportCardGenerator.swift
ios/SATVocabApp/Sources/SATVocabApp/Views/RootTabView.swift
ios/SATVocabApp/Sources/SATVocabApp/Views/SatMCQRoundView.swift
ios/SATVocabApp/Sources/SATVocabApp/Views/Session/PauseSheet.swift
ios/SATVocabApp/Sources/SATVocabApp/Views/Session/SessionCompleteView.swift
ios/SATVocabApp/Sources/SATVocabApp/Views/Session/SessionFlowView.swift
ios/SATVocabApp/Sources/SATVocabApp/Views/Session/SessionHeaderView.swift
ios/SATVocabApp/Sources/SATVocabApp/Views/Session/StepTransitionView.swift
ios/SATVocabApp/Sources/SATVocabApp/Views/StatsView.swift
ios/SATVocabApp/Sources/SATVocabApp/Views/ZoneReviewSessionView.swift
<exited with exit code 0>
```

</details>


---

<sub>⏱️ 46s</sub>

### ✅ `skill`

**dispatching-parallel-agents**

<details>
<summary>Arguments</summary>

```json
{
  "skill": "dispatching-parallel-agents"
}
```

</details>

```
Skill "dispatching-parallel-agents" loaded successfully. Follow the instructions in the skill context.
```


---

<sub>⏱️ 1m 1s</sub>

### 💬 Copilot

I’ve split the review into parallel tracks so I can cross-check screens, lifecycle handling, and data modeling independently before writing the report.

---

<sub>⏱️ 1m 1s</sub>

### ✅ `task`

**Review screens/actions**

<details>
<summary>Arguments</summary>

```json
{
  "description": "Review screens/actions",
  "agent_type": "explore",
  "name": "screen-review",
  "mode": "background",
  "prompt": "Review the Swift implementation in /Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources against /Users/jiong/myprojects/satspell/docs/ui-design-spec.md, focusing only on: (1) screen inventory and screen/state coverage, and (2) button actions/navigation behavior. Identify which Swift files implement the Map, Practice, Stats, Profile, session, and completion screens. Compare them to the UI spec sections, especially tab structure, map behavior, practice states/cards, and session step screens. Return a concise review with concrete mismatches and file+line references from the Swift code and spec section references where helpful. Do not modify files."
}
```

</details>

```
Agent started in background with agent_id: screen-review. You can use read_agent tool with this agent_id to check status and retrieve results. Instruct the user to use /tasks to manage the background agent.
```


---

<sub>⏱️ 1m 1s</sub>

### ✅ `task`

**Review lifecycle edges**

<details>
<summary>Arguments</summary>

```json
{
  "description": "Review lifecycle edges",
  "agent_type": "explore",
  "name": "lifecycle-review",
  "mode": "background",
  "prompt": "Review the Swift implementation in /Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources against /Users/jiong/myprojects/satspell/docs/ui-design-spec.md, focusing only on pause/resume/recovery and backgrounding edge cases. Inspect views, view models, and persistence/store code that govern pausing, resuming, restoring active sessions, and any recovery flow. Check whether the implementation handles the spec's pause, resume, recovery, rush detection/resume thresholds, evening unlock/let-it-marinate, and app relaunch restoration behavior. Return specific findings with file+line references. Do not modify files."
}
```

</details>

```
Agent started in background with agent_id: lifecycle-review. You can use read_agent tool with this agent_id to check status and retrieve results. Instruct the user to use /tasks to manage the background agent.
```


---

<sub>⏱️ 1m 1s</sub>

### ✅ `task`

**Review data model**

<details>
<summary>Arguments</summary>

```json
{
  "description": "Review data model",
  "agent_type": "explore",
  "name": "data-model-review",
  "mode": "background",
  "prompt": "Review the Swift implementation in /Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources against /Users/jiong/myprojects/satspell/docs/ui-design-spec.md, focusing only on the data model and config requirements implied by the spec. Inspect models, stores, config, and related view models for day/session state, zone navigation/test availability, review counts, paused session persistence, XP/streak data, and configurable thresholds. Identify mismatches or missing fields/structures versus what the UI spec requires. Return specific findings with file+line references. Do not modify files."
}
```

</details>

```
Agent started in background with agent_id: data-model-review. You can use read_agent tool with this agent_id to check status and retrieve results. Instruct the user to use /tasks to manage the background agent.
```


---

<sub>⏱️ 1m 9s</sub>

### ✅ `rg`

**/Users/jiong/myprojects/satspell/docs/ui-design-spec.md**

<details>
<summary>Arguments</summary>

```json
{
  "pattern": "^(##|###|####) ",
  "path": "/Users/jiong/myprojects/satspell/docs/ui-design-spec.md",
  "output_mode": "content",
  "-n": true
}
```

</details>

<details>
<summary>94 lines</summary>

```
/Users/jiong/myprojects/satspell/docs/ui-design-spec.md:3:## Overview
/Users/jiong/myprojects/satspell/docs/ui-design-spec.md:11:## 1. App Structure
/Users/jiong/myprojects/satspell/docs/ui-design-spec.md:13:### 1.1 Tab Bar (4 tabs)
/Users/jiong/myprojects/satspell/docs/ui-design-spec.md:30:### 1.2 Design System
/Users/jiong/myprojects/satspell/docs/ui-design-spec.md:82:### 1.3 Voice & Microcopy
/Users/jiong/myprojects/satspell/docs/ui-design-spec.md:110:### 1.4 Provisional Values ⚙️
/Users/jiong/myprojects/satspell/docs/ui-design-spec.md:134:## 2. Tab 1: Adventure Map
/Users/jiong/myprojects/satspell/docs/ui-design-spec.md:136:### 2.1 Screen Layout
/Users/jiong/myprojects/satspell/docs/ui-design-spec.md:162:### 2.2 Day Node States
/Users/jiong/myprojects/satspell/docs/ui-design-spec.md:172:### 2.3 Zone Test Node
/Users/jiong/myprojects/satspell/docs/ui-design-spec.md:179:### 2.4 Zone Navigation
/Users/jiong/myprojects/satspell/docs/ui-design-spec.md:186:### 2.5 Map Button Actions
/Users/jiong/myprojects/satspell/docs/ui-design-spec.md:196:### 2.6 Map CTA Button (context-aware)
/Users/jiong/myprojects/satspell/docs/ui-design-spec.md:210:## 3. Tab 2: Practice (Daily Hub)
/Users/jiong/myprojects/satspell/docs/ui-design-spec.md:214:### 3.1 Header
/Users/jiong/myprojects/satspell/docs/ui-design-spec.md:227:### 3.2 Practice Tab States
/Users/jiong/myprojects/satspell/docs/ui-design-spec.md:231:#### State A: Morning Available, Evening Locked
/Users/jiong/myprojects/satspell/docs/ui-design-spec.md:252:#### State B: Morning In Progress (Paused)
/Users/jiong/myprojects/satspell/docs/ui-design-spec.md:269:#### State C: Morning Done, Evening Locked
/Users/jiong/myprojects/satspell/docs/ui-design-spec.md:283:#### State D: Morning Done, Evening Available
/Users/jiong/myprojects/satspell/docs/ui-design-spec.md:298:#### State E: Both Sessions Complete
/Users/jiong/myprojects/satspell/docs/ui-design-spec.md:321:#### State F1: Recovery Evening (missed last evening only)
/Users/jiong/myprojects/satspell/docs/ui-design-spec.md:343:#### State F2: Catch-Up Day (missed 1 full day)
/Users/jiong/myprojects/satspell/docs/ui-design-spec.md:365:#### State F3: Re-entry Day (missed 3+ days)
/Users/jiong/myprojects/satspell/docs/ui-design-spec.md:385:#### State G: Back-Pressure / Review-Only Day
/Users/jiong/myprojects/satspell/docs/ui-design-spec.md:400:#### State H: Late Night Session (started morning after 8 PM)
/Users/jiong/myprojects/satspell/docs/ui-design-spec.md:417:### 3.3 Recovery Component Architecture
/Users/jiong/myprojects/satspell/docs/ui-design-spec.md:432:### 3.4 Practice-State Priority Resolver
/Users/jiong/myprojects/satspell/docs/ui-design-spec.md:451:### 3.5 Button Actions on Practice Tab
/Users/jiong/myprojects/satspell/docs/ui-design-spec.md:468:## 4. In-Session Flow
/Users/jiong/myprojects/satspell/docs/ui-design-spec.md:470:### 4.1 Session Structure
/Users/jiong/myprojects/satspell/docs/ui-design-spec.md:493:### 4.2 Session Header (all steps)
/Users/jiong/myprojects/satspell/docs/ui-design-spec.md:507:### 4.3 Step 1: Flashcard View (Exposure Only)
/Users/jiong/myprojects/satspell/docs/ui-design-spec.md:551:### 4.4 Step 2: Image-to-Word Game (📊 Scored)
/Users/jiong/myprojects/satspell/docs/ui-design-spec.md:582:### 4.5 Step 3: SAT Question (Split Scroll) (📊 Scored)
/Users/jiong/myprojects/satspell/docs/ui-design-spec.md:615:### 4.6 Quick Recall (Evening Step 2 — 📊 Scored, Day 1 Promotion)
/Users/jiong/myprojects/satspell/docs/ui-design-spec.md:653:### 4.7 Step Transition Screen
/Users/jiong/myprojects/satspell/docs/ui-design-spec.md:679:### 4.8 Session Complete Screen
/Users/jiong/myprojects/satspell/docs/ui-design-spec.md:709:### 4.9 Rush Detection
/Users/jiong/myprojects/satspell/docs/ui-design-spec.md:722:## 5. Session Interruption & Resume
/Users/jiong/myprojects/satspell/docs/ui-design-spec.md:724:### 5.1 Pause Confirmation (tapping ✕)
/Users/jiong/myprojects/satspell/docs/ui-design-spec.md:747:### 5.2 Resume Card
/Users/jiong/myprojects/satspell/docs/ui-design-spec.md:766:### 5.3 App Background / Kill Behavior
/Users/jiong/myprojects/satspell/docs/ui-design-spec.md:777:### 5.4 Edge Case: Pause During Evening, Resume Next Day
/Users/jiong/myprojects/satspell/docs/ui-design-spec.md:786:### 5.5 Restart Semantics
/Users/jiong/myprojects/satspell/docs/ui-design-spec.md:800:## 6. Tab 3: Stats
/Users/jiong/myprojects/satspell/docs/ui-design-spec.md:802:### 6.1 Layout
/Users/jiong/myprojects/satspell/docs/ui-design-spec.md:838:### 6.2 Stats Elements
/Users/jiong/myprojects/satspell/docs/ui-design-spec.md:860:### 6.3 Stats Button Actions
/Users/jiong/myprojects/satspell/docs/ui-design-spec.md:873:## 7. Tab 4: Profile
/Users/jiong/myprojects/satspell/docs/ui-design-spec.md:875:### 7.1 Layout (V1)
/Users/jiong/myprojects/satspell/docs/ui-design-spec.md:899:### 7.2 Profile Button Actions
/Users/jiong/myprojects/satspell/docs/ui-design-spec.md:908:### 7.3 V2 Profile Additions (not in V1)
/Users/jiong/myprojects/satspell/docs/ui-design-spec.md:917:## 8. Parent Report Card
/Users/jiong/myprojects/satspell/docs/ui-design-spec.md:919:### 8.1 Report Card Image (generated in-app)
/Users/jiong/myprojects/satspell/docs/ui-design-spec.md:946:### 8.2 When Report Is Offered
/Users/jiong/myprojects/satspell/docs/ui-design-spec.md:954:## 9. Zone Test Session
/Users/jiong/myprojects/satspell/docs/ui-design-spec.md:956:### 9.1 Structure (reduced from original)
/Users/jiong/myprojects/satspell/docs/ui-design-spec.md:968:### 9.2 Scoring & Remediation
/Users/jiong/myprojects/satspell/docs/ui-design-spec.md:990:### 9.3 Zone Test UI Differences
/Users/jiong/myprojects/satspell/docs/ui-design-spec.md:999:## 10. Final Review Days (19-20)
/Users/jiong/myprojects/satspell/docs/ui-design-spec.md:1001:### Day 19: Weak Word Blitz
/Users/jiong/myprojects/satspell/docs/ui-design-spec.md:1009:### Day 20: Final Assessment
/Users/jiong/myprojects/satspell/docs/ui-design-spec.md:1025:## 11. Screens Inventory
/Users/jiong/myprojects/satspell/docs/ui-design-spec.md:1071:## 12. Data Dependencies
/Users/jiong/myprojects/satspell/docs/ui-design-spec.md:1090:## 13. Global Edge Cases
/Users/jiong/myprojects/satspell/docs/ui-design-spec.md:1094:### First Launch (No Progress)
/Users/jiong/myprojects/satspell/docs/ui-design-spec.md:1102:### Notification Permission Denied
/Users/jiong/myprojects/satspell/docs/ui-design-spec.md:1109:### Report Sharing Before Any Session
/Users/jiong/myprojects/satspell/docs/ui-design-spec.md:1114:### Timezone / Cross-Midnight Behavior
/Users/jiong/myprojects/satspell/docs/ui-design-spec.md:1122:### No Internet
/Users/jiong/myprojects/satspell/docs/ui-design-spec.md:1130:## 14. Gap Resolutions
/Users/jiong/myprojects/satspell/docs/ui-design-spec.md:1134:### 14.1 Recovery Session Structures
/Users/jiong/myprojects/satspell/docs/ui-design-spec.md:1158:### 14.2 Back-Pressure Day Session Structure (State G)
/Users/jiong/myprojects/satspell/docs/ui-design-spec.md:1168:### 14.3 Bonus Practice (State E)
/Users/jiong/myprojects/satspell/docs/ui-design-spec.md:1172:### 14.4 Days 19-20 Session Structures
/Users/jiong/myprojects/satspell/docs/ui-design-spec.md:1192:### 14.5 Zone Test Remediation Day
/Users/jiong/myprojects/satspell/docs/ui-design-spec.md:1196:### 14.6 Map Day Tap Behavior
/Users/jiong/myprojects/satspell/docs/ui-design-spec.md:1206:### 14.7 Evening Unlock Timing Matrix
/Users/jiong/myprojects/satspell/docs/ui-design-spec.md:1216:### 14.8 Distractor Selection Rules
/Users/jiong/myprojects/satspell/docs/ui-design-spec.md:1233:### 14.9 V1 P0 Scope Clarification
/Users/jiong/myprojects/satspell/docs/ui-design-spec.md:1251:## 15. What Is NOT in V1
/Users/jiong/myprojects/satspell/docs/ui-design-spec.md:1276:## 14. Codex Release Review Notes (April 11, 2026)
/Users/jiong/myprojects/satspell/docs/ui-design-spec.md:1280:### Remaining Product Suggestions
/Users/jiong/myprojects/satspell/docs/ui-design-spec.md:1300:### Marketing / Audience Fit Notes
/Users/jiong/myprojects/satspell/docs/ui-design-spec.md:1319:### Short Release Verdict
/Users/jiong/myprojects/satspell/docs/ui-design-spec.md:1323:## Copilot Review (20260412-012104)
/Users/jiong/myprojects/satspell/docs/ui-design-spec.md:1325:### What Looks Good
/Users/jiong/myprojects/satspell/docs/ui-design-spec.md:1330:### Issues Found
/Users/jiong/myprojects/satspell/docs/ui-design-spec.md:1337:### Suggestions
/Users/jiong/myprojects/satspell/docs/ui-design-spec.md:1341:## Cross-Check Review — gpt-5.4 (20260411-213621)
/Users/jiong/myprojects/satspell/docs/ui-design-spec.md:1343:### What Looks Good
/Users/jiong/myprojects/satspell/docs/ui-design-spec.md:1348:### Issues Found
/Users/jiong/myprojects/satspell/docs/ui-design-spec.md:1354:### Suggestions
```

</details>


---

<sub>⏱️ 1m 9s</sub>

### ✅ `glob`

**/Users/jiong/myprojects/satspell**

"ios/SATVocabApp/Sources/SATVocabApp/Views/**/*.{swift}" in /Users/jiong/myprojects/satspell

<details>
<summary>44 matches</summary>

```
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Views/Session/StepTransitionView.swift
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Views/Session/SessionHeaderView.swift
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Views/Session/SessionCompleteView.swift
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Views/Session/SessionFlowView.swift
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Views/Session/PauseSheet.swift
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Views/GameSessionView.swift
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Views/RootTabView.swift
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Views/SatMCQRoundView.swift
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Views/Practice/PracticeStateResolver.swift
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Views/Practice/MorningSessionCard.swift
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Views/Practice/EveningCompleteCard.swift
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Views/Practice/DayCompleteSummary.swift
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Views/Practice/ReviewsDueRow.swift
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Views/Practice/PracticeHeader.swift
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Views/Practice/PracticeTabView.swift
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Views/Practice/EveningSessionCard.swift
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Views/Practice/MorningCompleteCard.swift
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Views/Practice/ResumeCard.swift
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Views/Report/ReportCardGenerator.swift
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Views/StatsView.swift
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Views/ZoneReviewSessionView.swift
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Views/Map/ZoneProgressBar.swift
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Views/Map/MapDayNode.swift
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Views/ImageResolver.swift
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Views/FlashcardView.swift
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Views/Flashcard/FlashcardBackView.swift
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Views/Flashcard/FlashcardCardView.swift
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Views/Flashcard/FlashcardStepView.swift
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Views/Flashcard/FlashcardFrontView.swift
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Views/ClozeRoundView.swift
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Views/ProfileView.swift
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Views/FlashcardSessionView.swift
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Views/AdventureMapView.swift
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Views/Game/SATQuestionView.swift
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Views/Game/AnswerFeedbackView.swift
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Views/Game/QuickRecallStepView.swift
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Views/Game/ImageGameStepView.swift
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Views/Game/QuickRecallView.swift
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Views/Game/ImageGameView.swift
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Views/Game/SATQuestionStepView.swift
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Views/Components/XPChipView.swift
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Views/Components/ComboCalloutView.swift
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Views/Components/Button3D.swift
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Views/Components/WordStrengthMeter.swift
```

</details>


---

<sub>⏱️ 1m 9s</sub>

### ✅ `glob`

**/Users/jiong/myprojects/satspell**

"ios/SATVocabApp/Sources/SATVocabApp/{Models,Data,ViewModels}/**/*.swift" in /Users/jiong/myprojects/satspell

<details>
<summary>24 matches</summary>

```
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/ViewModels/SessionFlowViewModel.swift
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/ViewModels/AppBootstrap.swift
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/ViewModels/PracticeTabViewModel.swift
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/ViewModels/GameSessionViewModel.swift
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/ViewModels/FlashcardSessionViewModel.swift
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/ViewModels/ZoneReviewSessionViewModel.swift
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Models/Models.swift
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Models/AdventureSchedule.swift
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Models/Enums.swift
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Data/SchemaV2.swift
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Data/AppConfig.swift
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Data/DatabasePaths.swift
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Data/ReviewLogger.swift
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Data/AdventureProgressStore.swift
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Data/LiveActivityManager.swift
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Data/TaskProgressStore.swift
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Data/StatsStore.swift
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Data/SessionStateStore.swift
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Data/SQLite.swift
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Data/LocalIdentity.swift
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Data/ContentImporter.swift
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Data/WordStateStore.swift
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Data/ZoneStore.swift
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Data/DataManager.swift
```

</details>


---

<sub>⏱️ 1m 9s</sub>

### ✅ `rg`

**/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp**

<details>
<summary>Arguments</summary>

```json
{
  "pattern": "^(struct|final class|class|enum) ",
  "path": "/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp",
  "glob": "*.swift",
  "output_mode": "content",
  "-n": true,
  "head_limit": 300
}
```

</details>

<details>
<summary>90 lines</summary>

```
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Views/Session/StepTransitionView.swift:3:struct StepTransitionView: View {
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Views/Session/SessionHeaderView.swift:4:struct SessionHeaderView: View {
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Views/ZoneReviewSessionView.swift:3:struct ZoneReviewSessionView: View {
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Views/Report/ReportCardGenerator.swift:3:enum ReportCardGenerator {
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Views/Session/SessionFlowView.swift:3:struct SessionFlowView: View {
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Views/GameSessionView.swift:3:struct GameSessionView: View {
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Views/FlashcardView.swift:5:struct FlashcardView: View {
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Views/FlashcardView.swift:240:struct SoundButton: View {
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Data/SchemaV2.swift:5:enum SchemaV2 {
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Data/AppConfig.swift:3:enum AppConfig {
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Views/Session/SessionCompleteView.swift:3:struct SessionCompleteView: View {
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Data/DatabasePaths.swift:3:enum DatabasePaths {
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Data/AdventureProgressStore.swift:3:final class AdventureProgressStore {
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Views/FlashcardSessionView.swift:3:struct FlashcardSessionView: View {
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Views/Map/ZoneProgressBar.swift:3:struct ZoneProgressBar: View {
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Views/RootTabView.swift:3:struct RootTabView: View {
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Views/SatMCQRoundView.swift:3:struct SatMCQRoundView: View {
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Views/Practice/PracticeStateResolver.swift:3:enum PracticeState {
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Views/Practice/PracticeStateResolver.swift:11:struct PracticeStateResolver {
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Views/Map/MapDayNode.swift:3:struct MapDayNode: View {
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Views/Session/PauseSheet.swift:3:struct PauseSheet: View {
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Views/StatsView.swift:3:struct StatsView: View {
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/ViewModels/SessionFlowViewModel.swift:5:final class SessionFlowViewModel: ObservableObject {
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Models/Models.swift:3:struct VocabCard: Identifiable, Hashable {
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Models/Models.swift:15:struct ListInfo: Identifiable, Hashable {
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Models/Models.swift:22:enum ReviewOutcome: String {
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Models/Models.swift:28:struct SatQuestion: Identifiable, Hashable {
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Models/Models.swift:53:struct ProgressSnapshot: Hashable {
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Models/Models.swift:65:struct WordState: Identifiable, Hashable {
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Models/Models.swift:86:struct DayState: Identifiable, Hashable {
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Models/Models.swift:105:struct SessionState: Identifiable, Hashable {
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Models/Models.swift:120:struct DailyStats: Identifiable, Hashable {
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Models/Models.swift:136:struct StreakInfo: Hashable {
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Models/Models.swift:148:struct ZoneState: Identifiable, Hashable {
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Data/LiveActivityManager.swift:6:struct SessionActivityAttributes: ActivityAttributes {
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Data/LiveActivityManager.swift:20:final class LiveActivityManager {
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Models/AdventureSchedule.swift:3:enum AdventureSchedule {
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Data/TaskProgressStore.swift:3:final class TaskProgressStore {
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Views/Game/SATQuestionView.swift:3:struct SATQuestionView: View {
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Views/Game/SATQuestionView.swift:187:struct SATFeedbackSheet: View {
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Data/ContentImporter.swift:6:enum ImportError: Error, CustomStringConvertible {
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Views/Components/XPChipView.swift:3:struct XPChipView: View {
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Data/WordStateStore.swift:6:enum BoxChange {
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/ViewModels/AppBootstrap.swift:4:final class AppBootstrap: ObservableObject {
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Utils/TextHighlight.swift:3:enum TextHighlight {
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Data/LocalIdentity.swift:3:enum LocalIdentity {
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Views/Game/AnswerFeedbackView.swift:3:struct AnswerFeedbackView: View {
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/ViewModels/PracticeTabViewModel.swift:5:final class PracticeTabViewModel: ObservableObject {
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Views/Components/ComboCalloutView.swift:3:struct ComboCalloutView: View {
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/ViewModels/GameSessionViewModel.swift:3:enum GameSessionMode: String, Hashable {
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/ViewModels/GameSessionViewModel.swift:8:enum GameRound: Hashable {
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/ViewModels/GameSessionViewModel.swift:14:final class GameSessionViewModel: ObservableObject {
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Utils/TextFill.swift:3:enum TextFill {
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Views/ClozeRoundView.swift:3:struct ClozeRoundView: View {
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Views/Game/QuickRecallStepView.swift:3:struct QuickRecallStepView: View {
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Views/ImageResolver.swift:3:enum ImageResolver {
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Views/ProfileView.swift:3:struct ProfileView: View {
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Views/ProfileView.swift:299:struct ShareSheet: UIViewControllerRepresentable {
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Views/Game/ImageGameStepView.swift:3:struct ImageGameStepView: View {
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Views/Game/ImageGameView.swift:3:struct ImageGameView: View {
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Views/Game/SATQuestionStepView.swift:3:struct SATQuestionStepView: View {
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Data/SQLite.swift:6:enum SQLiteError: Error, CustomStringConvertible {
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Data/SQLite.swift:22:final class SQLiteDB: @unchecked Sendable {
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Models/Enums.swift:3:enum SessionType: String, Codable, Identifiable {
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Models/Enums.swift:15:enum ActivityType: String, Codable {
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Models/Enums.swift:21:enum MemoryStatus: String, Codable {
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Models/Enums.swift:25:enum CardState {
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Models/Enums.swift:29:enum WordStrength: Int, CaseIterable {
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/ViewModels/FlashcardSessionViewModel.swift:3:enum FlashcardSessionMode: String, Hashable {
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/ViewModels/FlashcardSessionViewModel.swift:9:final class FlashcardSessionViewModel: ObservableObject {
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/ViewModels/ZoneReviewSessionViewModel.swift:4:final class ZoneReviewSessionViewModel: ObservableObject {
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/SATVocabAppApp.swift:4:struct SATVocabAppApp: App {
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Views/Practice/MorningSessionCard.swift:3:struct MorningSessionCard: View {
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Views/Practice/EveningCompleteCard.swift:3:struct EveningCompleteCard: View {
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Views/Practice/ReviewsDueRow.swift:3:struct ReviewsDueRow: View {
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Views/Flashcard/FlashcardBackView.swift:3:struct FlashcardBackView: View {
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Views/Flashcard/FlashcardBackView.swift:166:struct FlowLayout: Layout {
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Views/Components/WordStrengthMeter.swift:3:struct WordStrengthMeter: View {
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Views/Flashcard/FlashcardStepView.swift:3:struct FlashcardStepView: View {
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Views/Game/QuickRecallView.swift:3:struct QuickRecallView: View {
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Views/Practice/ResumeCard.swift:3:struct ResumeCard: View {
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Views/AdventureMapView.swift:3:struct AdventureMapView: View {
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Views/Practice/PracticeHeader.swift:3:struct PracticeHeader: View {
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Views/Practice/PracticeTabView.swift:3:struct PracticeTabView: View {
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Views/Components/Button3D.swift:3:struct Button3D: View {
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Views/Practice/DayCompleteSummary.swift:3:struct DayCompleteSummary: View {
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Views/Flashcard/FlashcardFrontView.swift:3:struct FlashcardFrontView: View {
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Views/Practice/MorningCompleteCard.swift:3:struct MorningCompleteCard: View {
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Views/Flashcard/FlashcardCardView.swift:3:struct FlashcardCardView: View {
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Views/Practice/EveningSessionCard.swift:3:struct EveningSessionCard: View {
```

</details>


---

<sub>⏱️ 1m 13s</sub>

### ✅ `view`

**view the file at /Users/jiong/myprojects/satspell/docs/ui-design-spec.md.**

/Users/jiong/myprojects/satspell/docs/ui-design-spec.md (lines 186-206)

<details>
<summary>21 lines</summary>

```
186. ### 2.5 Map Button Actions
187. 
188. | Element | Tap Action |
189. |---------|-----------|
190. | Day node (any state except locked) | Switch to Practice tab with that day selected |
191. | Day node (locked) | Disabled, no action |
192. | Zone test node | Navigate to zone test session |
193. | Zone chevrons | Switch displayed zone |
194. | START button | Navigate to Practice tab, start appropriate session |
195. 
196. ### 2.6 Map CTA Button (context-aware)
197. 
198. | Context | Button Text | Style |
199. |---------|------------|-------|
200. | Morning session available | "START MORNING SESSION" | Green 3D |
201. | Morning done, evening locked | "LET IT MARINATE. BACK AT 5 PM." | Gray 3D |
202. | Evening session available | "START EVENING SESSION" | Green 3D |
203. | Both done today | "DAY COMPLETE ✓" | Green 3D (disabled) |
204. | Session paused | "RESUME SESSION" | Gold 3D |
205. | Recovery needed | "START RECOVERY" | Orange 3D |
206. | Zone locked | "🔒 LOCKED" | Gray 3D (disabled) |
```

</details>


---

<sub>⏱️ 1m 13s</sub>

### ✅ `view`

**view the file at /Users/jiong/myprojects/satspell/docs/ui-design-spec.md.**

/Users/jiong/myprojects/satspell/docs/ui-design-spec.md (lines 227-466)

<details>
<summary>240 lines</summary>

````
227. ### 3.2 Practice Tab States
228. 
229. The Practice tab has **10 possible states**. Each state shows different cards.
230. 
231. #### State A: Morning Available, Evening Locked
232. 
233. ```
234. ┌─ Morning Session Card (active, green border) ──┐
235. │ ☀️ Morning Session                              │
236. │ Learn 11 new words · ~16 min                    │
237. │ [📚 Flashcards] [🎮 Image Game] [📝 SAT]       │
238. │ [ START ]                                       │
239. └─────────────────────────────────────────────────┘
240. 
241. ┌─ Evening Session Card (dimmed, locked) ─────────┐
242. │ 🌙 Evening Session                    🔒        │
243. │ Review & strengthen · ~17 min                    │
244. │ ┌─────────────────────────────────┐              │
245. │ │ Let it marinate. Back at 5 PM.  │              │
246. │ └─────────────────────────────────┘              │
247. └─────────────────────────────────────────────────┘
248. 
249. Reviews due today: 12 words
250. ```
251. 
252. #### State B: Morning In Progress (Paused)
253. 
254. ```
255. ┌─ Resume Card (gold border) ─────────────────────┐
256. │ ▶️ Continue Morning Session                      │
257. │ Paused at Step 1: Flashcards · 3/11             │
258. │ [███░░░░░░░]                                     │
259. │ [📚 8 left] [🎮 Image Game] [📝 SAT]            │
260. │ [ RESUME ]                                       │
261. └─────────────────────────────────────────────────┘
262.    Restart from beginning
263. 
264. ┌─ Evening (locked, dimmed) ──────────────────────┐
265. │ Complete morning first                    🔒     │
266. └─────────────────────────────────────────────────┘
267. ```
268. 
269. #### State C: Morning Done, Evening Locked
270. 
271. ```
272. ┌─ Morning Complete (green bg) ───────────────────┐
273. │ ✓ Morning Complete                               │
274. │ 11 new words · 82% accuracy · +180 XP           │
275. └─────────────────────────────────────────────────┘
276. 
277. ┌─ Evening Session Card (dimmed, locked) ─────────┐
278. │ 🌙 Evening Session                    🔒        │
279. │ Unlocks at 5:00 PM (2h 30m remaining)            │
280. └─────────────────────────────────────────────────┘
281. ```
282. 
283. #### State D: Morning Done, Evening Available
284. 
285. ```
286. ┌─ Morning Complete (green bg, compact) ──────────┐
287. │ ✓ Morning · 11 words · 82%                      │
288. └─────────────────────────────────────────────────┘
289. 
290. ┌─ Evening Session Card (active, green border) ───┐
291. │ 🌙 Evening Session                              │
292. │ 10 new + review morning words · ~17 min          │
293. │ [📚 Learn] [🧠 Recall] [🎮 Game] [📝 SAT]      │
294. │ [ START ]                                        │
295. └─────────────────────────────────────────────────┘
296. ```
297. 
298. #### State E: Both Sessions Complete
299. 
300. ```
301. ┌─ Morning Complete (compact) ────────────────────┐
302. │ ✓ Morning · 11 words · 82%                      │
303. └─────────────────────────────────────────────────┘
304. ┌─ Evening Complete (compact) ────────────────────┐
305. │ ✓ Evening · 10 words · 85%                      │
306. └─────────────────────────────────────────────────┘
307. 
308. ┌─ Today's Summary ───────────────────────────────┐
309. │ 21 NEW  |  14 REVIEWED  |  83% ACCURACY  | +350 XP │
310. └─────────────────────────────────────────────────┘
311. 
312. [ 📤 SHARE TODAY'S PROGRESS ]  ← Blue 3D button
313. 
314. ┌─ Bonus Practice ────────────────────────────────┐
315. │ ⭐ Bonus Practice                                │
316. │ Extra reps? That's how you get ahead.            │
317. │ [ PRACTICE MORE ]                                │
318. └─────────────────────────────────────────────────┘
319. ```
320. 
321. #### State F1: Recovery Evening (missed last evening only)
322. 
323. ```
324. ┌─ Recovery Banner (orange gradient) ─────────────┐
325. │ 👋 Welcome back. Let's finish yesterday first.   │
326. │ Your morning words still need their evening pass.│
327. └─────────────────────────────────────────────────┘
328. 
329. ┌─ Recovery Session Card (orange border) ─────────┐
330. │ 🔄 Recovery Evening                              │
331. │ Finish yesterday's review · ~12 min              │
332. │ [🧠 Recall yesterday] [🎮 Practice]             │
333. │ [ START RECOVERY ]                               │
334. └─────────────────────────────────────────────────┘
335. 
336. ┌─ Today's Morning (locked, dimmed) ──────────────┐
337. │ Complete recovery first                   🔒     │
338. └─────────────────────────────────────────────────┘
339. ```
340. 
341. **Behavior:** Yesterday's morning words do NOT get same-day Box 2 acceleration. They enter Box 1 after recovery.
342. 
343. #### State F2: Catch-Up Day (missed 1 full day)
344. 
345. ```
346. ┌─ Catch-Up Banner (orange gradient) ─────────────┐
347. │ 👋 Missed a day? No stress.                      │
348. │ Lighter load today — catch up, then keep going.  │
349. └─────────────────────────────────────────────────┘
350. 
351. ┌─ Catch-Up Session Card (orange border) ─────────┐
352. │ 🔄 Catch-Up Session                              │
353. │ Yesterday's words + priority reviews · ~15 min   │
354. │ [📚 Missed words] [🧠 Review] [🎮 Practice]     │
355. │ [ START CATCH-UP ]                               │
356. └─────────────────────────────────────────────────┘
357. 
358. ┌─ Today's Sessions (reduced, dimmed) ────────────┐
359. │ Available after catch-up · Reduced new words      │
360. └─────────────────────────────────────────────────┘
361. ```
362. 
363. **Behavior:** Today's new word count reduced by ~50% ⚙️. Catch-up session covers missed words + overdue Box 1-2 reviews.
364. 
365. #### State F3: Re-entry Day (missed 3+ days)
366. 
367. ```
368. ┌─ Re-entry Banner (warm red gradient) ───────────┐
369. │ 👋 It's been a few days. Welcome back.           │
370. │ Let's start with what you remember.              │
371. └─────────────────────────────────────────────────┘
372. 
373. ┌─ Re-entry Session Card (red-orange border) ─────┐
374. │ 🔄 Re-entry Review                               │
375. │ Diagnostic review · See what stuck · ~15 min     │
376. │ [🧠 Recall check] [🎮 Practice]                 │
377. │ [ START RE-ENTRY ]                               │
378. └─────────────────────────────────────────────────┘
379. 
380. No new words until overdue queue is healthy.
381. ```
382. 
383. **Behavior:** No new words. Review-only. New words resume when overdue Box 1-2 queue drops below threshold ⚙️. Program may extend by 1-3 study days.
384. 
385. #### State G: Back-Pressure / Review-Only Day
386. 
387. ```
388. ┌─ Review Focus Banner (blue gradient) ───────────┐
389. │ 📚 Review Focus Day                              │
390. │ 32 words need attention. Strengthening first.    │
391. └─────────────────────────────────────────────────┘
392. 
393. ┌─ Review Session Card ───────────────────────────┐
394. │ 🔄 Review Session                                │
395. │ No new words today · Focus on mastery            │
396. │ [ START REVIEW ]                                 │
397. └─────────────────────────────────────────────────┘
398. ```
399. 
400. #### State H: Late Night Session (started morning after 8 PM)
401. 
402. ```
403. ┌─ Late Night Banner (purple gradient) ───────────┐
404. │ 🌙 Late study session — no evening expected.     │
405. │ These words will get their review tomorrow.      │
406. └─────────────────────────────────────────────────┘
407. 
408. ┌─ Night Session Card (purple border) ────────────┐
409. │ 🌙 Night Session                                 │
410. │ Learn new words · No evening follow-up tonight   │
411. │ [ START ]                                        │
412. └─────────────────────────────────────────────────┘
413. ```
414. 
415. **Behavior:** Words do NOT qualify for same-day Box 2 acceleration. They enter Box 1, with review due tomorrow. The next day starts fresh with a normal morning.
416. 
417. ### 3.3 Recovery Component Architecture
418. 
419. States F1, F2, F3 share the same UI components with different configuration:
420. 
421. ```swift
422. enum RecoveryType {
423.     case recoveryEvening   // F1
424.     case catchUpDay        // F2
425.     case reEntryDay        // F3
426. }
427. ```
428. 
429. `RecoveryBanner(type:)` — controls icon, title, subtitle, gradient colors.
430. `RecoverySessionCard(type:)` — controls session structure, step tags, button label.
431. 
432. ### 3.4 Practice-State Priority Resolver
433. 
434. When multiple conditions overlap (e.g., paused session + recovery needed + back-pressure), the Practice tab resolves to **one** state using this priority order (highest priority first):
435. 
436. ```
437. 1. State B  — Paused session exists → show Resume card (always wins)
438. 2. State F3 — Missed 3+ days → Re-entry Day (review-only)
439. 3. State F2 — Missed 1-2 days → Catch-Up Day
440. 4. State F1 — Missed evening only → Recovery Evening
441. 5. State G  — Back-pressure triggered (overdue > 30) → Review-Only Day
442. 6. State H  — Current time ≥ 8 PM and morning not done → Late Night
443. 7. State A  — Morning available, evening locked (normal morning)
444. 8. State C  — Morning done, evening locked (waiting)
445. 9. State D  — Morning done, evening unlocked (normal evening)
446. 10. State E — Both sessions done (day complete)
447. ```
448. 
449. **Implementation:** A single `PracticeTabStateResolver` function evaluates conditions top-to-bottom and returns the first match.
450. 
451. ### 3.5 Button Actions on Practice Tab
452. 
453. | Button | Action |
454. |--------|--------|
455. | START (morning) | Begin morning session → navigate to Step 1 (flashcards). Hide tab bar. Save session start time. |
456. | START (evening) | Begin evening session → navigate to Step 1 (flashcards). Hide tab bar. |
457. | RESUME | Navigate directly to the paused step and item. Hide tab bar. |
458. | START RECOVERY | Begin recovery session (type depends on F1/F2/F3). |
459. | START CATCH-UP | Begin catch-up session with reduced new words + overdue reviews. |
460. | START RE-ENTRY | Begin diagnostic review session (no new words). |
461. | START REVIEW | Begin review-only session (back-pressure triggered). |
462. | SHARE TODAY'S PROGRESS | Generate report card image → open iOS share sheet. |
463. | PRACTICE MORE | Begin bonus practice (Box 1-2 words only, half XP). |
464. | "Restart from beginning" (text link) | Show confirmation → clear partial session → restart Step 1 item 0. Previous scored events marked `superseded` (see Section 5.5). |
465. 
466. ---
````

</details>


---

<sub>⏱️ 1m 13s</sub>

### ✅ `view`

**view the file at /Users/jiong/myprojects/satspell/docs/ui-design-spec.md.**

/Users/jiong/myprojects/satspell/docs/ui-design-spec.md (lines 468-799)

<details>
<summary>332 lines</summary>

````
468. ## 4. In-Session Flow
469. 
470. ### 4.1 Session Structure
471. 
472. **Morning Session (3 steps):**
473. 
474. | Step | Activity | Items | Scoring | Duration |
475. |------|----------|-------|---------|----------|
476. | 1 | New word flashcards | 11 ⚙️ cards | 👁️ Exposure only | ~7 min |
477. | 2 | Image-to-word game | 12 ⚙️ rounds (8 new + 4 review) | 📊 Scored | ~5 min |
478. | 3 | SAT questions | 3 ⚙️ questions | 📊 Scored | ~4 min |
479. 
480. **Evening Session (4 steps):**
481. 
482. | Step | Activity | Items | Scoring | Duration |
483. |------|----------|-------|---------|----------|
484. | 1 | New word flashcards | 10 ⚙️ cards | 👁️ Exposure only | ~7 min |
485. | 2 | Quick recall (morning words) | 11 words | 📊 Scored (Day 1 promotion) | ~4 min |
486. | 3 | Image-to-word game | 12 ⚙️ rounds (6 new + 6 review) | 📊 Scored (Day 1 promotion) | ~5 min |
487. | 4 | SAT questions | 2 ⚙️ questions | 📊 Scored | ~2.5 min |
488. 
489. **Scoring key:**
490. - 👁️ Exposure only = student sees the word but no scored recall. Does not affect box progression.
491. - 📊 Scored = objective recall event. Affects box progression and same-day promotion.
492. 
493. ### 4.2 Session Header (all steps)
494. 
495. ```
496. ✕                STEP 1 OF 3                 🔊
497.               Explore New Words · 3/11
498. [███████░░░░░░░░░░░░░░░░░░░░░░░░]
499. ```
500. 
501. - ✕ button: triggers pause confirmation (see Section 5)
502. - Step label: "STEP X OF Y" (10px, uppercase, secondary)
503. - Activity label + progress: "Explore New Words · 3/11" (12px, bold)
504. - Progress bar: fills based on current item / total items in step
505. - 🔊 button: text-to-speech for current word (flashcard/recall only)
506. 
507. ### 4.3 Step 1: Flashcard View (Exposure Only)
508. 
509. > **Full flashcard spec: `docs/flashcard-design.md`** — authoritative reference for flashcard layout, gestures, adaptive sizing, and implementation.
510. 
511. ```
512. ┌──────────────────────────────────┐
513. │       [progress bar overlay]     │  ← Top 10%
514. │  ✕       [ 2 / 5 ]          🔊  │
515. │                                  │
516. │       [ FULL ILLUSTRATION ]      │  ← Image fills 100%
517. │         object-fit: cover        │
518. │       character centered here    │  ← Middle 40-60%
519. │                                  │
520. │       [dark gradient overlay]    │  ← Bottom 20-30%
521. │  The minimalist design           │
522. │  reflected a particular          │
523. │  AESTHETIC philosophy            │  ← Sentence + gold word
524. │  that favored simplicity.        │
525. │      tap to flip · swipe next →  │
526. └──────────────────────────────────┘
527. BACK: definition, example, collocations, SAT context
528.       + [SHOW AGAIN] [GOT IT →] (soft signal, not scored)
529. ```
530. 
531. **Front side (initial view):**
532. - Card: white bg, 3D border, rounded 14px
533. - Image: fills top portion, aspect fit, proportional height (min 40%, max 55%)
534. - Part of speech: small badge top-right of image
535. - Word: 22px, weight 800, centered
536. - Definition: 12px, secondary, centered
537. - Example sentence: 11px, italic, word highlighted in green
538. 
539. **Tap to flip → Back side:**
540. - 3D rotation animation (0.4s)
541. - Shows: definition, example with highlighted word, collocations (top 3), SAT context
542. - Two soft-signal buttons:
543.   - **SHOW AGAIN** (outlined/gray 3D) → card re-queued at end of current step
544.   - **GOT IT →** (green 3D) → advance to next card
545. 
546. **Important:** These buttons are **soft signals for within-session ordering only**. They do NOT affect box progression. Box progression is driven purely by scored events in Steps 2-4.
547. 
548. **On review cards only:** small difficulty badge top-left:
549. - 🟢 easy · ⚪ normal · 🟡 fragile · 🔴 stubborn
550. 
551. ### 4.4 Step 2: Image-to-Word Game (📊 Scored)
552. 
553. > **Full game & recall spec: `docs/game-views-design.md`** — authoritative reference for image game, quick recall, and SAT question layout, gestures, feedback, scoring, and sizing. Summary below for context.
554. 
555. ```
556. ┌─ Image area ─────────────────────────────────────┐
557. │                                                   │
558. │  [REVIEW]        [mnemonic image]                 │
559. │                                                   │
560. │  ─────────── CHOOSE THE BEST WORD ───────────     │
561. └───────────────────────────────────────────────────┘
562. 
563.    The sunset was ________, gone in moments.
564. 
565.    ┌──────────┐  ┌──────────┐
566.    │ ephemeral│  │ perpetual│
567.    └──────────┘  └──────────┘
568.    ┌──────────┐  ┌──────────┐
569.    │  mundane │  │ abundant │
570.    └──────────┘  └──────────┘
571. ```
572. 
573. - Image: proportional height (min 40%, max 55%), rounded corners, gradient overlay at bottom with caption
574. - REVIEW badge: orange pill, top-left of image, only on review words
575. - Cloze sentence: centered, blank highlighted with gold underline
576. - 2x2 grid: 3D card buttons, font 13px bold
577. - Correct answer: card turns green, microcopy toast (e.g., "Nailed it."), auto-advance 1.5s
578. - Wrong answer: card turns red, correct card pulses green, microcopy toast (e.g., "That word is fighting back."), auto-advance 2s
579. - This is a **primary scored event** for same-day box promotion
580. - Minimum response time: 1 second ⚙️ (faster = flagged as guess, doesn't count for promotion)
581. 
582. ### 4.5 Step 3: SAT Question (Split Scroll) (📊 Scored)
583. 
584. ```
585. ┌─ Passage (scrollable, proportional height) ─────┐
586. │ 📖 PASSAGE                           scroll ↕    │
587. │                                                   │
588. │ The environmental movement has undergone a        │
589. │ [profound transformation] in recent decades...     │
590. └───────────────────────────────────────────────────┘
591.                ─── QUESTION ───
592. As used in the passage, "profound transformation"
593. most nearly means:
594. 
595.   (A) a minor adjustment
596.   ⦿ (B) a fundamental change        ← selected (blue)
597.   (C) a temporary shift
598.   (D) a superficial alteration
599. 
600. [ CHECK ]
601. ```
602. 
603. - Passage area: warm yellow background (#FFF8E1), 2px border (#FFE082), scrollable independently, proportional height (min 35%, max 45%)
604. - Target word/phrase: highlighted with yellow underline gradient
605. - Question area: fills remaining space, fixed (not scrollable)
606. - Options: 3D card style, letter circle left-aligned, full-width rows
607. - Selected option: blue border + blue letter circle + blue text
608. - CHECK button: green when option selected, gray when not
609. - After CHECK:
610.   - Correct: green flash, microcopy (e.g., "Clean."), explanation shown
611.   - Wrong: red flash, correct option highlighted, microcopy (e.g., "Brutal SAT word, but you'll get it."), explanation shown
612.   - Both show: word definition, context, explanation
613.   - NEXT button to advance
614. 
615. ### 4.6 Quick Recall (Evening Step 2 — 📊 Scored, Day 1 Promotion)
616. 
617. ```
618.             WHAT DOES THIS MEAN?
619. 
620.               EPHEMERAL
621.            from this morning
622. 
623.   ┌─────────────────────────────────┐
624.   │ very important or significant   │
625.   └─────────────────────────────────┘
626.   ┌─────────────────────────────────┐
627.   │ lasting a very short time       │
628.   └─────────────────────────────────┘
629.   ┌─────────────────────────────────┐
630.   │ extremely complicated           │
631.   └─────────────────────────────────┘
632.   ┌─────────────────────────────────┐
633.   │ widely known and admired        │
634.   └─────────────────────────────────┘
635. ```
636. 
637. - Word: 28px, weight 800, centered
638. - "from this morning" label: purple (#CE82FF), 11px
639. - 4 definition choices: full-width 3D card buttons, 13px text
640. - Progress bar: purple fill
641. - Correct: card flashes green, microcopy, 1s pause, auto-advance
642. - Wrong: card flashes red, correct card highlighted green, auto-advance after 2s
643. - This is a **primary scored event** for same-day box promotion
644. - Minimum response time: 1 second ⚙️ (faster = flagged as guess, doesn't count)
645. 
646. **Day 1 promotion scored events (3 total):**
647. 1. Morning image-to-word game (Step 2)
648. 2. Evening quick recall (Step 2)
649. 3. Evening image-to-word game (Step 3)
650. 
651. Promotion rule: 2/3 scored correct AND correct final recall → Box 2. Otherwise → Box 1.
652. 
653. ### 4.7 Step Transition Screen
654. 
655. Shown between steps. Auto-advances after 3 seconds or tap CONTINUE.
656. 
657. ```
658.               🎉
659. 
660.         Step 1 Complete!
661.      11 new words explored
662. 
663.           ● ○ ○
664. 
665.         ┌─ NEXT UP ──────────┐
666.         │ 🎮 Image Practice  │
667.         │ 12 rounds          │
668.         └────────────────────┘
669. 
670.         [ CONTINUE ]
671. ```
672. 
673. - Celebration emoji: changes per step (🎉, 💪, 🏆)
674. - Microcopy: varies (e.g., "11 new words explored" / "12 rounds crushed" / "3 SAT questions down")
675. - Step dots: filled = done, empty = remaining
676. - Next up card: gray background, shows next activity name + count
677. - CONTINUE button: green 3D
678. 
679. ### 4.8 Session Complete Screen
680. 
681. ```
682.               🎉
683. 
684.      Done. Your brain just leveled up.
685. 
686.    🔥5 STREAK    +350 XP    105 WORDS
687. 
688.   ┌─ TODAY'S BOX MOVES ──────────────┐
689.   │ ↑ 18 promoted                    │
690.   │ ↓ 3 need more practice           │
691.   └──────────────────────────────────┘
692. 
693.   [ 📤 SHARE TODAY'S PROGRESS ]
694.   [ DONE ]
695. ```
696. 
697. - Confetti animation (particles falling) for milestones (zone complete, 50 words, 10-day streak)
698. - Microcopy rotates: "Done. Your brain just leveled up." / "That's a wrap." / "Solid session."
699. - Stats row: 3 tiles with icon + number + label
700. - Box moves: simple summary of promotions and demotions today
701. - Share button: blue 3D, generates report card image
702. - DONE button: green 3D, returns to Practice tab
703. - If only morning complete: "See you tonight — let it sink in." message. **No share button on morning-only completion.**
704. - Share button ("Share Today's Progress") appears ONLY on:
705.   - Evening session complete screen
706.   - Practice tab State E (both sessions done)
707.   - Profile tab (always available)
708. 
709. ### 4.9 Rush Detection
710. 
711. **Applies to scored steps only (image game, quick recall, SAT questions). Does NOT apply to flashcards — flashcards are exposure-only and have no scoring or rush checks.**
712. 
713. - Game answer in < 1 second ⚙️: toast "Too fast. Take a moment."
714. - Quick recall answer in < 1 second ⚙️: same toast
715. - SAT question answered in < 3 seconds ⚙️: toast "Slow down — your brain needs a second."
716. - These are non-blocking — don't pause the session
717. - Rushed answers don't count toward same-day box promotion
718. - After 3 rush warnings in a session: slightly larger banner "Learning works best when you take your time." (dismissible)
719. 
720. ---
721. 
722. ## 5. Session Interruption & Resume
723. 
724. ### 5.1 Pause Confirmation (tapping ✕)
725. 
726. Bottom sheet modal slides up. Background dimmed.
727. 
728. **Content varies by progress:**
729. 
730. | Progress | Title | Encouragement | Primary Button |
731. |----------|-------|---------------|----------------|
732. | < 50% of current step | "Pause Session?" | "Progress saved automatically." | KEEP GOING (green) |
733. | ≥ 50% of current step | "Almost there." | "X left. ~Y min." | FINISH IT (green) |
734. | Between steps | "Pause Session?" | Step checklist (✓ done, ○ pending) | CONTINUE TO STEP X (green) |
735. 
736. **All variants show:**
737. - Progress info: current step, items done / total, estimated time remaining
738. - Focus tip (< 50%): "Finishing in one sitting helps it stick."
739. - Secondary button: "PAUSE & EXIT" (gray 3D) — always available
740. 
741. **Pause & Exit action:**
742. 1. Save current step index + current item index to UserDefaults
743. 2. Log all completed reviews to SQLite (already done per-item)
744. 3. Navigate back to Practice tab
745. 4. Practice tab shows Resume card (State B)
746. 
747. ### 5.2 Resume Card
748. 
749. Shown on Practice tab when a session is paused.
750. 
751. **Gold border card replacing the normal session card:**
752. - ▶️ icon with gold gradient circle
753. - "Continue [Morning/Evening] Session"
754. - "Paused at Step X: [Activity] · Y/Z"
755. - Segmented progress bar (done = green, remaining = gold, unstarted = gray)
756. - Step activity tags showing remaining steps
757. - RESUME button (gold 3D)
758. - "Restart from beginning" text link (small, below card)
759. 
760. **Resume button action:**
761. 1. Read saved step index + item index
762. 2. Navigate directly to that step's view
763. 3. Set current item to saved index
764. 4. Continue session as normal
765. 
766. ### 5.3 App Background / Kill Behavior
767. 
768. | Scenario | Behavior |
769. |----------|----------|
770. | Switch to another app, return < 30 min ⚙️ | Resume in-place (stay on the activity screen) |
771. | Switch to another app, return ≥ 30 min ⚙️ | Navigate to Practice tab, show Resume card |
772. | iOS kills app in background | Next launch: Practice tab with Resume card |
773. | Student force-quits app | Same as iOS kill: Resume card on next launch |
774. 
775. **Implementation:** Save session state to UserDefaults on every `scenePhase` change to `.background`. On launch / foreground, check for saved state and elapsed time.
776. 
777. ### 5.4 Edge Case: Pause During Evening, Resume Next Day
778. 
779. If student pauses the evening session and doesn't return until the next day:
780. - The paused evening session becomes a **Recovery Evening** (State F1)
781. - Resume card shows: "🔄 Continue Yesterday's Evening Session"
782. - After completing it, morning session for today becomes available
783. - Same-day acceleration does NOT apply (spacing was broken)
784. - Words from the incomplete evening enter Box 1, not Box 2
785. 
786. ### 5.5 Restart Semantics
787. 
788. When a student taps "Restart from beginning":
789. 
790. 1. Show confirmation: "Restart session? Your previous answers are kept for practice, but scoring starts fresh."
791. 2. On confirm:
792.    - All previous scored events from this session are marked `superseded` in the review log
793.    - Only the latest (restarted) attempt's scored events count toward box progression and XP
794.    - Previous exposure events are preserved for analytics
795.    - Clear saved step/item index, start from Step 1 item 0
796. 3. XP from the superseded attempt is subtracted (net zero until new attempt earns it back)
797. 
798. ---
799.
````

</details>


---

<sub>⏱️ 1m 13s</sub>

### ✅ `view`

**view the file at /Users/jiong/myprojects/satspell/docs/ui-design-spec.md.**

/Users/jiong/myprojects/satspell/docs/ui-design-spec.md (lines 800-953)

<details>
<summary>154 lines</summary>

````
800. ## 6. Tab 3: Stats
801. 
802. ### 6.1 Layout
803. 
804. ```
805. Your Progress
806. 
807. ┌─ Hero Tiles (3 across) ─────────────────────────┐
808. │  🔥        ⚡         📚                         │
809. │  5         1,600      105                        │
810. │  STREAK    XP         WORDS                      │
811. └──────────────────────────────────────────────────┘
812. 
813. ┌─ Word Mastery (stacked bar) ────────────────────┐
814. │  [████████████████████████░░░░░░░░░░░░░░░]       │
815. │  🟢 Mastered 15  🟩 Solid 60  🟡 Strong 30       │
816. │  🟠 Rising 123  🔴 Locked In 17                  │
817. └──────────────────────────────────────────────────┘
818. 
819. ┌─ This Week (calendar) ──────────────────────────┐
820. │  M    T    W    T    F    S    S                  │
821. │  ✓    ✓    ✓    ☀️   ○    ○    ○                 │
822. │  ☀️🌙 ☀️🌙 ☀️🌙 ☀️                                │
823. └──────────────────────────────────────────────────┘
824. 
825. ┌─ Words Fighting Back 💪 ───────────────────────┐
826. │  These need a different angle. Tap to explore.   │
827. │  ephemeral          missed 3x · Box 1            │
828. │  ambivalent         missed 2x · Box 1            │
829. └──────────────────────────────────────────────────┘
830. 
831. ┌─ Zones ─────────────────────────────────────────┐
832. │  ✓ Foundation                           90%      │
833. │  ⭐ Cloud Realm                         35%      │
834. │  🔒 Island · Space · Future City                 │
835. └──────────────────────────────────────────────────┘
836. ```
837. 
838. ### 6.2 Stats Elements
839. 
840. **Hero tiles:** 3D border-bottom style matching Duolingo. Each tile has gradient background matching its color theme.
841. 
842. **Word Mastery bar:** Maps to Leitner boxes:
843. 
844. | Visual | Box | Label | Color |
845. |--------|-----|-------|-------|
846. | 🟢 | Box 5 | Mastered | #58CC02 |
847. | 🟩 | Box 4 | Solid | #89E219 |
848. | 🟡 | Box 3 | Strong | #FFC800 |
849. | 🟠 | Box 2 | Rising | #FFAB40 |
850. | 🔴 | Box 1 | Locked In | #FF7043 |
851. 
852. Note: These are student-facing labels. Internal code uses: mastered, strong, familiar, learning, struggling.
853. 
854. **Weekly calendar:** Shows each day of the current week. Completed days: green circle with ✓. Morning-only days: gold circle with ☀️. Future/missed: gray circle. Session dots below each day.
855. 
856. **Words Fighting Back 💪:** Shows words with `memory_status = stubborn`. Header copy: "These need a different angle." Display-only in V1 (not tappable — WordDetailView is P2). Shows word, miss count, and current box. Max 5 shown. Tappable word detail view deferred to P1/P2.
857. 
858. **Zone progress:** List of zones with completion % (familiar+ words / total zone words). Tappable → shows zone word list with individual box levels.
859. 
860. ### 6.3 Stats Button Actions
861. 
862. | Element | Tap Action |
863. |---------|-----------|
864. | Hero tile | No action (display only) |
865. | Word mastery bar | No action (display only) |
866. | Calendar day | No action (display only) |
867. | Word Fighting Back row | Display only in V1 (no tap action) |
868. | "See all" | Deferred to P1/P2 |
869. | Zone row | Navigate to zone word list view |
870. 
871. ---
872. 
873. ## 7. Tab 4: Profile
874. 
875. ### 7.1 Layout (V1)
876. 
877. ```
878. Profile
879. 
880. ┌─ User Info ─────────────────────────────────────┐
881. │ 👤 Student Name                                  │
882. │ Day 5 · Zone 2 · 105 words learned               │
883. └──────────────────────────────────────────────────┘
884. 
885. ┌─ Report ────────────────────────────────────────┐
886. │ 📤 Share Today's Progress                     [>]  │
887. └──────────────────────────────────────────────────┘
888. 
889. ┌─ Session Settings ──────────────────────────────┐
890. │ 🔔 Morning Reminder: 8:00 AM       [toggle]     │
891. │ 🔔 Evening Reminder: 6:00 PM       [toggle]     │
892. └──────────────────────────────────────────────────┘
893. 
894. ┌─ Danger Zone ───────────────────────────────────┐
895. │ 🔄 Reset All Progress                       [>]  │
896. └──────────────────────────────────────────────────┘
897. ```
898. 
899. ### 7.2 Profile Button Actions
900. 
901. | Element | Tap Action |
902. |---------|-----------|
903. | Share Today's Progress | Generate report image → iOS share sheet |
904. | Evening Unlock Mode | Removed from V1. Hardcoded: 4-hour gap OR after 5 PM, whichever comes first. |
905. | Morning/Evening Reminder | Toggle → request notification permission if needed, schedule local notification at specified time |
906. | Reset All Progress | Confirmation dialog ("This cannot be undone. All words, sessions, and progress will be reset.") → clears all data |
907. 
908. ### 7.3 V2 Profile Additions (not in V1)
909. 
910. - Parent email input + auto-send toggle
911. - Report time picker
912. - Customizable daily word count (casual/regular/intense)
913. - Cloud sync settings
914. 
915. ---
916. 
917. ## 8. Parent Report Card
918. 
919. ### 8.1 Report Card Image (generated in-app)
920. 
921. The report is a rendered image (not a live view) that can be shared via iOS share sheet.
922. 
923. **Content:**
924. ```
925. ┌─────────────────────────────────┐
926. │ 📊 SAT Vocab Report             │  ← Green gradient header
927. │ Day 5 · April 11, 2026          │
928. ├─────────────────────────────────┤
929. │ ✓✓      🔥5     33m     83%    │  ← Sessions, streak, time, accuracy
930. │ SESSIONS STREAK  TIME  ACCURACY │
931. ├─────────────────────────────────┤
932. │ [████████████░░░░░░░░░░░░]      │  ← Mastery bar
933. │ 105/372 words at familiar+      │
934. ├─────────────────────────────────┤
935. │ ⚠️ Words fighting back:         │  ← Stubborn words (if any)
936. │ ephemeral, ambivalent, pragmatic│
937. ├─────────────────────────────────┤
938. │ 🎉 Milestone: 100 words!        │  ← Only when earned
939. └─────────────────────────────────┘
940. ```
941. 
942. **Size:** iPhone-friendly aspect ratio (roughly 3:4 or 1:1)
943. 
944. **Generation:** Use SwiftUI `ImageRenderer` to render a view to UIImage, then pass to `UIActivityViewController`.
945. 
946. ### 8.2 When Report Is Offered
947. 
948. - After completing **evening session** → on Session Complete screen
949. - On **Practice tab** when both sessions are done (State E)
950. - On **Profile tab** → "Share Today's Progress" button (always available)
951. 
952. ---
953.
````

</details>


---

<sub>⏱️ 1m 13s</sub>

### ✅ `view`

**view the file at /Users/jiong/myprojects/satspell/docs/ui-design-spec.md.**

/Users/jiong/myprojects/satspell/docs/ui-design-spec.md (lines 1025-1130)

<details>
<summary>106 lines</summary>

```
1025. ## 11. Screens Inventory
1026. 
1027. Complete list of all unique screens/views to implement:
1028. 
1029. | # | Screen | New/Existing | Priority |
1030. |---|--------|-------------|----------|
1031. | 1 | RootTabView (4 tabs) | Modify | P0 |
1032. | 2 | AdventureMapView (zone backgrounds, node states) | Redesign | P0 |
1033. | 3 | PracticeTabView (daily hub, 10 states) | **New** | P0 |
1034. | 4 | MorningSessionCard | **New** | P0 |
1035. | 5 | EveningSessionCard | **New** | P0 |
1036. | 6 | ResumeCard | **New** | P0 |
1037. | 7 | RecoveryBanner(type:) | **New** | P1 |
1038. | 8 | RecoverySessionCard(type:) | **New** | P1 |
1039. | 9 | BackPressureBanner | **New** | P1 |
1040. | 10 | LateNightBanner | **New** | P2 |
1041. | 11 | SessionFlowView (step orchestrator) | **New** | P0 |
1042. | 12 | FlashcardView (exposure only, Got it / Show again) | Redesign | P0 |
1043. | 13 | ClozeRoundView / Image Game (scored, polish) | Redesign | P0 |
1044. | 14 | SatMCQRoundView (split scroll, scored) | Redesign | P0 |
1045. | 15 | QuickRecallView (scored) | **New** | P0 |
1046. | 16 | StepTransitionView | **New** | P1 |
1047. | 17 | SessionCompleteView | **New** | P0 |
1048. | 18 | PauseConfirmationSheet | **New** | P0 |
1049. | 19 | StatsView (redesign) | Redesign | P1 |
1050. | 20 | BoxDistributionChart | **New** | P1 |
1051. | 21 | WeeklyCalendarView | **New** | P1 |
1052. | 22 | WordsFightingBackView (display-only list, no tap) | **New** | P1 |
1053. | 23 | ZoneMasteryListView | **New** | P1 |
1054. | 24 | ProfileView (V1 settings) | Redesign | P1 |
1055. | 25 | ParentReportCardView (image renderer) | **New** | P1 |
1056. | 26 | ZoneTestSessionView (reduced + remediation) | Redesign | P1 |
1057. | 27 | ZoneRemediationView | **New** | P1 |
1058. | 28 | WordDetailView | **New** | P2 |
1059. | 29 | RushDetectionToast | **New** | P2 |
1060. | 30 | BonusPracticeView | **New** | P2 |
1061. 
1062. **Priority definitions:**
1063. - **P0 = V1 first release** — must ship for the app to be usable
1064. - **P1 = V1.1 fast follow** — ship within 1-2 weeks after first release
1065. - **P2 = V2** — not in the first release cycle
1066. 
1067. **Summary:** P0: 12 screens (first release). P1: 12 screens (fast follow). P2: 6 screens (V2).
1068. 
1069. ---
1070. 
1071. ## 12. Data Dependencies
1072. 
1073. The UI depends on these data layer components (defined in `learning-model-design.md`):
1074. 
1075. | Data Component | UI Consumer |
1076. |----------------|------------|
1077. | `WordState` (box_level, due_at, memory_status, lapse_count) | Stats tab, review badges, Words Fighting Back list |
1078. | `SessionState` (step_index, item_index, is_paused, session_type) | Resume card, Practice tab state |
1079. | `DayState` (morning_complete, evening_complete, morning_complete_at) | Practice tab state, Map node dots, evening lock timer |
1080. | `RecoveryState` (recovery_type, is_recovery_needed) | Practice tab F1/F2/F3 states |
1081. | `ReviewQueue` (priority-sorted due words by box then memory_status) | Image game review words, quick recall, review count badge |
1082. | `BoxTransitionLog` (promotions, demotions today) | Session complete screen |
1083. | `DailyStats` (new_count, review_count, accuracy, xp) | Practice tab summary, report card |
1084. | `StreakStore` (current_streak, last_study_date) | Header badges, Stats tab, report card |
1085. | `ReviewLog` (word_id, outcome, superseded flag) | Restart semantics, analytics |
1086. | Evening unlock rule (hardcoded: 4hr gap OR 5 PM) | Lock timer (no UI setting in V1) |
1087. 
1088. ---
1089. 
1090. ## 13. Global Edge Cases
1091. 
1092. These are production scenarios that apply across multiple screens.
1093. 
1094. ### First Launch (No Progress)
1095. 
1096. - Practice tab: State A with Day 1 selected, streak = 0, XP = 0
1097. - Map: Zone 1 unlocked, Day 1 as "current" (gold ⭐), Days 2-4 available but dim, Zones 2-5 locked
1098. - Stats: all zeros, empty mastery bar, no Words Fighting Back, no weekly calendar history
1099. - Profile: name defaults to "Student" (editable)
1100. - No onboarding tutorial in V1 — the app is self-explanatory
1101. 
1102. ### Notification Permission Denied
1103. 
1104. - If student denies notification permission when toggling reminders:
1105.   - Show brief explanation: "Reminders help you stay on track. You can enable them in Settings."
1106.   - Toggle stays off, no retry prompt
1107.   - App works fully without notifications — they are convenience only
1108. 
1109. ### Report Sharing Before Any Session
1110. 
1111. - Profile "Share Today's Progress" button: if no session completed today, generate a report showing overall progress instead of daily stats
1112. - Never show an empty or broken report card
1113. 
1114. ### Timezone / Cross-Midnight Behavior
1115. 
1116. - Study day boundary: midnight local time
1117. - If a session starts at 11:50 PM and finishes at 12:10 AM: counts as the day it started on
1118. - Evening unlock timer: based on elapsed real time since morning completion, not clock labels
1119. - Streak: counts study days (days with at least one session completed), not calendar days
1120. - If device clock changes (travel, manual change): freeze new-word unlocks until pending session completes
1121. 
1122. ### No Internet
1123. 
1124. - App is fully offline (all data in bundled SQLite + local images)
1125. - Share Report uses iOS share sheet which works offline (student can share when back online)
1126. - No network-dependent features in V1
1127. 
1128. ---
1129. 
1130. ## 14. Gap Resolutions
```

</details>


---

<sub>⏱️ 1m 13s</sub>

### ✅ `view`

**view the file at /Users/jiong/myprojects/satspell/docs/ui-design-spec.md.**

/Users/jiong/myprojects/satspell/docs/ui-design-spec.md (lines 1130-1260)

<details>
<summary>131 lines</summary>

```
1130. ## 14. Gap Resolutions
1131. 
1132. Issues identified in the final gap audit and resolved here.
1133. 
1134. ### 14.1 Recovery Session Structures
1135. 
1136. **Recovery Evening (F1):**
1137. 
1138. | Step | Activity | Items |
1139. |------|----------|-------|
1140. | 1 | Quick recall of yesterday's morning words | up to 11 |
1141. | 2 | Image-to-word game (yesterday's words + overdue reviews) | 10 |
1142. 
1143. **Catch-Up Day (F2):**
1144. 
1145. | Step | Activity | Items |
1146. |------|----------|-------|
1147. | 1 | Flashcard exposure (missed words) | up to 11 |
1148. | 2 | Image-to-word game (missed + overdue) | 10 |
1149. | 3 | Quick recall | 8 |
1150. 
1151. **Re-entry Day (F3):**
1152. 
1153. | Step | Activity | Items |
1154. |------|----------|-------|
1155. | 1 | Quick recall (diagnostic — sample from all learned words) | 15 |
1156. | 2 | Image-to-word game (words recalled incorrectly) | 10 |
1157. 
1158. ### 14.2 Back-Pressure Day Session Structure (State G)
1159. 
1160. Single session, review only:
1161. 
1162. | Step | Activity | Items |
1163. |------|----------|-------|
1164. | 1 | Quick recall (Box 1 words first, then Box 2) | 15 |
1165. | 2 | Image-to-word game (same words) | 12 |
1166. | 3 | SAT questions (from reviewed words) | 3 |
1167. 
1168. ### 14.3 Bonus Practice (State E)
1169. 
1170. Deferred from V1 first release. In State E, the "PRACTICE MORE" button is **hidden in P0**. It appears only when BonusPracticeView is built (P1). Until then, State E shows the summary + share button only.
1171. 
1172. ### 14.4 Days 19-20 Session Structures
1173. 
1174. **Day 19 — Weak Word Blitz (morning):**
1175. 
1176. | Step | Activity | Items |
1177. |------|----------|-------|
1178. | 1 | Flashcard exposure (Box 1-2 words, weakest first) | 15 |
1179. | 2 | Image-to-word game (same words) | 12 |
1180. | 3 | SAT questions (same words) | 5 |
1181. 
1182. **Day 19 — Evening:** Same structure, next 15 weakest words.
1183. 
1184. **Day 20 — Final Assessment (morning):**
1185. 
1186. | Step | Activity | Items |
1187. |------|----------|-------|
1188. | 1 | SAT-style comprehensive test (all zones) | 30 |
1189. 
1190. **Day 20 — Evening:** Results review screen. No session — just final stats display with Share Final Report.
1191. 
1192. ### 14.5 Zone Test Remediation Day
1193. 
1194. When a student fails the zone test 3+ times, the next study day uses **State G (Review-Only Day)** with its banner text changed to: "Let's strengthen these zone words before retesting." After completing the review session, the zone test becomes available again.
1195. 
1196. ### 14.6 Map Day Tap Behavior
1197. 
1198. | Node State | Tap Action |
1199. |------------|-----------|
1200. | Current day (active) | Switch to Practice tab |
1201. | Past day (completed) | Show read-only day summary: "Day X ✓ · 21 words · 83%" (no action) |
1202. | Future day (unlocked but not yet reached) | Disabled — subtle bounce animation, no navigation |
1203. | Future day (locked) | Disabled — no response |
1204. | Zone test node | Navigate to zone test (if available) |
1205. 
1206. ### 14.7 Evening Unlock Timing Matrix
1207. 
1208. | Morning Completed At | Evening Unlocks At | State H? | Notes |
1209. |---------------------|-------------------|----------|-------|
1210. | Before 1:00 PM | 5:00 PM (fallback wins) | No | Normal flow |
1211. | 1:00 – 5:00 PM | 5:00 PM (fallback wins) | No | Normal flow |
1212. | 5:00 – 7:59 PM | Morning + 4 hours | No | Evening available same night |
1213. | 8:00 PM or later | Next day morning | Yes (State H) | No evening expected tonight |
1214. | Cross midnight | Counts as the day it started | No | Session stays on original day |
1215. 
1216. ### 14.8 Distractor Selection Rules
1217. 
1218. **Quick Recall (4 definition choices):**
1219. 1. Correct definition = the word's actual definition
1220. 2. Distractor 1 = definition of a word from the same zone
1221. 3. Distractor 2 = definition of a word with the same part of speech
1222. 4. Distractor 3 = definition of a random word from any zone
1223. 5. Shuffle all 4 positions randomly
1224. 
1225. **Image-to-Word Game (4 word choices):**
1226. 1. Correct word = the target word
1227. 2. Distractor 1 = word from same zone, same part of speech
1228. 3. Distractor 2 = word from same zone, different part of speech
1229. 4. Distractor 3 = random word from any zone
1230. 5. Shuffle all 4 positions randomly
1231. 6. Never repeat a distractor set for the same target word within a session
1232. 
1233. ### 14.9 V1 P0 Scope Clarification
1234. 
1235. Features that appear in V1 flows but are NOT in P0 first release. These should be hidden/omitted, not half-built:
1236. 
1237. | Feature | Priority | P0 Fallback |
1238. |---------|----------|-------------|
1239. | Recovery modes (F1/F2/F3) | P1 | If recovery is needed, show generic "Welcome back" banner + start normal morning session (no special recovery flow) |
1240. | Back-pressure (State G) | P1 | Never triggered in P0 — all days have full new words |
1241. | Late Night (State H) | P2 | No special handling — normal morning session starts |
1242. | Rush detection toast | P2 | Not shown — all answers count |
1243. | Bonus practice | P1 | Button hidden in State E |
1244. | Step transition screen | P1 | Skip directly to next step |
1245. | Zone test remediation | P1 | Unlimited retries (no remediation flow) |
1246. 
1247. The Practice tab state resolver in P0 only needs: **A, B, C, D, E** (5 states). F1/F2/F3, G, H added in P1/P2.
1248. 
1249. ---
1250. 
1251. ## 15. What Is NOT in V1
1252. 
1253. Explicitly out of scope:
1254. 
1255. - Dark mode (architect for, don't implement)
1256. - Automatic push notifications to parent (V2 — requires backend)
1257. - Weekly email digest (V2)
1258. - Parent email input + auto-send (V2)
1259. - Customizable evening unlock time picker (V1 uses simple toggle)
1260. - Word pronunciation audio files (use AVFoundation text-to-speech)
```

</details>


---

<sub>⏱️ 1m 21s</sub>

### 💬 Copilot

I’ve got the key spec sections now. Next I’m reading the main Swift surfaces that own tabs, map/practice state, session flow, and persistence so the final review can cite concrete implementation lines.

---

<sub>⏱️ 1m 21s</sub>

### ✅ `view`

**view the file at /Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Views/RootTabView.swift.**

/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Views/RootTabView.swift

<details>
<summary>56 lines</summary>

```
1. import SwiftUI
2. 
3. struct RootTabView: View {
4.     enum Tab: Hashable {
5.         case map
6.         case practice
7.         case stats
8.         case profile
9.     }
10. 
11.     @State private var selected: Tab = .practice
12. 
13.     var body: some View {
14.         TabView(selection: $selected) {
15.             NavigationStack {
16.                 AdventureMapView()
17.             }
18.             .tabItem {
19.                 Label("Map", systemImage: "map")
20.             }
21.             .tag(Tab.map)
22. 
23.             NavigationStack {
24.                 PracticeTabView()
25.             }
26.             .tabItem {
27.                 Label("Practice", systemImage: "pencil.and.list.clipboard")
28.             }
29.             .tag(Tab.practice)
30. 
31.             NavigationStack {
32.                 StatsView()
33.             }
34.             .tabItem {
35.                 Label("Stats", systemImage: "chart.bar")
36.             }
37.             .tag(Tab.stats)
38. 
39.             NavigationStack {
40.                 ProfileView()
41.             }
42.             .tabItem {
43.                 Label("Profile", systemImage: "person")
44.             }
45.             .tag(Tab.profile)
46.         }
47.         .tint(Color(hex: "#58CC02"))
48.     }
49. }
50. 
51. // Color(hex:) extension is in Views/Components/Button3D.swift
52. 
53. #Preview {
54.     RootTabView()
55. }
56.
```

</details>


---

<sub>⏱️ 1m 21s</sub>

### ✅ `view`

**view the file at /Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Views/AdventureMapView.swift.**

/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Views/AdventureMapView.swift

<details>
<summary>233 lines</summary>

```
1. import SwiftUI
2. 
3. struct AdventureMapView: View {
4.     @State private var zoneIndex: Int = AdventureSchedule.zoneIndex(forDayIndex: AdventureSchedule.dayIndexForToday())
5.     @State private var route: AdventureMapRoute? = nil
6.     @State private var familiarCount: Int = 0
7.     @State private var totalWordsInZone: Int = 0
8. 
9.     private let nodePositions: [CGPoint] = [
10.         CGPoint(x: 0.50, y: 0.10),
11.         CGPoint(x: 0.75, y: 0.28),
12.         CGPoint(x: 0.45, y: 0.46),
13.         CGPoint(x: 0.20, y: 0.64),
14.         CGPoint(x: 0.55, y: 0.84)  // zone test node
15.     ]
16. 
17.     var body: some View {
18.         let zoneIsUnlocked = AdventureProgressStore.shared.isZoneUnlocked(zoneIndex: zoneIndex)
19.         let zoneTitle = AdventureSchedule.zoneTitle(zoneIndex: zoneIndex)
20.         let dayStart = zoneIndex * AdventureSchedule.daysPerZone
21.         let dayEnd = min(dayStart + AdventureSchedule.daysPerZone, AdventureSchedule.totalDays)
22.         let days = Array(dayStart..<dayEnd)
23. 
24.         let nextDayToStart = AdventureProgressStore.shared.firstIncompleteDayIndex()
25.         let highlightedDay: Int? = AdventureSchedule.zoneIndex(forDayIndex: nextDayToStart) == zoneIndex ? nextDayToStart : nil
26. 
27.         VStack(spacing: 16) {
28.             // Zone header with navigation
29.             VStack(spacing: 6) {
30.                 Text("Adventure Map")
31.                     .font(.system(.headline, design: .rounded).weight(.semibold))
32.                     .foregroundStyle(.secondary)
33. 
34.                 HStack(spacing: 8) {
35.                     Button {
36.                         zoneIndex = max(0, zoneIndex - 1)
37.                     } label: {
38.                         Image(systemName: "chevron.left")
39.                             .font(.system(size: 16, weight: .semibold))
40.                             .frame(width: 36, height: 36)
41.                     }
42.                     .buttonStyle(.plain)
43.                     .disabled(zoneIndex == 0)
44. 
45.                     Text(zoneTitle)
46.                         .font(.system(.title2, design: .rounded).weight(.bold))
47.                         .lineLimit(1)
48.                         .minimumScaleFactor(0.8)
49. 
50.                     Button {
51.                         zoneIndex = min(AdventureSchedule.totalZones - 1, zoneIndex + 1)
52.                     } label: {
53.                         Image(systemName: "chevron.right")
54.                             .font(.system(size: 16, weight: .semibold))
55.                             .frame(width: 36, height: 36)
56.                     }
57.                     .buttonStyle(.plain)
58.                     .disabled(zoneIndex >= AdventureSchedule.totalZones - 1)
59.                 }
60.             }
61.             .padding(.top, 10)
62. 
63.             // Zone progress bar
64.             ZoneProgressBar(familiarCount: familiarCount, totalCount: max(1, totalWordsInZone))
65.                 .padding(.horizontal, 4)
66. 
67.             // Map area
68.             ZStack {
69.                 RoundedRectangle(cornerRadius: 22, style: .continuous)
70.                     .fill(zoneBackgroundGradient)
71. 
72.                 GeometryReader { geo in
73.                     ZStack {
74.                         // Path
75.                         AdventureMapPathShape()
76.                             .stroke(
77.                                 Color.white.opacity(0.55),
78.                                 style: StrokeStyle(lineWidth: 18, lineCap: .round, lineJoin: .round, dash: [10, 10])
79.                             )
80.                             .padding(.horizontal, 10)
81.                             .padding(.vertical, 8)
82. 
83.                         // Day nodes
84.                         ForEach(Array(days.enumerated()), id: \.element) { idx, dayIndex in
85.                             if idx < nodePositions.count - 1 {
86.                                 let pos = nodePositions[idx]
87.                                 let dayTasks = AdventureProgressStore.shared.loadDayTasks(dayIndex: dayIndex)
88.                                 let dayCompleted = dayTasks.allSatisfy { $0 }
89. 
90.                                 MapDayNode(
91.                                     title: "Day \(AdventureSchedule.globalDayNumber(forDayIndex: dayIndex))",
92.                                     state: mapNodeState(
93.                                         dayIndex: dayIndex,
94.                                         dayCompleted: dayCompleted,
95.                                         zoneIsUnlocked: zoneIsUnlocked,
96.                                         highlightedDay: highlightedDay
97.                                     ),
98.                                     onTap: {
99.                                         guard zoneIsUnlocked else { return }
100.                                         route = .day(dayIndex)
101.                                     }
102.                                 )
103.                                 .position(x: geo.size.width * pos.x, y: geo.size.height * pos.y)
104.                             }
105.                         }
106. 
107.                         // Zone test node (last position)
108.                         let testPos = nodePositions[min(nodePositions.count - 1, days.count)]
109.                         let zoneCompleted = AdventureProgressStore.shared.isZoneCompleted(zoneIndex: zoneIndex)
110. 
111.                         MapDayNode(
112.                             title: "Zone Test",
113.                             state: .zoneTest(passed: zoneCompleted),
114.                             onTap: {
115.                                 guard zoneIsUnlocked else { return }
116.                                 route = .zoneTest(zoneIndex)
117.                             }
118.                         )
119.                         .position(x: geo.size.width * testPos.x, y: geo.size.height * testPos.y)
120.                     }
121.                 }
122.                 .padding(14)
123.             }
124.             .frame(height: 440)
125. 
126.             Spacer(minLength: 0)
127.         }
128.         .padding(.horizontal, 16)
129.         .navigationDestination(item: $route) { route in
130.             switch route {
131.             case .day:
132.                 // Navigate to Practice tab
133.                 PracticeTabView()
134.             case .zoneTest(let zi):
135.                 ZoneReviewSessionView(zoneIndex: zi) {
136.                     AdventureProgressStore.shared.setZoneUnlocked(zoneIndex: zi + 1, unlocked: true)
137.                 }
138.             }
139.         }
140.         .navigationBarTitleDisplayMode(.inline)
141.         .task {
142.             await loadZoneWordProgress()
143.         }
144.         .onChange(of: zoneIndex) { _, _ in
145.             Task { await loadZoneWordProgress() }
146.         }
147.     }
148. 
149.     private func loadZoneWordProgress() async {
150.         do {
151.             let dm = DataManager.shared
152.             try await dm.initializeIfNeeded()
153.             let userId = LocalIdentity.userId()
154.             let wsStore = WordStateStore(db: dm.db)
155.             let dist = try await wsStore.getBoxDistribution(userId: userId)
156.             // Count words with box >= 1 as "familiar"
157.             familiarCount = dist.filter { $0.key >= 1 }.values.reduce(0, +)
158.             totalWordsInZone = max(dist.values.reduce(0, +), AdventureSchedule.daysPerZone * (AppConfig.morningNewWords + AppConfig.eveningNewWords))
159.         } catch {
160.             familiarCount = 0
161.             totalWordsInZone = 1
162.         }
163.     }
164. 
165.     private func mapNodeState(dayIndex: Int, dayCompleted: Bool, zoneIsUnlocked: Bool, highlightedDay: Int?) -> MapDayNode.NodeState {
166.         if dayCompleted {
167.             // Check if morning/evening are done (simplified: if day completed, both are done)
168.             return .completed(morningDone: true, eveningDone: true)
169.         }
170.         if highlightedDay == dayIndex {
171.             return .current
172.         }
173.         return zoneIsUnlocked ? .available : .locked
174.     }
175. 
176.     private var zoneBackgroundGradient: LinearGradient {
177.         let colors: [Color] = {
178.             switch zoneIndex % 5 {
179.             case 0: return [Color.green.opacity(0.18), Color.green.opacity(0.08)]
180.             case 1: return [Color.blue.opacity(0.18), Color.blue.opacity(0.08)]
181.             case 2: return [Color.teal.opacity(0.18), Color.teal.opacity(0.08)]
182.             case 3: return [Color.purple.opacity(0.18), Color.purple.opacity(0.08)]
183.             default: return [Color.orange.opacity(0.18), Color.orange.opacity(0.08)]
184.             }
185.         }()
186.         return LinearGradient(colors: colors, startPoint: .top, endPoint: .bottom)
187.     }
188. }
189. 
190. // MARK: - Route
191. 
192. private enum AdventureMapRoute: Hashable, Identifiable {
193.     case day(Int)
194.     case zoneTest(Int)
195. 
196.     var id: String {
197.         switch self {
198.         case .day(let idx): return "day-\(idx)"
199.         case .zoneTest(let zone): return "test-\(zone)"
200.         }
201.     }
202. }
203. 
204. // MARK: - Path Shape
205. 
206. private struct AdventureMapPathShape: Shape {
207.     func path(in rect: CGRect) -> Path {
208.         var p = Path()
209. 
210.         let start = CGPoint(x: rect.midX, y: rect.minY + rect.height * 0.10)
211.         p.move(to: start)
212. 
213.         p.addQuadCurve(
214.             to: CGPoint(x: rect.width * 0.80, y: rect.height * 0.28),
215.             control: CGPoint(x: rect.width * 0.62, y: rect.height * 0.14)
216.         )
217.         p.addQuadCurve(
218.             to: CGPoint(x: rect.width * 0.48, y: rect.height * 0.46),
219.             control: CGPoint(x: rect.width * 0.84, y: rect.height * 0.36)
220.         )
221.         p.addQuadCurve(
222.             to: CGPoint(x: rect.width * 0.26, y: rect.height * 0.64),
223.             control: CGPoint(x: rect.width * 0.28, y: rect.height * 0.54)
224.         )
225.         p.addQuadCurve(
226.             to: CGPoint(x: rect.width * 0.54, y: rect.height * 0.84),
227.             control: CGPoint(x: rect.width * 0.14, y: rect.height * 0.78)
228.         )
229. 
230.         return p
231.     }
232. }
233.
```

</details>


---

<sub>⏱️ 1m 21s</sub>

### ✅ `view`

**view the file at /Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Views/Map/MapDayNode.swift.**

/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Views/Map/MapDayNode.swift

<details>
<summary>135 lines</summary>

```
1. import SwiftUI
2. 
3. struct MapDayNode: View {
4.     enum NodeState {
5.         case completed(morningDone: Bool, eveningDone: Bool)
6.         case current
7.         case available
8.         case locked
9.         case zoneTest(passed: Bool)
10.     }
11. 
12.     let title: String
13.     let state: NodeState
14.     let onTap: () -> Void
15. 
16.     var body: some View {
17.         Button(action: onTap) {
18.             VStack(spacing: 6) {
19.                 ZStack {
20.                     RoundedRectangle(cornerRadius: 14, style: .continuous)
21.                         .fill(fillColor)
22.                         .frame(width: 68, height: 48)
23.                         .overlay(
24.                             RoundedRectangle(cornerRadius: 14, style: .continuous)
25.                                 .strokeBorder(borderColor, lineWidth: borderWidth)
26.                         )
27. 
28.                     nodeIcon
29.                 }
30. 
31.                 Text(title)
32.                     .font(.system(.footnote, design: .rounded).weight(.bold))
33.                     .foregroundStyle(.white)
34.                     .padding(.horizontal, 10)
35.                     .padding(.vertical, 5)
36.                     .background(Color.black.opacity(0.22))
37.                     .clipShape(Capsule())
38. 
39.                 // Session dots for completed days
40.                 sessionDots
41.             }
42.         }
43.         .buttonStyle(.plain)
44.         .disabled(isDisabled)
45.     }
46. 
47.     @ViewBuilder
48.     private var nodeIcon: some View {
49.         switch state {
50.         case .completed:
51.             Image(systemName: "checkmark")
52.                 .font(.system(size: 18, weight: .bold))
53.                 .foregroundStyle(.white)
54.         case .current:
55.             Circle()
56.                 .fill(.white.opacity(0.95))
57.                 .frame(width: 10, height: 10)
58.         case .available:
59.             Circle()
60.                 .fill(.white.opacity(0.8))
61.                 .frame(width: 10, height: 10)
62.         case .locked:
63.             Image(systemName: "lock.fill")
64.                 .font(.system(size: 16, weight: .bold))
65.                 .foregroundStyle(.white.opacity(0.95))
66.         case .zoneTest(let passed):
67.             if passed {
68.                 Text("\u{1F3C6}")
69.                     .font(.system(size: 20))
70.             } else {
71.                 Image(systemName: "flag.checkered")
72.                     .font(.system(size: 16, weight: .bold))
73.                     .foregroundStyle(.white)
74.             }
75.         }
76.     }
77. 
78.     @ViewBuilder
79.     private var sessionDots: some View {
80.         switch state {
81.         case .completed(let morningDone, let eveningDone):
82.             HStack(spacing: 4) {
83.                 if morningDone {
84.                     Text("\u{2600}\u{FE0F}")
85.                         .font(.system(size: 12))
86.                 }
87.                 if eveningDone {
88.                     Text("\u{1F319}")
89.                         .font(.system(size: 12))
90.                 }
91.             }
92.         default:
93.             EmptyView()
94.         }
95.     }
96. 
97.     private var fillColor: Color {
98.         switch state {
99.         case .completed:
100.             return Color(hex: "#58CC02")
101.         case .current:
102.             return Color.blue.opacity(0.92)
103.         case .available:
104.             return Color(hex: "#58CC02").opacity(0.75)
105.         case .locked:
106.             return Color.gray.opacity(0.55)
107.         case .zoneTest(let passed):
108.             return passed ? Color.purple.opacity(0.85) : Color.indigo.opacity(0.8)
109.         }
110.     }
111. 
112.     private var borderColor: Color {
113.         switch state {
114.         case .current:
115.             return Color.white.opacity(0.5)
116.         default:
117.             return Color.black.opacity(0.10)
118.         }
119.     }
120. 
121.     private var borderWidth: CGFloat {
122.         switch state {
123.         case .current: return 2
124.         default: return 1
125.         }
126.     }
127. 
128.     private var isDisabled: Bool {
129.         switch state {
130.         case .locked: return true
131.         default: return false
132.         }
133.     }
134. }
135.
```

</details>


---

<sub>⏱️ 1m 21s</sub>

### ✅ `view`

**view the file at /Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Views/Practice/PracticeTabView.swift.**

/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Views/Practice/PracticeTabView.swift

<details>
<summary>101 lines</summary>

```
1. import SwiftUI
2. 
3. struct PracticeTabView: View {
4.     @StateObject private var vm = PracticeTabViewModel()
5.     @State private var navigateToSession: SessionType? = nil
6. 
7.     var body: some View {
8.         ScrollView {
9.             VStack(spacing: 14) {
10.                 PracticeHeader(
11.                     studyDay: vm.studyDay,
12.                     zoneIndex: vm.zoneIndex,
13.                     streak: vm.streak.currentStreak,
14.                     totalXP: vm.streak.totalXP
15.                 )
16. 
17.                 if vm.isLoading {
18.                     ProgressView()
19.                         .accessibilityIdentifier("practiceLoading")
20.                         .padding(.top, 40)
21.                 } else {
22.                     stateContent
23.                 }
24.             }
25.             .padding(.horizontal, 16)
26.         }
27.         .navigationBarTitleDisplayMode(.inline)
28.         .onAppear {
29.             if navigateToSession != nil {
30.                 navigateToSession = nil
31.             }
32.             Task { await vm.load() }
33.         }
34.         .navigationDestination(item: $navigateToSession) { type in
35.             SessionFlowView(vm: SessionFlowViewModel(sessionType: type, studyDay: vm.studyDay))
36.         }
37.     }
38. 
39.     @ViewBuilder
40.     private var stateContent: some View {
41.         switch vm.state {
42.         case .morningAvailable:
43.             MorningSessionCard {
44.                 navigateToSession = .morning
45.             }
46.             EveningSessionCard(locked: true, unlockAt: nil)
47.             ReviewsDueRow(count: vm.reviewsDueCount)
48. 
49.         case .paused(let session):
50.             ResumeCard(
51.                 session: session,
52.                 onResume: {
53.                     navigateToSession = session.sessionType
54.                 },
55.                 onRestart: {
56.                     Task {
57.                         try? await SessionStateStore.shared.discardSession(
58.                             userId: vm.userId,
59.                             studyDay: session.studyDay,
60.                             sessionType: session.sessionType
61.                         )
62.                         navigateToSession = session.sessionType
63.                     }
64.                 }
65.             )
66.             // Show morning as reviewable if paused session is evening
67.             if session.sessionType == .evening {
68.                 MorningCompleteCard(reviewable: true) {
69.                     navigateToSession = .morning
70.                 }
71.             }
72. 
73.         case .morningDoneEveningLocked(let unlockAt):
74.             MorningCompleteCard(reviewable: true) {
75.                 navigateToSession = .morning
76.             }
77.             EveningSessionCard(locked: true, unlockAt: unlockAt)
78.             ReviewsDueRow(count: vm.reviewsDueCount)
79. 
80.         case .eveningAvailable:
81.             MorningCompleteCard(reviewable: true) {
82.                 navigateToSession = .morning
83.             }
84.             EveningSessionCard(locked: false, unlockAt: nil) {
85.                 navigateToSession = .evening
86.             }
87.             ReviewsDueRow(count: vm.reviewsDueCount)
88. 
89.         case .bothComplete:
90.             MorningCompleteCard(reviewable: true) {
91.                 navigateToSession = .morning
92.             }
93.             EveningCompleteCard(reviewable: true) {
94.                 navigateToSession = .evening
95.             }
96.             DayCompleteSummary(studyDay: vm.studyDay, userId: vm.userId)
97.             ReviewsDueRow(count: vm.reviewsDueCount)
98.         }
99.     }
100. }
101.
```

</details>


---

<sub>⏱️ 1m 21s</sub>

### ✅ `view`

**view the file at /Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Views/Practice/PracticeStateResolver.swift.**

/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Views/Practice/PracticeStateResolver.swift

<details>
<summary>70 lines</summary>

```
1. import Foundation
2. 
3. enum PracticeState {
4.     case morningAvailable                           // A
5.     case paused(SessionState)                       // B
6.     case morningDoneEveningLocked(unlockAt: Date)   // C
7.     case eveningAvailable                           // D
8.     case bothComplete                               // E
9. }
10. 
11. struct PracticeStateResolver {
12.     static func resolve(
13.         dayState: DayState?,
14.         activeSession: SessionState?,
15.         now: Date = Date()
16.     ) -> PracticeState {
17.         // Priority 1: Paused session
18.         if let session = activeSession, session.isPaused {
19.             return .paused(session)
20.         }
21. 
22.         guard let day = dayState else {
23.             return .morningAvailable
24.         }
25. 
26.         // Both done
27.         if day.morningComplete && day.eveningComplete {
28.             return .bothComplete
29.         }
30. 
31.         // Morning done, check evening
32.         if day.morningComplete {
33.             let unlockAt = calculateEveningUnlock(morningCompleteAt: day.morningCompleteAt, now: now)
34.             if now >= unlockAt {
35.                 return .eveningAvailable
36.             } else {
37.                 return .morningDoneEveningLocked(unlockAt: unlockAt)
38.             }
39.         }
40. 
41.         // Morning not done
42.         return .morningAvailable
43.     }
44. 
45.     static func calculateEveningUnlock(morningCompleteAt: Date?, now: Date = Date()) -> Date {
46.         let cal = Calendar.current
47. 
48.         // Build the fallback hour — if today's fallback is already past, use tomorrow's
49.         let fallback: Date = {
50.             let todayFallback = cal.date(bySettingHour: AppConfig.eveningUnlockFallbackHour,
51.                                          minute: 0, second: 0, of: now) ?? now
52.             if todayFallback > now {
53.                 return todayFallback
54.             }
55.             // Today's fallback already passed — use tomorrow
56.             return cal.date(byAdding: .day, value: 1, to: todayFallback) ?? todayFallback
57.         }()
58. 
59.         guard let morningDone = morningCompleteAt else {
60.             // morningCompleteAt is nil — fall back to now + unlock hours,
61.             // capped by the fallback hour so it never unlocks immediately
62.             let hoursFromNow = now.addingTimeInterval(TimeInterval(AppConfig.eveningUnlockHours * 3600))
63.             return min(hoursFromNow, fallback)
64.         }
65. 
66.         let hoursLater = morningDone.addingTimeInterval(TimeInterval(AppConfig.eveningUnlockHours * 3600))
67.         return min(hoursLater, fallback)
68.     }
69. }
70.
```

</details>


---

<sub>⏱️ 1m 21s</sub>

### ✅ `view`

**view the file at /Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/ViewModels/PracticeTabViewModel.swift.**

/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/ViewModels/PracticeTabViewModel.swift

<details>
<summary>49 lines</summary>

```
1. import Foundation
2. import Combine
3. 
4. @MainActor
5. final class PracticeTabViewModel: ObservableObject {
6.     @Published var state: PracticeState = .morningAvailable
7.     @Published var studyDay: Int = 0
8.     @Published var zoneIndex: Int = 0
9.     @Published var streak: StreakInfo = StreakInfo(
10.         currentStreak: 0, bestStreak: 0, lastStudyDate: nil,
11.         totalXP: 0, totalStudyDays: 0,
12.         streak3Claimed: false, streak7Claimed: false,
13.         streak14Claimed: false, streak30Claimed: false
14.     )
15.     @Published var reviewsDueCount: Int = 0
16.     @Published var isLoading: Bool = true
17. 
18.     let userId = LocalIdentity.userId()
19. 
20.     func load() async {
21.         isLoading = true
22.         do {
23.             let dm = DataManager.shared
24.             try await dm.initializeIfNeeded()
25. 
26.             let sessionStore = SessionStateStore.shared
27.             let statsStore = StatsStore.shared
28.             let wsStore = WordStateStore(db: dm.db)
29. 
30.             let dayState = try await sessionStore.getCurrentDayState(userId: userId)
31.             let activeSession = try await sessionStore.getActiveSession(userId: userId)
32.             streak = try await statsStore.getStreak(userId: userId)
33.             reviewsDueCount = try await wsStore.countOverdue(userId: userId)
34. 
35.             studyDay = dayState?.studyDay ?? 0
36.             zoneIndex = dayState?.zoneIndex ?? 0
37. 
38.             state = PracticeStateResolver.resolve(
39.                 dayState: dayState,
40.                 activeSession: activeSession
41.             )
42.         } catch {
43.             // Default to morning available on error
44.             state = .morningAvailable
45.         }
46.         isLoading = false
47.     }
48. }
49.
```

</details>


---

<sub>⏱️ 1m 28s</sub>

### ✅ `view`

**view the file at /Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Views/Practice/MorningSessionCard.swift.**

/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Views/Practice/MorningSessionCard.swift

<details>
<summary>47 lines</summary>

```
1. import SwiftUI
2. 
3. struct MorningSessionCard: View {
4.     var onStart: () -> Void = {}
5. 
6.     var body: some View {
7.         Button(action: onStart) {
8.             HStack(spacing: 14) {
9.                 ZStack {
10.                     Circle()
11.                         .fill(Color(hex: "#58CC02").opacity(0.15))
12.                         .frame(width: 52, height: 52)
13.                     Text("\u{2600}\u{FE0F}")
14.                         .font(.system(size: 24))
15.                 }
16. 
17.                 VStack(alignment: .leading, spacing: 4) {
18.                     Text("Morning Session")
19.                         .font(.system(.headline, design: .rounded).weight(.bold))
20.                     Text("Learn \(AppConfig.morningNewWords) new words")
21.                         .font(.system(.subheadline, design: .rounded))
22.                         .foregroundStyle(.secondary)
23.                 }
24. 
25.                 Spacer()
26. 
27.                 Text("Start")
28.                     .font(.system(.headline, design: .rounded).weight(.semibold))
29.                     .foregroundStyle(.white)
30.                     .padding(.horizontal, 18)
31.                     .padding(.vertical, 10)
32.                     .background(Color(hex: "#58CC02"))
33.                     .clipShape(Capsule())
34.             }
35.             .padding(16)
36.             .background(.white)
37.             .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
38.             .overlay(
39.                 RoundedRectangle(cornerRadius: 18, style: .continuous)
40.                     .strokeBorder(Color(hex: "#58CC02").opacity(0.3), lineWidth: 1.5)
41.             )
42.         }
43.         .buttonStyle(.plain)
44.         .accessibilityIdentifier("morningSessionCard")
45.     }
46. }
47.
```

</details>


---

<sub>⏱️ 1m 28s</sub>

### ✅ `view`

**view the file at /Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Views/Practice/EveningSessionCard.swift.**

/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Views/Practice/EveningSessionCard.swift

<details>
<summary>100 lines</summary>

```
1. import SwiftUI
2. 
3. struct EveningSessionCard: View {
4.     let locked: Bool
5.     let unlockAt: Date?
6.     var onStart: () -> Void = {}
7. 
8.     @State private var timeRemaining: String = ""
9.     @State private var timer: Timer? = nil
10. 
11.     var body: some View {
12.         Button(action: { if !locked { onStart() } }) {
13.             HStack(spacing: 14) {
14.                 ZStack {
15.                     Circle()
16.                         .fill(Color.indigo.opacity(0.15))
17.                         .frame(width: 52, height: 52)
18.                     Text("\u{1F319}")
19.                         .font(.system(size: 24))
20.                 }
21. 
22.                 VStack(alignment: .leading, spacing: 4) {
23.                     Text("Evening Session")
24.                         .font(.system(.headline, design: .rounded).weight(.bold))
25. 
26.                     if locked, unlockAt != nil {
27.                         Text("Unlocks \(timeRemaining)")
28.                             .font(.system(.subheadline, design: .rounded))
29.                             .foregroundStyle(.orange)
30.                     } else if locked {
31.                         Text("Complete morning first")
32.                             .font(.system(.subheadline, design: .rounded))
33.                             .foregroundStyle(.secondary)
34.                     } else {
35.                         Text("Review \(AppConfig.eveningNewWords) new words")
36.                             .font(.system(.subheadline, design: .rounded))
37.                             .foregroundStyle(.secondary)
38.                     }
39.                 }
40. 
41.                 Spacer()
42. 
43.                 if locked {
44.                     Image(systemName: "lock.fill")
45.                         .font(.system(size: 18, weight: .semibold))
46.                         .foregroundStyle(.secondary)
47.                 } else {
48.                     Text("Start")
49.                         .font(.system(.headline, design: .rounded).weight(.semibold))
50.                         .foregroundStyle(.white)
51.                         .padding(.horizontal, 18)
52.                         .padding(.vertical, 10)
53.                         .background(Color.indigo)
54.                         .clipShape(Capsule())
55.                 }
56.             }
57.             .padding(16)
58.             .background(.white)
59.             .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
60.             .overlay(
61.                 RoundedRectangle(cornerRadius: 18, style: .continuous)
62.                     .strokeBorder(locked ? Color.gray.opacity(0.15) : Color.indigo.opacity(0.3), lineWidth: 1.5)
63.             )
64.             .opacity(locked ? 0.7 : 1.0)
65.         }
66.         .buttonStyle(.plain)
67.         .disabled(locked)
68.         .accessibilityIdentifier(locked ? "eveningSessionCardLocked" : "eveningSessionCard")
69.         .onAppear { startTimer() }
70.         .onDisappear { timer?.invalidate() }
71.     }
72. 
73.     private func startTimer() {
74.         updateTimeRemaining()
75.         timer = Timer.scheduledTimer(withTimeInterval: 60, repeats: true) { _ in
76.             updateTimeRemaining()
77.         }
78.     }
79. 
80.     private func updateTimeRemaining() {
81.         guard let unlockAt else {
82.             timeRemaining = ""
83.             return
84.         }
85.         let diff = unlockAt.timeIntervalSinceNow
86.         if diff <= 0 {
87.             timeRemaining = "now"
88.             timer?.invalidate()
89.         } else {
90.             let hours = Int(diff) / 3600
91.             let minutes = (Int(diff) % 3600) / 60
92.             if hours > 0 {
93.                 timeRemaining = "in \(hours)h \(minutes)m"
94.             } else {
95.                 timeRemaining = "in \(minutes)m"
96.             }
97.         }
98.     }
99. }
100.
```

</details>


---

<sub>⏱️ 1m 28s</sub>

### ✅ `view`

**view the file at /Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Views/Practice/ResumeCard.swift.**

/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Views/Practice/ResumeCard.swift

<details>
<summary>82 lines</summary>

```
1. import SwiftUI
2. 
3. struct ResumeCard: View {
4.     let session: SessionState
5.     var onResume: () -> Void = {}
6.     var onRestart: (() -> Void)? = nil
7. 
8.     var body: some View {
9.         VStack(spacing: 0) {
10.             HStack(spacing: 14) {
11.                 ZStack {
12.                     Circle()
13.                         .fill(Color.orange.opacity(0.15))
14.                         .frame(width: 52, height: 52)
15.                     Image(systemName: "play.fill")
16.                         .font(.system(size: 20, weight: .bold))
17.                         .foregroundStyle(.orange)
18.                 }
19. 
20.                 VStack(alignment: .leading, spacing: 4) {
21.                     Text("Paused: \(session.sessionType.rawValue.capitalized) Session")
22.                         .font(.system(.headline, design: .rounded).weight(.bold))
23.                     Text("Step \(session.stepIndex + 1), Item \(session.itemIndex + 1)")
24.                         .font(.system(.subheadline, design: .rounded))
25.                         .foregroundStyle(.secondary)
26.                 }
27. 
28.                 Spacer()
29.             }
30.             .padding(.horizontal, 16)
31.             .padding(.top, 16)
32.             .padding(.bottom, 12)
33. 
34.             // Two buttons: Resume and Start Over
35.             HStack(spacing: 10) {
36.                 Button(action: onResume) {
37.                     HStack(spacing: 6) {
38.                         Image(systemName: "play.fill")
39.                             .font(.system(size: 13, weight: .bold))
40.                         Text("Resume")
41.                             .font(.system(.headline, design: .rounded).weight(.semibold))
42.                     }
43.                     .foregroundStyle(.white)
44.                     .frame(maxWidth: .infinity)
45.                     .padding(.vertical, 12)
46.                     .background(Color.orange)
47.                     .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
48.                 }
49.                 .buttonStyle(.plain)
50.                 .accessibilityIdentifier("resumeButton")
51. 
52.                 if let onRestart {
53.                     Button(action: onRestart) {
54.                         HStack(spacing: 6) {
55.                             Image(systemName: "arrow.counterclockwise")
56.                                 .font(.system(size: 13, weight: .bold))
57.                             Text("Start Over")
58.                                 .font(.system(.headline, design: .rounded).weight(.semibold))
59.                         }
60.                         .foregroundStyle(Color(hex: "#666666"))
61.                         .frame(maxWidth: .infinity)
62.                         .padding(.vertical, 12)
63.                         .background(Color(hex: "#F5F5F5"))
64.                         .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
65.                     }
66.                     .buttonStyle(.plain)
67.                     .accessibilityIdentifier("startOverButton")
68.                 }
69.             }
70.             .padding(.horizontal, 16)
71.             .padding(.bottom, 16)
72.         }
73.         .background(.white)
74.         .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
75.         .overlay(
76.             RoundedRectangle(cornerRadius: 18, style: .continuous)
77.                 .strokeBorder(Color.orange.opacity(0.4), lineWidth: 2)
78.         )
79.         .accessibilityIdentifier("resumeCard")
80.     }
81. }
82.
```

</details>


---

<sub>⏱️ 1m 28s</sub>

### ✅ `view`

**view the file at /Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Views/Practice/MorningCompleteCard.swift.**

/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Views/Practice/MorningCompleteCard.swift

<details>
<summary>58 lines</summary>

```
1. import SwiftUI
2. 
3. struct MorningCompleteCard: View {
4.     var reviewable: Bool = false
5.     var onReview: (() -> Void)? = nil
6. 
7.     var body: some View {
8.         Button {
9.             onReview?()
10.         } label: {
11.             HStack(spacing: 14) {
12.                 ZStack {
13.                     Circle()
14.                         .fill(Color(hex: "#58CC02").opacity(0.15))
15.                         .frame(width: 52, height: 52)
16.                     Image(systemName: "checkmark.circle.fill")
17.                         .font(.system(size: 24, weight: .bold))
18.                         .foregroundStyle(Color(hex: "#58CC02"))
19.                 }
20. 
21.                 VStack(alignment: .leading, spacing: 4) {
22.                     Text("Morning Session")
23.                         .font(.system(.headline, design: .rounded).weight(.bold))
24.                         .foregroundStyle(.primary)
25.                     Text("Complete!")
26.                         .font(.system(.subheadline, design: .rounded))
27.                         .foregroundStyle(Color(hex: "#58CC02"))
28.                 }
29. 
30.                 Spacer()
31. 
32.                 if reviewable {
33.                     Text("Review")
34.                         .font(.system(size: 13, weight: .semibold, design: .rounded))
35.                         .foregroundStyle(Color(hex: "#58CC02"))
36.                         .padding(.horizontal, 12)
37.                         .padding(.vertical, 6)
38.                         .background(Color(hex: "#58CC02").opacity(0.1))
39.                         .clipShape(Capsule())
40.                 }
41. 
42.                 Text("\u{2600}\u{FE0F}")
43.                     .font(.system(size: 22))
44.             }
45.             .padding(16)
46.             .background(.white)
47.             .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
48.             .overlay(
49.                 RoundedRectangle(cornerRadius: 18, style: .continuous)
50.                     .strokeBorder(Color(hex: "#58CC02").opacity(0.2), lineWidth: 1)
51.             )
52.         }
53.         .buttonStyle(.plain)
54.         .disabled(!reviewable)
55.         .accessibilityIdentifier("morningCompleteCard")
56.     }
57. }
58.
```

</details>


---

<sub>⏱️ 1m 28s</sub>

### ✅ `view`

**view the file at /Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Views/Practice/EveningCompleteCard.swift.**

/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Views/Practice/EveningCompleteCard.swift

<details>
<summary>58 lines</summary>

```
1. import SwiftUI
2. 
3. struct EveningCompleteCard: View {
4.     var reviewable: Bool = false
5.     var onReview: (() -> Void)? = nil
6. 
7.     var body: some View {
8.         Button {
9.             onReview?()
10.         } label: {
11.             HStack(spacing: 14) {
12.                 ZStack {
13.                     Circle()
14.                         .fill(Color.indigo.opacity(0.15))
15.                         .frame(width: 52, height: 52)
16.                     Image(systemName: "checkmark.circle.fill")
17.                         .font(.system(size: 24, weight: .bold))
18.                         .foregroundStyle(.indigo)
19.                 }
20. 
21.                 VStack(alignment: .leading, spacing: 4) {
22.                     Text("Evening Session")
23.                         .font(.system(.headline, design: .rounded).weight(.bold))
24.                         .foregroundStyle(.primary)
25.                     Text("Complete!")
26.                         .font(.system(.subheadline, design: .rounded))
27.                         .foregroundStyle(.indigo)
28.                 }
29. 
30.                 Spacer()
31. 
32.                 if reviewable {
33.                     Text("Review")
34.                         .font(.system(size: 13, weight: .semibold, design: .rounded))
35.                         .foregroundStyle(.indigo)
36.                         .padding(.horizontal, 12)
37.                         .padding(.vertical, 6)
38.                         .background(Color.indigo.opacity(0.1))
39.                         .clipShape(Capsule())
40.                 }
41. 
42.                 Text("\u{1F319}")
43.                     .font(.system(size: 22))
44.             }
45.             .padding(16)
46.             .background(.white)
47.             .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
48.             .overlay(
49.                 RoundedRectangle(cornerRadius: 18, style: .continuous)
50.                     .strokeBorder(Color.indigo.opacity(0.2), lineWidth: 1)
51.             )
52.         }
53.         .buttonStyle(.plain)
54.         .disabled(!reviewable)
55.         .accessibilityIdentifier("eveningCompleteCard")
56.     }
57. }
58.
```

</details>


---

<sub>⏱️ 1m 28s</sub>

### ✅ `view`

**view the file at /Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Views/Practice/DayCompleteSummary.swift.**

/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Views/Practice/DayCompleteSummary.swift

<details>
<summary>71 lines</summary>

```
1. import SwiftUI
2. 
3. struct DayCompleteSummary: View {
4.     let studyDay: Int
5.     let userId: String
6. 
7.     @State private var dailyStats: DailyStats?
8.     @State private var wordsLearned: Int = 0
9. 
10.     var body: some View {
11.         VStack(spacing: 14) {
12.             Text("Day \(studyDay) Complete!")
13.                 .font(.system(.title2, design: .rounded).weight(.bold))
14.                 .foregroundStyle(Color(hex: "#58CC02"))
15. 
16.             if let stats = dailyStats {
17.                 HStack(spacing: 16) {
18.                     summaryTile(title: "Words", value: "\(wordsLearned)", icon: "textformat.abc")
19.                     summaryTile(title: "XP", value: "\(stats.xpEarned + stats.sessionBonus)", icon: "star.fill")
20.                     summaryTile(title: "Accuracy", value: stats.totalCount > 0 ? "\(Int(Double(stats.correctCount) / Double(stats.totalCount) * 100))%" : "--", icon: "target")
21.                 }
22.             } else {
23.                 HStack(spacing: 16) {
24.                     summaryTile(title: "Words", value: "--", icon: "textformat.abc")
25.                     summaryTile(title: "XP", value: "--", icon: "star.fill")
26.                     summaryTile(title: "Accuracy", value: "--", icon: "target")
27.                 }
28.             }
29. 
30.             Text("Great work today! Come back tomorrow.")
31.                 .font(.system(.subheadline, design: .rounded))
32.                 .foregroundStyle(.secondary)
33.         }
34.         .padding(20)
35.         .background(.white)
36.         .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
37.         .overlay(
38.             RoundedRectangle(cornerRadius: 20, style: .continuous)
39.                 .strokeBorder(Color(hex: "#58CC02").opacity(0.2), lineWidth: 1)
40.         )
41.         .accessibilityIdentifier("dayCompleteSummary")
42.         .task {
43.             do {
44.                 let statsStore = StatsStore.shared
45.                 dailyStats = try await statsStore.getOrCreateDailyStats(userId: userId, studyDay: studyDay)
46. 
47.                 let dm = DataManager.shared
48.                 try await dm.initializeIfNeeded()
49.                 let wsStore = WordStateStore(db: dm.db)
50.                 wordsLearned = try await wsStore.countWordsLearned(userId: userId)
51.             } catch {
52.                 // ignore
53.             }
54.         }
55.     }
56. 
57.     private func summaryTile(title: String, value: String, icon: String) -> some View {
58.         VStack(spacing: 6) {
59.             Image(systemName: icon)
60.                 .font(.system(size: 18, weight: .semibold))
61.                 .foregroundStyle(.secondary)
62.             Text(value)
63.                 .font(.system(.title3, design: .rounded).weight(.bold))
64.             Text(title)
65.                 .font(.system(.caption, design: .rounded))
66.                 .foregroundStyle(.secondary)
67.         }
68.         .frame(maxWidth: .infinity)
69.     }
70. }
71.
```

</details>


---

<sub>⏱️ 1m 28s</sub>

### ✅ `view`

**view the file at /Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Views/Practice/PracticeHeader.swift.**

/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Views/Practice/PracticeHeader.swift

<details>
<summary>42 lines</summary>

```
1. import SwiftUI
2. 
3. struct PracticeHeader: View {
4.     let studyDay: Int
5.     let zoneIndex: Int
6.     let streak: Int
7.     let totalXP: Int
8. 
9.     var body: some View {
10.         VStack(spacing: 10) {
11.             HStack {
12.                 VStack(alignment: .leading, spacing: 4) {
13.                     Text("Day \(studyDay)")
14.                         .font(.system(.largeTitle, design: .rounded).weight(.bold))
15.                     Text(AdventureSchedule.zoneTitle(zoneIndex: zoneIndex))
16.                         .font(.system(.subheadline, design: .rounded))
17.                         .foregroundStyle(.secondary)
18.                 }
19. 
20.                 Spacer()
21. 
22.                 HStack(spacing: 14) {
23.                     HStack(spacing: 5) {
24.                         Image(systemName: "flame.fill")
25.                             .foregroundStyle(.orange)
26.                         Text("\(streak)")
27.                             .font(.system(.headline, design: .rounded).weight(.bold))
28.                     }
29. 
30.                     HStack(spacing: 5) {
31.                         Image(systemName: "star.fill")
32.                             .foregroundStyle(.yellow)
33.                         Text("\(totalXP)")
34.                             .font(.system(.headline, design: .rounded).weight(.bold))
35.                     }
36.                 }
37.             }
38.         }
39.         .padding(.top, 8)
40.     }
41. }
42.
```

</details>


---

<sub>⏱️ 1m 28s</sub>

### ✅ `view`

**view the file at /Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Views/Practice/ReviewsDueRow.swift.**

/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Views/Practice/ReviewsDueRow.swift

<details>
<summary>28 lines</summary>

```
1. import SwiftUI
2. 
3. struct ReviewsDueRow: View {
4.     let count: Int
5. 
6.     var body: some View {
7.         if count > 0 {
8.             HStack(spacing: 10) {
9.                 Image(systemName: "arrow.counterclockwise.circle.fill")
10.                     .font(.system(size: 18, weight: .semibold))
11.                     .foregroundStyle(.blue)
12. 
13.                 Text("\(count) review\(count == 1 ? "" : "s") due today")
14.                     .font(.system(.subheadline, design: .rounded).weight(.semibold))
15. 
16.                 Spacer()
17. 
18.                 Image(systemName: "chevron.right")
19.                     .font(.system(size: 12, weight: .semibold))
20.                     .foregroundStyle(.secondary)
21.             }
22.             .padding(14)
23.             .background(Color.blue.opacity(0.06))
24.             .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
25.         }
26.     }
27. }
28.
```

</details>


---

<sub>⏱️ 1m 34s</sub>

### ✅ `view`

**view the file at /Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Views/Session/SessionFlowView.swift.**

/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Views/Session/SessionFlowView.swift

<details>
<summary>143 lines</summary>

```
1. import SwiftUI
2. 
3. struct SessionFlowView: View {
4.     @StateObject var vm: SessionFlowViewModel
5.     @Environment(\.dismiss) private var dismiss
6.     @State private var isLoading = true
7.     @State private var loadError: String?
8. 
9.     var body: some View {
10.         ZStack {
11.             if isLoading {
12.                 VStack(spacing: 12) {
13.                     ProgressView()
14.                     Text("Loading words...")
15.                         .font(.system(size: 15, weight: .medium, design: .rounded))
16.                         .foregroundColor(.gray)
17.                 }
18.             } else if let error = loadError {
19.                 VStack(spacing: 12) {
20.                     Text("Failed to load")
21.                         .font(.system(size: 18, weight: .bold, design: .rounded))
22.                     Text(error)
23.                         .font(.system(size: 13))
24.                         .foregroundColor(.secondary)
25.                         .multilineTextAlignment(.center)
26.                         .padding(.horizontal)
27.                     Button("Go Back") { dismiss() }
28.                         .buttonStyle(.borderedProminent)
29.                 }
30.             } else if vm.isComplete {
31.                 SessionCompleteView(
32.                     xpEarned: vm.xpEarned,
33.                     totalCorrect: vm.totalCorrect,
34.                     totalAttempts: vm.totalAttempts,
35.                     wordsPromoted: vm.wordsPromoted,
36.                     wordsDemoted: vm.wordsDemoted,
37.                     onDone: { dismiss() }
38.                 )
39.             } else if vm.showStepTransition {
40.                 StepTransitionView(
41.                     stepNumber: vm.currentStepIndex + 1,
42.                     totalSteps: vm.totalSteps,
43.                     nextStepLabel: vm.steps[safe: vm.currentStepIndex + 1]?.label ?? "Done",
44.                     onContinue: { vm.continueAfterTransition() }
45.                 )
46.             } else if let step = vm.currentStep {
47.                 switch step.type {
48.                 case .flashcard:
49.                     FlashcardStepView(
50.                         words: vm.newWords,
51.                         stepNumber: vm.currentStepIndex + 1,
52.                         totalSteps: vm.totalSteps,
53.                         startItemIndex: vm.resumeItemIndex,
54.                         onComplete: { showAgainIds in
55.                             vm.receiveShowAgainIds(showAgainIds)
56.                             vm.advanceToNextStep()
57.                         },
58.                         onItemAdvance: { itemIdx in
59.                             vm.didAdvanceItem(to: itemIdx)
60.                         },
61.                         onPause: { stepIdx, itemIdx, saIds, rqIds in
62.                             Task { await vm.pause(stepIndex: stepIdx, itemIndex: itemIdx, showAgainIds: saIds, requeuedIds: rqIds) }
63.                             dismiss()
64.                         }
65.                     )
66.                 case .imageGame:
67.                     ImageGameStepView(
68.                         words: vm.newWords,
69.                         showAgainPriority: vm.showAgainWordIds,
70.                         stepNumber: vm.currentStepIndex + 1,
71.                         totalSteps: vm.totalSteps,
72.                         startItemIndex: vm.resumeItemIndex,
73.                         onAnswer: { correct, wordId in
74.                             Task { await vm.recordAnswer(correct: correct, wordId: wordId, activityType: .imageGame, durationMs: 0) }
75.                         },
76.                         onComplete: { vm.advanceToNextStep() },
77.                         onItemAdvance: { itemIdx in
78.                             vm.didAdvanceItem(to: itemIdx)
79.                         },
80.                         onPause: { stepIdx, itemIdx, saIds, rqIds in
81.                             Task { await vm.pause(stepIndex: stepIdx, itemIndex: itemIdx, showAgainIds: saIds, requeuedIds: rqIds) }
82.                             dismiss()
83.                         }
84.                     )
85.                 case .quickRecall:
86.                     QuickRecallStepView(
87.                         words: vm.morningWords,
88.                         stepNumber: vm.currentStepIndex + 1,
89.                         totalSteps: vm.totalSteps,
90.                         startItemIndex: vm.resumeItemIndex,
91.                         onAnswer: { correct, wordId in
92.                             Task { await vm.recordAnswer(correct: correct, wordId: wordId, activityType: .quickRecall, durationMs: 0) }
93.                         },
94.                         onComplete: { vm.advanceToNextStep() },
95.                         onItemAdvance: { itemIdx in
96.                             vm.didAdvanceItem(to: itemIdx)
97.                         },
98.                         onPause: { stepIdx, itemIdx, saIds, rqIds in
99.                             Task { await vm.pause(stepIndex: stepIdx, itemIndex: itemIdx, showAgainIds: saIds, requeuedIds: rqIds) }
100.                             dismiss()
101.                         }
102.                     )
103.                 case .satQuestion:
104.                     SATQuestionStepView(
105.                         words: vm.newWords,
106.                         stepNumber: vm.currentStepIndex + 1,
107.                         totalSteps: vm.totalSteps,
108.                         startItemIndex: vm.resumeItemIndex,
109.                         onAnswer: { correct, wordId in
110.                             Task { await vm.recordAnswer(correct: correct, wordId: wordId, activityType: .satQuestion, durationMs: 0) }
111.                         },
112.                         onComplete: { vm.advanceToNextStep() },
113.                         onItemAdvance: { itemIdx in
114.                             vm.didAdvanceItem(to: itemIdx)
115.                         },
116.                         onPause: { stepIdx, itemIdx, saIds, rqIds in
117.                             Task { await vm.pause(stepIndex: stepIdx, itemIndex: itemIdx, showAgainIds: saIds, requeuedIds: rqIds) }
118.                             dismiss()
119.                         }
120.                     )
121.                 }
122.             }
123.         }
124.         .toolbar(.hidden, for: .tabBar)
125.         .navigationBarBackButtonHidden(true)
126.         .task {
127.             do {
128.                 try await vm.loadWords()
129.                 isLoading = false
130.             } catch {
131.                 loadError = String(describing: error)
132.                 isLoading = false
133.             }
134.         }
135.     }
136. }
137. 
138. extension Array {
139.     subscript(safe index: Int) -> Element? {
140.         indices.contains(index) ? self[index] : nil
141.     }
142. }
143.
```

</details>


---

<sub>⏱️ 1m 34s</sub>

### ✅ `view`

**view the file at /Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/ViewModels/SessionFlowViewModel.swift.**

/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/ViewModels/SessionFlowViewModel.swift

<details>
<summary>334 lines</summary>

```
1. import Foundation
2. import ActivityKit
3. 
4. @MainActor
5. final class SessionFlowViewModel: ObservableObject {
6.     // Session config
7.     let sessionType: SessionType
8.     let studyDay: Int
9.     let userId: String
10. 
11.     // State
12.     @Published var currentStepIndex: Int = 0
13.     @Published var isComplete: Bool = false
14.     @Published var isPaused: Bool = false
15.     @Published var showStepTransition: Bool = false
16. 
17.     // Scoring
18.     @Published var totalCorrect: Int = 0
19.     @Published var totalAttempts: Int = 0
20.     @Published var xpEarned: Int = 0
21.     @Published var wordsPromoted: Int = 0
22.     @Published var wordsDemoted: Int = 0
23.     @Published var comboCount: Int = 0
24. 
25.     // Show Again from flashcard step -> image game step
26.     var showAgainWordIds: [Int] = []
27. 
28.     // Words for each step (loaded at session start)
29.     var newWords: [VocabCard] = []
30.     var reviewWords: [VocabCard] = []
31.     var morningWords: [VocabCard] = []  // for evening quick recall
32. 
33.     // Step definitions
34.     struct StepDef {
35.         let type: StepType
36.         let label: String
37.         let itemCount: Int
38.     }
39. 
40.     enum StepType {
41.         case flashcard
42.         case imageGame
43.         case quickRecall
44.         case satQuestion
45.     }
46. 
47.     var steps: [StepDef] = []
48. 
49.     var currentStep: StepDef? {
50.         steps.indices.contains(currentStepIndex) ? steps[currentStepIndex] : nil
51.     }
52. 
53.     var totalSteps: Int { steps.count }
54. 
55.     var progressLabel: String {
56.         guard let step = currentStep else { return "" }
57.         return step.label
58.     }
59. 
60.     init(sessionType: SessionType, studyDay: Int) {
61.         self.sessionType = sessionType
62.         self.studyDay = studyDay
63.         self.userId = LocalIdentity.userId()
64. 
65.         // Define steps based on session type
66.         switch sessionType {
67.         case .morning:
68.             steps = [
69.                 StepDef(type: .flashcard, label: "Explore New Words", itemCount: AppConfig.morningNewWords),
70.                 StepDef(type: .imageGame, label: "Image Practice", itemCount: AppConfig.morningGameRounds),
71.                 StepDef(type: .satQuestion, label: "SAT Questions", itemCount: AppConfig.morningSATQuestions),
72.             ]
73.         case .evening:
74.             steps = [
75.                 StepDef(type: .flashcard, label: "Explore New Words", itemCount: AppConfig.eveningNewWords),
76.                 StepDef(type: .quickRecall, label: "Quick Recall", itemCount: AppConfig.morningNewWords),
77.                 StepDef(type: .imageGame, label: "Image Practice", itemCount: AppConfig.eveningGameRounds),
78.                 StepDef(type: .satQuestion, label: "SAT Questions", itemCount: AppConfig.eveningSATQuestions),
79.             ]
80.         default:
81.             // Recovery/review/bonus sessions — simplified
82.             steps = [
83.                 StepDef(type: .imageGame, label: "Practice", itemCount: 12),
84.                 StepDef(type: .satQuestion, label: "SAT Questions", itemCount: 3),
85.             ]
86.         }
87.     }
88. 
89.     // Restored item index within current step (0 = start from beginning)
90.     var resumeItemIndex: Int = 0
91. 
92.     func loadWords() async throws {
93.         let dm = DataManager.shared
94.         try await dm.initializeIfNeeded()
95. 
96.         // Create required rows BEFORE any updates
97.         let sessionStore = SessionStateStore.shared
98.         let statsStore = StatsStore.shared
99.         let zoneIdx = studyDay / 4  // approximate zone
100.         _ = try await sessionStore.getOrCreateDayState(userId: userId, studyDay: studyDay, zoneIndex: zoneIdx)
101. 
102.         // Check for an existing paused session before creating a new one
103.         if let existingSession = try await sessionStore.getActiveSession(userId: userId),
104.            existingSession.sessionType == sessionType,
105.            existingSession.studyDay == studyDay {
106.             // Resume: restore saved step/item index instead of resetting
107.             currentStepIndex = existingSession.stepIndex
108.             resumeItemIndex = existingSession.itemIndex
109.             showAgainWordIds = existingSession.showAgainIds
110.             try await sessionStore.resumeSession(userId: userId, studyDay: studyDay, sessionType: sessionType)
111. 
112.             // Restore in-flight scoring totals from daily_stats
113.             let dailyStats = try await statsStore.getOrCreateDailyStats(userId: userId, studyDay: studyDay)
114.             totalCorrect = dailyStats.correctCount
115.             totalAttempts = dailyStats.totalCount
116.             xpEarned = dailyStats.xpEarned + dailyStats.sessionBonus
117.             wordsPromoted = dailyStats.wordsPromoted
118.             wordsDemoted = dailyStats.wordsDemoted
119.         } else {
120.             _ = try await sessionStore.createSession(userId: userId, sessionType: sessionType, studyDay: studyDay)
121.             _ = try await statsStore.getOrCreateDailyStats(userId: userId, studyDay: studyDay)
122.         }
123. 
124.         let list = try await dm.getDefaultList()
125.         let totalDailyWords = AppConfig.morningNewWords + AppConfig.eveningNewWords
126.         let dayStart = studyDay * totalDailyWords
127. 
128.         switch sessionType {
129.         case .morning:
130.             newWords = try await dm.fetchSessionQueue(listId: list.id, limit: AppConfig.morningNewWords, startIndex: dayStart)
131.         case .evening:
132.             // Load morning words for the quick recall step
133.             morningWords = try await dm.fetchSessionQueue(listId: list.id, limit: AppConfig.morningNewWords, startIndex: dayStart)
134.             let eveningStart = dayStart + AppConfig.morningNewWords
135.             newWords = try await dm.fetchSessionQueue(listId: list.id, limit: AppConfig.eveningNewWords, startIndex: eveningStart)
136.         default:
137.             break
138.         }
139. 
140.         // Safety: if evening session has a quick recall step, ensure morningWords is populated
141.         if sessionType == .evening && morningWords.isEmpty {
142.             morningWords = try await dm.fetchSessionQueue(listId: list.id, limit: AppConfig.morningNewWords, startIndex: dayStart)
143.         }
144. 
145.         // Preload SAT context + collocations for each word
146.         for idx in newWords.indices {
147.             let context = try await dm.randomSatContext(wordId: newWords[idx].id)
148.             newWords[idx].satContext = context
149.             let collocations = try await dm.fetchCollocations(wordId: newWords[idx].id)
150.             newWords[idx].collocations = collocations.isEmpty ? nil : collocations
151.         }
152.         for idx in morningWords.indices {
153.             let context = try await dm.randomSatContext(wordId: morningWords[idx].id)
154.             morningWords[idx].satContext = context
155.             let collocations = try await dm.fetchCollocations(wordId: morningWords[idx].id)
156.             morningWords[idx].collocations = collocations.isEmpty ? nil : collocations
157.         }
158. 
159.         // Load review words from word_state
160.         let wsStore = WordStateStore(db: dm.db)
161.         let reviews = try await wsStore.getReviewQueue(userId: userId, limit: 6)
162.         // Convert WordState to VocabCard — would need a lookup
163.         // (simplified — full implementation maps wordId -> VocabCard)
164.         _ = reviews // suppress unused warning
165. 
166.         // Start Live Activity for Dynamic Island
167.         let firstStepLabel = steps.first?.label ?? "Study"
168.         LiveActivityManager.shared.start(
169.             sessionType: sessionType.rawValue,
170.             stepLabel: firstStepLabel,
171.             totalSteps: totalSteps
172.         )
173.     }
174. 
175.     func advanceToNextStep() {
176.         currentItemIndex = 0
177.         resumeItemIndex = 0  // Reset so next step starts from 0
178.         showStepTransition = true
179.     }
180. 
181.     func continueAfterTransition() {
182.         showStepTransition = false
183.         currentStepIndex += 1
184.         currentItemIndex = 0
185.         resumeItemIndex = 0
186.         if currentStepIndex >= steps.count {
187.             completeSession()
188.         } else {
189.             autoSaveProgress(stepIndex: currentStepIndex, itemIndex: 0)
190.         }
191.     }
192. 
193.     /// Called by step views when item index changes (e.g., next flashcard, next question)
194.     func didAdvanceItem(to itemIndex: Int) {
195.         currentItemIndex = itemIndex
196.         autoSaveProgress(stepIndex: currentStepIndex, itemIndex: itemIndex)
197.     }
198. 
199.     /// Track item index within current step for auto-save
200.     @Published var currentItemIndex: Int = 0
201. 
202.     func recordAnswer(correct: Bool, wordId: Int, activityType: ActivityType, durationMs: Int) async {
203.         print("📝 recordAnswer called: wordId=\(wordId) correct=\(correct) activityType=\(activityType)")
204.         totalAttempts += 1
205.         if correct {
206.             totalCorrect += 1
207.             xpEarned += AppConfig.correctAnswerXP
208.             comboCount += 1
209.         } else {
210.             comboCount = 0
211.         }
212. 
213.         // Record in data layer
214.         do {
215.             let dm = DataManager.shared
216.             let reviewLogger = ReviewLogger(db: dm.db)
217.             let wsStore = WordStateStore(db: dm.db)
218.             let statsStore = StatsStore.shared
219. 
220.             // 1. Write review_log entry
221.             let outcome: ReviewOutcome = correct ? .correct : .incorrect
222.             print("📝 about to call logReview for wordId=\(wordId)")
223.             try await reviewLogger.logReview(
224.                 userId: userId, wordId: wordId, outcome: outcome,
225.                 activityType: activityType, sessionType: sessionType,
226.                 studyDay: studyDay, durationMs: durationMs)
227.             print("📝 logReview succeeded for wordId=\(wordId)")
228. 
229.             // 2. Update word_state (box progression)
230.             print("📝 about to call recordScoredAnswer for wordId=\(wordId)")
231.             let boxChange = try await wsStore.recordScoredAnswer(userId: userId, wordId: wordId, correct: correct)
232.             print("📝 recordScoredAnswer succeeded for wordId=\(wordId) boxChange=\(boxChange)")
233. 
234.             switch boxChange {
235.             case .promoted(_, _): wordsPromoted += 1
236.             case .demoted(_, _): wordsDemoted += 1
237.             case .none: break
238.             }
239. 
240.             if correct {
241.                 try await statsStore.recordCorrectAnswer(userId: userId, studyDay: studyDay)
242.             } else {
243.                 try await statsStore.recordWrongAnswer(userId: userId, studyDay: studyDay)
244.             }
245.         } catch {
246.             print("❌ recordAnswer ERROR: \(error)")
247.         }
248. 
249.         // Update Live Activity
250.         let stepLabel = currentStep?.label ?? ""
251.         LiveActivityManager.shared.update(
252.             stepLabel: stepLabel,
253.             progress: "\(totalCorrect)/\(totalAttempts)",
254.             stepNumber: currentStepIndex + 1,
255.             totalSteps: totalSteps,
256.             xpEarned: xpEarned
257.         )
258.     }
259. 
260.     func receiveShowAgainIds(_ ids: [Int]) {
261.         showAgainWordIds = ids
262.     }
263. 
264.     /// Auto-save current position to SQLite so a hard kill preserves progress.
265.     /// Called by step views whenever the item index advances.
266.     func autoSaveProgress(stepIndex: Int, itemIndex: Int) {
267.         Task {
268.             do {
269.                 let store = SessionStateStore.shared
270.                 try await store.saveProgress(userId: userId, studyDay: studyDay, sessionType: sessionType,
271.                                              stepIndex: stepIndex, itemIndex: itemIndex,
272.                                              showAgainIds: showAgainWordIds)
273.             } catch {
274.                 print("⚠️ autoSaveProgress ERROR: \(error)")
275.             }
276.         }
277.     }
278. 
279.     private func completeSession() {
280.         isComplete = true
281.         LiveActivityManager.shared.end(xpEarned: xpEarned)
282. 
283.         Task {
284.             do {
285.                 let sessionStore = SessionStateStore.shared
286.                 let statsStore = StatsStore.shared
287. 
288.                 // Mark session complete
289.                 try await sessionStore.completeSession(userId: userId, studyDay: studyDay, sessionType: sessionType)
290. 
291.                 // Session bonus
292.                 try await statsStore.addSessionBonus(userId: userId, studyDay: studyDay)
293.                 xpEarned += AppConfig.sessionBonusXP
294. 
295.                 // Mark day state
296.                 if sessionType == .morning {
297.                     try await sessionStore.markMorningComplete(userId: userId, studyDay: studyDay,
298.                         accuracy: totalAttempts > 0 ? Double(totalCorrect) / Double(totalAttempts) : 0,
299.                         xp: xpEarned, newWords: newWords.count)
300.                 } else if sessionType == .evening {
301.                     try await sessionStore.markEveningComplete(userId: userId, studyDay: studyDay,
302.                         accuracy: totalAttempts > 0 ? Double(totalCorrect) / Double(totalAttempts) : 0,
303.                         xp: xpEarned, newWords: newWords.count)
304. 
305.                     // Run Day 1 promotion
306.                     let dm = DataManager.shared
307.                     let wsStore = WordStateStore(db: dm.db)
308.                     let promotion = try await wsStore.runDay1Promotion(userId: userId, studyDay: studyDay)
309.                     wordsPromoted += promotion.promoted
310.                 }
311. 
312.                 // Update streak
313.                 let (_, milestoneXP) = try await statsStore.updateStreak(userId: userId, xpToday: xpEarned)
314.                 xpEarned += milestoneXP
315.             } catch {
316.                 print("❌ completeSession ERROR: \(error)")
317.             }
318.         }
319.     }
320. 
321.     // MARK: - Pause/Resume
322. 
323.     func pause(stepIndex: Int, itemIndex: Int, showAgainIds: [Int], requeuedIds: [Int]) async {
324.         isPaused = true
325.         LiveActivityManager.shared.end(xpEarned: xpEarned)
326.         do {
327.             let store = SessionStateStore.shared
328.             try await store.pauseSession(userId: userId, studyDay: studyDay, sessionType: sessionType,
329.                                         stepIndex: stepIndex, itemIndex: itemIndex,
330.                                         showAgainIds: showAgainIds, requeuedIds: requeuedIds)
331.         } catch { print("❌ pause ERROR: \(error)") }
332.     }
333. }
334.
```

</details>


---

<sub>⏱️ 1m 34s</sub>

### ✅ `view`

**view the file at /Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Views/Session/SessionHeaderView.swift.**

/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Views/Session/SessionHeaderView.swift

<details>
<summary>90 lines</summary>

```
1. import SwiftUI
2. import AVFoundation
3. 
4. struct SessionHeaderView: View {
5.     let stepNumber: Int
6.     let totalSteps: Int
7.     let stepLabel: String
8.     var currentWord: String = ""
9.     let currentItem: Int
10.     let totalItems: Int
11.     let progressColor: Color
12.     let isScored: Bool
13.     let onClose: () -> Void
14. 
15.     private let synthesizer = AVSpeechSynthesizer()
16. 
17.     var body: some View {
18.         VStack(spacing: 4) {
19.             HStack(spacing: 12) {
20.                 Button(action: onClose) {
21.                     Image(systemName: "xmark")
22.                         .font(.system(size: 16, weight: .semibold))
23.                         .foregroundColor(Color(hex: "#AFAFAF"))
24.                         .frame(width: 36, height: 36)
25.                 }
26. 
27.                 // Compact info
28.                 HStack(spacing: 6) {
29.                     Text("\(stepNumber)/\(totalSteps)")
30.                         .font(.system(size: 13, weight: .bold, design: .rounded))
31.                         .foregroundColor(isScored ? progressColor : Color(hex: "#AFAFAF"))
32. 
33.                     if !currentWord.isEmpty {
34.                         Text("\u{00B7}")
35.                             .foregroundColor(Color(hex: "#AFAFAF"))
36.                         Text(currentWord.uppercased())
37.                             .font(.system(size: 15, weight: .black, design: .rounded))
38.                             .foregroundColor(Color(hex: "#FFC800"))
39.                             .lineLimit(1)
40.                     }
41. 
42.                     Text("\(currentItem)/\(totalItems)")
43.                         .font(.system(size: 13, weight: .semibold, design: .rounded))
44.                         .foregroundColor(Color(hex: "#AFAFAF"))
45.                 }
46.                 .frame(maxWidth: .infinity)
47. 
48.                 // Sound button — pronounces the current word
49.                 Button {
50.                     speakWord()
51.                 } label: {
52.                     Image(systemName: "speaker.wave.2.fill")
53.                         .font(.system(size: 14, weight: .semibold))
54.                         .foregroundColor(currentWord.isEmpty ? Color(hex: "#AFAFAF") : Color(hex: "#1CB0F6"))
55.                         .frame(width: 36, height: 36)
56.                 }
57.                 .disabled(currentWord.isEmpty)
58.             }
59.             .padding(.horizontal, 8)
60. 
61.             // Progress bar
62.             GeometryReader { geo in
63.                 ZStack(alignment: .leading) {
64.                     RoundedRectangle(cornerRadius: 3, style: .continuous)
65.                         .fill(Color(hex: "#E5E5E5"))
66. 
67.                     RoundedRectangle(cornerRadius: 3, style: .continuous)
68.                         .fill(progressColor)
69.                         .frame(width: geo.size.width * CGFloat(currentItem) / CGFloat(max(totalItems, 1)))
70.                 }
71.             }
72.             .frame(height: 5)
73.             .padding(.horizontal, 12)
74.         }
75.         .padding(.top, 4)
76.         .padding(.bottom, 2)
77.     }
78. 
79.     private func speakWord() {
80.         guard !currentWord.isEmpty else { return }
81.         if synthesizer.isSpeaking {
82.             synthesizer.stopSpeaking(at: .immediate)
83.         }
84.         let utterance = AVSpeechUtterance(string: currentWord)
85.         utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
86.         utterance.rate = AVSpeechUtteranceDefaultSpeechRate * 0.85
87.         synthesizer.speak(utterance)
88.     }
89. }
90.
```

</details>


---

<sub>⏱️ 1m 34s</sub>

### ✅ `view`

**view the file at /Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Views/Session/PauseSheet.swift.**

/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Views/Session/PauseSheet.swift

<details>
<summary>65 lines</summary>

```
1. import SwiftUI
2. 
3. struct PauseSheet: View {
4.     let onKeepGoing: () -> Void
5.     let onPauseExit: () -> Void
6.     @Environment(\.dismiss) private var dismiss
7. 
8.     var body: some View {
9.         VStack(spacing: 20) {
10.             // Handle
11.             RoundedRectangle(cornerRadius: 3)
12.                 .fill(Color(hex: "#E5E5E5"))
13.                 .frame(width: 40, height: 4)
14.                 .padding(.top, 12)
15. 
16.             Text("Take a break?")
17.                 .font(.system(size: 20, weight: .bold, design: .rounded))
18.                 .foregroundColor(Color(hex: "#4B4B4B"))
19. 
20.             Text("Your progress is saved. You can pick up where you left off.")
21.                 .font(.system(size: 13, weight: .medium))
22.                 .foregroundColor(Color(hex: "#AFAFAF"))
23.                 .multilineTextAlignment(.center)
24.                 .padding(.horizontal, 24)
25. 
26.             // Focus tip
27.             VStack(spacing: 6) {
28.                 Text("FOCUS TIP")
29.                     .font(.system(size: 11, weight: .bold, design: .rounded))
30.                     .foregroundColor(Color(hex: "#CE82FF"))
31.                     .tracking(0.5)
32.                 Text("Short, focused sessions work better than long ones. Even 5 minutes counts!")
33.                     .font(.system(size: 12, weight: .medium))
34.                     .foregroundColor(Color(hex: "#666666"))
35.                     .multilineTextAlignment(.center)
36.             }
37.             .padding(16)
38.             .background(Color(hex: "#CE82FF").opacity(0.05))
39.             .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
40.             .padding(.horizontal, 20)
41. 
42.             Spacer()
43. 
44.             // Buttons
45.             VStack(spacing: 10) {
46.                 Button3D("Keep Going", action: onKeepGoing)
47. 
48.                 Button3D("Pause & Exit",
49.                          color: .white,
50.                          pressedColor: Color(hex: "#E5E5E5"),
51.                          textColor: Color(hex: "#AFAFAF"),
52.                          action: {
53.                              dismiss()
54.                              DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) {
55.                                  onPauseExit()
56.                              }
57.                          })
58.             }
59.             .padding(.horizontal, 24)
60.             .padding(.bottom, 30)
61.         }
62.         .presentationDetents([.fraction(0.5)])
63.     }
64. }
65.
```

</details>


---

<sub>⏱️ 1m 34s</sub>

### ✅ `view`

**view the file at /Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Views/Session/SessionCompleteView.swift.**

/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Views/Session/SessionCompleteView.swift

<details>
<summary>109 lines</summary>

```
1. import SwiftUI
2. 
3. struct SessionCompleteView: View {
4.     let xpEarned: Int
5.     let totalCorrect: Int
6.     let totalAttempts: Int
7.     let wordsPromoted: Int
8.     let wordsDemoted: Int
9.     let onDone: () -> Void
10. 
11.     @State private var appeared = false
12. 
13.     private var accuracy: Int {
14.         totalAttempts > 0 ? Int(Double(totalCorrect) / Double(totalAttempts) * 100) : 0
15.     }
16. 
17.     var body: some View {
18.         VStack(spacing: 20) {
19.             Spacer()
20. 
21.             // Celebration
22.             Text("Session Complete!")
23.                 .font(.system(size: 24, weight: .black, design: .rounded))
24.                 .foregroundColor(Color(hex: "#4B4B4B"))
25. 
26.             Text("Great work today")
27.                 .font(.system(size: 14, weight: .medium))
28.                 .foregroundColor(Color(hex: "#AFAFAF"))
29. 
30.             // XP earned
31.             VStack(spacing: 4) {
32.                 Text("+\(xpEarned)")
33.                     .font(.system(size: 48, weight: .black, design: .rounded))
34.                     .foregroundColor(Color(hex: "#FFC800"))
35.                 Text("XP EARNED")
36.                     .font(.system(size: 10, weight: .bold, design: .rounded))
37.                     .foregroundColor(Color(hex: "#AFAFAF"))
38.                     .tracking(0.5)
39.             }
40.             .padding(.vertical, 8)
41. 
42.             // Stats grid
43.             HStack(spacing: 20) {
44.                 statItem(value: "\(accuracy)%", label: "Accuracy", color: "#58CC02")
45.                 statItem(value: "\(totalCorrect)/\(totalAttempts)", label: "Correct", color: "#1CB0F6")
46.             }
47. 
48.             HStack(spacing: 20) {
49.                 if wordsPromoted > 0 {
50.                     statItem(value: "+\(wordsPromoted)", label: "Promoted", color: "#58CC02")
51.                 }
52.                 if wordsDemoted > 0 {
53.                     statItem(value: "-\(wordsDemoted)", label: "Demoted", color: "#FF7043")
54.                 }
55.             }
56. 
57.             Spacer()
58. 
59.             // Share button placeholder
60.             Button {
61.                 // Share functionality placeholder
62.             } label: {
63.                 HStack(spacing: 6) {
64.                     Image(systemName: "square.and.arrow.up")
65.                         .font(.system(size: 13, weight: .semibold))
66.                     Text("Share Progress")
67.                         .font(.system(size: 13, weight: .bold, design: .rounded))
68.                 }
69.                 .foregroundColor(Color(hex: "#1CB0F6"))
70.                 .padding(.horizontal, 20)
71.                 .padding(.vertical, 10)
72.                 .background(Color(hex: "#1CB0F6").opacity(0.1))
73.                 .clipShape(Capsule())
74.             }
75. 
76.             // Done button
77.             Button3D("Done", action: onDone)
78.                 .padding(.horizontal, 40)
79.                 .padding(.bottom, 30)
80.         }
81.         .scaleEffect(appeared ? 1.0 : 0.8)
82.         .opacity(appeared ? 1.0 : 0.0)
83.         .onAppear {
84.             withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
85.                 appeared = true
86.             }
87.         }
88.         .background(Color.white)
89.         .accessibilityIdentifier("sessionCompleteView")
90.     }
91. 
92.     @ViewBuilder
93.     private func statItem(value: String, label: String, color: String) -> some View {
94.         VStack(spacing: 4) {
95.             Text(value)
96.                 .font(.system(size: 22, weight: .heavy, design: .rounded))
97.                 .foregroundColor(Color(hex: color))
98.             Text(label.uppercased())
99.                 .font(.system(size: 11, weight: .bold, design: .rounded))
100.                 .foregroundColor(Color(hex: "#AFAFAF"))
101.                 .tracking(0.5)
102.         }
103.         .frame(minWidth: 80)
104.         .padding(.vertical, 12)
105.         .background(Color(hex: color).opacity(0.05))
106.         .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
107.     }
108. }
109.
```

</details>


---

<sub>⏱️ 1m 34s</sub>

### ✅ `view`

**view the file at /Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Views/Session/StepTransitionView.swift.**

/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Views/Session/StepTransitionView.swift

<details>
<summary>62 lines</summary>

```
1. import SwiftUI
2. 
3. struct StepTransitionView: View {
4.     let stepNumber: Int
5.     let totalSteps: Int
6.     let nextStepLabel: String
7.     let onContinue: () -> Void
8. 
9.     var body: some View {
10.         VStack(spacing: 24) {
11.             Spacer()
12. 
13.             // Celebration
14.             Text("Step \(stepNumber) Complete!")
15.                 .font(.system(size: 22, weight: .black, design: .rounded))
16.                 .foregroundColor(Color(hex: "#4B4B4B"))
17. 
18.             // Step dots
19.             HStack(spacing: 8) {
20.                 ForEach(1...totalSteps, id: \.self) { step in
21.                     Circle()
22.                         .fill(step <= stepNumber
23.                               ? Color(hex: "#58CC02")
24.                               : Color(hex: "#E5E5E5"))
25.                         .frame(width: 12, height: 12)
26.                         .overlay(
27.                             step <= stepNumber
28.                                 ? Image(systemName: "checkmark")
29.                                     .font(.system(size: 11, weight: .bold))
30.                                     .foregroundColor(.white)
31.                                 : nil
32.                         )
33.                 }
34.             }
35. 
36.             // Next step card
37.             VStack(spacing: 8) {
38.                 Text("UP NEXT")
39.                     .font(.system(size: 11, weight: .bold, design: .rounded))
40.                     .foregroundColor(Color(hex: "#AFAFAF"))
41.                     .tracking(0.5)
42. 
43.                 Text(nextStepLabel)
44.                     .font(.system(size: 16, weight: .bold, design: .rounded))
45.                     .foregroundColor(Color(hex: "#4B4B4B"))
46.             }
47.             .padding(20)
48.             .frame(maxWidth: .infinity)
49.             .background(Color(hex: "#F7F7F7"))
50.             .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
51.             .padding(.horizontal, 24)
52. 
53.             Spacer()
54. 
55.             Button3D("Continue", action: onContinue)
56.                 .padding(.horizontal, 40)
57.                 .padding(.bottom, 30)
58.         }
59.         .background(Color.white)
60.     }
61. }
62.
```

</details>


---

<sub>⏱️ 1m 41s</sub>

### ✅ `view`

**view the file at /Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Views/Flashcard/FlashcardStepView.swift.**

/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Views/Flashcard/FlashcardStepView.swift

<details>
<summary>155 lines</summary>

```
1. import SwiftUI
2. 
3. struct FlashcardStepView: View {
4.     let words: [VocabCard]
5.     let stepNumber: Int
6.     let totalSteps: Int
7.     var startItemIndex: Int = 0
8.     let onComplete: ([Int]) -> Void
9.     var onItemAdvance: ((Int) -> Void)? = nil
10.     let onPause: (Int, Int, [Int], [Int]) -> Void
11. 
12.     @State private var currentIndex: Int = 0
13.     @State private var showAgainIds: Set<Int> = []
14.     @State private var completedIds: Set<Int> = []
15.     @State private var requeuedCards: [VocabCard] = []
16.     @State private var showPause: Bool = false
17.     @State private var dragOffset: CGFloat = 0
18.     @State private var didInit = false
19. 
20.     private var allCards: [VocabCard] {
21.         words + requeuedCards
22.     }
23. 
24.     private var totalCards: Int {
25.         allCards.count
26.     }
27. 
28.     private var currentCard: VocabCard? {
29.         guard allCards.indices.contains(currentIndex) else { return nil }
30.         return allCards[currentIndex]
31.     }
32. 
33.     private var isReadOnly: Bool {
34.         guard let card = currentCard else { return false }
35.         return completedIds.contains(card.id)
36.     }
37. 
38.     var body: some View {
39.         VStack(spacing: 0) {
40.             SessionHeaderView(
41.                 stepNumber: stepNumber,
42.                 totalSteps: totalSteps,
43.                 stepLabel: "Explore New Words",
44.                 currentWord: currentCard?.lemma ?? "",
45.                 currentItem: min(currentIndex + 1, totalCards),
46.                 totalItems: totalCards,
47.                 progressColor: Color(hex: "#58CC02"),
48.                 isScored: false,
49.                 onClose: { showPause = true }
50.             )
51. 
52.             if let card = currentCard {
53.                 FlashcardCardView(
54.                     card: card,
55.                     cardIndex: currentIndex,
56.                     totalCards: totalCards,
57.                     boxLevel: 0,
58.                     memoryStatus: .normal,
59.                     isReadOnly: isReadOnly,
60.                     onShowAgain: {
61.                         handleShowAgain(card)
62.                     },
63.                     onGotIt: {
64.                         advanceCard(card)
65.                     }
66.                 )
67.                 .id(currentIndex)
68.                 .offset(x: dragOffset)
69.                 .gesture(
70.                     DragGesture(minimumDistance: 50)
71.                         .onChanged { value in
72.                             dragOffset = value.translation.width
73.                         }
74.                         .onEnded { value in
75.                             let threshold: CGFloat = 80
76.                             withAnimation(.spring(response: 0.3)) {
77.                                 if value.translation.width < -threshold {
78.                                     if let card = currentCard {
79.                                         advanceCard(card)
80.                                     }
81.                                 } else if value.translation.width > threshold {
82.                                     goBack()
83.                                 }
84.                                 dragOffset = 0
85.                             }
86.                         }
87.                 )
88.                 .padding(.horizontal, 8)
89.                 .padding(.vertical, 4)
90.             } else {
91.                 VStack(spacing: 16) {
92.                     Spacer()
93.                     Text("All caught up!")
94.                         .font(.system(size: 20, weight: .bold, design: .rounded))
95.                         .foregroundColor(Color(hex: "#4B4B4B"))
96.                     Text("No words to review right now.")
97.                         .font(.system(size: 14, weight: .medium))
98.                         .foregroundColor(Color(hex: "#AFAFAF"))
99.                     Spacer()
100.                 }
101.             }
102.         }
103.         .onAppear {
104.             if !didInit {
105.                 didInit = true
106.                 currentIndex = min(startItemIndex, max(allCards.count - 1, 0))
107.             }
108.             if words.isEmpty {
109.                 onComplete([])
110.             }
111.         }
112.         .sheet(isPresented: $showPause) {
113.             PauseSheet(
114.                 onKeepGoing: { showPause = false },
115.                 onPauseExit: {
116.                     onPause(stepNumber - 1, currentIndex, Array(showAgainIds), requeuedCards.map { $0.id })
117.                 }
118.             )
119.         }
120.     }
121. 
122.     private func handleShowAgain(_ card: VocabCard) {
123.         if !showAgainIds.contains(card.id) {
124.             showAgainIds.insert(card.id)
125.             requeuedCards.append(card)
126.         }
127.         completedIds.insert(card.id)
128.         advanceToNext()
129.     }
130. 
131.     private func advanceCard(_ card: VocabCard) {
132.         completedIds.insert(card.id)
133.         advanceToNext()
134.     }
135. 
136.     private func advanceToNext() {
137.         if currentIndex + 1 >= totalCards {
138.             onComplete(Array(showAgainIds))
139.         } else {
140.             withAnimation(.easeInOut(duration: 0.25)) {
141.                 currentIndex += 1
142.             }
143.             onItemAdvance?(currentIndex)
144.         }
145.     }
146. 
147.     private func goBack() {
148.         if currentIndex > 0 {
149.             withAnimation(.easeInOut(duration: 0.25)) {
150.                 currentIndex -= 1
151.             }
152.         }
153.     }
154. }
155.
```

</details>


---

<sub>⏱️ 1m 41s</sub>

### ✅ `view`

**view the file at /Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Views/Game/ImageGameStepView.swift.**

/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Views/Game/ImageGameStepView.swift

<details>
<summary>112 lines</summary>

```
1. import SwiftUI
2. 
3. struct ImageGameStepView: View {
4.     let words: [VocabCard]
5.     let showAgainPriority: [Int]
6.     let stepNumber: Int
7.     let totalSteps: Int
8.     var startItemIndex: Int = 0
9.     let onAnswer: (Bool, Int) -> Void
10.     let onComplete: () -> Void
11.     var onItemAdvance: ((Int) -> Void)? = nil
12.     let onPause: (Int, Int, [Int], [Int]) -> Void
13. 
14.     @State private var currentRound: Int = 0
15.     @State private var roundCards: [(card: VocabCard, choices: [VocabCard])] = []
16.     @State private var isLoading = true
17.     @State private var showPause = false
18.     @State private var didInit = false
19. 
20.     private var totalRounds: Int {
21.         roundCards.count
22.     }
23. 
24.     var body: some View {
25.         VStack(spacing: 0) {
26.             SessionHeaderView(
27.                 stepNumber: stepNumber,
28.                 totalSteps: totalSteps,
29.                 stepLabel: "Image Practice",
30.                 currentWord: (currentRound < roundCards.count) ? roundCards[currentRound].card.lemma : "",
31.                 currentItem: min(currentRound + 1, max(totalRounds, 1)),
32.                 totalItems: max(totalRounds, 1),
33.                 progressColor: Color(hex: "#58CC02"),
34.                 isScored: true,
35.                 onClose: { showPause = true }
36.             )
37. 
38.             if isLoading {
39.                 Spacer()
40.                 ProgressView("Loading...")
41.                 Spacer()
42.             } else if currentRound < totalRounds {
43.                 let round = roundCards[currentRound]
44.                 ImageGameView(
45.                     card: round.card,
46.                     choices: round.choices,
47.                     roundIndex: currentRound,
48.                     totalRounds: totalRounds,
49.                     onAnswer: { correct in
50.                         onAnswer(correct, round.card.id)
51.                         if currentRound + 1 >= totalRounds {
52.                             onComplete()
53.                         } else {
54.                             currentRound += 1
55.                             onItemAdvance?(currentRound)
56.                         }
57.                     }
58.                 )
59.                 .id(currentRound)
60.             }
61.         }
62.         .onAppear {
63.             if words.isEmpty {
64.                 onComplete()
65.             }
66.         }
67.         .task {
68.             await loadRounds()
69.             if !didInit {
70.                 didInit = true
71.                 currentRound = min(startItemIndex, max(roundCards.count - 1, 0))
72.             }
73.         }
74.         .sheet(isPresented: $showPause) {
75.             PauseSheet(
76.                 onKeepGoing: { showPause = false },
77.                 onPauseExit: {
78.                     onPause(stepNumber - 1, currentRound, [], [])
79.                 }
80.             )
81.         }
82.     }
83. 
84.     private func loadRounds() async {
85.         var ordered: [VocabCard] = []
86.         let priorityIds = Set(showAgainPriority)
87.         let priorityCards = words.filter { priorityIds.contains($0.id) }
88.         let otherCards = words.filter { !priorityIds.contains($0.id) }
89.         ordered = priorityCards + otherCards
90. 
91.         var rounds: [(card: VocabCard, choices: [VocabCard])] = []
92.         for card in ordered {
93.             do {
94.                 let dm = DataManager.shared
95.                 let list = try await dm.getDefaultList()
96.                 let distractors = try await dm.fetchDistractors(listId: list.id, pos: card.pos, excludeWordId: card.id, limit: 3)
97.                 var choices = distractors + [card]
98.                 choices.shuffle()
99.                 rounds.append((card: card, choices: choices))
100.             } catch {
101.                 var choices = Array(words.filter { $0.id != card.id }.prefix(3))
102.                 choices.append(card)
103.                 choices.shuffle()
104.                 rounds.append((card: card, choices: choices))
105.             }
106.         }
107. 
108.         roundCards = rounds
109.         isLoading = false
110.     }
111. }
112.
```

</details>


---

<sub>⏱️ 1m 41s</sub>

### ✅ `view`

**view the file at /Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Views/Game/QuickRecallStepView.swift.**

/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Views/Game/QuickRecallStepView.swift

<details>
<summary>110 lines</summary>

```
1. import SwiftUI
2. 
3. struct QuickRecallStepView: View {
4.     let words: [VocabCard]
5.     let stepNumber: Int
6.     let totalSteps: Int
7.     var startItemIndex: Int = 0
8.     let onAnswer: (Bool, Int) -> Void
9.     let onComplete: () -> Void
10.     var onItemAdvance: ((Int) -> Void)? = nil
11.     let onPause: (Int, Int, [Int], [Int]) -> Void
12. 
13.     @State private var currentRound: Int = 0
14.     @State private var roundData: [(card: VocabCard, choices: [QuickRecallView.DefinitionChoice])] = []
15.     @State private var isLoading = true
16.     @State private var showPause = false
17.     @State private var didInit = false
18. 
19.     private var totalRounds: Int {
20.         roundData.count
21.     }
22. 
23.     var body: some View {
24.         VStack(spacing: 0) {
25.             SessionHeaderView(
26.                 stepNumber: stepNumber,
27.                 totalSteps: totalSteps,
28.                 stepLabel: "Quick Recall",
29.                 currentWord: (currentRound < roundData.count) ? roundData[currentRound].card.lemma : "",
30.                 currentItem: min(currentRound + 1, max(totalRounds, 1)),
31.                 totalItems: max(totalRounds, 1),
32.                 progressColor: Color(hex: "#CE82FF"),
33.                 isScored: true,
34.                 onClose: { showPause = true }
35.             )
36. 
37.             if isLoading {
38.                 Spacer()
39.                 ProgressView("Loading...")
40.                 Spacer()
41.             } else if currentRound < totalRounds {
42.                 let round = roundData[currentRound]
43.                 QuickRecallView(
44.                     card: round.card,
45.                     definitionChoices: round.choices,
46.                     onAnswer: { correct in
47.                         onAnswer(correct, round.card.id)
48.                         if currentRound + 1 >= totalRounds {
49.                             onComplete()
50.                         } else {
51.                             currentRound += 1
52.                             onItemAdvance?(currentRound)
53.                         }
54.                     }
55.                 )
56.                 .id(currentRound)
57.             }
58.         }
59.         .onAppear {
60.             if words.isEmpty {
61.                 onComplete()
62.             }
63.         }
64.         .task {
65.             await loadRounds()
66.             if !didInit {
67.                 didInit = true
68.                 currentRound = min(startItemIndex, max(roundData.count - 1, 0))
69.             }
70.         }
71.         .sheet(isPresented: $showPause) {
72.             PauseSheet(
73.                 onKeepGoing: { showPause = false },
74.                 onPauseExit: {
75.                     onPause(stepNumber - 1, currentRound, [], [])
76.                 }
77.             )
78.         }
79.     }
80. 
81.     private func loadRounds() async {
82.         var rounds: [(card: VocabCard, choices: [QuickRecallView.DefinitionChoice])] = []
83. 
84.         for card in words {
85.             do {
86.                 let dm = DataManager.shared
87.                 let list = try await dm.getDefaultList()
88.                 let distractors = try await dm.fetchDistractors(listId: list.id, pos: card.pos, excludeWordId: card.id, limit: 3)
89. 
90.                 var choices: [QuickRecallView.DefinitionChoice] = distractors.map { d in
91.                     QuickRecallView.DefinitionChoice(id: d.id, definition: d.definition ?? "Unknown", isCorrect: false)
92.                 }
93.                 choices.append(QuickRecallView.DefinitionChoice(id: card.id, definition: card.definition ?? "Unknown", isCorrect: true))
94.                 choices.shuffle()
95.                 rounds.append((card: card, choices: choices))
96.             } catch {
97.                 var choices: [QuickRecallView.DefinitionChoice] = words.filter { $0.id != card.id }.prefix(3).map { d in
98.                     QuickRecallView.DefinitionChoice(id: d.id, definition: d.definition ?? "Unknown", isCorrect: false)
99.                 }
100.                 choices.append(QuickRecallView.DefinitionChoice(id: card.id, definition: card.definition ?? "Unknown", isCorrect: true))
101.                 choices.shuffle()
102.                 rounds.append((card: card, choices: choices))
103.             }
104.         }
105. 
106.         roundData = rounds
107.         isLoading = false
108.     }
109. }
110.
```

</details>


---

<sub>⏱️ 1m 41s</sub>

### ✅ `view`

**view the file at /Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Views/Game/SATQuestionStepView.swift.**

/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Views/Game/SATQuestionStepView.swift

<details>
<summary>112 lines</summary>

```
1. import SwiftUI
2. 
3. struct SATQuestionStepView: View {
4.     let words: [VocabCard]
5.     let stepNumber: Int
6.     let totalSteps: Int
7.     var startItemIndex: Int = 0
8.     let onAnswer: (Bool, Int) -> Void
9.     let onComplete: () -> Void
10.     var onItemAdvance: ((Int) -> Void)? = nil
11.     let onPause: (Int, Int, [Int], [Int]) -> Void
12. 
13.     @State private var currentRound: Int = 0
14.     @State private var questions: [(wordId: Int, question: SatQuestion)] = []
15.     @State private var isLoading = true
16.     @State private var showPause = false
17.     @State private var didInit = false
18. 
19.     private var totalRounds: Int {
20.         questions.count
21.     }
22. 
23.     var body: some View {
24.         VStack(spacing: 0) {
25.             SessionHeaderView(
26.                 stepNumber: stepNumber,
27.                 totalSteps: totalSteps,
28.                 stepLabel: "SAT Questions",
29.                 currentWord: "",
30.                 currentItem: min(currentRound + 1, max(totalRounds, 1)),
31.                 totalItems: max(totalRounds, 1),
32.                 progressColor: Color(hex: "#FF9600"),
33.                 isScored: true,
34.                 onClose: { showPause = true }
35.             )
36. 
37.             if isLoading {
38.                 Spacer()
39.                 ProgressView("Loading SAT questions...")
40.                 Spacer()
41.             } else if currentRound < totalRounds {
42.                 let round = questions[currentRound]
43.                 SATQuestionView(
44.                     question: round.question,
45.                     onAnswer: { correct in
46.                         onAnswer(correct, round.wordId)
47.                         if currentRound + 1 >= totalRounds {
48.                             onComplete()
49.                         } else {
50.                             currentRound += 1
51.                             onItemAdvance?(currentRound)
52.                         }
53.                     }
54.                 )
55.                 .id(currentRound)
56.             } else {
57.                 VStack(spacing: 16) {
58.                     Spacer()
59.                     Text("No SAT questions available")
60.                         .font(.system(size: 16, weight: .bold, design: .rounded))
61.                         .foregroundColor(Color(hex: "#AFAFAF"))
62.                     Button3D("Continue", action: onComplete)
63.                         .padding(.horizontal, 40)
64.                     Spacer()
65.                 }
66.             }
67.         }
68.         .task {
69.             await loadQuestions()
70.             if !didInit {
71.                 didInit = true
72.                 currentRound = min(startItemIndex, max(questions.count - 1, 0))
73.             }
74.         }
75.         .sheet(isPresented: $showPause) {
76.             PauseSheet(
77.                 onKeepGoing: { showPause = false },
78.                 onPauseExit: {
79.                     onPause(stepNumber - 1, currentRound, [], [])
80.                 }
81.             )
82.         }
83.     }
84. 
85.     private func loadQuestions() async {
86.         var loaded: [(wordId: Int, question: SatQuestion)] = []
87.         let dm = DataManager.shared
88. 
89.         for card in words.shuffled() {
90.             do {
91.                 let qs = try await dm.fetchSatQuestionsForWord(
92.                     wordId: card.id,
93.                     limit: 1,
94.                     verifiedOnly: AppConfig.satQuestionsVerifiedOnly
95.                 )
96.                 if let q = qs.first {
97.                     loaded.append((wordId: card.id, question: q))
98.                 }
99.             } catch {
100.                 // Skip this word
101.             }
102. 
103.             if loaded.count >= (stepNumber <= 3 ? AppConfig.morningSATQuestions : AppConfig.eveningSATQuestions) {
104.                 break
105.             }
106.         }
107. 
108.         questions = loaded
109.         isLoading = false
110.     }
111. }
112.
```

</details>


---

<sub>⏱️ 1m 41s</sub>

### ✅ `view`

**view the file at /Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Views/FlashcardView.swift.**

/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Views/FlashcardView.swift

<details>
<summary>263 lines</summary>

```
1. import SwiftUI
2. import AVFoundation
3. import Foundation
4. 
5. struct FlashcardView: View {
6.     let card: VocabCard
7.     let onForgot: () -> Void
8.     let onGotIt: () -> Void
9. 
10.     @State private var isFlipped = false
11. 
12.     var body: some View {
13.         let satContextRaw = (card.satContext ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
14.         let exampleRaw = (card.example ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
15. 
16.         let satContext = TextFill.fillBlankPlaceholders(satContextRaw, with: card.lemma)
17.         let example = TextFill.fillBlankPlaceholders(exampleRaw, with: card.lemma)
18.         let frontSentence = example.isEmpty ? satContext : example
19. 
20.         ZStack {
21.             if isFlipped {
22.                 back(context: satContext)
23.                     .transition(.opacity)
24.             } else {
25.                 front(sentence: frontSentence)
26.                     .transition(.opacity)
27.             }
28.         }
29.         .frame(maxWidth: .infinity)
30.         .frame(maxHeight: .infinity)
31.         .contentShape(Rectangle())
32.         .onTapGesture {
33.             withAnimation(.spring(response: 0.55, dampingFraction: 0.85)) {
34.                 isFlipped.toggle()
35.             }
36.         }
37.         .onChange(of: card.id) { _, _ in
38.             // Always show the front when moving to the next word.
39.             isFlipped = false
40.         }
41.         .rotation3DEffect(
42.             .degrees(isFlipped ? 180 : 0),
43.             axis: (x: 0, y: 1, z: 0),
44.             perspective: 0.75
45.         )
46.     }
47. 
48.     private func front(sentence: String) -> some View {
49.         GeometryReader { geo in
50.             VStack(alignment: .leading, spacing: 8) {
51.                 VStack(alignment: .leading, spacing: 8) {
52.                     if sentence.isEmpty {
53.                         Text(card.lemma)
54.                             .font(.system(size: 21, design: .rounded).weight(.bold))
55.                             .foregroundStyle(.primary)
56.                     } else {
57.                         highlightedSentence(sentence, term: card.lemma)
58.                             .font(.system(size: 21, design: .rounded)) // ~body + 4
59.                             .foregroundStyle(.primary)
60.                             .multilineTextAlignment(.leading)
61.                             .fixedSize(horizontal: false, vertical: true)
62.                     }
63. 
64.                     if let def = card.definition, !def.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
65.                         Text(def)
66.                             .font(.system(.body, design: .rounded))
67.                             .foregroundStyle(.secondary)
68.                             .lineLimit(2)
69.                     }
70.                 }
71.                 .padding(.horizontal, 16)
72.                 .padding(.top, 6)
73. 
74.                 ZStack {
75.                     if let ui = ImageResolver.uiImage(for: card.imageFilename) {
76.                         Image(uiImage: ui)
77.                             .resizable(resizingMode: .stretch) // may change ratio, but never crops content
78.                             .frame(maxWidth: .infinity, maxHeight: .infinity)
79.                     } else {
80.                         Rectangle()
81.                             .fill(Color.gray.opacity(0.12))
82.                             .overlay(
83.                                 Image(systemName: "photo")
84.                                     .font(.system(size: 36, weight: .semibold))
85.                                     .foregroundStyle(.gray.opacity(0.6))
86.                             )
87.                     }
88.                 }
89.                 .frame(maxWidth: .infinity, maxHeight: .infinity)
90.                 .background(Color.gray.opacity(0.06))
91.                 .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
92.                 .padding(.horizontal, 16)
93.                 .ignoresSafeArea(.container, edges: .bottom)
94.             }
95.             .frame(width: geo.size.width, height: geo.size.height)
96.         }
97.         .background(.white)
98.     }
99. 
100.     private func back(context: String) -> some View {
101.         GeometryReader { geo in
102.             ScrollView {
103.                 VStack(alignment: .leading, spacing: 12) {
104.                         VStack(alignment: .leading, spacing: 6) {
105.                             Text("Definition")
106.                                 .font(.system(.caption, design: .rounded).weight(.bold))
107.                                 .foregroundStyle(.secondary)
108.                             Text(card.definition ?? "(No definition yet)")
109.                                 .font(.system(.title3, design: .rounded).weight(.bold))
110.                                 .foregroundStyle(.primary)
111.                         }
112. 
113.                         if let ex = card.example?.trimmingCharacters(in: .whitespacesAndNewlines), !ex.isEmpty {
114.                             VStack(alignment: .leading, spacing: 6) {
115.                                 Text("Example")
116.                                     .font(.system(.caption, design: .rounded).weight(.bold))
117.                                     .foregroundStyle(.secondary)
118.                                 highlightedSentence(ex, term: card.lemma)
119.                                     .font(.system(.headline, design: .rounded))
120.                                     .foregroundStyle(.primary)
121.                             }
122.                         }
123. 
124.                         if let cols = card.collocations, !cols.isEmpty {
125.                             VStack(alignment: .leading, spacing: 6) {
126.                                 Text("Collocations")
127.                                     .font(.system(.caption, design: .rounded).weight(.bold))
128.                                     .foregroundStyle(.secondary)
129. 
130.                                 VStack(alignment: .leading, spacing: 4) {
131.                                     ForEach(cols.prefix(3), id: \.self) { phrase in
132.                                         Text(phrase)
133.                                             .font(.system(.headline, design: .rounded))
134.                                             .foregroundStyle(.primary)
135.                                     }
136.                                 }
137.                             }
138.                         }
139. 
140.                         VStack(alignment: .leading, spacing: 6) {
141.                             Text("SAT Context")
142.                                 .font(.system(.caption, design: .rounded).weight(.bold))
143.                                 .foregroundStyle(.secondary)
144. 
145.                             if context.isEmpty {
146.                                 Text("(No SAT context yet)")
147.                                     .font(.system(.headline, design: .rounded))
148.                                     .foregroundStyle(.primary)
149.                             } else {
150.                                 highlightedSentence(TextFill.fillBlankPlaceholders(context, with: card.lemma), term: card.lemma)
151.                                     .font(.system(.headline, design: .rounded))
152.                                     .foregroundStyle(.primary)
153.                             }
154.                         }
155.                         Spacer(minLength: 0)
156.                 }
157.                 .padding(12)
158.                 .frame(maxWidth: .infinity, minHeight: max(0, geo.size.height - 140), alignment: .topLeading)
159.                 .background(Color.gray.opacity(0.08))
160.                 .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
161.                 .padding(.horizontal, 16)
162.                 .padding(.top, 8)
163.             }
164.             .safeAreaInset(edge: .bottom) {
165.                 HStack(spacing: 12) {
166.                     Button(action: onForgot) {
167.                         HStack(spacing: 8) {
168.                             Image(systemName: "xmark")
169.                             Text("Review")
170.                         }
171.                         .font(.system(.headline, design: .rounded).weight(.semibold))
172.                         .frame(maxWidth: .infinity)
173.                         .padding(.vertical, 14)
174.                         .background(Color.red)
175.                         .foregroundStyle(.white)
176.                         .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
177.                     }
178. 
179.                     Button(action: onGotIt) {
180.                         HStack(spacing: 8) {
181.                             Image(systemName: "checkmark")
182.                             Text("Master")
183.                         }
184.                         .font(.system(.headline, design: .rounded).weight(.semibold))
185.                         .frame(maxWidth: .infinity)
186.                         .padding(.vertical, 14)
187.                         .background(Color.green)
188.                         .foregroundStyle(.white)
189.                         .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
190.                     }
191.                 }
192.                 .padding(.horizontal, 16)
193.                 .padding(.top, 10)
194.                 .padding(.bottom, 12)
195.                 .background(.white)
196.             }
197.             .frame(width: geo.size.width, height: geo.size.height, alignment: .top)
198.         }
199.         .background(.white)
200.         // keep text readable after 3D rotation
201.         .rotation3DEffect(.degrees(180), axis: (x: 0, y: 1, z: 0))
202.     }
203. 
204.     private func highlightedSentence(_ text: String, term: String) -> Text {
205.         guard !text.isEmpty else { return Text("") }
206.         guard !term.isEmpty else { return Text(text) }
207. 
208.         let nsText = text as NSString
209.         let pattern = "\\b" + NSRegularExpression.escapedPattern(for: term) + "\\b"
210.         let regex = (try? NSRegularExpression(pattern: pattern, options: [.caseInsensitive]))
211.         let matches = regex?.matches(in: text, range: NSRange(location: 0, length: nsText.length)) ?? []
212. 
213.         if matches.isEmpty {
214.             return Text(text)
215.         }
216. 
217.         var out = Text("")
218.         var cursor = 0
219.         for m in matches {
220.             if m.range.location > cursor {
221.                 out = out + Text(nsText.substring(with: NSRange(location: cursor, length: m.range.location - cursor)))
222.             }
223. 
224.             let matched = nsText.substring(with: m.range)
225.             out = out + Text(matched)
226.                 .fontWeight(.bold)
227.                 .foregroundStyle(Color.brown)
228. 
229.             cursor = m.range.location + m.range.length
230.         }
231. 
232.         if cursor < nsText.length {
233.             out = out + Text(nsText.substring(from: cursor))
234.         }
235. 
236.         return out
237.     }
238. }
239. 
240. struct SoundButton: View {
241.     let text: String
242. 
243.     private let synthesizer = AVSpeechSynthesizer()
244. 
245.     var body: some View {
246.         Button {
247.             let utterance = AVSpeechUtterance(string: text)
248.             utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
249.             utterance.rate = AVSpeechUtteranceDefaultSpeechRate
250.             synthesizer.speak(utterance)
251.         } label: {
252.             Image(systemName: "speaker.wave.2.fill")
253.                 .font(.system(size: 18, weight: .semibold))
254.                 .foregroundStyle(.blue)
255.                 .padding(8)
256.                 .background(Color.blue.opacity(0.10))
257.                 .clipShape(Circle())
258.         }
259.         .buttonStyle(.plain)
260.         .accessibilityLabel("Pronounce word")
261.     }
262. }
263.
```

</details>


---

<sub>⏱️ 1m 41s</sub>

### ✅ `view`

**view the file at /Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Views/ClozeRoundView.swift.**

/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Views/ClozeRoundView.swift

<details>
<summary>214 lines</summary>

```
1. import SwiftUI
2. 
3. struct ClozeRoundView: View {
4.     let target: VocabCard
5.     let context: String
6.     let choices: [VocabCard]
7.     let correctWordId: Int
8.     /// - Parameters:
9.     ///   - isCorrect: Whether the chosen answer is correct.
10.     ///   - keepInReview: Whether this word should be flagged for review even if eventually answered correctly.
11.     let onSubmit: (_ isCorrect: Bool, _ keepInReview: Bool) -> Void
12.     let onNext: () -> Void
13. 
14.     @State private var locked = false
15.     @State private var isCorrect: Bool? = nil
16.     @State private var didMiss = false
17.     @State private var showTryAgain = false
18. 
19.     var body: some View {
20.         GeometryReader { geo in
21.             // Keep everything on one screen: shrink image slightly so the 2x2 choices aren't cut off.
22.             let imageHeight = min(max(200, geo.size.height * 0.55), 420)
23.             let bottomSafePadding = max(10, geo.safeAreaInsets.bottom)
24. 
25.             VStack(spacing: 12) {
26.                 ZStack(alignment: .bottomLeading) {
27.                     if let ui = ImageResolver.uiImage(for: target.imageFilename) {
28.                         Image(uiImage: ui)
29.                             .resizable(resizingMode: .stretch) // allow distortion, but never crop
30.                             .frame(maxWidth: .infinity)
31.                             .frame(height: imageHeight)
32.                     } else {
33.                         RoundedRectangle(cornerRadius: 16, style: .continuous)
34.                             .fill(Color.gray.opacity(0.15))
35.                             .frame(height: imageHeight)
36.                             .overlay(
37.                                 Image(systemName: "photo")
38.                                     .font(.system(size: 24, weight: .semibold))
39.                                     .foregroundStyle(.gray.opacity(0.6))
40.                             )
41.                     }
42. 
43.                     Text("Choose the best word")
44.                         .font(.system(.caption, design: .rounded).weight(.bold))
45.                         .foregroundStyle(.white)
46.                         .padding(10)
47.                         .background(Color.black.opacity(0.35))
48.                         .clipShape(Capsule())
49.                         .padding(12)
50.                 }
51.                 .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
52. 
53.                 if isCorrect == true {
54.                     feedbackViewCorrect()
55.                 } else if showTryAgain {
56.                     tryAgainView
57.                 } else {
58.                     Text(clozeSentence)
59.                         .font(.system(size: 24, weight: .semibold, design: .rounded))
60.                         .frame(maxWidth: .infinity, alignment: .leading)
61.                         .padding(14)
62.                         .background(Color.gray.opacity(0.08))
63.                         .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
64. 
65.                     LazyVGrid(
66.                         columns: [GridItem(.flexible(), spacing: 10), GridItem(.flexible(), spacing: 10)],
67.                         spacing: 10
68.                     ) {
69.                         ForEach(choices, id: \.id) { choice in
70.                             Button {
71.                                 guard !locked else { return }
72.                                 let correct = (choice.id == correctWordId)
73.                                 if correct {
74.                                     locked = true
75.                                     isCorrect = true
76.                                     onSubmit(true, didMiss)
77. 
78.                                     DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
79.                                         // Avoid stale auto-advance if the view already moved on.
80.                                         guard isCorrect == true else { return }
81.                                         onNext()
82.                                     }
83.                                 } else {
84.                                     didMiss = true
85.                                     onSubmit(false, true)
86. 
87.                                     locked = true
88.                                     showTryAgain = true
89.                                     DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
90.                                         // Return to the original question until the user gets it right.
91.                                         guard showTryAgain, isCorrect != true else { return }
92.                                         showTryAgain = false
93.                                         locked = false
94.                                     }
95.                                 }
96.                             } label: {
97.                                 HStack {
98.                                     Text(choice.lemma)
99.                                         .font(.system(size: 20, weight: .semibold, design: .rounded))
100.                                         .lineLimit(1)
101.                                     Spacer(minLength: 0)
102.                                 }
103.                                 .frame(maxWidth: .infinity)
104.                                 .padding(.vertical, 14)
105.                                 .padding(.horizontal, 14)
106.                                 .background(Color.white)
107.                                 .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
108.                                 .overlay(
109.                                     RoundedRectangle(cornerRadius: 14, style: .continuous)
110.                                         .strokeBorder(Color.gray.opacity(0.12), lineWidth: 1)
111.                                 )
112.                             }
113.                             .buttonStyle(.plain)
114.                         }
115.                     }
116.                 }
117.             }
118.             .padding(.top, 8)
119.             .padding(.bottom, bottomSafePadding)
120.             .frame(width: geo.size.width, height: geo.size.height, alignment: .top)
121.         }
122.         .onChange(of: target.id) { _, _ in
123.             locked = false
124.             isCorrect = nil
125.             didMiss = false
126.             showTryAgain = false
127.         }
128.     }
129. 
130.     @ViewBuilder
131.     private func feedbackViewCorrect() -> some View {
132.         let sentence = TextFill.fillBlankPlaceholders(context, with: target.lemma)
133.         VStack(alignment: .leading, spacing: 10) {
134.             Text("Right")
135.                 .font(.system(.headline, design: .rounded).weight(.bold))
136.                 .foregroundStyle(Color.green)
137. 
138.             highlightedText(sentence, term: target.lemma, highlightColor: .green)
139.                 .font(.system(.body, design: .rounded))
140.                 .foregroundStyle(.primary)
141. 
142.             if let def = target.definition, !def.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
143.                 Text(def)
144.                     .font(.system(.body, design: .rounded).weight(.semibold))
145.                     .foregroundStyle(.secondary)
146.             }
147.         }
148.         .padding(14)
149.         .background(Color.gray.opacity(0.08))
150.         .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
151.     }
152. 
153.     private var tryAgainView: some View {
154.         VStack(alignment: .leading, spacing: 8) {
155.             Text("Try again")
156.                 .font(.system(.title3, design: .rounded).weight(.bold))
157.                 .foregroundStyle(.secondary)
158.         }
159.         .frame(maxWidth: .infinity, alignment: .leading)
160.         .padding(14)
161.         .background(Color.gray.opacity(0.08))
162.         .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
163.     }
164. 
165.     private func highlightedText(_ text: String, term: String, highlightColor: Color) -> Text {
166.         guard !text.isEmpty else { return Text("") }
167.         guard !term.isEmpty else { return Text(text) }
168. 
169.         let nsText = text as NSString
170.         let pattern = "\\b" + NSRegularExpression.escapedPattern(for: term) + "\\b"
171.         let regex = (try? NSRegularExpression(pattern: pattern, options: [.caseInsensitive]))
172.         let matches = regex?.matches(in: text, range: NSRange(location: 0, length: nsText.length)) ?? []
173. 
174.         guard !matches.isEmpty else { return Text(text) }
175. 
176.         var out = Text("")
177.         var cursor = 0
178.         for m in matches {
179.             if m.range.location > cursor {
180.                 out = out + Text(nsText.substring(with: NSRange(location: cursor, length: m.range.location - cursor)))
181.             }
182.             let matched = nsText.substring(with: m.range)
183.             out = out + Text(matched)
184.                 .fontWeight(.bold)
185.                 .foregroundStyle(highlightColor)
186.             cursor = m.range.location + m.range.length
187.         }
188.         if cursor < nsText.length {
189.             out = out + Text(nsText.substring(from: cursor))
190.         }
191.         return out
192.     }
193. 
194.     private var clozeSentence: String {
195.         let lemma = target.lemma
196.         if lemma.isEmpty { return context }
197. 
198.         // Some SAT contexts already contain "______ blank" placeholders.
199.         // Fill those first so we can reliably turn the target word into "____".
200.         let filledContext = TextFill.fillBlankPlaceholders(context, with: lemma)
201. 
202.         // Whole-word case-insensitive replacement.
203.         let escaped = NSRegularExpression.escapedPattern(for: lemma)
204.         let pattern = "\\b\(escaped)\\b"
205.         guard let regex = try? NSRegularExpression(pattern: pattern, options: [.caseInsensitive]) else {
206.             return filledContext
207.         }
208. 
209.         let range = NSRange(filledContext.startIndex..<filledContext.endIndex, in: filledContext)
210.         let replaced = regex.stringByReplacingMatches(in: filledContext, options: [], range: range, withTemplate: "____")
211.         return replaced == filledContext ? filledContext : replaced
212.     }
213. }
214.
```

</details>


---

<sub>⏱️ 1m 41s</sub>

### ✅ `view`

**view the file at /Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Views/SatMCQRoundView.swift.**

/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Views/SatMCQRoundView.swift

<details>
<summary>319 lines</summary>

```
1. import SwiftUI
2. 
3. struct SatMCQRoundView: View {
4.     let target: VocabCard
5.     let question: SatQuestion
6.     /// - Parameters:
7.     ///   - isCorrect: Whether the chosen answer is correct.
8.     ///   - keepInReview: Whether this word should be flagged for review even if eventually answered correctly.
9.     let onSubmit: (_ isCorrect: Bool, _ keepInReview: Bool) -> Void
10.     let onNext: () -> Void
11. 
12.     @State private var selected: String? = nil
13.     @State private var didMiss = false
14.     @State private var showFeedbackSheet = false
15.     @State private var sheetVerdict: Bool? = nil
16. 
17.     private var keywordTerm: String {
18.         let kw = target.lemma.trimmingCharacters(in: .whitespacesAndNewlines)
19.         if !kw.isEmpty { return kw }
20.         return (question.targetWord ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
21.     }
22. 
23.     var body: some View {
24.         ScrollView {
25.             VStack(alignment: .leading, spacing: 14) {
26.                 if let passage = question.passage, !passage.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
27.                     Text(passage)
28.                         .font(.system(.body, design: .rounded))
29.                         .foregroundStyle(.primary)
30.                         .padding(14)
31.                         .background(Color.gray.opacity(0.08))
32.                         .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
33.                 }
34. 
35.                 Text(question.question ?? "")
36.                     .font(.system(.title3, design: .rounded).weight(.semibold))
37. 
38.                 VStack(spacing: 10) {
39.                     optionRow(letter: "A", text: question.optionA)
40.                     optionRow(letter: "B", text: question.optionB)
41.                     optionRow(letter: "C", text: question.optionC)
42.                     optionRow(letter: "D", text: question.optionD)
43.                 }
44.             }
45.             .padding(.top, 8)
46.         }
47.         .onChange(of: question.id) { _, _ in
48.             selected = nil
49.             didMiss = false
50.             showFeedbackSheet = false
51.             sheetVerdict = nil
52.         }
53.         .sheet(isPresented: $showFeedbackSheet) {
54.             feedbackSheet
55.         }
56.     }
57. 
58.     @ViewBuilder
59.     private func optionRow(letter: String, text: String?) -> some View {
60.         let display = (text ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
61. 
62.         Button {
63.             guard !display.isEmpty else { return }
64.             guard showFeedbackSheet == false else { return }
65.             selected = letter
66.             let correct = isCorrectSelection(letter: letter, optionText: display)
67.             if !correct { didMiss = true }
68. 
69.             // Log incorrect attempts, and keep the word in review if it was ever missed.
70.             if correct {
71.                 onSubmit(true, didMiss)
72.             } else {
73.                 onSubmit(false, true)
74.             }
75. 
76.             sheetVerdict = correct
77.             showFeedbackSheet = true
78.         } label: {
79.             HStack(alignment: .top, spacing: 12) {
80.                 Text(letter)
81.                     .font(.system(.headline, design: .rounded).weight(.bold))
82.                     .frame(width: 28, height: 28)
83.                     .background(Color.gray.opacity(0.12))
84.                     .clipShape(Circle())
85. 
86.                 Text(display)
87.                     .font(.system(.headline, design: .rounded))
88.                     .foregroundStyle(.primary)
89. 
90.                 Spacer(minLength: 0)
91.             }
92.             .padding(.vertical, 14)
93.             .padding(.horizontal, 14)
94.             .background(Color.white)
95.             .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
96.             .overlay(
97.                 RoundedRectangle(cornerRadius: 14, style: .continuous)
98.                     .strokeBorder(Color.gray.opacity(0.12), lineWidth: 1)
99.             )
100.         }
101.         .buttonStyle(.plain)
102.         .disabled(display.isEmpty)
103.         .opacity(display.isEmpty ? 0.35 : 1.0)
104.     }
105. 
106.     private var feedbackSheet: some View {
107.         let verdict = (sheetVerdict == true)
108.         let snippet = sentenceSnippet(passage: question.passage, questionText: question.question, term: keywordTerm)
109. 
110.         return NavigationStack {
111.             ScrollView {
112.                 VStack(alignment: .leading, spacing: 12) {
113.                     Text(verdict ? "Right" : "Wrong")
114.                         .font(.system(.title3, design: .rounded).weight(.bold))
115.                         .foregroundStyle(verdict ? Color.green : Color.red)
116. 
117.                     VStack(alignment: .leading, spacing: 6) {
118.                         Text("Key word")
119.                             .font(.system(.caption, design: .rounded).weight(.bold))
120.                             .foregroundStyle(.secondary)
121.                         Text(keywordTerm)
122.                             .font(.system(.headline, design: .rounded).weight(.semibold))
123.                             .foregroundStyle(Color.brown)
124.                     }
125. 
126.                     highlightedText(snippet, term: keywordTerm)
127.                         .font(.system(.body, design: .rounded))
128.                         .foregroundStyle(.primary)
129. 
130.                     if let def = target.definition, !def.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
131.                         VStack(alignment: .leading, spacing: 6) {
132.                             Text("Meaning")
133.                                 .font(.system(.caption, design: .rounded).weight(.bold))
134.                                 .foregroundStyle(.secondary)
135.                             Text(def)
136.                                 .font(.system(.headline, design: .rounded))
137.                                 .foregroundStyle(.primary)
138.                         }
139.                     }
140. 
141.                     if let bg = question.deepseekBackground?.trimmingCharacters(in: .whitespacesAndNewlines), !bg.isEmpty {
142.                         VStack(alignment: .leading, spacing: 6) {
143.                             Text("Background")
144.                                 .font(.system(.caption, design: .rounded).weight(.bold))
145.                                 .foregroundStyle(.secondary)
146.                             Text(bg)
147.                                 .font(.system(.body, design: .rounded))
148.                                 .foregroundStyle(.primary)
149.                         }
150.                     }
151. 
152.                     if let reason = question.deepseekReason?.trimmingCharacters(in: .whitespacesAndNewlines), !reason.isEmpty {
153.                         VStack(alignment: .leading, spacing: 6) {
154.                             Text("Explanation")
155.                                 .font(.system(.caption, design: .rounded).weight(.bold))
156.                                 .foregroundStyle(.secondary)
157.                             Text(reason)
158.                                 .font(.system(.body, design: .rounded))
159.                                 .foregroundStyle(.primary)
160.                         }
161.                     }
162. 
163.                     if let ans = question.deepseekAnswer?.trimmingCharacters(in: .whitespacesAndNewlines), !ans.isEmpty {
164.                         VStack(alignment: .leading, spacing: 6) {
165.                             Text("Answer")
166.                                 .font(.system(.caption, design: .rounded).weight(.bold))
167.                                 .foregroundStyle(.secondary)
168.                             Text(ans)
169.                                 .font(.system(.body, design: .rounded).weight(.semibold))
170.                                 .foregroundStyle(.primary)
171.                         }
172.                     }
173. 
174.                     if question.deepseekBackground == nil && question.deepseekReason == nil && question.deepseekAnswer == nil {
175.                         Text("(No DeepSeek feedback yet)")
176.                             .font(.system(.body, design: .rounded))
177.                             .foregroundStyle(.secondary)
178.                     }
179.                 }
180.                 .padding(16)
181.             }
182.             .navigationTitle("Feedback")
183.             .navigationBarTitleDisplayMode(.inline)
184.             .safeAreaInset(edge: .bottom) {
185.                 HStack {
186.                     if verdict {
187.                         Button("Next") {
188.                             showFeedbackSheet = false
189.                             selected = nil
190.                             sheetVerdict = nil
191.                             onNext()
192.                         }
193.                         .buttonStyle(.borderedProminent)
194.                     } else {
195.                         Button("Try again") {
196.                             showFeedbackSheet = false
197.                             selected = nil
198.                             sheetVerdict = nil
199.                         }
200.                         .buttonStyle(.borderedProminent)
201.                     }
202.                 }
203.                 .frame(maxWidth: .infinity, alignment: .trailing)
204.                 .padding(.horizontal, 16)
205.                 .padding(.vertical, 12)
206.                 .background(.white)
207.             }
208.         }
209.     }
210. 
211.     private func highlightedText(_ text: String, term: String) -> Text {
212.         guard !text.isEmpty else { return Text("") }
213.         guard !term.isEmpty else { return Text(text) }
214. 
215.         let nsText = text as NSString
216.         let pattern = "\\b" + NSRegularExpression.escapedPattern(for: term) + "\\b"
217.         let regex = (try? NSRegularExpression(pattern: pattern, options: [.caseInsensitive]))
218.         let matches = regex?.matches(in: text, range: NSRange(location: 0, length: nsText.length)) ?? []
219. 
220.         guard !matches.isEmpty else { return Text(text) }
221. 
222.         var out = Text("")
223.         var cursor = 0
224.         for m in matches {
225.             if m.range.location > cursor {
226.                 out = out + Text(nsText.substring(with: NSRange(location: cursor, length: m.range.location - cursor)))
227.             }
228.             let matched = nsText.substring(with: m.range)
229.             out = out + Text(matched)
230.                 .fontWeight(.bold)
231.                 .foregroundStyle(Color.brown)
232.             cursor = m.range.location + m.range.length
233.         }
234.         if cursor < nsText.length {
235.             out = out + Text(nsText.substring(from: cursor))
236.         }
237.         return out
238.     }
239. 
240.     private func sentenceSnippet(passage: String?, questionText: String?, term: String) -> String {
241.         let cleanedPassage = (passage ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
242.         let cleanedQuestion = (questionText ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
243. 
244.         let source = !cleanedPassage.isEmpty ? cleanedPassage : cleanedQuestion
245.         guard !source.isEmpty else { return term }
246.         guard !term.isEmpty else { return source }
247. 
248.         // Try to pick a single sentence containing the term.
249.         let parts = source
250.             .replacingOccurrences(of: "\n", with: " ")
251.             .split(separator: ".")
252.             .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
253.             .filter { !$0.isEmpty }
254. 
255.         if let hit = parts.first(where: { $0.range(of: term, options: [.caseInsensitive, .diacriticInsensitive]) != nil }) {
256.             return hit + "."
257.         }
258. 
259.         return source
260.     }
261. 
262.     private func normalizeAnswerText(_ s: String?) -> String {
263.         let raw = (s ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
264.         if raw.isEmpty { return "" }
265. 
266.         // Drop common leading markers like "A.", "A)", "A:".
267.         if raw.count >= 2 {
268.             let prefix2 = raw.prefix(2)
269.             if prefix2.count == 2 {
270.                 let first = prefix2.prefix(1).uppercased()
271.                 let second = prefix2.suffix(1)
272.                 if ["A", "B", "C", "D"].contains(first), [".", ")", ":"].contains(String(second)) {
273.                     let dropped = raw.dropFirst(2)
274.                     return normalizeAnswerText(String(dropped))
275.                 }
276.             }
277.         }
278. 
279.         // Lowercase + collapse whitespace.
280.         let lowered = raw.lowercased()
281.         let parts = lowered.split(whereSeparator: { $0.isWhitespace })
282.         return parts.joined(separator: " ")
283.     }
284. 
285.     private func correctLetterFromQuestion() -> String? {
286.         let ansRaw = (question.answer ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
287.         let ansNorm = normalizeAnswerText(ansRaw)
288. 
289.         // Case 1: stored as letter.
290.         if ["a", "b", "c", "d"].contains(ansNorm) {
291.             return ansNorm.uppercased()
292.         }
293. 
294.         // Case 2: stored as full correct option text.
295.         let options: [(String, String)] = [
296.             ("A", normalizeAnswerText(question.optionA)),
297.             ("B", normalizeAnswerText(question.optionB)),
298.             ("C", normalizeAnswerText(question.optionC)),
299.             ("D", normalizeAnswerText(question.optionD))
300.         ]
301.         for (letter, optNorm) in options {
302.             if !optNorm.isEmpty, optNorm == ansNorm {
303.                 return letter
304.             }
305.         }
306.         return nil
307.     }
308. 
309.     private func isCorrectSelection(letter: String, optionText: String) -> Bool {
310.         if let correctLetter = correctLetterFromQuestion() {
311.             return correctLetter == letter
312.         }
313.         // Fallback: compare normalized option text against normalized stored answer text.
314.         let ansNorm = normalizeAnswerText(question.answer)
315.         let optNorm = normalizeAnswerText(optionText)
316.         return !ansNorm.isEmpty && ansNorm == optNorm
317.     }
318. }
319.
```

</details>


---

<sub>⏱️ 1m 41s</sub>

### ✅ `view`

**view the file at /Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Views/Game/QuickRecallView.swift.**

/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Views/Game/QuickRecallView.swift

<details>
<summary>99 lines</summary>

```
1. import SwiftUI
2. 
3. struct QuickRecallView: View {
4.     let card: VocabCard
5.     let definitionChoices: [DefinitionChoice]
6.     let onAnswer: (Bool) -> Void
7. 
8.     @State private var selectedIndex: Int? = nil
9.     @State private var isCorrect: Bool? = nil
10.     @State private var showFeedback = false
11. 
12.     struct DefinitionChoice: Identifiable {
13.         let id: Int  // word id
14.         let definition: String
15.         let isCorrect: Bool
16.     }
17. 
18.     var body: some View {
19.         VStack(spacing: 16) {
20.             Spacer()
21. 
22.             // Word display
23.             VStack(spacing: 6) {
24.                 Text("WHAT DOES THIS MEAN?")
25.                     .font(.system(size: 11, weight: .semibold, design: .rounded))
26.                     .foregroundColor(Color(hex: "#AFAFAF"))
27.                     .tracking(0.5)
28. 
29.                 Text(card.lemma.uppercased())
30.                     .font(.system(size: 28, weight: .heavy, design: .rounded))
31.                     .foregroundColor(Color(hex: "#4B4B4B"))
32. 
33.                 Text("from this morning")
34.                     .font(.system(size: 13, weight: .medium))
35.                     .foregroundColor(Color(hex: "#CE82FF"))
36.             }
37. 
38.             Spacer()
39. 
40.             // 4 vertical definition choices
41.             VStack(spacing: 8) {
42.                 ForEach(Array(definitionChoices.enumerated()), id: \.element.id) { index, choice in
43.                     definitionButton(choice: choice, index: index)
44.                 }
45.             }
46.             .padding(.horizontal, 16)
47.             .padding(.bottom, 20)
48.         }
49.         .allowsHitTesting(!showFeedback)
50.     }
51. 
52.     @ViewBuilder
53.     private func definitionButton(choice: DefinitionChoice, index: Int) -> some View {
54.         let isSelected = selectedIndex == index
55.         let bgColor: Color = {
56.             guard showFeedback else { return .white }
57.             if isSelected && isCorrect == true { return Color(hex: "#58CC02").opacity(0.15) }
58.             if isSelected && isCorrect == false { return Color(hex: "#FF4B4B").opacity(0.15) }
59.             if choice.isCorrect && isCorrect == false { return Color(hex: "#58CC02").opacity(0.15) }
60.             return .white
61.         }()
62.         let borderColor: Color = {
63.             guard showFeedback else { return Color(hex: "#E5E5E5") }
64.             if isSelected && isCorrect == true { return Color(hex: "#58CC02") }
65.             if isSelected && isCorrect == false { return Color(hex: "#FF4B4B") }
66.             if choice.isCorrect && isCorrect == false { return Color(hex: "#58CC02") }
67.             return Color(hex: "#E5E5E5")
68.         }()
69. 
70.         Button {
71.             guard !showFeedback else { return }
72.             selectedIndex = index
73.             let correct = choice.isCorrect
74.             isCorrect = correct
75.             showFeedback = true
76. 
77.             let delay: Double = correct ? 1.0 : 2.0
78.             DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
79.                 onAnswer(correct)
80.             }
81.         } label: {
82.             Text(choice.definition)
83.                 .font(.system(size: 16, weight: .medium))
84.                 .foregroundColor(Color(hex: "#4B4B4B"))
85.                 .multilineTextAlignment(.leading)
86.                 .frame(maxWidth: .infinity, alignment: .leading)
87.                 .padding(.horizontal, 12)
88.                 .padding(.vertical, 10)
89.                 .background(bgColor)
90.                 .overlay(
91.                     RoundedRectangle(cornerRadius: 10, style: .continuous)
92.                         .stroke(borderColor, lineWidth: 1.5)
93.                 )
94.                 .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
95.         }
96.         .buttonStyle(.plain)
97.     }
98. }
99.
```

</details>


---

<sub>⏱️ 1m 46s</sub>

### ✅ `view`

**view the file at /Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Views/Game/ImageGameView.swift.**

/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Views/Game/ImageGameView.swift

<details>
<summary>145 lines</summary>

```
1. import SwiftUI
2. 
3. struct ImageGameView: View {
4.     let card: VocabCard
5.     let choices: [VocabCard]  // 4 choices including the correct one
6.     let roundIndex: Int
7.     let totalRounds: Int
8.     let onAnswer: (Bool) -> Void
9. 
10.     @State private var selectedId: Int? = nil
11.     @State private var isCorrect: Bool? = nil
12.     @State private var showFeedback = false
13. 
14.     private var clozeSentence: String {
15.         guard let example = card.example else { return "________" }
16.         let clean = example.replacingOccurrences(of: "**", with: "")
17.         let pattern = "\\b\(NSRegularExpression.escapedPattern(for: card.lemma))\\b"
18.         if let regex = try? NSRegularExpression(pattern: pattern, options: .caseInsensitive) {
19.             let range = NSRange(clean.startIndex..., in: clean)
20.             return regex.stringByReplacingMatches(in: clean, range: range, withTemplate: "________")
21.         }
22.         return clean
23.     }
24. 
25.     var body: some View {
26.         GeometryReader { geo in
27.             VStack(spacing: 0) {
28.                 // Image area — ~60% of available height
29.                 ZStack(alignment: .bottom) {
30.                     if let ui = ImageResolver.uiImage(for: card.imageFilename) {
31.                         Image(uiImage: ui)
32.                             .resizable()
33.                             .scaledToFill()
34.                             .frame(width: geo.size.width - 24, height: geo.size.height * 0.55)
35.                             .clipped()
36.                     } else {
37.                         LinearGradient(
38.                             colors: [Color(hex: "#4A90D9"), Color(hex: "#2C5F8A")],
39.                             startPoint: .topLeading,
40.                             endPoint: .bottomTrailing
41.                         )
42.                     }
43. 
44.                     // Bottom gradient with caption
45.                     LinearGradient(
46.                         gradient: Gradient(colors: [.clear, Color.black.opacity(0.5)]),
47.                         startPoint: .top,
48.                         endPoint: .bottom
49.                     )
50.                     .frame(height: 80)
51. 
52.                     Text("CHOOSE THE BEST WORD")
53.                         .font(.system(size: 12, weight: .bold, design: .rounded))
54.                         .foregroundColor(.white)
55.                         .tracking(0.5)
56.                         .padding(.bottom, 8)
57.                 }
58.                 .frame(height: geo.size.height * 0.55)
59.                 .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
60.                 .padding(.horizontal, 12)
61. 
62.                 // Cloze sentence
63.                 Text(clozeSentence)
64.                     .font(.system(size: 22, weight: .medium))
65.                     .foregroundColor(Color(hex: "#4B4B4B"))
66.                     .multilineTextAlignment(.center)
67.                     .lineLimit(3)
68.                     .minimumScaleFactor(0.8)
69.                     .padding(.horizontal, 16)
70.                     .padding(.vertical, 10)
71.                     .frame(maxWidth: .infinity)
72.                     .background(Color(hex: "#F7F7F7"))
73.                     .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
74.                     .padding(.horizontal, 12)
75.                     .padding(.top, 8)
76. 
77.                 Spacer(minLength: 4)
78. 
79.                 // 2x2 answer grid
80.                 VStack(spacing: 8) {
81.                     ForEach(0..<2, id: \.self) { row in
82.                         HStack(spacing: 8) {
83.                             ForEach(0..<2, id: \.self) { col in
84.                                 let index = row * 2 + col
85.                                 if index < choices.count {
86.                                     answerButton(for: choices[index])
87.                                 }
88.                             }
89.                         }
90.                     }
91.                 }
92.                 .padding(.horizontal, 12)
93.                 .padding(.bottom, 12)
94.             }
95.         }
96.         .allowsHitTesting(!showFeedback)
97.     }
98. 
99.     @ViewBuilder
100.     private func answerButton(for choice: VocabCard) -> some View {
101.         let isSelected = selectedId == choice.id
102.         let isCorrectAnswer = choice.id == card.id
103.         let bgColor: Color = {
104.             guard showFeedback else { return .white }
105.             if isSelected && isCorrect == true { return Color(hex: "#58CC02").opacity(0.2) }
106.             if isSelected && isCorrect == false { return Color(hex: "#FF4B4B").opacity(0.2) }
107.             if isCorrectAnswer && isCorrect == false { return Color(hex: "#58CC02").opacity(0.2) }
108.             return .white
109.         }()
110.         let borderColor: Color = {
111.             guard showFeedback else { return Color(hex: "#E5E5E5") }
112.             if isSelected && isCorrect == true { return Color(hex: "#58CC02") }
113.             if isSelected && isCorrect == false { return Color(hex: "#FF4B4B") }
114.             if isCorrectAnswer && isCorrect == false { return Color(hex: "#58CC02") }
115.             return Color(hex: "#E5E5E5")
116.         }()
117. 
118.         Button {
119.             guard !showFeedback else { return }
120.             selectedId = choice.id
121.             let correct = choice.id == card.id
122.             isCorrect = correct
123.             showFeedback = true
124. 
125.             let delay: Double = correct ? 1.5 : 2.5
126.             DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
127.                 onAnswer(correct)
128.             }
129.         } label: {
130.             Text(choice.lemma)
131.                 .font(.system(size: 22, weight: .bold, design: .rounded))
132.                 .foregroundColor(Color(hex: "#4B4B4B"))
133.                 .frame(maxWidth: .infinity)
134.                 .padding(.vertical, 14)
135.                 .background(bgColor)
136.                 .overlay(
137.                     RoundedRectangle(cornerRadius: 12, style: .continuous)
138.                         .stroke(borderColor, lineWidth: 2)
139.                 )
140.                 .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
141.         }
142.         .buttonStyle(.plain)
143.     }
144. }
145.
```

</details>


---

<sub>⏱️ 1m 46s</sub>

### ✅ `view`

**view the file at /Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Views/Game/SATQuestionView.swift.**

/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Views/Game/SATQuestionView.swift

<details>
<summary>256 lines</summary>

```
1. import SwiftUI
2. 
3. struct SATQuestionView: View {
4.     let question: SatQuestion
5.     let onAnswer: (Bool) -> Void
6. 
7.     @State private var selectedOption: String? = nil
8.     @State private var showFeedback = false
9.     @State private var isCorrect: Bool? = nil
10. 
11.     private let options = ["A", "B", "C", "D"]
12. 
13.     private func optionText(for letter: String) -> String {
14.         switch letter {
15.         case "A": return question.optionA ?? ""
16.         case "B": return question.optionB ?? ""
17.         case "C": return question.optionC ?? ""
18.         case "D": return question.optionD ?? ""
19.         default: return ""
20.         }
21.     }
22. 
23.     private var correctLetter: String {
24.         let answer = (question.deepseekAnswer ?? question.answer ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
25.         if answer.count == 1 && "ABCD".contains(answer.uppercased()) {
26.             return answer.uppercased()
27.         }
28.         if answer.count >= 2 {
29.             let first = String(answer.prefix(1)).uppercased()
30.             if "ABCD".contains(first) {
31.                 return first
32.             }
33.         }
34.         for letter in options {
35.             if optionText(for: letter).lowercased().trimmingCharacters(in: .whitespacesAndNewlines) == answer.lowercased() {
36.                 return letter
37.             }
38.         }
39.         return question.answer?.prefix(1).uppercased() ?? "A"
40.     }
41. 
42.     var body: some View {
43.         GeometryReader { geo in
44.             VStack(spacing: 0) {
45.                 // Passage area — 60% of available height, auto-fit text, no scroll
46.                 VStack(alignment: .leading, spacing: 6) {
47.                     Text("PASSAGE")
48.                         .font(.system(size: 11, weight: .bold, design: .rounded))
49.                         .foregroundColor(Color(hex: "#AFAFAF"))
50.                         .tracking(0.5)
51. 
52.                     if let passage = question.passage, !passage.isEmpty {
53.                         Text(passage)
54.                             .font(.system(size: 18, weight: .regular, design: .serif))
55.                             .foregroundColor(Color(hex: "#4B4B4B"))
56.                             .lineSpacing(2)
57.                             .minimumScaleFactor(0.5)
58.                     }
59.                 }
60.                 .padding(12)
61.                 .frame(maxWidth: .infinity, maxHeight: geo.size.height * 0.6, alignment: .topLeading)
62.                 .background(Color(hex: "#FFF8E1"))
63.                 .overlay(
64.                     RoundedRectangle(cornerRadius: 12, style: .continuous)
65.                         .stroke(Color(hex: "#FFE082"), lineWidth: 2)
66.                 )
67.                 .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
68.                 .padding(.horizontal, 12)
69. 
70.                 // Question text
71.                 if let questionText = question.question {
72.                     Text(questionText)
73.                         .font(.system(size: 18, weight: .semibold))
74.                         .foregroundColor(Color(hex: "#4B4B4B"))
75.                         .minimumScaleFactor(0.7)
76.                         .lineLimit(3)
77.                         .padding(.horizontal, 16)
78.                         .padding(.vertical, 6)
79.                 }
80. 
81.                 // Answer options
82.                 VStack(spacing: 4) {
83.                     ForEach(options, id: \.self) { letter in
84.                         answerRow(letter: letter)
85.                     }
86.                 }
87.                 .padding(.horizontal, 12)
88. 
89.                 Spacer(minLength: 4)
90. 
91.                 // CHECK button
92.                 Button {
93.                     guard let selected = selectedOption, !showFeedback else { return }
94.                     let correct = selected == correctLetter
95.                     isCorrect = correct
96.                     showFeedback = true
97.                 } label: {
98.                     Text("CHECK")
99.                         .font(.system(size: 22, weight: .heavy, design: .rounded))
100.                         .foregroundColor(.white)
101.                         .frame(maxWidth: .infinity)
102.                         .padding(.vertical, 12)
103.                         .background(selectedOption != nil && !showFeedback ? Color(hex: "#58CC02") : Color(hex: "#E5E5E5"))
104.                         .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
105.                 }
106.                 .disabled(selectedOption == nil || showFeedback)
107.                 .padding(.horizontal, 16)
108.                 .padding(.bottom, 10)
109.             }
110.         }
111.         .sheet(isPresented: $showFeedback) {
112.             SATFeedbackSheet(
113.                 isCorrect: isCorrect ?? false,
114.                 targetWord: question.targetWord ?? "",
115.                 correctAnswer: (isCorrect == true) ? optionText(for: correctLetter) : "",
116.                 explanation: (isCorrect == true) ? (question.deepseekReason ?? question.deepseekBackground ?? "") : "Read the passage carefully and try again!",
117.                 onNext: {
118.                     showFeedback = false
119.                     if isCorrect == true {
120.                         onAnswer(true)
121.                     } else {
122.                         selectedOption = nil
123.                         isCorrect = nil
124.                     }
125.                 }
126.             )
127.             .presentationDetents([.fraction(0.5)])
128.         }
129.     }
130. 
131.     @ViewBuilder
132.     private func answerRow(letter: String) -> some View {
133.         let isSelected = selectedOption == letter
134.         let isCorrectOption = showFeedback && (isCorrect == true) && letter == correctLetter
135.         let isWrongSelected = showFeedback && isSelected && letter != correctLetter
136. 
137.         Button {
138.             guard !showFeedback else { return }
139.             selectedOption = letter
140.         } label: {
141.             HStack(spacing: 8) {
142.                 ZStack {
143.                     Circle()
144.                         .stroke(isSelected ? Color(hex: "#1CB0F6") : Color(hex: "#E5E5E5"), lineWidth: 2)
145.                         .fill(isSelected ? Color(hex: "#1CB0F6") : .clear)
146.                         .frame(width: 22, height: 22)
147. 
148.                     Text(letter)
149.                         .font(.system(size: 13, weight: .bold))
150.                         .foregroundColor(isSelected ? .white : Color(hex: "#AFAFAF"))
151.                 }
152. 
153.                 Text(optionText(for: letter))
154.                     .font(.system(size: 17, weight: .medium))
155.                     .foregroundColor(Color(hex: "#4B4B4B"))
156.                     .multilineTextAlignment(.leading)
157.                     .minimumScaleFactor(0.7)
158.                     .lineLimit(2)
159. 
160.                 Spacer()
161.             }
162.             .padding(.horizontal, 10)
163.             .padding(.vertical, 7)
164.             .background(
165.                 isCorrectOption ? Color(hex: "#58CC02").opacity(0.1) :
166.                 isWrongSelected ? Color(hex: "#FF4B4B").opacity(0.1) :
167.                 Color.white
168.             )
169.             .overlay(
170.                 RoundedRectangle(cornerRadius: 8, style: .continuous)
171.                     .stroke(
172.                         isCorrectOption ? Color(hex: "#58CC02") :
173.                         isWrongSelected ? Color(hex: "#FF4B4B") :
174.                         isSelected ? Color(hex: "#1CB0F6") :
175.                         Color(hex: "#E5E5E5"),
176.                         lineWidth: 1.5
177.                     )
178.             )
179.             .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
180.         }
181.         .buttonStyle(.plain)
182.     }
183. }
184. 
185. // MARK: - SAT Feedback Sheet
186. 
187. struct SATFeedbackSheet: View {
188.     let isCorrect: Bool
189.     let targetWord: String
190.     let correctAnswer: String
191.     let explanation: String
192.     let onNext: () -> Void
193. 
194.     var body: some View {
195.         VStack(alignment: .leading, spacing: 12) {
196.             HStack {
197.                 if isCorrect {
198.                     Image(systemName: "checkmark.circle.fill")
199.                         .foregroundColor(Color(hex: "#58CC02"))
200.                     Text("Correct!")
201.                         .font(.system(size: 22, weight: .bold, design: .rounded))
202.                         .foregroundColor(Color(hex: "#58CC02"))
203.                 } else {
204.                     Image(systemName: "xmark.circle.fill")
205.                         .foregroundColor(Color(hex: "#FF4B4B"))
206.                     Text("Not quite.")
207.                         .font(.system(size: 22, weight: .bold, design: .rounded))
208.                         .foregroundColor(Color(hex: "#FF4B4B"))
209.                 }
210.                 Spacer()
211.             }
212. 
213.             if !targetWord.isEmpty {
214.                 VStack(alignment: .leading, spacing: 2) {
215.                     Text("WORD")
216.                         .font(.system(size: 13, weight: .bold))
217.                         .foregroundColor(Color(hex: "#AFAFAF"))
218.                     Text(targetWord)
219.                         .font(.system(size: 23, weight: .semibold))
220.                         .foregroundColor(Color(hex: "#4B4B4B"))
221.                 }
222.             }
223. 
224.             if !correctAnswer.isEmpty {
225.                 VStack(alignment: .leading, spacing: 2) {
226.                     Text("MEANING")
227.                         .font(.system(size: 13, weight: .bold))
228.                         .foregroundColor(Color(hex: "#AFAFAF"))
229.                     Text(correctAnswer)
230.                         .font(.system(size: 23, weight: .medium))
231.                         .foregroundColor(Color(hex: "#4B4B4B"))
232.                 }
233.             }
234. 
235.             if !explanation.isEmpty {
236.                 VStack(alignment: .leading, spacing: 2) {
237.                     Text("WHY")
238.                         .font(.system(size: 13, weight: .bold))
239.                         .foregroundColor(Color(hex: "#AFAFAF"))
240.                     Text(explanation)
241.                         .font(.system(size: 16, weight: .regular))
242.                         .foregroundColor(Color(hex: "#666666"))
243.                         .lineSpacing(2)
244.                 }
245.             }
246. 
247.             Spacer()
248. 
249.             Button3D(isCorrect ? "NEXT \u{2192}" : "TRY AGAIN", action: onNext)
250.                 .padding(.horizontal, 4)
251.         }
252.         .padding(20)
253.         .background(isCorrect ? Color(hex: "#58CC02").opacity(0.05) : Color(hex: "#FF4B4B").opacity(0.05))
254.     }
255. }
256.
```

</details>


---

<sub>⏱️ 1m 46s</sub>

### ✅ `view`

**view the file at /Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Views/ZoneReviewSessionView.swift.**

/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Views/ZoneReviewSessionView.swift

<details>
<summary>72 lines</summary>

```
1. import SwiftUI
2. 
3. struct ZoneReviewSessionView: View {
4.     let zoneIndex: Int
5.     let onCompleted: () -> Void
6. 
7.     @Environment(\.dismiss) private var dismiss
8.     @StateObject private var vm: ZoneReviewSessionViewModel
9. 
10.     init(zoneIndex: Int, onCompleted: @escaping () -> Void) {
11.         self.zoneIndex = zoneIndex
12.         self.onCompleted = onCompleted
13.         _vm = StateObject(wrappedValue: ZoneReviewSessionViewModel(zoneIndex: zoneIndex))
14.     }
15. 
16.     var body: some View {
17.         VStack(spacing: 0) {
18.             if vm.isLoading {
19.                 ProgressView()
20.                     .onAppear { vm.start() }
21.             } else if let err = vm.errorMessage {
22.                 VStack(spacing: 12) {
23.                     Text("Failed to load")
24.                         .font(.title3.weight(.semibold))
25.                     Text(err)
26.                         .font(.footnote)
27.                         .foregroundStyle(.secondary)
28.                         .multilineTextAlignment(.center)
29.                         .padding(.horizontal)
30.                 }
31.             } else if vm.isFinished {
32.                 VStack(spacing: 12) {
33.                     Text("Zone review complete")
34.                         .font(.system(.largeTitle, design: .rounded).weight(.bold))
35.                     Text("Nice work")
36.                         .foregroundStyle(.secondary)
37.                     Button("Done") {
38.                         onCompleted()
39.                         dismiss()
40.                     }
41.                     .buttonStyle(.borderedProminent)
42.                 }
43.             } else if let card = vm.currentCard {
44.                 FlashcardView(
45.                     card: card,
46.                     onForgot: { vm.recordAnswer(outcome: .incorrect) },
47.                     onGotIt: { vm.recordAnswer(outcome: .correct) }
48.                 )
49.                 .id(card.id)
50.                 .frame(maxWidth: .infinity, maxHeight: .infinity)
51.             } else {
52.                 VStack(spacing: 12) {
53.                     Text("No difficult words")
54.                         .font(.system(.title2, design: .rounded).weight(.bold))
55.                     Text("You have no incorrect words in this zone.")
56.                         .font(.system(.body, design: .rounded))
57.                         .foregroundStyle(.secondary)
58.                     Button("Done") {
59.                         onCompleted()
60.                         dismiss()
61.                     }
62.                     .buttonStyle(.borderedProminent)
63.                 }
64.             }
65.         }
66.         .navigationTitle("Zone \(zoneIndex + 1)")
67.         .navigationBarTitleDisplayMode(.inline)
68.         .toolbar(.hidden, for: .tabBar)
69.         .padding(.horizontal, 16)
70.     }
71. }
72.
```

</details>


---

<sub>⏱️ 1m 46s</sub>

### ✅ `view`

**view the file at /Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/ViewModels/ZoneReviewSessionViewModel.swift.**

/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/ViewModels/ZoneReviewSessionViewModel.swift

<details>
<summary>98 lines</summary>

```
1. import Foundation
2. 
3. @MainActor
4. final class ZoneReviewSessionViewModel: ObservableObject {
5.     @Published var isLoading: Bool = true
6.     @Published var errorMessage: String? = nil
7. 
8.     @Published private(set) var queue: [VocabCard] = []
9. 
10.     let zoneIndex: Int
11.     let userId = LocalIdentity.userId()
12. 
13.     private(set) var list: ListInfo? = nil
14.     private var shownAt: Date = Date()
15. 
16.     init(zoneIndex: Int) {
17.         self.zoneIndex = zoneIndex
18.     }
19. 
20.     var currentCard: VocabCard? {
21.         queue.first
22.     }
23. 
24.     var isFinished: Bool {
25.         !isLoading && errorMessage == nil && queue.isEmpty
26.     }
27. 
28.     func start() {
29.         isLoading = true
30.         errorMessage = nil
31.         queue = []
32. 
33.         Task {
34.             do {
35.                 let list = try await DataManager.shared.getDefaultList()
36.                 self.list = list
37.                 try await DataManager.shared.ensureProgressSnapshot(userId: userId, listId: list.id)
38. 
39.                 let wordsPerDay = AppConfig.task1CardCount
40.                 let zoneStartIndex = zoneIndex * AdventureSchedule.daysPerZone * wordsPerDay
41.                 let zoneWords = try await DataManager.shared.fetchSessionQueue(
42.                     listId: list.id,
43.                     limit: AdventureSchedule.daysPerZone * wordsPerDay,
44.                     startIndex: zoneStartIndex
45.                 )
46.                 let zoneWordIds = zoneWords.map { $0.id }
47.                 if zoneWordIds.isEmpty {
48.                     isLoading = false
49.                     return
50.                 }
51. 
52.                 let cards = try await DataManager.shared.fetchReviewQueue(userId: userId, listId: list.id, limit: 200, restrictToWordIds: zoneWordIds)
53.                 var enriched = cards
54.                 for idx in enriched.indices {
55.                     enriched[idx].satContext = try await DataManager.shared.randomSatContext(wordId: enriched[idx].id)
56.                     let collocations = try await DataManager.shared.fetchCollocations(wordId: enriched[idx].id)
57.                     enriched[idx].collocations = collocations.isEmpty ? nil : collocations
58.                 }
59. 
60.                 self.queue = enriched
61.                 self.shownAt = Date()
62.                 self.isLoading = false
63.             } catch {
64.                 self.errorMessage = String(describing: error)
65.                 self.isLoading = false
66.             }
67.         }
68.     }
69. 
70.     func recordAnswer(outcome: ReviewOutcome) {
71.         guard let list else { return }
72.         guard let card = queue.first else { return }
73. 
74.         let durationMs = Int(Date().timeIntervalSince(shownAt) * 1000)
75.         let deviceId = LocalIdentity.deviceId()
76. 
77.         Task {
78.             do {
79.                 try await DataManager.shared.logReview(
80.                     userId: userId,
81.                     wordId: card.id,
82.                     listId: list.id,
83.                     outcome: outcome,
84.                     durationMs: durationMs,
85.                     reviewedAt: Date(),
86.                     deviceId: deviceId
87.                 )
88.             } catch {
89.                 // non-fatal
90.             }
91.         }
92. 
93.         // This zone review is a cleanup pass; do not repeat cards in-session.
94.         queue.removeFirst()
95.         shownAt = Date()
96.     }
97. }
98.
```

</details>


---

<sub>⏱️ 1m 46s</sub>

### ✅ `view`

**view the file at /Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Views/StatsView.swift.**

/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Views/StatsView.swift

<details>
<summary>221 lines</summary>

```
1. import SwiftUI
2. 
3. struct StatsView: View {
4.     @State private var streak: StreakInfo = StreakInfo(
5.         currentStreak: 0, bestStreak: 0, lastStudyDate: nil,
6.         totalXP: 0, totalStudyDays: 0,
7.         streak3Claimed: false, streak7Claimed: false,
8.         streak14Claimed: false, streak30Claimed: false
9.     )
10.     @State private var boxDistribution: [Int: Int] = [:]
11.     @State private var stubbornWords: [(lemma: String, pos: String?, lapseCount: Int, boxLevel: Int)] = []
12.     @State private var wordsLearnedCount: Int = 0
13. 
14.     private let userId = LocalIdentity.userId()
15. 
16.     var body: some View {
17.         ScrollView {
18.             VStack(alignment: .leading, spacing: 16) {
19.                 // Hero tiles
20.                 HStack(spacing: 12) {
21.                     StatsHeroTile(title: "Streak", value: "\(streak.currentStreak)", icon: "flame.fill", color: .orange)
22.                     StatsHeroTile(title: "XP", value: "\(streak.totalXP)", icon: "star.fill", color: .yellow)
23.                     StatsHeroTile(title: "Words", value: "\(wordsLearnedCount)", icon: "textformat.abc", color: Color(hex: "#58CC02"))
24.                 }
25. 
26.                 // Box distribution
27.                 VStack(alignment: .leading, spacing: 12) {
28.                     Text("Word Strength")
29.                         .font(.system(.headline, design: .rounded).weight(.bold))
30. 
31.                     BoxDistributionBar(distribution: boxDistribution)
32.                 }
33.                 .padding(16)
34.                 .background(.white)
35.                 .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
36.                 .overlay(
37.                     RoundedRectangle(cornerRadius: 18, style: .continuous)
38.                         .strokeBorder(Color.black.opacity(0.06), lineWidth: 1)
39.                 )
40. 
41.                 // Words Fighting Back
42.                 if !stubbornWords.isEmpty {
43.                     VStack(alignment: .leading, spacing: 12) {
44.                         Text("Words Fighting Back")
45.                             .font(.system(.headline, design: .rounded).weight(.bold))
46. 
47.                         Text("These words need extra attention")
48.                             .font(.system(.subheadline, design: .rounded))
49.                             .foregroundStyle(.secondary)
50. 
51.                         ForEach(Array(stubbornWords.enumerated()), id: \.offset) { _, word in
52.                             HStack(spacing: 10) {
53.                                 Text(word.lemma)
54.                                     .font(.system(.body, design: .rounded).weight(.semibold))
55. 
56.                                 if let pos = word.pos {
57.                                     Text(pos)
58.                                         .font(.system(.caption, design: .rounded))
59.                                         .foregroundStyle(.secondary)
60.                                         .padding(.horizontal, 6)
61.                                         .padding(.vertical, 2)
62.                                         .background(Color.gray.opacity(0.1))
63.                                         .clipShape(Capsule())
64.                                 }
65. 
66.                                 Spacer()
67. 
68.                                 Text("Box \(word.boxLevel)")
69.                                     .font(.system(.caption, design: .rounded).weight(.semibold))
70.                                     .foregroundStyle(.orange)
71. 
72.                                 Text("\(word.lapseCount)x")
73.                                     .font(.system(.caption, design: .rounded).weight(.bold))
74.                                     .foregroundStyle(.red)
75.                             }
76.                             .padding(.vertical, 4)
77. 
78.                             if word.lemma != stubbornWords.last?.lemma {
79.                                 Divider().opacity(0.3)
80.                             }
81.                         }
82.                     }
83.                     .padding(16)
84.                     .background(.white)
85.                     .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
86.                     .overlay(
87.                         RoundedRectangle(cornerRadius: 18, style: .continuous)
88.                             .strokeBorder(Color.black.opacity(0.06), lineWidth: 1)
89.                     )
90.                 }
91. 
92.                 // Best streak
93.                 HStack {
94.                     Text("Best Streak")
95.                         .font(.system(.subheadline, design: .rounded).weight(.semibold))
96.                         .foregroundStyle(.secondary)
97.                     Spacer()
98.                     Text("\(streak.bestStreak) days")
99.                         .font(.system(.subheadline, design: .rounded).weight(.bold))
100.                 }
101.                 .padding(16)
102.                 .background(.white)
103.                 .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
104.                 .overlay(
105.                     RoundedRectangle(cornerRadius: 18, style: .continuous)
106.                         .strokeBorder(Color.black.opacity(0.06), lineWidth: 1)
107.                 )
108.             }
109.             .padding(16)
110.         }
111.         .navigationTitle("Stats")
112.         .navigationBarTitleDisplayMode(.inline)
113.         .task {
114.             await loadStats()
115.         }
116.     }
117. 
118.     private func loadStats() async {
119.         do {
120.             let dm = DataManager.shared
121.             try await dm.initializeIfNeeded()
122. 
123.             let statsStore = StatsStore.shared
124.             streak = try await statsStore.getStreak(userId: userId)
125. 
126.             let wsStore = WordStateStore(db: dm.db)
127.             boxDistribution = try await wsStore.getBoxDistribution(userId: userId)
128.             stubbornWords = try await wsStore.getStubbornWords(userId: userId, limit: 10)
129.             wordsLearnedCount = try await wsStore.countWordsLearned(userId: userId)
130.         } catch {
131.             // ignore
132.         }
133.     }
134. }
135. 
136. // MARK: - Hero Tile
137. 
138. private struct StatsHeroTile: View {
139.     let title: String
140.     let value: String
141.     let icon: String
142.     let color: Color
143. 
144.     var body: some View {
145.         VStack(spacing: 8) {
146.             Image(systemName: icon)
147.                 .font(.system(size: 22, weight: .semibold))
148.                 .foregroundStyle(color)
149. 
150.             Text(value)
151.                 .font(.system(.title2, design: .rounded).weight(.bold))
152. 
153.             Text(title)
154.                 .font(.system(.caption, design: .rounded).weight(.semibold))
155.                 .foregroundStyle(.secondary)
156.         }
157.         .frame(maxWidth: .infinity)
158.         .padding(.vertical, 16)
159.         .background(.white)
160.         .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
161.         .overlay(
162.             RoundedRectangle(cornerRadius: 16, style: .continuous)
163.                 .strokeBorder(Color.black.opacity(0.06), lineWidth: 1)
164.         )
165.     }
166. }
167. 
168. // MARK: - Box Distribution Bar
169. 
170. private struct BoxDistributionBar: View {
171.     let distribution: [Int: Int]
172. 
173.     private var total: Int {
174.         distribution.values.reduce(0, +)
175.     }
176. 
177.     var body: some View {
178.         if total > 0 {
179.             VStack(spacing: 8) {
180.                 // Stacked bar
181.                 GeometryReader { geo in
182.                     HStack(spacing: 1) {
183.                         ForEach(0...5, id: \.self) { box in
184.                             let count = distribution[box] ?? 0
185.                             let width = geo.size.width * CGFloat(count) / CGFloat(max(1, total))
186.                             if count > 0 {
187.                                 RoundedRectangle(cornerRadius: 3, style: .continuous)
188.                                     .fill(Color(hex: WordStrength(rawValue: box)?.colorHex ?? "#E8ECF0"))
189.                                     .frame(width: max(4, width))
190.                             }
191.                         }
192.                     }
193.                 }
194.                 .frame(height: 20)
195.                 .clipShape(RoundedRectangle(cornerRadius: 6, style: .continuous))
196. 
197.                 // Legend
198.                 HStack(spacing: 8) {
199.                     ForEach(1...5, id: \.self) { box in
200.                         let strength = WordStrength(rawValue: box)
201.                         let count = distribution[box] ?? 0
202.                         HStack(spacing: 4) {
203.                             Circle()
204.                                 .fill(Color(hex: strength?.colorHex ?? "#E8ECF0"))
205.                                 .frame(width: 8, height: 8)
206.                             Text("\(count)")
207.                                 .font(.system(.caption2, design: .rounded).weight(.semibold))
208.                         }
209.                     }
210.                 }
211.             }
212.         } else {
213.             Text("No words studied yet")
214.                 .font(.system(.subheadline, design: .rounded))
215.                 .foregroundStyle(.secondary)
216.                 .frame(maxWidth: .infinity)
217.                 .padding(.vertical, 12)
218.         }
219.     }
220. }
221.
```

</details>


---

<sub>⏱️ 1m 46s</sub>

### ✅ `view`

**view the file at /Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Views/ProfileView.swift.**

/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Views/ProfileView.swift

<details>
<summary>308 lines</summary>

```
1. import SwiftUI
2. 
3. struct ProfileView: View {
4.     @State private var streak: StreakInfo = StreakInfo(
5.         currentStreak: 0, bestStreak: 0, lastStudyDate: nil,
6.         totalXP: 0, totalStudyDays: 0,
7.         streak3Claimed: false, streak7Claimed: false,
8.         streak14Claimed: false, streak30Claimed: false
9.     )
10.     @State private var showShareSheet = false
11.     @State private var shareImage: UIImage? = nil
12.     @State private var morningNotifications = true
13.     @State private var eveningNotifications = true
14.     @State private var displayName: String = LocalIdentity.displayName()
15.     @State private var avatarEmoji: String = LocalIdentity.avatarEmoji()
16.     @State private var isEditingName = false
17.     @State private var showAvatarPicker = false
18. 
19.     private let userId = LocalIdentity.userId()
20. 
21.     private let avatarOptions = [
22.         "🧑‍🎓", "👩‍🎓", "👨‍🎓", "🦊", "🐱", "🐶",
23.         "🐼", "🦁", "🐯", "🐸", "🦉", "🐙",
24.         "🚀", "⭐", "🌟", "💎", "🔥", "🎯",
25.         "🎓", "📚", "🧠", "💡", "🏆", "👑"
26.     ]
27. 
28.     var body: some View {
29.         ScrollView {
30.             VStack(spacing: 18) {
31.                 // User info with editable avatar and name
32.                 VStack(spacing: 10) {
33.                     // Tappable avatar
34.                     Button {
35.                         showAvatarPicker = true
36.                     } label: {
37.                         ZStack {
38.                             Circle()
39.                                 .fill(Color(hex: "#58CC02").opacity(0.15))
40.                                 .frame(width: 80, height: 80)
41.                             Text(avatarEmoji)
42.                                 .font(.system(size: 40))
43.                             // Edit badge
44.                             Image(systemName: "pencil.circle.fill")
45.                                 .font(.system(size: 22))
46.                                 .foregroundStyle(Color(hex: "#58CC02"))
47.                                 .background(Circle().fill(.white).frame(width: 20, height: 20))
48.                                 .offset(x: 28, y: 28)
49.                         }
50.                     }
51.                     .buttonStyle(.plain)
52. 
53.                     // Tappable name
54.                     if isEditingName {
55.                         HStack(spacing: 8) {
56.                             TextField("Your name", text: $displayName)
57.                                 .font(.system(.title2, design: .rounded).weight(.bold))
58.                                 .multilineTextAlignment(.center)
59.                                 .textFieldStyle(.roundedBorder)
60.                                 .frame(maxWidth: 200)
61.                                 .onSubmit { saveName() }
62. 
63.                             Button {
64.                                 saveName()
65.                             } label: {
66.                                 Image(systemName: "checkmark.circle.fill")
67.                                     .font(.system(size: 24))
68.                                     .foregroundStyle(Color(hex: "#58CC02"))
69.                             }
70.                             .buttonStyle(.plain)
71.                         }
72.                     } else {
73.                         Button {
74.                             isEditingName = true
75.                         } label: {
76.                             HStack(spacing: 6) {
77.                                 Text(displayName)
78.                                     .font(.system(.title2, design: .rounded).weight(.bold))
79.                                     .foregroundColor(.primary)
80.                                 Image(systemName: "pencil")
81.                                     .font(.system(size: 14, weight: .semibold))
82.                                     .foregroundStyle(Color(hex: "#AFAFAF"))
83.                             }
84.                         }
85.                         .buttonStyle(.plain)
86.                     }
87. 
88.                     HStack(spacing: 20) {
89.                         VStack(spacing: 2) {
90.                             Text("\(streak.currentStreak)")
91.                                 .font(.system(.title3, design: .rounded).weight(.bold))
92.                             Text("Streak")
93.                                 .font(.system(.caption, design: .rounded))
94.                                 .foregroundStyle(.secondary)
95.                         }
96.                         VStack(spacing: 2) {
97.                             Text("\(streak.totalXP)")
98.                                 .font(.system(.title3, design: .rounded).weight(.bold))
99.                             Text("Total XP")
100.                                 .font(.system(.caption, design: .rounded))
101.                                 .foregroundStyle(.secondary)
102.                         }
103.                         VStack(spacing: 2) {
104.                             Text("\(streak.totalStudyDays)")
105.                                 .font(.system(.title3, design: .rounded).weight(.bold))
106.                             Text("Days")
107.                                 .font(.system(.caption, design: .rounded))
108.                                 .foregroundStyle(.secondary)
109.                         }
110.                     }
111.                 }
112.                 .padding(.vertical, 8)
113. 
114.                 // Share button
115.                 Button {
116.                     generateAndShare()
117.                 } label: {
118.                     HStack(spacing: 10) {
119.                         Image(systemName: "square.and.arrow.up")
120.                             .font(.system(size: 16, weight: .semibold))
121.                         Text("Share Today's Progress")
122.                             .font(.system(.headline, design: .rounded).weight(.semibold))
123.                     }
124.                     .frame(maxWidth: .infinity)
125.                     .padding(.vertical, 14)
126.                     .background(Color(hex: "#58CC02"))
127.                     .foregroundStyle(.white)
128.                     .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
129.                 }
130.                 .buttonStyle(.plain)
131. 
132.                 // Notification toggles
133.                 VStack(spacing: 0) {
134.                     settingsHeader("Notifications")
135. 
136.                     Toggle(isOn: $morningNotifications) {
137.                         HStack(spacing: 10) {
138.                             Image(systemName: "sun.max.fill")
139.                                 .foregroundStyle(.orange)
140.                             Text("Morning reminder")
141.                                 .font(.system(.body, design: .rounded))
142.                         }
143.                     }
144.                     .padding(.horizontal, 16)
145.                     .padding(.vertical, 12)
146. 
147.                     Divider().padding(.horizontal, 16)
148. 
149.                     Toggle(isOn: $eveningNotifications) {
150.                         HStack(spacing: 10) {
151.                             Image(systemName: "moon.fill")
152.                                 .foregroundStyle(.indigo)
153.                             Text("Evening reminder")
154.                                 .font(.system(.body, design: .rounded))
155.                         }
156.                     }
157.                     .padding(.horizontal, 16)
158.                     .padding(.vertical, 12)
159.                 }
160.                 .background(.white)
161.                 .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
162.                 .overlay(
163.                     RoundedRectangle(cornerRadius: 16, style: .continuous)
164.                         .strokeBorder(Color.black.opacity(0.06), lineWidth: 1)
165.                 )
166. 
167.                 // About
168.                 VStack(spacing: 0) {
169.                     settingsHeader("About")
170. 
171.                     settingsRow("App Version", value: "1.0.0")
172.                     Divider().padding(.horizontal, 16)
173.                     settingsRow("User ID", value: String(userId.prefix(8)) + "...")
174.                 }
175.                 .background(.white)
176.                 .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
177.                 .overlay(
178.                     RoundedRectangle(cornerRadius: 16, style: .continuous)
179.                         .strokeBorder(Color.black.opacity(0.06), lineWidth: 1)
180.                 )
181.             }
182.             .padding(.horizontal, 16)
183.         }
184.         .navigationTitle("Profile")
185.         .navigationBarTitleDisplayMode(.inline)
186.         .task {
187.             do {
188.                 let statsStore = StatsStore.shared
189.                 streak = try await statsStore.getStreak(userId: userId)
190.             } catch {
191.                 // ignore
192.             }
193.         }
194.         .sheet(isPresented: $showShareSheet) {
195.             if let image = shareImage {
196.                 ShareSheet(items: [image])
197.             }
198.         }
199.         .sheet(isPresented: $showAvatarPicker) {
200.             AvatarPickerSheet(
201.                 options: avatarOptions,
202.                 selected: avatarEmoji,
203.                 onSelect: { emoji in
204.                     avatarEmoji = emoji
205.                     LocalIdentity.setAvatarEmoji(emoji)
206.                     showAvatarPicker = false
207.                 }
208.             )
209.             .presentationDetents([.fraction(0.4)])
210.         }
211.     }
212. 
213.     private func settingsHeader(_ title: String) -> some View {
214.         Text(title)
215.             .font(.system(.subheadline, design: .rounded).weight(.semibold))
216.             .foregroundStyle(.secondary)
217.             .frame(maxWidth: .infinity, alignment: .leading)
218.             .padding(.horizontal, 16)
219.             .padding(.top, 14)
220.             .padding(.bottom, 6)
221.     }
222. 
223.     private func settingsRow(_ title: String, value: String) -> some View {
224.         HStack {
225.             Text(title)
226.                 .font(.system(.body, design: .rounded))
227.             Spacer()
228.             Text(value)
229.                 .font(.system(.body, design: .rounded))
230.                 .foregroundStyle(.secondary)
231.         }
232.         .padding(.horizontal, 16)
233.         .padding(.vertical, 12)
234.     }
235. 
236.     private func saveName() {
237.         let trimmed = displayName.trimmingCharacters(in: .whitespacesAndNewlines)
238.         displayName = trimmed.isEmpty ? "SAT Learner" : trimmed
239.         LocalIdentity.setDisplayName(displayName)
240.         isEditingName = false
241.     }
242. 
243.     private func generateAndShare() {
244.         let image = ReportCardGenerator.render(streak: streak, userId: userId)
245.         shareImage = image
246.         showShareSheet = true
247.     }
248. }
249. 
250. // MARK: - Avatar Picker
251. 
252. private struct AvatarPickerSheet: View {
253.     let options: [String]
254.     let selected: String
255.     let onSelect: (String) -> Void
256. 
257.     private let columns = Array(repeating: GridItem(.flexible(), spacing: 12), count: 6)
258. 
259.     var body: some View {
260.         VStack(spacing: 16) {
261.             Text("Choose Your Character")
262.                 .font(.system(.headline, design: .rounded).weight(.bold))
263.                 .padding(.top, 16)
264. 
265.             LazyVGrid(columns: columns, spacing: 12) {
266.                 ForEach(options, id: \.self) { emoji in
267.                     Button {
268.                         onSelect(emoji)
269.                     } label: {
270.                         Text(emoji)
271.                             .font(.system(size: 36))
272.                             .frame(width: 52, height: 52)
273.                             .background(
274.                                 emoji == selected
275.                                     ? Color(hex: "#58CC02").opacity(0.2)
276.                                     : Color(hex: "#F5F5F5")
277.                             )
278.                             .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
279.                             .overlay(
280.                                 RoundedRectangle(cornerRadius: 12, style: .continuous)
281.                                     .stroke(
282.                                         emoji == selected ? Color(hex: "#58CC02") : .clear,
283.                                         lineWidth: 2
284.                                     )
285.                             )
286.                     }
287.                     .buttonStyle(.plain)
288.                 }
289.             }
290.             .padding(.horizontal, 16)
291. 
292.             Spacer()
293.         }
294.     }
295. }
296. 
297. // MARK: - ShareSheet wrapper
298. 
299. struct ShareSheet: UIViewControllerRepresentable {
300.     let items: [Any]
301. 
302.     func makeUIViewController(context: Context) -> UIActivityViewController {
303.         UIActivityViewController(activityItems: items, applicationActivities: nil)
304.     }
305. 
306.     func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
307. }
308.
```

</details>


---

<sub>⏱️ 1m 53s</sub>

### ✅ `view`

**view the file at /Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Models/Models.swift.**

/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Models/Models.swift

<details>
<summary>157 lines</summary>

```
1. import Foundation
2. 
3. struct VocabCard: Identifiable, Hashable {
4.     let id: Int
5.     let lemma: String
6.     let pos: String?
7.     let definition: String?
8.     let example: String?
9.     let imageFilename: String?
10. 
11.     var satContext: String? = nil
12.     var collocations: [String]? = nil
13. }
14. 
15. struct ListInfo: Identifiable, Hashable {
16.     let id: Int
17.     let name: String
18.     let description: String?
19.     let version: Int
20. }
21. 
22. enum ReviewOutcome: String {
23.     case correct
24.     case incorrect
25.     case skip
26. }
27. 
28. struct SatQuestion: Identifiable, Hashable {
29.     let id: String
30.     let wordId: Int?
31.     let targetWord: String?
32.     let section: String?
33.     let module: Int?
34.     let qType: String?
35.     let passage: String?
36.     let question: String?
37.     let optionA: String?
38.     let optionB: String?
39.     let optionC: String?
40.     let optionD: String?
41.     let answer: String?
42.     let sourcePdf: String?
43.     let page: Int?
44.     let feedbackGenerated: Int
45.     let answerVerified: Int
46. 
47.     // DeepSeek feedback (optional, may be missing for some questions)
48.     let deepseekAnswer: String?
49.     let deepseekBackground: String?
50.     let deepseekReason: String?
51. }
52. 
53. struct ProgressSnapshot: Hashable {
54.     let userId: String
55.     let listId: Int
56.     let masteredCount: Int
57.     let totalSeen: Int
58.     let streakDays: Int
59.     let lastReviewedAt: Date?
60.     let version: Int
61. }
62. 
63. // MARK: - Learning State Models
64. 
65. struct WordState: Identifiable, Hashable {
66.     let id: Int
67.     let userId: String
68.     let wordId: Int
69.     var boxLevel: Int
70.     var dueAt: Date?
71.     var introStage: Int
72.     var memoryStatus: MemoryStatus
73.     var lapseCount: Int
74.     var consecutiveWrong: Int
75.     var totalCorrect: Int
76.     var totalSeen: Int
77.     var dayTouches: Int
78.     var recentAccuracy: Double
79.     var lastReviewedAt: Date?
80. 
81.     var strength: WordStrength {
82.         WordStrength(rawValue: boxLevel) ?? .notIntroduced
83.     }
84. }
85. 
86. struct DayState: Identifiable, Hashable {
87.     let id: Int
88.     let userId: String
89.     let studyDay: Int
90.     let zoneIndex: Int
91.     var morningComplete: Bool
92.     var eveningComplete: Bool
93.     var morningCompleteAt: Date?
94.     var eveningCompleteAt: Date?
95.     var newWordsMorning: Int
96.     var newWordsEvening: Int
97.     var morningAccuracy: Double
98.     var eveningAccuracy: Double
99.     var morningXP: Int
100.     var eveningXP: Int
101.     var isRecoveryDay: Bool
102.     var isReviewOnlyDay: Bool
103. }
104. 
105. struct SessionState: Identifiable, Hashable {
106.     let id: Int
107.     let userId: String
108.     let sessionType: SessionType
109.     let studyDay: Int
110.     var stepIndex: Int
111.     var itemIndex: Int
112.     var isPaused: Bool
113.     var showAgainIds: [Int]
114.     var requeuedIds: [Int]
115.     var startedAt: Date?
116.     var pausedAt: Date?
117.     var completedAt: Date?
118. }
119. 
120. struct DailyStats: Identifiable, Hashable {
121.     let id: Int
122.     let userId: String
123.     let studyDay: Int
124.     let calendarDate: String
125.     var newCount: Int
126.     var reviewCount: Int
127.     var correctCount: Int
128.     var totalCount: Int
129.     var xpEarned: Int
130.     var sessionBonus: Int
131.     var studyMinutes: Double
132.     var wordsPromoted: Int
133.     var wordsDemoted: Int
134. }
135. 
136. struct StreakInfo: Hashable {
137.     var currentStreak: Int
138.     var bestStreak: Int
139.     var lastStudyDate: String?
140.     var totalXP: Int
141.     var totalStudyDays: Int
142.     var streak3Claimed: Bool
143.     var streak7Claimed: Bool
144.     var streak14Claimed: Bool
145.     var streak30Claimed: Bool
146. }
147. 
148. struct ZoneState: Identifiable, Hashable {
149.     let id: Int
150.     let userId: String
151.     let zoneIndex: Int
152.     var unlocked: Bool
153.     var testPassed: Bool
154.     var testAttempts: Int
155.     var testBestScore: Double
156. }
157.
```

</details>


---

<sub>⏱️ 1m 53s</sub>

### ✅ `view`

**view the file at /Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Models/Enums.swift.**

/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Models/Enums.swift

<details>
<summary>70 lines</summary>

```
1. import Foundation
2. 
3. enum SessionType: String, Codable, Identifiable {
4.     var id: String { rawValue }
5.     case morning
6.     case evening
7.     case recoveryEvening = "recovery_evening"
8.     case catchUp = "catch_up"
9.     case reEntry = "re_entry"
10.     case reviewOnly = "review_only"
11.     case zoneTest = "zone_test"
12.     case bonus
13. }
14. 
15. enum ActivityType: String, Codable {
16.     case imageGame = "image_game"
17.     case quickRecall = "quick_recall"
18.     case satQuestion = "sat_question"
19. }
20. 
21. enum MemoryStatus: String, Codable {
22.     case easy, normal, fragile, stubborn
23. }
24. 
25. enum CardState {
26.     case pending, current, completed, requeued
27. }
28. 
29. enum WordStrength: Int, CaseIterable {
30.     case notIntroduced = 0
31.     case lockedIn = 1
32.     case rising = 2
33.     case strong = 3
34.     case solid = 4
35.     case mastered = 5
36. 
37.     var label: String {
38.         switch self {
39.         case .notIntroduced: return ""
40.         case .lockedIn: return "Locked In"
41.         case .rising: return "Rising"
42.         case .strong: return "Strong"
43.         case .solid: return "Solid"
44.         case .mastered: return "Mastered"
45.         }
46.     }
47. 
48.     var reviewIntervalDays: Int? {
49.         switch self {
50.         case .notIntroduced: return nil
51.         case .lockedIn: return 1
52.         case .rising: return 3
53.         case .strong: return 7
54.         case .solid: return 14
55.         case .mastered: return nil
56.         }
57.     }
58. 
59.     var colorHex: String {
60.         switch self {
61.         case .notIntroduced: return "#E8ECF0"
62.         case .lockedIn: return "#FF7043"
63.         case .rising: return "#FFAB40"
64.         case .strong: return "#FFC800"
65.         case .solid: return "#89E219"
66.         case .mastered: return "#58CC02"
67.         }
68.     }
69. }
70.
```

</details>


---

<sub>⏱️ 1m 53s</sub>

### ✅ `view`

**view the file at /Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Data/AppConfig.swift.**

/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Data/AppConfig.swift

<details>
<summary>53 lines</summary>

```
1. import Foundation
2. 
3. enum AppConfig {
4.     static let defaultListName = "sat_core_1"
5. 
6.     // Testing helpers
7.     // When enabled, all dashboard tasks are unlocked/clickable (including Task 5/6).
8.     static let unlockAllTasksForTesting = true
9. 
10.     // When enabled, all adventure zones/days/tasks are treated as unlocked.
11.     // This is intended for UI testing/polish; gating rules can be added later.
12.     static let unlockAllAdventureForTesting = true
13. 
14.     // Dashboard tasks (v1)
15.     static let task1CardCount = 20
16.     static let task2CardCount = 10
17. 
18.     // Task 3: 20 image-to-word rounds
19.     // Task 4: 20 SAT MCQ rounds
20.     static let task3SetsCount = 20
21.     static let task4McqCount = 20
22.     static let task4McqFetchPerWord = 2
23. 
24.     // Verified-only SAT MCQ questions in v1
25.     static let satQuestionsVerifiedOnly = false  // V1: no verified questions in data, use all
26. 
27.     // Bundle resource names
28.     static let bundledDatabaseName = "data"
29.     static let bundledDatabaseExtension = "db"
30.     static let bundledImagesFolderName = "Images" // add as folder reference in Xcode
31. 
32.     static let xpPerCorrect = 10
33. 
34.     // V2 Learning Model
35.     static let morningNewWords = 11
36.     static let eveningNewWords = 10
37.     static let morningGameRounds = 12
38.     static let eveningGameRounds = 12
39.     static let morningSATQuestions = 3
40.     static let eveningSATQuestions = 2
41.     static let eveningUnlockHours = 4
42.     static let eveningUnlockFallbackHour = 17
43.     static let backPressureReduceAt = 18
44.     static let backPressureStopAt = 30
45.     static let zoneTestPassThreshold = 0.8
46.     static let rushMinGameMs = 1000
47.     static let rushMinSATMs = 3000
48.     static let sessionBonusXP = 30
49.     static let correctAnswerXP = 10
50.     static let bonusPracticeXP = 5
51.     static let lateNightHour = 20
52. }
53.
```

</details>


---

<sub>⏱️ 1m 53s</sub>

### ✅ `view`

**view the file at /Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Data/SessionStateStore.swift.**

/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Data/SessionStateStore.swift

<details>
<summary>349 lines</summary>

```
1. import Foundation
2. import SQLite3
3. 
4. actor SessionStateStore {
5.     static let shared = SessionStateStore()
6. 
7.     private var db: SQLiteDB { DataManager.shared.db }
8. 
9.     private let iso = ISO8601DateFormatter()
10. 
11.     private init() {}
12. 
13.     // MARK: - Day State
14. 
15.     func getCurrentDayState(userId: String) throws -> DayState? {
16.         let db = self.db
17.         let sql = """
18.         SELECT id, user_id, study_day, zone_index, morning_complete, evening_complete,
19.                morning_complete_at, evening_complete_at, new_words_morning, new_words_evening,
20.                morning_accuracy, evening_accuracy, morning_xp, evening_xp,
21.                is_recovery_day, is_review_only_day
22.         FROM day_state
23.         WHERE user_id = ?
24.         ORDER BY study_day DESC
25.         LIMIT 1;
26.         """
27.         let stmt = try db.prepare(sql)
28.         defer { stmt?.finalize() }
29.         try SQLiteDB.bind(stmt, 1, userId)
30.         if sqlite3_step(stmt) == SQLITE_ROW {
31.             return parseDayState(stmt)
32.         }
33.         return nil
34.     }
35. 
36.     func getDayState(userId: String, studyDay: Int) throws -> DayState? {
37.         let db = self.db
38.         let sql = """
39.         SELECT id, user_id, study_day, zone_index, morning_complete, evening_complete,
40.                morning_complete_at, evening_complete_at, new_words_morning, new_words_evening,
41.                morning_accuracy, evening_accuracy, morning_xp, evening_xp,
42.                is_recovery_day, is_review_only_day
43.         FROM day_state
44.         WHERE user_id = ? AND study_day = ?
45.         LIMIT 1;
46.         """
47.         let stmt = try db.prepare(sql)
48.         defer { stmt?.finalize() }
49.         try SQLiteDB.bind(stmt, 1, userId)
50.         try SQLiteDB.bind(stmt, 2, studyDay)
51.         if sqlite3_step(stmt) == SQLITE_ROW {
52.             return parseDayState(stmt)
53.         }
54.         return nil
55.     }
56. 
57.     func getOrCreateDayState(userId: String, studyDay: Int, zoneIndex: Int) throws -> DayState {
58.         let db = self.db
59.         let insertSQL = """
60.         INSERT OR IGNORE INTO day_state(user_id, study_day, zone_index)
61.         VALUES (?, ?, ?);
62.         """
63.         let s1 = try db.prepare(insertSQL)
64.         defer { s1?.finalize() }
65.         try SQLiteDB.bind(s1, 1, userId)
66.         try SQLiteDB.bind(s1, 2, studyDay)
67.         try SQLiteDB.bind(s1, 3, zoneIndex)
68.         if sqlite3_step(s1) != SQLITE_DONE {
69.             throw SQLiteError.stepFailed(message: db.errorMessage())
70.         }
71. 
72.         guard let state = try getDayState(userId: userId, studyDay: studyDay) else {
73.             throw SQLiteError.stepFailed(message: "Failed to fetch day_state after insert")
74.         }
75.         return state
76.     }
77. 
78.     func markMorningComplete(userId: String, studyDay: Int, accuracy: Double, xp: Int, newWords: Int) throws {
79.         let db = self.db
80.         let sql = """
81.         UPDATE day_state
82.         SET morning_complete = 1,
83.             morning_complete_at = ?,
84.             morning_accuracy = ?,
85.             morning_xp = ?,
86.             new_words_morning = ?
87.         WHERE user_id = ? AND study_day = ?;
88.         """
89.         let stmt = try db.prepare(sql)
90.         defer { stmt?.finalize() }
91.         let now = iso.string(from: Date())
92.         try SQLiteDB.bind(stmt, 1, now)
93.         try SQLiteDB.bind(stmt, 2, accuracy)
94.         try SQLiteDB.bind(stmt, 3, xp)
95.         try SQLiteDB.bind(stmt, 4, newWords)
96.         try SQLiteDB.bind(stmt, 5, userId)
97.         try SQLiteDB.bind(stmt, 6, studyDay)
98.         if sqlite3_step(stmt) != SQLITE_DONE {
99.             throw SQLiteError.stepFailed(message: db.errorMessage())
100.         }
101.     }
102. 
103.     func markEveningComplete(userId: String, studyDay: Int, accuracy: Double, xp: Int, newWords: Int) throws {
104.         let db = self.db
105.         let sql = """
106.         UPDATE day_state
107.         SET evening_complete = 1,
108.             evening_complete_at = ?,
109.             evening_accuracy = ?,
110.             evening_xp = ?,
111.             new_words_evening = ?
112.         WHERE user_id = ? AND study_day = ?;
113.         """
114.         let stmt = try db.prepare(sql)
115.         defer { stmt?.finalize() }
116.         let now = iso.string(from: Date())
117.         try SQLiteDB.bind(stmt, 1, now)
118.         try SQLiteDB.bind(stmt, 2, accuracy)
119.         try SQLiteDB.bind(stmt, 3, xp)
120.         try SQLiteDB.bind(stmt, 4, newWords)
121.         try SQLiteDB.bind(stmt, 5, userId)
122.         try SQLiteDB.bind(stmt, 6, studyDay)
123.         if sqlite3_step(stmt) != SQLITE_DONE {
124.             throw SQLiteError.stepFailed(message: db.errorMessage())
125.         }
126.     }
127. 
128.     // MARK: - Session State
129. 
130.     func getActiveSession(userId: String) throws -> SessionState? {
131.         let db = self.db
132.         let sql = """
133.         SELECT id, user_id, session_type, study_day, step_index, item_index,
134.                is_paused, show_again_ids, requeued_ids, started_at, paused_at, completed_at
135.         FROM session_state
136.         WHERE user_id = ? AND is_paused = 1 AND completed_at IS NULL
137.         LIMIT 1;
138.         """
139.         let stmt = try db.prepare(sql)
140.         defer { stmt?.finalize() }
141.         try SQLiteDB.bind(stmt, 1, userId)
142.         if sqlite3_step(stmt) == SQLITE_ROW {
143.             return parseSessionState(stmt)
144.         }
145.         return nil
146.     }
147. 
148.     func createSession(userId: String, sessionType: SessionType, studyDay: Int) throws -> SessionState {
149.         let db = self.db
150.         let sql = """
151.         INSERT OR REPLACE INTO session_state(user_id, session_type, study_day, step_index, item_index,
152.             is_paused, show_again_ids, requeued_ids, started_at, paused_at, completed_at)
153.         VALUES (?, ?, ?, 0, 0, 0, '[]', '[]', ?, NULL, NULL);
154.         """
155.         let stmt = try db.prepare(sql)
156.         defer { stmt?.finalize() }
157.         let now = iso.string(from: Date())
158.         try SQLiteDB.bind(stmt, 1, userId)
159.         try SQLiteDB.bind(stmt, 2, sessionType.rawValue)
160.         try SQLiteDB.bind(stmt, 3, studyDay)
161.         try SQLiteDB.bind(stmt, 4, now)
162.         if sqlite3_step(stmt) != SQLITE_DONE {
163.             throw SQLiteError.stepFailed(message: db.errorMessage())
164.         }
165. 
166.         let rowId = Int(db.lastInsertRowId())
167.         return SessionState(
168.             id: rowId,
169.             userId: userId,
170.             sessionType: sessionType,
171.             studyDay: studyDay,
172.             stepIndex: 0,
173.             itemIndex: 0,
174.             isPaused: false,
175.             showAgainIds: [],
176.             requeuedIds: [],
177.             startedAt: Date(),
178.             pausedAt: nil,
179.             completedAt: nil
180.         )
181.     }
182. 
183.     func pauseSession(userId: String, studyDay: Int, sessionType: SessionType,
184.                        stepIndex: Int, itemIndex: Int,
185.                        showAgainIds: [Int], requeuedIds: [Int]) throws {
186.         let db = self.db
187.         let sql = """
188.         UPDATE session_state
189.         SET is_paused = 1,
190.             paused_at = ?,
191.             step_index = ?,
192.             item_index = ?,
193.             show_again_ids = ?,
194.             requeued_ids = ?
195.         WHERE user_id = ? AND study_day = ? AND session_type = ?;
196.         """
197.         let stmt = try db.prepare(sql)
198.         defer { stmt?.finalize() }
199.         let now = iso.string(from: Date())
200.         let showJSON = try encodeIntArray(showAgainIds)
201.         let reqJSON = try encodeIntArray(requeuedIds)
202.         try SQLiteDB.bind(stmt, 1, now)
203.         try SQLiteDB.bind(stmt, 2, stepIndex)
204.         try SQLiteDB.bind(stmt, 3, itemIndex)
205.         try SQLiteDB.bind(stmt, 4, showJSON)
206.         try SQLiteDB.bind(stmt, 5, reqJSON)
207.         try SQLiteDB.bind(stmt, 6, userId)
208.         try SQLiteDB.bind(stmt, 7, studyDay)
209.         try SQLiteDB.bind(stmt, 8, sessionType.rawValue)
210.         if sqlite3_step(stmt) != SQLITE_DONE {
211.             throw SQLiteError.stepFailed(message: db.errorMessage())
212.         }
213.     }
214. 
215.     func resumeSession(userId: String, studyDay: Int, sessionType: SessionType) throws {
216.         let db = self.db
217.         let sql = """
218.         UPDATE session_state
219.         SET is_paused = 0
220.         WHERE user_id = ? AND study_day = ? AND session_type = ?;
221.         """
222.         let stmt = try db.prepare(sql)
223.         defer { stmt?.finalize() }
224.         try SQLiteDB.bind(stmt, 1, userId)
225.         try SQLiteDB.bind(stmt, 2, studyDay)
226.         try SQLiteDB.bind(stmt, 3, sessionType.rawValue)
227.         if sqlite3_step(stmt) != SQLITE_DONE {
228.             throw SQLiteError.stepFailed(message: db.errorMessage())
229.         }
230.     }
231. 
232.     /// Lightweight progress save — updates step/item position without marking as paused.
233.     /// Used for auto-save on each item advance so a hard kill preserves position.
234.     func saveProgress(userId: String, studyDay: Int, sessionType: SessionType,
235.                       stepIndex: Int, itemIndex: Int, showAgainIds: [Int]) throws {
236.         let db = self.db
237.         let sql = """
238.         UPDATE session_state
239.         SET step_index = ?,
240.             item_index = ?,
241.             show_again_ids = ?,
242.             is_paused = 1
243.         WHERE user_id = ? AND study_day = ? AND session_type = ?;
244.         """
245.         let stmt = try db.prepare(sql)
246.         defer { stmt?.finalize() }
247.         let showJSON = try encodeIntArray(showAgainIds)
248.         try SQLiteDB.bind(stmt, 1, stepIndex)
249.         try SQLiteDB.bind(stmt, 2, itemIndex)
250.         try SQLiteDB.bind(stmt, 3, showJSON)
251.         try SQLiteDB.bind(stmt, 4, userId)
252.         try SQLiteDB.bind(stmt, 5, studyDay)
253.         try SQLiteDB.bind(stmt, 6, sessionType.rawValue)
254.         if sqlite3_step(stmt) != SQLITE_DONE {
255.             throw SQLiteError.stepFailed(message: db.errorMessage())
256.         }
257.     }
258. 
259.     func discardSession(userId: String, studyDay: Int, sessionType: SessionType) throws {
260.         let db = self.db
261.         let sql = """
262.         DELETE FROM session_state
263.         WHERE user_id = ? AND study_day = ? AND session_type = ?;
264.         """
265.         let stmt = try db.prepare(sql)
266.         defer { stmt?.finalize() }
267.         try SQLiteDB.bind(stmt, 1, userId)
268.         try SQLiteDB.bind(stmt, 2, studyDay)
269.         try SQLiteDB.bind(stmt, 3, sessionType.rawValue)
270.         if sqlite3_step(stmt) != SQLITE_DONE {
271.             throw SQLiteError.stepFailed(message: db.errorMessage())
272.         }
273.     }
274. 
275.     func completeSession(userId: String, studyDay: Int, sessionType: SessionType) throws {
276.         let db = self.db
277.         let sql = """
278.         UPDATE session_state
279.         SET completed_at = ?, is_paused = 0
280.         WHERE user_id = ? AND study_day = ? AND session_type = ?;
281.         """
282.         let stmt = try db.prepare(sql)
283.         defer { stmt?.finalize() }
284.         let now = iso.string(from: Date())
285.         try SQLiteDB.bind(stmt, 1, now)
286.         try SQLiteDB.bind(stmt, 2, userId)
287.         try SQLiteDB.bind(stmt, 3, studyDay)
288.         try SQLiteDB.bind(stmt, 4, sessionType.rawValue)
289.         if sqlite3_step(stmt) != SQLITE_DONE {
290.             throw SQLiteError.stepFailed(message: db.errorMessage())
291.         }
292.     }
293. 
294.     // MARK: - Private Helpers
295. 
296.     private func parseDayState(_ stmt: OpaquePointer?) -> DayState {
297.         DayState(
298.             id: SQLiteDB.columnInt(stmt, 0),
299.             userId: SQLiteDB.columnText(stmt, 1) ?? "",
300.             studyDay: SQLiteDB.columnInt(stmt, 2),
301.             zoneIndex: SQLiteDB.columnInt(stmt, 3),
302.             morningComplete: SQLiteDB.columnInt(stmt, 4) != 0,
303.             eveningComplete: SQLiteDB.columnInt(stmt, 5) != 0,
304.             morningCompleteAt: SQLiteDB.columnText(stmt, 6).flatMap { iso.date(from: $0) },
305.             eveningCompleteAt: SQLiteDB.columnText(stmt, 7).flatMap { iso.date(from: $0) },
306.             newWordsMorning: SQLiteDB.columnInt(stmt, 8),
307.             newWordsEvening: SQLiteDB.columnInt(stmt, 9),
308.             morningAccuracy: SQLiteDB.columnDouble(stmt, 10),
309.             eveningAccuracy: SQLiteDB.columnDouble(stmt, 11),
310.             morningXP: SQLiteDB.columnInt(stmt, 12),
311.             eveningXP: SQLiteDB.columnInt(stmt, 13),
312.             isRecoveryDay: SQLiteDB.columnInt(stmt, 14) != 0,
313.             isReviewOnlyDay: SQLiteDB.columnInt(stmt, 15) != 0
314.         )
315.     }
316. 
317.     private func parseSessionState(_ stmt: OpaquePointer?) -> SessionState {
318.         let showAgainJSON = SQLiteDB.columnText(stmt, 7) ?? "[]"
319.         let requeuedJSON = SQLiteDB.columnText(stmt, 8) ?? "[]"
320.         let showAgain = (try? decodeIntArray(showAgainJSON)) ?? []
321.         let requeued = (try? decodeIntArray(requeuedJSON)) ?? []
322. 
323.         return SessionState(
324.             id: SQLiteDB.columnInt(stmt, 0),
325.             userId: SQLiteDB.columnText(stmt, 1) ?? "",
326.             sessionType: SessionType(rawValue: SQLiteDB.columnText(stmt, 2) ?? "morning") ?? .morning,
327.             studyDay: SQLiteDB.columnInt(stmt, 3),
328.             stepIndex: SQLiteDB.columnInt(stmt, 4),
329.             itemIndex: SQLiteDB.columnInt(stmt, 5),
330.             isPaused: SQLiteDB.columnInt(stmt, 6) != 0,
331.             showAgainIds: showAgain,
332.             requeuedIds: requeued,
333.             startedAt: SQLiteDB.columnText(stmt, 9).flatMap { iso.date(from: $0) },
334.             pausedAt: SQLiteDB.columnText(stmt, 10).flatMap { iso.date(from: $0) },
335.             completedAt: SQLiteDB.columnText(stmt, 11).flatMap { iso.date(from: $0) }
336.         )
337.     }
338. 
339.     private func encodeIntArray(_ arr: [Int]) throws -> String {
340.         let data = try JSONEncoder().encode(arr)
341.         return String(data: data, encoding: .utf8) ?? "[]"
342.     }
343. 
344.     private func decodeIntArray(_ json: String) throws -> [Int] {
345.         guard let data = json.data(using: .utf8) else { return [] }
346.         return try JSONDecoder().decode([Int].self, from: data)
347.     }
348. }
349.
```

</details>


---

<sub>⏱️ 1m 53s</sub>

### ✅ `view`

**view the file at /Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Data/AdventureProgressStore.swift.**

/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Data/AdventureProgressStore.swift

<details>
<summary>64 lines</summary>

```
1. import Foundation
2. 
3. final class AdventureProgressStore {
4.     static let shared = AdventureProgressStore()
5. 
6.     private let defaults = UserDefaults.standard
7.     private init() {}
8. 
9.     private func dayKey(dayIndex: Int) -> String {
10.         "adventure.day.\(AdventureSchedule.clampDayIndex(dayIndex))"
11.     }
12. 
13.     private func zoneUnlockedKey(zoneIndex: Int) -> String {
14.         "adventure.zone_unlocked.\(zoneIndex)"
15.     }
16. 
17.     // MARK: - Day Tasks (4 per day)
18. 
19.     func loadDayTasks(dayIndex: Int) -> [Bool] {
20.         let k = dayKey(dayIndex: dayIndex)
21.         if let arr = defaults.array(forKey: k) as? [Bool], arr.count == 4 {
22.             return arr
23.         }
24.         return [false, false, false, false]
25.     }
26. 
27.     func setDayTaskCompleted(dayIndex: Int, taskIndex: Int, completed: Bool) {
28.         precondition((0..<4).contains(taskIndex))
29.         var state = loadDayTasks(dayIndex: dayIndex)
30.         state[taskIndex] = completed
31.         defaults.set(state, forKey: dayKey(dayIndex: dayIndex))
32.     }
33. 
34.     func isDayCompleted(dayIndex: Int) -> Bool {
35.         loadDayTasks(dayIndex: dayIndex).allSatisfy { $0 }
36.     }
37. 
38.     func firstIncompleteDayIndex() -> Int {
39.         for day in 0..<AdventureSchedule.totalDays {
40.             if !isDayCompleted(dayIndex: day) { return day }
41.         }
42.         return AdventureSchedule.totalDays - 1
43.     }
44. 
45.     // MARK: - Zone Unlocks
46. 
47.     func isZoneUnlocked(zoneIndex: Int) -> Bool {
48.         if AppConfig.unlockAllAdventureForTesting { return true }
49.         if zoneIndex <= 0 { return true }
50.         return defaults.bool(forKey: zoneUnlockedKey(zoneIndex: zoneIndex))
51.     }
52. 
53.     func setZoneUnlocked(zoneIndex: Int, unlocked: Bool) {
54.         defaults.set(unlocked, forKey: zoneUnlockedKey(zoneIndex: zoneIndex))
55.     }
56. 
57.     func isZoneCompleted(zoneIndex: Int) -> Bool {
58.         let start = zoneIndex * AdventureSchedule.daysPerZone
59.         let end = min(start + AdventureSchedule.daysPerZone, AdventureSchedule.totalDays)
60.         guard start < end else { return false }
61.         return (start..<end).allSatisfy { isDayCompleted(dayIndex: $0) }
62.     }
63. }
64.
```

</details>


---

<sub>⏱️ 1m 53s</sub>

### ✅ `view`

**view the file at /Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Data/StatsStore.swift.**

/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Data/StatsStore.swift

<details>
<summary>270 lines</summary>

```
1. import Foundation
2. import SQLite3
3. 
4. extension DateFormatter {
5.     static let yyyyMMdd: DateFormatter = {
6.         let f = DateFormatter()
7.         f.calendar = Calendar.current
8.         f.locale = Locale(identifier: "en_US_POSIX")
9.         f.dateFormat = "yyyy-MM-dd"
10.         return f
11.     }()
12. }
13. 
14. actor StatsStore {
15.     static let shared = StatsStore()
16. 
17.     private let _db: SQLiteDB?
18.     private var db: SQLiteDB { _db ?? DataManager.shared.db }
19. 
20.     private init() { _db = nil }
21. 
22.     /// Testable initializer accepting an explicit database
23.     init(db: SQLiteDB) { _db = db }
24. 
25.     // MARK: - Daily Stats
26. 
27.     func getOrCreateDailyStats(userId: String, studyDay: Int) throws -> DailyStats {
28.         let calendarDate = DateFormatter.yyyyMMdd.string(from: Date())
29. 
30.         let insertSQL = """
31.         INSERT OR IGNORE INTO daily_stats(user_id, study_day, calendar_date)
32.         VALUES (?, ?, ?);
33.         """
34.         let s1 = try db.prepare(insertSQL)
35.         defer { s1?.finalize() }
36.         try SQLiteDB.bind(s1, 1, userId)
37.         try SQLiteDB.bind(s1, 2, studyDay)
38.         try SQLiteDB.bind(s1, 3, calendarDate)
39.         if sqlite3_step(s1) != SQLITE_DONE {
40.             throw SQLiteError.stepFailed(message: db.errorMessage())
41.         }
42. 
43.         let selectSQL = """
44.         SELECT id, user_id, study_day, calendar_date, new_count, review_count,
45.                correct_count, total_count, xp_earned, session_bonus,
46.                study_minutes, words_promoted, words_demoted
47.         FROM daily_stats
48.         WHERE user_id = ? AND study_day = ?
49.         LIMIT 1;
50.         """
51.         let s2 = try db.prepare(selectSQL)
52.         defer { s2?.finalize() }
53.         try SQLiteDB.bind(s2, 1, userId)
54.         try SQLiteDB.bind(s2, 2, studyDay)
55.         if sqlite3_step(s2) == SQLITE_ROW {
56.             return parseDailyStats(s2)
57.         }
58.         throw SQLiteError.stepFailed(message: "Failed to fetch daily_stats after insert")
59.     }
60. 
61.     func recordCorrectAnswer(userId: String, studyDay: Int, xpPerCorrect: Int = AppConfig.correctAnswerXP) throws {
62.         let sql = """
63.         UPDATE daily_stats
64.         SET correct_count = correct_count + 1,
65.             total_count = total_count + 1,
66.             xp_earned = xp_earned + ?
67.         WHERE user_id = ? AND study_day = ?;
68.         """
69.         let stmt = try db.prepare(sql)
70.         defer { stmt?.finalize() }
71.         try SQLiteDB.bind(stmt, 1, xpPerCorrect)
72.         try SQLiteDB.bind(stmt, 2, userId)
73.         try SQLiteDB.bind(stmt, 3, studyDay)
74.         if sqlite3_step(stmt) != SQLITE_DONE {
75.             throw SQLiteError.stepFailed(message: db.errorMessage())
76.         }
77.     }
78. 
79.     func recordWrongAnswer(userId: String, studyDay: Int) throws {
80.         let sql = """
81.         UPDATE daily_stats
82.         SET total_count = total_count + 1
83.         WHERE user_id = ? AND study_day = ?;
84.         """
85.         let stmt = try db.prepare(sql)
86.         defer { stmt?.finalize() }
87.         try SQLiteDB.bind(stmt, 1, userId)
88.         try SQLiteDB.bind(stmt, 2, studyDay)
89.         if sqlite3_step(stmt) != SQLITE_DONE {
90.             throw SQLiteError.stepFailed(message: db.errorMessage())
91.         }
92.     }
93. 
94.     func addSessionBonus(userId: String, studyDay: Int, bonus: Int = AppConfig.sessionBonusXP) throws {
95.         let sql = """
96.         UPDATE daily_stats
97.         SET session_bonus = session_bonus + ?
98.         WHERE user_id = ? AND study_day = ?;
99.         """
100.         let stmt = try db.prepare(sql)
101.         defer { stmt?.finalize() }
102.         try SQLiteDB.bind(stmt, 1, bonus)
103.         try SQLiteDB.bind(stmt, 2, userId)
104.         try SQLiteDB.bind(stmt, 3, studyDay)
105.         if sqlite3_step(stmt) != SQLITE_DONE {
106.             throw SQLiteError.stepFailed(message: db.errorMessage())
107.         }
108.     }
109. 
110.     func recordWordPromoted(userId: String, studyDay: Int) throws {
111.         let sql = """
112.         UPDATE daily_stats
113.         SET words_promoted = words_promoted + 1
114.         WHERE user_id = ? AND study_day = ?;
115.         """
116.         let stmt = try db.prepare(sql)
117.         defer { stmt?.finalize() }
118.         try SQLiteDB.bind(stmt, 1, userId)
119.         try SQLiteDB.bind(stmt, 2, studyDay)
120.         if sqlite3_step(stmt) != SQLITE_DONE {
121.             throw SQLiteError.stepFailed(message: db.errorMessage())
122.         }
123.     }
124. 
125.     func recordWordDemoted(userId: String, studyDay: Int) throws {
126.         let sql = """
127.         UPDATE daily_stats
128.         SET words_demoted = words_demoted + 1
129.         WHERE user_id = ? AND study_day = ?;
130.         """
131.         let stmt = try db.prepare(sql)
132.         defer { stmt?.finalize() }
133.         try SQLiteDB.bind(stmt, 1, userId)
134.         try SQLiteDB.bind(stmt, 2, studyDay)
135.         if sqlite3_step(stmt) != SQLITE_DONE {
136.             throw SQLiteError.stepFailed(message: db.errorMessage())
137.         }
138.     }
139. 
140.     // MARK: - Streak
141. 
142.     func getStreak(userId: String) throws -> StreakInfo {
143.         let sql = """
144.         SELECT current_streak, best_streak, last_study_date,
145.                total_xp, total_study_days,
146.                streak_3_claimed, streak_7_claimed, streak_14_claimed, streak_30_claimed
147.         FROM streak_store
148.         WHERE user_id = ?
149.         LIMIT 1;
150.         """
151.         let stmt = try db.prepare(sql)
152.         defer { stmt?.finalize() }
153.         try SQLiteDB.bind(stmt, 1, userId)
154.         if sqlite3_step(stmt) == SQLITE_ROW {
155.             return StreakInfo(
156.                 currentStreak: SQLiteDB.columnInt(stmt, 0),
157.                 bestStreak: SQLiteDB.columnInt(stmt, 1),
158.                 lastStudyDate: SQLiteDB.columnText(stmt, 2),
159.                 totalXP: SQLiteDB.columnInt(stmt, 3),
160.                 totalStudyDays: SQLiteDB.columnInt(stmt, 4),
161.                 streak3Claimed: SQLiteDB.columnInt(stmt, 5) != 0,
162.                 streak7Claimed: SQLiteDB.columnInt(stmt, 6) != 0,
163.                 streak14Claimed: SQLiteDB.columnInt(stmt, 7) != 0,
164.                 streak30Claimed: SQLiteDB.columnInt(stmt, 8) != 0
165.             )
166.         }
167.         // Return default if no row found
168.         return StreakInfo(
169.             currentStreak: 0, bestStreak: 0, lastStudyDate: nil,
170.             totalXP: 0, totalStudyDays: 0,
171.             streak3Claimed: false, streak7Claimed: false,
172.             streak14Claimed: false, streak30Claimed: false
173.         )
174.     }
175. 
176.     func updateStreak(userId: String, xpToday: Int) throws -> (newStreak: Int, milestoneXP: Int) {
177.         let current = try getStreak(userId: userId)
178.         let today = DateFormatter.yyyyMMdd.string(from: Date())
179.         let calendar = Calendar.current
180. 
181.         var newStreak = current.currentStreak
182.         var newBest = current.bestStreak
183.         var newTotalDays = current.totalStudyDays
184. 
185.         if current.lastStudyDate == today {
186.             // Already studied today, just update XP
187.         } else {
188.             // Check if yesterday
189.             let yesterday = calendar.date(byAdding: .day, value: -1, to: Date())!
190.             let yesterdayStr = DateFormatter.yyyyMMdd.string(from: yesterday)
191. 
192.             if current.lastStudyDate == yesterdayStr {
193.                 newStreak += 1
194.             } else {
195.                 newStreak = 1
196.             }
197.             newTotalDays += 1
198.         }
199. 
200.         if newStreak > newBest {
201.             newBest = newStreak
202.         }
203. 
204.         // Calculate milestone bonuses
205.         var milestoneXP = 0
206.         var s3 = current.streak3Claimed
207.         var s7 = current.streak7Claimed
208.         var s14 = current.streak14Claimed
209.         var s30 = current.streak30Claimed
210. 
211.         if newStreak >= 3 && !s3 { milestoneXP += 20; s3 = true }
212.         if newStreak >= 7 && !s7 { milestoneXP += 50; s7 = true }
213.         if newStreak >= 14 && !s14 { milestoneXP += 100; s14 = true }
214.         if newStreak >= 30 && !s30 { milestoneXP += 200; s30 = true }
215. 
216.         let newTotalXP = current.totalXP + xpToday + milestoneXP
217. 
218.         let sql = """
219.         UPDATE streak_store
220.         SET current_streak = ?,
221.             best_streak = ?,
222.             last_study_date = ?,
223.             total_xp = ?,
224.             total_study_days = ?,
225.             streak_3_claimed = ?,
226.             streak_7_claimed = ?,
227.             streak_14_claimed = ?,
228.             streak_30_claimed = ?
229.         WHERE user_id = ?;
230.         """
231.         let stmt = try db.prepare(sql)
232.         defer { stmt?.finalize() }
233.         try SQLiteDB.bind(stmt, 1, newStreak)
234.         try SQLiteDB.bind(stmt, 2, newBest)
235.         try SQLiteDB.bind(stmt, 3, today)
236.         try SQLiteDB.bind(stmt, 4, newTotalXP)
237.         try SQLiteDB.bind(stmt, 5, newTotalDays)
238.         try SQLiteDB.bind(stmt, 6, s3 ? 1 : 0)
239.         try SQLiteDB.bind(stmt, 7, s7 ? 1 : 0)
240.         try SQLiteDB.bind(stmt, 8, s14 ? 1 : 0)
241.         try SQLiteDB.bind(stmt, 9, s30 ? 1 : 0)
242.         try SQLiteDB.bind(stmt, 10, userId)
243.         if sqlite3_step(stmt) != SQLITE_DONE {
244.             throw SQLiteError.stepFailed(message: db.errorMessage())
245.         }
246. 
247.         return (newStreak: newStreak, milestoneXP: milestoneXP)
248.     }
249. 
250.     // MARK: - Private
251. 
252.     private func parseDailyStats(_ stmt: OpaquePointer?) -> DailyStats {
253.         DailyStats(
254.             id: SQLiteDB.columnInt(stmt, 0),
255.             userId: SQLiteDB.columnText(stmt, 1) ?? "",
256.             studyDay: SQLiteDB.columnInt(stmt, 2),
257.             calendarDate: SQLiteDB.columnText(stmt, 3) ?? "",
258.             newCount: SQLiteDB.columnInt(stmt, 4),
259.             reviewCount: SQLiteDB.columnInt(stmt, 5),
260.             correctCount: SQLiteDB.columnInt(stmt, 6),
261.             totalCount: SQLiteDB.columnInt(stmt, 7),
262.             xpEarned: SQLiteDB.columnInt(stmt, 8),
263.             sessionBonus: SQLiteDB.columnInt(stmt, 9),
264.             studyMinutes: SQLiteDB.columnDouble(stmt, 10),
265.             wordsPromoted: SQLiteDB.columnInt(stmt, 11),
266.             wordsDemoted: SQLiteDB.columnInt(stmt, 12)
267.         )
268.     }
269. }
270.
```

</details>


---

<sub>⏱️ 1m 53s</sub>

### ✅ `view`

**view the file at /Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Data/WordStateStore.swift.**

/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Data/WordStateStore.swift

<details>
<summary>473 lines</summary>

```
1. import Foundation
2. import SQLite3
3. 
4. // MARK: - BoxChange
5. 
6. enum BoxChange {
7.     case none
8.     case promoted(from: Int, to: Int)
9.     case demoted(from: Int, to: Int)
10. 
11.     var isMastery: Bool {
12.         switch self {
13.         case .promoted(_, let to): return to >= 5
14.         default: return false
15.         }
16.     }
17. }
18. 
19. // MARK: - WordStateStore
20. 
21. actor WordStateStore {
22.     private let db: SQLiteDB
23.     private let iso = ISO8601DateFormatter()
24. 
25.     init(db: SQLiteDB) {
26.         self.db = db
27.     }
28. 
29.     // MARK: - Read Methods
30. 
31.     func getWordState(userId: String, wordId: Int) throws -> WordState? {
32.         let sql = """
33.         SELECT id, user_id, word_id, box_level, due_at, intro_stage,
34.                memory_status, lapse_count, consecutive_wrong, total_correct,
35.                total_seen, day_touches, recent_accuracy, last_reviewed_at
36.         FROM word_state
37.         WHERE user_id = ? AND word_id = ?
38.         LIMIT 1;
39.         """
40.         let stmt = try db.prepare(sql)
41.         defer { stmt?.finalize() }
42.         try SQLiteDB.bind(stmt, 1, userId)
43.         try SQLiteDB.bind(stmt, 2, wordId)
44.         if sqlite3_step(stmt) == SQLITE_ROW {
45.             return parseWordState(stmt)
46.         }
47.         return nil
48.     }
49. 
50.     func getReviewQueue(userId: String, limit: Int) throws -> [WordState] {
51.         let nowStr = iso.string(from: Date())
52.         let sql = """
53.         SELECT id, user_id, word_id, box_level, due_at, intro_stage,
54.                memory_status, lapse_count, consecutive_wrong, total_correct,
55.                total_seen, day_touches, recent_accuracy, last_reviewed_at
56.         FROM word_state
57.         WHERE user_id = ? AND due_at <= ? AND box_level > 0
58.         ORDER BY box_level ASC,
59.                  CASE memory_status
60.                      WHEN 'stubborn' THEN 0
61.                      WHEN 'fragile' THEN 1
62.                      WHEN 'normal' THEN 2
63.                      WHEN 'easy' THEN 3
64.                      ELSE 4
65.                  END,
66.                  due_at ASC
67.         LIMIT ?;
68.         """
69.         let stmt = try db.prepare(sql)
70.         defer { stmt?.finalize() }
71.         try SQLiteDB.bind(stmt, 1, userId)
72.         try SQLiteDB.bind(stmt, 2, nowStr)
73.         try SQLiteDB.bind(stmt, 3, limit)
74. 
75.         var out: [WordState] = []
76.         while sqlite3_step(stmt) == SQLITE_ROW {
77.             out.append(parseWordState(stmt))
78.         }
79.         return out
80.     }
81. 
82.     func countOverdue(userId: String) throws -> Int {
83.         let nowStr = iso.string(from: Date())
84.         let sql = """
85.         SELECT COUNT(*) FROM word_state
86.         WHERE user_id = ? AND due_at <= ? AND box_level > 0;
87.         """
88.         let stmt = try db.prepare(sql)
89.         defer { stmt?.finalize() }
90.         try SQLiteDB.bind(stmt, 1, userId)
91.         try SQLiteDB.bind(stmt, 2, nowStr)
92.         if sqlite3_step(stmt) == SQLITE_ROW {
93.             return SQLiteDB.columnInt(stmt, 0)
94.         }
95.         return 0
96.     }
97. 
98.     func countWordsLearned(userId: String) throws -> Int {
99.         let sql = """
100.         SELECT COUNT(DISTINCT word_id) FROM word_state
101.         WHERE user_id = ? AND intro_stage > 0;
102.         """
103.         let stmt = try db.prepare(sql)
104.         defer { stmt?.finalize() }
105.         try SQLiteDB.bind(stmt, 1, userId)
106.         if sqlite3_step(stmt) == SQLITE_ROW {
107.             return SQLiteDB.columnInt(stmt, 0)
108.         }
109.         return 0
110.     }
111. 
112.     func getBoxDistribution(userId: String) throws -> [Int: Int] {
113.         let sql = """
114.         SELECT box_level, COUNT(*) FROM word_state
115.         WHERE user_id = ?
116.         GROUP BY box_level;
117.         """
118.         let stmt = try db.prepare(sql)
119.         defer { stmt?.finalize() }
120.         try SQLiteDB.bind(stmt, 1, userId)
121. 
122.         var dist: [Int: Int] = [:]
123.         while sqlite3_step(stmt) == SQLITE_ROW {
124.             let box = SQLiteDB.columnInt(stmt, 0)
125.             let count = SQLiteDB.columnInt(stmt, 1)
126.             dist[box] = count
127.         }
128.         return dist
129.     }
130. 
131.     func getStubbornWords(userId: String, limit: Int) throws -> [(lemma: String, pos: String?, lapseCount: Int, boxLevel: Int)] {
132.         let sql = """
133.         SELECT w.lemma, w.pos, ws.lapse_count, ws.box_level
134.         FROM word_state ws
135.         JOIN words w ON w.id = ws.word_id
136.         WHERE ws.user_id = ? AND ws.memory_status = 'stubborn'
137.         ORDER BY ws.lapse_count DESC, ws.consecutive_wrong DESC
138.         LIMIT ?;
139.         """
140.         let stmt = try db.prepare(sql)
141.         defer { stmt?.finalize() }
142.         try SQLiteDB.bind(stmt, 1, userId)
143.         try SQLiteDB.bind(stmt, 2, limit)
144. 
145.         var out: [(lemma: String, pos: String?, lapseCount: Int, boxLevel: Int)] = []
146.         while sqlite3_step(stmt) == SQLITE_ROW {
147.             let lemma = SQLiteDB.columnText(stmt, 0) ?? ""
148.             let pos = SQLiteDB.columnText(stmt, 1)
149.             let lapse = SQLiteDB.columnInt(stmt, 2)
150.             let box = SQLiteDB.columnInt(stmt, 3)
151.             out.append((lemma: lemma, pos: pos, lapseCount: lapse, boxLevel: box))
152.         }
153.         return out
154.     }
155. 
156.     // MARK: - Write Methods
157. 
158.     func introduceWord(userId: String, wordId: Int) throws {
159.         print("📝 introduceWord called: wordId=\(wordId)")
160.         let nowStr = iso.string(from: Date())
161.         let sql = """
162.         INSERT INTO word_state(user_id, word_id, box_level, intro_stage, total_seen, memory_status, created_at, updated_at)
163.         VALUES (?, ?, 0, 1, 1, 'normal', ?, ?)
164.         ON CONFLICT(user_id, word_id) DO UPDATE SET
165.             intro_stage = MAX(intro_stage, 1),
166.             total_seen = total_seen + 1,
167.             updated_at = excluded.updated_at;
168.         """
169.         let stmt = try db.prepare(sql)
170.         defer { stmt?.finalize() }
171.         try SQLiteDB.bind(stmt, 1, userId)
172.         try SQLiteDB.bind(stmt, 2, wordId)
173.         try SQLiteDB.bind(stmt, 3, nowStr)
174.         try SQLiteDB.bind(stmt, 4, nowStr)
175.         if sqlite3_step(stmt) != SQLITE_DONE {
176.             throw SQLiteError.stepFailed(message: db.errorMessage())
177.         }
178.     }
179. 
180.     func recordScoredAnswer(userId: String, wordId: Int, correct: Bool) throws -> BoxChange {
181.         print("📝 recordScoredAnswer called: wordId=\(wordId) correct=\(correct)")
182.         // Fetch current state
183.         guard var ws = try getWordState(userId: userId, wordId: wordId) else {
184.             // Word not yet introduced; introduce it first
185.             try introduceWord(userId: userId, wordId: wordId)
186.             return .none
187.         }
188. 
189.         let oldBox = ws.boxLevel
190. 
191.         // Update box level
192.         // Box 0 words are NOT promoted here — they wait for Day 1 promotion (runDay1Promotion)
193.         if correct {
194.             if ws.boxLevel > 0 {
195.                 ws.boxLevel = min(ws.boxLevel + 1, 5)
196.             }
197.             // Box 0 stays at 0 — only Day 1 promotion moves 0→1 or 0→2
198.             ws.consecutiveWrong = 0
199.             ws.totalCorrect += 1
200.         } else {
201.             if ws.boxLevel > 1 {
202.                 ws.boxLevel = 1
203.                 ws.lapseCount += 1
204.             }
205.             // Box 0 and Box 1 stay where they are on wrong answer
206.             ws.consecutiveWrong += 1
207.         }
208. 
209.         ws.totalSeen += 1
210.         ws.dayTouches += 1
211. 
212.         // Recalculate recent accuracy
213.         ws.recentAccuracy = try computeRecentAccuracy(userId: userId, wordId: wordId, includingCurrent: correct)
214. 
215.         // Classify memory status
216.         ws.memoryStatus = classifyMemoryStatus(ws)
217. 
218.         // Calculate due date based on new box level
219.         let now = Date()
220.         let nowStr = iso.string(from: now)
221.         let dueDate: Date?
222.         if let interval = WordStrength(rawValue: ws.boxLevel)?.reviewIntervalDays {
223.             dueDate = Calendar.current.date(byAdding: .day, value: interval, to: now)
224.         } else {
225.             dueDate = nil // box 0 or mastered (5)
226.         }
227.         let dueStr: String? = dueDate.map { iso.string(from: $0) }
228. 
229.         let sql = """
230.         UPDATE word_state SET
231.             box_level = ?,
232.             due_at = ?,
233.             memory_status = ?,
234.             lapse_count = ?,
235.             consecutive_wrong = ?,
236.             total_correct = ?,
237.             total_seen = ?,
238.             day_touches = ?,
239.             recent_accuracy = ?,
240.             last_reviewed_at = ?,
241.             updated_at = ?
242.         WHERE user_id = ? AND word_id = ?;
243.         """
244.         let stmt = try db.prepare(sql)
245.         defer { stmt?.finalize() }
246.         try SQLiteDB.bind(stmt, 1, ws.boxLevel)
247.         try SQLiteDB.bind(stmt, 2, dueStr)
248.         try SQLiteDB.bind(stmt, 3, ws.memoryStatus.rawValue)
249.         try SQLiteDB.bind(stmt, 4, ws.lapseCount)
250.         try SQLiteDB.bind(stmt, 5, ws.consecutiveWrong)
251.         try SQLiteDB.bind(stmt, 6, ws.totalCorrect)
252.         try SQLiteDB.bind(stmt, 7, ws.totalSeen)
253.         try SQLiteDB.bind(stmt, 8, ws.dayTouches)
254.         try SQLiteDB.bind(stmt, 9, ws.recentAccuracy)
255.         try SQLiteDB.bind(stmt, 10, nowStr)
256.         try SQLiteDB.bind(stmt, 11, nowStr)
257.         try SQLiteDB.bind(stmt, 12, userId)
258.         try SQLiteDB.bind(stmt, 13, wordId)
259.         if sqlite3_step(stmt) != SQLITE_DONE {
260.             throw SQLiteError.stepFailed(message: db.errorMessage())
261.         }
262. 
263.         // Determine box change
264.         if ws.boxLevel > oldBox {
265.             return .promoted(from: oldBox, to: ws.boxLevel)
266.         } else if ws.boxLevel < oldBox {
267.             return .demoted(from: oldBox, to: ws.boxLevel)
268.         }
269.         return .none
270.     }
271. 
272.     func runDay1Promotion(userId: String, studyDay: Int) throws -> (promoted: Int, notPromoted: Int) {
273.         // Find words with intro_stage IN (1,2) AND box_level = 0
274.         let findSQL = """
275.         SELECT word_id FROM word_state
276.         WHERE user_id = ? AND intro_stage IN (1, 2) AND box_level = 0;
277.         """
278.         let findStmt = try db.prepare(findSQL)
279.         defer { findStmt?.finalize() }
280.         try SQLiteDB.bind(findStmt, 1, userId)
281. 
282.         var wordIds: [Int] = []
283.         while sqlite3_step(findStmt) == SQLITE_ROW {
284.             wordIds.append(SQLiteDB.columnInt(findStmt, 0))
285.         }
286. 
287.         var promoted = 0
288.         var notPromoted = 0
289.         let now = Date()
290.         let nowStr = iso.string(from: now)
291. 
292.         for wordId in wordIds {
293.             // Count scored correct answers from review_log
294.             let countSQL = """
295.             SELECT
296.                 SUM(CASE WHEN outcome = 'correct' THEN 1 ELSE 0 END) AS correct_count,
297.                 COUNT(*) AS total_count
298.             FROM review_log
299.             WHERE user_id = ? AND word_id = ? AND study_day = ?
300.               AND activity_type IN ('image_game', 'quick_recall')
301.               AND superseded = 0;
302.             """
303.             let countStmt = try db.prepare(countSQL)
304.             defer { countStmt?.finalize() }
305.             try SQLiteDB.bind(countStmt, 1, userId)
306.             try SQLiteDB.bind(countStmt, 2, wordId)
307.             try SQLiteDB.bind(countStmt, 3, studyDay)
308. 
309.             var correctCount = 0
310.             var totalCount = 0
311.             if sqlite3_step(countStmt) == SQLITE_ROW {
312.                 correctCount = SQLiteDB.columnInt(countStmt, 0)
313.                 totalCount = SQLiteDB.columnInt(countStmt, 1)
314.             }
315. 
316.             // Check if last recall was correct (same study day)
317.             let lastSQL = """
318.             SELECT outcome FROM review_log
319.             WHERE user_id = ? AND word_id = ? AND study_day = ?
320.               AND activity_type IN ('image_game', 'quick_recall')
321.               AND superseded = 0
322.             ORDER BY reviewed_at DESC, id DESC
323.             LIMIT 1;
324.             """
325.             let lastStmt = try db.prepare(lastSQL)
326.             defer { lastStmt?.finalize() }
327.             try SQLiteDB.bind(lastStmt, 1, userId)
328.             try SQLiteDB.bind(lastStmt, 2, wordId)
329.             try SQLiteDB.bind(lastStmt, 3, studyDay)
330. 
331.             var lastCorrect = false
332.             if sqlite3_step(lastStmt) == SQLITE_ROW {
333.                 let outcome = SQLiteDB.columnText(lastStmt, 0)
334.                 lastCorrect = (outcome == "correct")
335.             }
336. 
337.             // Rule: 2/3 correct AND last recall correct -> box 2, else -> box 1
338.             let meetsThreshold = totalCount >= 3 && correctCount >= 2 && lastCorrect
339.             let newBox: Int
340.             let dueDays: Int
341.             if meetsThreshold {
342.                 newBox = 2
343.                 dueDays = 3
344.                 promoted += 1
345.             } else {
346.                 newBox = 1
347.                 dueDays = 1
348.                 notPromoted += 1
349.             }
350. 
351.             let dueDate = Calendar.current.date(byAdding: .day, value: dueDays, to: now)!
352.             let dueStr = iso.string(from: dueDate)
353. 
354.             let updateSQL = """
355.             UPDATE word_state SET
356.                 box_level = ?,
357.                 due_at = ?,
358.                 intro_stage = 3,
359.                 updated_at = ?
360.             WHERE user_id = ? AND word_id = ?;
361.             """
362.             let updateStmt = try db.prepare(updateSQL)
363.             defer { updateStmt?.finalize() }
364.             try SQLiteDB.bind(updateStmt, 1, newBox)
365.             try SQLiteDB.bind(updateStmt, 2, dueStr)
366.             try SQLiteDB.bind(updateStmt, 3, nowStr)
367.             try SQLiteDB.bind(updateStmt, 4, userId)
368.             try SQLiteDB.bind(updateStmt, 5, wordId)
369.             if sqlite3_step(updateStmt) != SQLITE_DONE {
370.                 throw SQLiteError.stepFailed(message: db.errorMessage())
371.             }
372.         }
373. 
374.         return (promoted: promoted, notPromoted: notPromoted)
375.     }
376. 
377.     func resetDayTouches(userId: String) throws {
378.         let sql = "UPDATE word_state SET day_touches = 0 WHERE user_id = ?;"
379.         let stmt = try db.prepare(sql)
380.         defer { stmt?.finalize() }
381.         try SQLiteDB.bind(stmt, 1, userId)
382.         if sqlite3_step(stmt) != SQLITE_DONE {
383.             throw SQLiteError.stepFailed(message: db.errorMessage())
384.         }
385.     }
386. 
387.     // MARK: - Private Helpers
388. 
389.     private func computeRecentAccuracy(userId: String, wordId: Int, includingCurrent correct: Bool? = nil) throws -> Double {
390.         let sql = """
391.         SELECT outcome FROM review_log
392.         WHERE user_id = ? AND word_id = ?
393.           AND outcome IN ('correct', 'incorrect')
394.           AND superseded = 0
395.         ORDER BY reviewed_at DESC
396.         LIMIT 5;
397.         """
398.         let stmt = try db.prepare(sql)
399.         defer { stmt?.finalize() }
400.         try SQLiteDB.bind(stmt, 1, userId)
401.         try SQLiteDB.bind(stmt, 2, wordId)
402. 
403.         var outcomes: [Bool] = []
404.         while sqlite3_step(stmt) == SQLITE_ROW {
405.             let outcome = SQLiteDB.columnText(stmt, 0) ?? ""
406.             outcomes.append(outcome == "correct")
407.         }
408. 
409.         // If we have a current answer that hasn't been logged yet, prepend it
410.         if let current = correct {
411.             outcomes.insert(current, at: 0)
412.             if outcomes.count > 5 {
413.                 outcomes = Array(outcomes.prefix(5))
414.             }
415.         }
416. 
417.         guard !outcomes.isEmpty else { return 0.0 }
418.         let correctCount = outcomes.filter { $0 }.count
419.         return Double(correctCount) / Double(outcomes.count)
420.     }
421. 
422.     private func classifyMemoryStatus(_ ws: WordState) -> MemoryStatus {
423.         if ws.lapseCount >= 3 || ws.consecutiveWrong >= 2 {
424.             return .stubborn
425.         }
426.         if ws.recentAccuracy < 0.6 || ws.lapseCount >= 1 {
427.             return .fragile
428.         }
429.         if ws.boxLevel >= 3 && ws.recentAccuracy >= 0.85 && ws.lapseCount == 0 {
430.             return .easy
431.         }
432.         return .normal
433.     }
434. 
435.     private func parseWordState(_ stmt: OpaquePointer?) -> WordState {
436.         let id = SQLiteDB.columnInt(stmt, 0)
437.         let userId = SQLiteDB.columnText(stmt, 1) ?? ""
438.         let wordId = SQLiteDB.columnInt(stmt, 2)
439.         let boxLevel = SQLiteDB.columnInt(stmt, 3)
440.         let dueAtStr = SQLiteDB.columnText(stmt, 4)
441.         let introStage = SQLiteDB.columnInt(stmt, 5)
442.         let memStatusStr = SQLiteDB.columnText(stmt, 6) ?? "normal"
443.         let lapseCount = SQLiteDB.columnInt(stmt, 7)
444.         let consecutiveWrong = SQLiteDB.columnInt(stmt, 8)
445.         let totalCorrect = SQLiteDB.columnInt(stmt, 9)
446.         let totalSeen = SQLiteDB.columnInt(stmt, 10)
447.         let dayTouches = SQLiteDB.columnInt(stmt, 11)
448.         let recentAccuracy = SQLiteDB.columnDouble(stmt, 12)
449.         let lastReviewedStr = SQLiteDB.columnText(stmt, 13)
450. 
451.         let dueAt = dueAtStr.flatMap { iso.date(from: $0) }
452.         let lastReviewedAt = lastReviewedStr.flatMap { iso.date(from: $0) }
453.         let memoryStatus = MemoryStatus(rawValue: memStatusStr) ?? .normal
454. 
455.         return WordState(
456.             id: id,
457.             userId: userId,
458.             wordId: wordId,
459.             boxLevel: boxLevel,
460.             dueAt: dueAt,
461.             introStage: introStage,
462.             memoryStatus: memoryStatus,
463.             lapseCount: lapseCount,
464.             consecutiveWrong: consecutiveWrong,
465.             totalCorrect: totalCorrect,
466.             totalSeen: totalSeen,
467.             dayTouches: dayTouches,
468.             recentAccuracy: recentAccuracy,
469.             lastReviewedAt: lastReviewedAt
470.         )
471.     }
472. }
473.
```

</details>


---

<sub>⏱️ 1m 53s</sub>

### ✅ `view`

**view the file at /Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Data/ReviewLogger.swift.**

/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Data/ReviewLogger.swift

<details>
<summary>62 lines</summary>

```
1. import Foundation
2. import SQLite3
3. 
4. actor ReviewLogger {
5.     private let db: SQLiteDB
6. 
7.     init(db: SQLiteDB) {
8.         self.db = db
9.     }
10. 
11.     func logReview(
12.         userId: String,
13.         wordId: Int,
14.         outcome: ReviewOutcome,
15.         activityType: ActivityType,
16.         sessionType: SessionType,
17.         studyDay: Int,
18.         durationMs: Int
19.     ) throws {
20.         print("📝 logReview called: wordId=\(wordId) outcome=\(outcome)")
21.         let sql = """
22.         INSERT INTO review_log(user_id, word_id, outcome, duration_ms, reviewed_at, device_id, activity_type, session_type, study_day, superseded)
23.         VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, 0);
24.         """
25.         let stmt = try db.prepare(sql)
26.         defer { stmt?.finalize() }
27. 
28.         let reviewedAt = ISO8601DateFormatter().string(from: Date())
29. 
30.         try SQLiteDB.bind(stmt, 1, userId)
31.         try SQLiteDB.bind(stmt, 2, wordId)
32.         try SQLiteDB.bind(stmt, 3, outcome.rawValue)
33.         try SQLiteDB.bind(stmt, 4, durationMs)
34.         try SQLiteDB.bind(stmt, 5, reviewedAt)
35.         try SQLiteDB.bind(stmt, 6, LocalIdentity.deviceId())
36.         try SQLiteDB.bind(stmt, 7, activityType.rawValue)
37.         try SQLiteDB.bind(stmt, 8, sessionType.rawValue)
38.         try SQLiteDB.bind(stmt, 9, studyDay)
39. 
40.         if sqlite3_step(stmt) != SQLITE_DONE {
41.             throw SQLiteError.stepFailed(message: db.errorMessage())
42.         }
43.     }
44. 
45.     func supersedeSession(userId: String, studyDay: Int, sessionType: SessionType) throws {
46.         let sql = """
47.         UPDATE review_log SET superseded = 1
48.         WHERE user_id = ? AND study_day = ? AND session_type = ? AND superseded = 0;
49.         """
50.         let stmt = try db.prepare(sql)
51.         defer { stmt?.finalize() }
52. 
53.         try SQLiteDB.bind(stmt, 1, userId)
54.         try SQLiteDB.bind(stmt, 2, studyDay)
55.         try SQLiteDB.bind(stmt, 3, sessionType.rawValue)
56. 
57.         if sqlite3_step(stmt) != SQLITE_DONE {
58.             throw SQLiteError.stepFailed(message: db.errorMessage())
59.         }
60.     }
61. }
62.
```

</details>


---

<sub>⏱️ 1m 59s</sub>

### ✅ `rg`

**/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp**

<details>
<summary>Arguments</summary>

```json
{
  "pattern": "scenePhase|UIApplication|background|foreground|phase",
  "path": "/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp",
  "glob": "*.swift",
  "output_mode": "content",
  "-n": true,
  "head_limit": 200
}
```

</details>

<details>
<summary>6 lines</summary>

```
Output too large to read at once (39.6 KB). Saved to: /var/folders/lw/yv880yw12w36hj114qn16_g00000gn/T/copilot-tool-output-1776043195603-b96aqt.txt
Consider using tools like grep (for searching), head/tail (for viewing start/end), view with view_range (for specific sections), or jq (for JSON) to examine portions of the output.

Preview (first 500 chars):
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Views/Session/StepTransitionView.swift:16:                .foregroundColor(Color(hex: "#4B4B4B"))
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Views/Session/StepTransitionView.swift:30:                                    .foregroundColor(.white)
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Views/Session/StepTransitionView.swift:40:                    .foregroundColor(Color(hex: "#
```

</details>


---

<sub>⏱️ 1m 59s</sub>

### ✅ `rg`

**/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp**

<details>
<summary>Arguments</summary>

```json
{
  "pattern": "UNUserNotification|notification|Reminder|schedule|requestAuthorization",
  "path": "/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp",
  "glob": "*.swift",
  "output_mode": "content",
  "-n": true,
  "head_limit": 200
}
```

</details>

```
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Views/Practice/EveningSessionCard.swift:75:        timer = Timer.scheduledTimer(withTimeInterval: 60, repeats: true) { _ in
```


---

<sub>⏱️ 1m 59s</sub>

### ✅ `rg`

**/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp**

<details>
<summary>Arguments</summary>

```json
{
  "pattern": "superseded|supersedeSession|Restart|restart|discardSession|Start Over",
  "path": "/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp",
  "glob": "*.swift",
  "output_mode": "content",
  "-n": true,
  "head_limit": 200
}
```

</details>

<details>
<summary>17 lines</summary>

```
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Views/Practice/PracticeTabView.swift:55:                onRestart: {
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Views/Practice/PracticeTabView.swift:57:                        try? await SessionStateStore.shared.discardSession(
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Views/Practice/ResumeCard.swift:6:    var onRestart: (() -> Void)? = nil
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Views/Practice/ResumeCard.swift:34:            // Two buttons: Resume and Start Over
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Views/Practice/ResumeCard.swift:52:                if let onRestart {
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Views/Practice/ResumeCard.swift:53:                    Button(action: onRestart) {
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Views/Practice/ResumeCard.swift:57:                            Text("Start Over")
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Data/SessionStateStore.swift:259:    func discardSession(userId: String, studyDay: Int, sessionType: SessionType) throws {
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Data/SchemaV2.swift:190:            superseded    INTEGER DEFAULT 0
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Data/SchemaV2.swift:274:        "CREATE INDEX IF NOT EXISTS idx_review_log_scored ON review_log(user_id, word_id, activity_type, superseded, reviewed_at DESC)",
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Data/ReviewLogger.swift:22:        INSERT INTO review_log(user_id, word_id, outcome, duration_ms, reviewed_at, device_id, activity_type, session_type, study_day, superseded)
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Data/ReviewLogger.swift:45:    func supersedeSession(userId: String, studyDay: Int, sessionType: SessionType) throws {
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Data/ReviewLogger.swift:47:        UPDATE review_log SET superseded = 1
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Data/ReviewLogger.swift:48:        WHERE user_id = ? AND study_day = ? AND session_type = ? AND superseded = 0;
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Data/WordStateStore.swift:301:              AND superseded = 0;
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Data/WordStateStore.swift:321:              AND superseded = 0
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Data/WordStateStore.swift:394:          AND superseded = 0
```

</details>


---

<sub>⏱️ 1m 59s</sub>

### ✅ `rg`

**/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp**

<details>
<summary>Arguments</summary>

```json
{
  "pattern": "Recovery|recovery|catchUp|reEntry|reviewOnly|lateNight|bonus",
  "path": "/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp",
  "glob": "*.swift",
  "output_mode": "content",
  "-n": true,
  "head_limit": 300
}
```

</details>

<details>
<summary>20 lines</summary>

```
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Data/SchemaV2.swift:152:            is_recovery_day     INTEGER DEFAULT 0,
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Data/SchemaV2.swift:220:            session_bonus  INTEGER DEFAULT 0,
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/ViewModels/SessionFlowViewModel.swift:81:            // Recovery/review/bonus sessions — simplified
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/ViewModels/SessionFlowViewModel.swift:291:                // Session bonus
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Data/AppConfig.swift:50:    static let bonusPracticeXP = 5
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Data/AppConfig.swift:51:    static let lateNightHour = 20
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Data/SessionStateStore.swift:21:               is_recovery_day, is_review_only_day
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Data/SessionStateStore.swift:42:               is_recovery_day, is_review_only_day
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Data/SessionStateStore.swift:312:            isRecoveryDay: SQLiteDB.columnInt(stmt, 14) != 0,
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Models/Enums.swift:7:    case recoveryEvening = "recovery_evening"
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Models/Enums.swift:8:    case catchUp = "catch_up"
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Models/Enums.swift:9:    case reEntry = "re_entry"
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Models/Enums.swift:10:    case reviewOnly = "review_only"
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Models/Enums.swift:12:    case bonus
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Models/Models.swift:101:    var isRecoveryDay: Bool
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Data/StatsStore.swift:45:               correct_count, total_count, xp_earned, session_bonus,
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Data/StatsStore.swift:94:    func addSessionBonus(userId: String, studyDay: Int, bonus: Int = AppConfig.sessionBonusXP) throws {
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Data/StatsStore.swift:97:        SET session_bonus = session_bonus + ?
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Data/StatsStore.swift:102:        try SQLiteDB.bind(stmt, 1, bonus)
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Data/StatsStore.swift:204:        // Calculate milestone bonuses
```

</details>


---

<sub>⏱️ 2m 7s</sub>

### ✅ `rg`

**/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp**

<details>
<summary>Arguments</summary>

```json
{
  "pattern": "scenePhase",
  "path": "/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp",
  "glob": "*.swift",
  "output_mode": "content",
  "-n": true
}
```

</details>

```
No matches found.
```


---

<sub>⏱️ 2m 7s</sub>

### ✅ `rg`

**/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp**

<details>
<summary>Arguments</summary>

```json
{
  "pattern": "UNUserNotification|requestAuthorization|UNNotification|schedule.*notification|UNMutableNotificationContent",
  "path": "/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp",
  "glob": "*.swift",
  "output_mode": "content",
  "-n": true
}
```

</details>

```
No matches found.
```


---

<sub>⏱️ 2m 7s</sub>

### ✅ `view`

**view the file at /Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/SATVocabAppApp.swift.**

/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/SATVocabAppApp.swift

<details>
<summary>30 lines</summary>

```
1. import SwiftUI
2. 
3. @main
4. struct SATVocabAppApp: App {
5.     @StateObject private var bootstrap = AppBootstrap()
6. 
7.     var body: some Scene {
8.         WindowGroup {
9.             Group {
10.                 if let err = bootstrap.errorMessage {
11.                     VStack(spacing: 12) {
12.                         Text("Failed to start")
13.                             .font(.title3.weight(.semibold))
14.                         Text(err)
15.                             .font(.footnote)
16.                             .foregroundStyle(.secondary)
17.                             .multilineTextAlignment(.center)
18.                             .padding(.horizontal)
19.                     }
20.                 } else if !bootstrap.isReady {
21.                     ProgressView()
22.                         .onAppear { bootstrap.start() }
23.                 } else {
24.                     RootTabView()
25.                 }
26.             }
27.         }
28.     }
29. }
30.
```

</details>


---

<sub>⏱️ 2m 7s</sub>

### ✅ `view`

**view the file at /Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/ViewModels/AppBootstrap.swift.**

/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/ViewModels/AppBootstrap.swift

<details>
<summary>19 lines</summary>

```
1. import Foundation
2. 
3. @MainActor
4. final class AppBootstrap: ObservableObject {
5.     @Published var isReady: Bool = false
6.     @Published var errorMessage: String? = nil
7. 
8.     func start() {
9.         Task {
10.             do {
11.                 try await DataManager.shared.initializeIfNeeded()
12.                 isReady = true
13.             } catch {
14.                 errorMessage = String(describing: error)
15.             }
16.         }
17.     }
18. }
19.
```

</details>


---

<sub>⏱️ 2m 7s</sub>

### ✅ `view`

**view the file at /Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Data/SchemaV2.swift.**

/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Data/SchemaV2.swift (lines 140-240)

<details>
<summary>101 lines</summary>

```
140.             study_day           INTEGER NOT NULL,
141.             zone_index          INTEGER NOT NULL,
142.             morning_complete    INTEGER DEFAULT 0,
143.             evening_complete    INTEGER DEFAULT 0,
144.             morning_complete_at TEXT,
145.             evening_complete_at TEXT,
146.             new_words_morning   INTEGER DEFAULT 0,
147.             new_words_evening   INTEGER DEFAULT 0,
148.             morning_accuracy    REAL DEFAULT 0,
149.             evening_accuracy    REAL DEFAULT 0,
150.             morning_xp          INTEGER DEFAULT 0,
151.             evening_xp          INTEGER DEFAULT 0,
152.             is_recovery_day     INTEGER DEFAULT 0,
153.             is_review_only_day  INTEGER DEFAULT 0,
154.             created_at          TEXT DEFAULT (datetime('now')),
155.             UNIQUE(user_id, study_day)
156.         )
157.         """,
158. 
159.         """
160.         CREATE TABLE IF NOT EXISTS session_state (
161.             id             INTEGER PRIMARY KEY AUTOINCREMENT,
162.             user_id        TEXT NOT NULL REFERENCES users(id),
163.             session_type   TEXT NOT NULL,
164.             study_day      INTEGER NOT NULL,
165.             step_index     INTEGER DEFAULT 0,
166.             item_index     INTEGER DEFAULT 0,
167.             is_paused      INTEGER DEFAULT 0,
168.             show_again_ids TEXT,
169.             requeued_ids   TEXT,
170.             started_at     TEXT,
171.             paused_at      TEXT,
172.             completed_at   TEXT,
173.             UNIQUE(user_id, study_day, session_type)
174.         )
175.         """,
176. 
177.         """
178.         CREATE TABLE IF NOT EXISTS review_log (
179.             id            INTEGER PRIMARY KEY AUTOINCREMENT,
180.             user_id       TEXT NOT NULL REFERENCES users(id),
181.             word_id       INTEGER NOT NULL REFERENCES words(id),
182.             list_id       INTEGER,
183.             outcome       TEXT NOT NULL,
184.             duration_ms   INTEGER,
185.             reviewed_at   TEXT NOT NULL,
186.             device_id     TEXT,
187.             activity_type TEXT,
188.             session_type  TEXT,
189.             study_day     INTEGER,
190.             superseded    INTEGER DEFAULT 0
191.         )
192.         """,
193. 
194.         """
195.         CREATE TABLE IF NOT EXISTS session (
196.             id            INTEGER PRIMARY KEY AUTOINCREMENT,
197.             user_id       TEXT NOT NULL,
198.             list_id       INTEGER,
199.             started_at    TEXT,
200.             ended_at      TEXT,
201.             items_total   INTEGER,
202.             items_correct INTEGER DEFAULT 0,
203.             session_type  TEXT,
204.             study_day     INTEGER,
205.             xp_earned     INTEGER DEFAULT 0
206.         )
207.         """,
208. 
209.         """
210.         CREATE TABLE IF NOT EXISTS daily_stats (
211.             id             INTEGER PRIMARY KEY AUTOINCREMENT,
212.             user_id        TEXT NOT NULL REFERENCES users(id),
213.             study_day      INTEGER NOT NULL,
214.             calendar_date  TEXT NOT NULL,
215.             new_count      INTEGER DEFAULT 0,
216.             review_count   INTEGER DEFAULT 0,
217.             correct_count  INTEGER DEFAULT 0,
218.             total_count    INTEGER DEFAULT 0,
219.             xp_earned      INTEGER DEFAULT 0,
220.             session_bonus  INTEGER DEFAULT 0,
221.             study_minutes  REAL DEFAULT 0,
222.             words_promoted INTEGER DEFAULT 0,
223.             words_demoted  INTEGER DEFAULT 0,
224.             UNIQUE(user_id, study_day)
225.         )
226.         """,
227. 
228.         """
229.         CREATE TABLE IF NOT EXISTS streak_store (
230.             id                INTEGER PRIMARY KEY AUTOINCREMENT,
231.             user_id           TEXT NOT NULL REFERENCES users(id),
232.             current_streak    INTEGER DEFAULT 0,
233.             best_streak       INTEGER DEFAULT 0,
234.             last_study_date   TEXT,
235.             streak_3_claimed  INTEGER DEFAULT 0,
236.             streak_7_claimed  INTEGER DEFAULT 0,
237.             streak_14_claimed INTEGER DEFAULT 0,
238.             streak_30_claimed INTEGER DEFAULT 0,
239.             total_xp          INTEGER DEFAULT 0,
240.             total_study_days  INTEGER DEFAULT 0,
```

</details>


---

<sub>⏱️ 2m 11s</sub>

### ✅ `view`

**view the file at /Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Views/Report/ReportCardGenerator.swift.**

/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Views/Report/ReportCardGenerator.swift

<details>
<summary>65 lines</summary>

```
1. import SwiftUI
2. 
3. enum ReportCardGenerator {
4.     @MainActor
5.     static func render(streak: StreakInfo, userId: String) -> UIImage {
6.         let view = ReportCardView(streak: streak, userId: userId)
7.         let renderer = ImageRenderer(content: view)
8.         renderer.scale = UIScreen.main.scale
9.         return renderer.uiImage ?? UIImage()
10.     }
11. }
12. 
13. // MARK: - Report Card View (rendered to image)
14. 
15. private struct ReportCardView: View {
16.     let streak: StreakInfo
17.     let userId: String
18. 
19.     var body: some View {
20.         VStack(spacing: 20) {
21.             Text("SAT Vocab Progress")
22.                 .font(.system(.title, design: .rounded).weight(.bold))
23.                 .foregroundStyle(.white)
24. 
25.             HStack(spacing: 24) {
26.                 reportStat(value: "\(streak.currentStreak)", label: "Day Streak", icon: "flame.fill")
27.                 reportStat(value: "\(streak.totalXP)", label: "Total XP", icon: "star.fill")
28.                 reportStat(value: "\(streak.totalStudyDays)", label: "Study Days", icon: "calendar")
29.             }
30. 
31.             Text("Best Streak: \(streak.bestStreak) days")
32.                 .font(.system(.subheadline, design: .rounded).weight(.semibold))
33.                 .foregroundStyle(.white.opacity(0.8))
34. 
35.             Text(DateFormatter.yyyyMMdd.string(from: Date()))
36.                 .font(.system(.caption, design: .rounded))
37.                 .foregroundStyle(.white.opacity(0.6))
38.         }
39.         .padding(30)
40.         .frame(width: 360)
41.         .background(
42.             LinearGradient(
43.                 colors: [Color(hex: "#58CC02"), Color(hex: "#3B8C00")],
44.                 startPoint: .topLeading,
45.                 endPoint: .bottomTrailing
46.             )
47.         )
48.         .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
49.     }
50. 
51.     private func reportStat(value: String, label: String, icon: String) -> some View {
52.         VStack(spacing: 6) {
53.             Image(systemName: icon)
54.                 .font(.system(size: 22, weight: .semibold))
55.                 .foregroundStyle(.white.opacity(0.9))
56.             Text(value)
57.                 .font(.system(.title2, design: .rounded).weight(.bold))
58.                 .foregroundStyle(.white)
59.             Text(label)
60.                 .font(.system(.caption, design: .rounded).weight(.medium))
61.                 .foregroundStyle(.white.opacity(0.75))
62.         }
63.     }
64. }
65.
```

</details>


---

<sub>⏱️ 2m 11s</sub>

### ✅ `view`

**view the file at /Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Data/LocalIdentity.swift.**

/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Data/LocalIdentity.swift

<details>
<summary>63 lines</summary>

```
1. import Foundation
2. 
3. enum LocalIdentity {
4.     private static let userIdKey = "local.user_id"
5.     private static let deviceIdKey = "local.device_id"
6.     private static let learningStartDateKey = "local.learning_start_date"
7.     private static let displayNameKey = "local.display_name"
8.     private static let avatarEmojiKey = "local.avatar_emoji"
9. 
10.     static func displayName() -> String {
11.         UserDefaults.standard.string(forKey: displayNameKey) ?? "SAT Learner"
12.     }
13. 
14.     static func setDisplayName(_ name: String) {
15.         UserDefaults.standard.set(name, forKey: displayNameKey)
16.     }
17. 
18.     static func avatarEmoji() -> String {
19.         UserDefaults.standard.string(forKey: avatarEmojiKey) ?? "🧑‍🎓"
20.     }
21. 
22.     static func setAvatarEmoji(_ emoji: String) {
23.         UserDefaults.standard.set(emoji, forKey: avatarEmojiKey)
24.     }
25. 
26.     static func userId() -> String {
27.         if let v = UserDefaults.standard.string(forKey: userIdKey) {
28.             return v
29.         }
30.         let v = UUID().uuidString
31.         UserDefaults.standard.set(v, forKey: userIdKey)
32.         return v
33.     }
34. 
35.     static func deviceId() -> String {
36.         if let v = UserDefaults.standard.string(forKey: deviceIdKey) {
37.             return v
38.         }
39.         let v = UUID().uuidString
40.         UserDefaults.standard.set(v, forKey: deviceIdKey)
41.         return v
42.     }
43. 
44.     static func learningStartDate() -> Date {
45.         let defaults = UserDefaults.standard
46.         if let stored = defaults.object(forKey: learningStartDateKey) as? Double {
47.             return Date(timeIntervalSince1970: stored)
48.         }
49. 
50.         let startOfToday = Calendar.current.startOfDay(for: Date())
51.         defaults.set(startOfToday.timeIntervalSince1970, forKey: learningStartDateKey)
52.         return startOfToday
53.     }
54. 
55.     static func dailyStartIndex(dailyWordCount: Int, today: Date = Date()) -> Int {
56.         let cal = Calendar.current
57.         let start = cal.startOfDay(for: learningStartDate())
58.         let end = cal.startOfDay(for: today)
59.         let day = cal.dateComponents([.day], from: start, to: end).day ?? 0
60.         return max(0, day) * max(1, dailyWordCount)
61.     }
62. }
63.
```

</details>


---

<sub>⏱️ 2m 11s</sub>

### ✅ `view`

**view the file at /Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Data/DataManager.swift.**

/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Data/DataManager.swift

<details>
<summary>678 lines</summary>

```
1. import Foundation
2. import SQLite3
3. 
4. actor DataManager {
5.     static let shared = DataManager()
6. 
7.     nonisolated let db = SQLiteDB()
8.     private var isInitialized = false
9. 
10.     private init() {}
11. 
12.     deinit {
13.         db.close()
14.     }
15. 
16.     func initializeIfNeeded() throws {
17.         if isInitialized { return }
18. 
19.         let fm = FileManager.default
20.         let writableURL = try DatabasePaths.writableDatabaseURL()
21.         let fileExisted = fm.fileExists(atPath: writableURL.path)
22. 
23.         try db.open(path: writableURL.path)
24. 
25.         // Determine if import is needed: either fresh install or a previous
26.         // failed import left the DB file with zero words.
27.         var needsImport = !fileExisted
28.         if fileExisted {
29.             let checkStmt = try db.prepare("SELECT COUNT(*) FROM words;")
30.             defer { checkStmt?.finalize() }
31.             if sqlite3_step(checkStmt) == SQLITE_ROW {
32.                 let wordCount = SQLiteDB.columnInt(checkStmt, 0)
33.                 if wordCount == 0 {
34.                     needsImport = true
35.                 }
36.             } else {
37.                 // Table may not exist yet (corrupted state) — re-import
38.                 needsImport = true
39.             }
40.         }
41. 
42.         if needsImport {
43.             // Fresh install: create schema, import bundled content, seed user defaults
44.             try SchemaV2.createAll(db: db)
45.             try ContentImporter.importBundledContent(db: db)
46. 
47.             let userId = LocalIdentity.userId()
48.             try ensureUserExists(userId: userId)
49. 
50.             // Seed streak_store row
51.             let streakSQL = "INSERT OR IGNORE INTO streak_store(user_id) VALUES (?)"
52.             let s1 = try db.prepare(streakSQL)
53.             defer { s1?.finalize() }
54.             try SQLiteDB.bind(s1, 1, userId)
55.             if sqlite3_step(s1) != SQLITE_DONE {
56.                 throw SQLiteError.stepFailed(message: db.errorMessage())
57.             }
58. 
59.             // Seed zone_state row for zone 0 (unlocked by default)
60.             let zoneSQL = "INSERT OR IGNORE INTO zone_state(user_id, zone_index, unlocked, unlocked_at) VALUES (?, 0, 1, datetime('now'))"
61.             let s2 = try db.prepare(zoneSQL)
62.             defer { s2?.finalize() }
63.             try SQLiteDB.bind(s2, 1, userId)
64.             if sqlite3_step(s2) != SQLITE_DONE {
65.                 throw SQLiteError.stepFailed(message: db.errorMessage())
66.             }
67.         } else {
68.             // Existing DB: just ensure user row exists
69.             let userId = LocalIdentity.userId()
70.             try ensureUserExists(userId: userId)
71.         }
72. 
73.         isInitialized = true
74.     }
75. 
76.     // MARK: - Users
77. 
78.     func ensureUserExists(userId: String) throws {
79.         let sql = "INSERT OR IGNORE INTO users(id, email) VALUES (?, NULL);"
80.         let stmt = try db.prepare(sql)
81.         defer { stmt?.finalize() }
82.         try SQLiteDB.bind(stmt, 1, userId)
83.         if sqlite3_step(stmt) != SQLITE_DONE {
84.             throw SQLiteError.stepFailed(message: db.errorMessage())
85.         }
86.     }
87. 
88.     // MARK: - Lists
89. 
90.     func getDefaultList() throws -> ListInfo {
91.         let sql = """
92.         SELECT id, name, description, version
93.         FROM lists
94.         ORDER BY CASE WHEN name=? THEN 0 ELSE 1 END, id
95.         LIMIT 1;
96.         """
97.         let stmt = try db.prepare(sql)
98.         defer { stmt?.finalize() }
99.         try SQLiteDB.bind(stmt, 1, AppConfig.defaultListName)
100.         if sqlite3_step(stmt) == SQLITE_ROW {
101.             let id = SQLiteDB.columnInt(stmt, 0)
102.             let name = SQLiteDB.columnText(stmt, 1) ?? ""
103.             let description = SQLiteDB.columnText(stmt, 2)
104.             let version = SQLiteDB.columnInt(stmt, 3)
105.             return ListInfo(id: id, name: name, description: description, version: version)
106.         }
107.         throw SQLiteError.stepFailed(message: "No list found")
108.     }
109. 
110.     // MARK: - Queue
111. 
112.     func fetchSessionQueue(listId: Int, limit: Int, startIndex: Int) throws -> [VocabCard] {
113.         // Deterministic sequential ordering (no jumping): offset = startIndex % totalInList
114.         let total = try countWordsInList(listId: listId)
115.         if total == 0 { return [] }
116.         let offset = ((startIndex % total) + total) % total
117. 
118.         // Fetch with wrap-around using two queries.
119.         let first = try fetchOrderedWords(listId: listId, limit: min(limit, total), offset: offset)
120.         if first.count >= limit { return first }
121.         let remaining = limit - first.count
122.         let second = try fetchOrderedWords(listId: listId, limit: remaining, offset: 0)
123.         return first + second
124.     }
125. 
126.     func fetchReviewQueue(userId: String, listId: Int, limit: Int) throws -> [VocabCard] {
127.         try fetchReviewQueue(userId: userId, listId: listId, limit: limit, restrictToWordIds: nil)
128.     }
129. 
130.     func fetchReviewQueue(userId: String, listId: Int, limit: Int, restrictToWordIds: [Int]?) throws -> [VocabCard] {
131.         // Words that currently "need review" are those whose latest logged outcome is incorrect.
132.         // Optionally restrict to a known subset of word IDs (e.g., zone difficulty review).
133. 
134.         if let ids = restrictToWordIds, ids.isEmpty {
135.             return []
136.         }
137. 
138.         let wordFilterSql: String
139.         if let ids = restrictToWordIds {
140.             let placeholders = Array(repeating: "?", count: ids.count).joined(separator: ",")
141.             wordFilterSql = "AND l.word_id IN (\(placeholders))"
142.         } else {
143.             wordFilterSql = ""
144.         }
145. 
146.         let sql = """
147.         WITH latest AS (
148.             SELECT rl.word_id,
149.                    rl.outcome,
150.                    rl.reviewed_at,
151.                    ROW_NUMBER() OVER (PARTITION BY rl.word_id ORDER BY rl.reviewed_at DESC) AS rn
152.             FROM review_log rl
153.             JOIN word_list wl ON wl.word_id = rl.word_id AND wl.list_id = ?
154.             WHERE rl.user_id = ?
155.         )
156.         SELECT w.id, w.lemma, w.pos, w.definition, w.example, w.image_filename
157.         FROM latest l
158.         JOIN words w ON w.id = l.word_id
159.         WHERE l.rn = 1
160.           AND l.outcome = 'incorrect'
161.           \(wordFilterSql)
162.         ORDER BY l.reviewed_at DESC
163.         LIMIT ?;
164.         """
165. 
166.         let stmt = try db.prepare(sql)
167.         defer { stmt?.finalize() }
168. 
169.         var bindIndex: Int32 = 1
170.         try SQLiteDB.bind(stmt, bindIndex, listId)
171.         bindIndex += 1
172.         try SQLiteDB.bind(stmt, bindIndex, userId)
173.         bindIndex += 1
174. 
175.         if let ids = restrictToWordIds {
176.             for id in ids {
177.                 try SQLiteDB.bind(stmt, bindIndex, id)
178.                 bindIndex += 1
179.             }
180.         }
181. 
182.         try SQLiteDB.bind(stmt, bindIndex, limit)
183. 
184.         var out: [VocabCard] = []
185.         while sqlite3_step(stmt) == SQLITE_ROW {
186.             out.append(VocabCard(
187.                 id: SQLiteDB.columnInt(stmt, 0),
188.                 lemma: SQLiteDB.columnText(stmt, 1) ?? "",
189.                 pos: SQLiteDB.columnText(stmt, 2),
190.                 definition: SQLiteDB.columnText(stmt, 3),
191.                 example: SQLiteDB.columnText(stmt, 4),
192.                 imageFilename: SQLiteDB.columnText(stmt, 5)
193.             ))
194.         }
195.         return out
196.     }
197. 
198.     private func countWordsInList(listId: Int) throws -> Int {
199.         let sql = "SELECT COUNT(*) FROM word_list WHERE list_id=?;"
200.         let stmt = try db.prepare(sql)
201.         defer { stmt?.finalize() }
202.         try SQLiteDB.bind(stmt, 1, listId)
203.         if sqlite3_step(stmt) == SQLITE_ROW {
204.             return SQLiteDB.columnInt(stmt, 0)
205.         }
206.         return 0
207.     }
208. 
209.     private func fetchOrderedWords(listId: Int, limit: Int, offset: Int) throws -> [VocabCard] {
210.         let sql = """
211.         SELECT w.id, w.lemma, w.pos, w.definition, w.example, w.image_filename
212.         FROM word_list wl
213.         JOIN words w ON w.id = wl.word_id
214.         WHERE wl.list_id = ?
215.         ORDER BY COALESCE(wl.rank, 999999), w.id
216.         LIMIT ? OFFSET ?;
217.         """
218.         let stmt = try db.prepare(sql)
219.         defer { stmt?.finalize() }
220.         try SQLiteDB.bind(stmt, 1, listId)
221.         try SQLiteDB.bind(stmt, 2, limit)
222.         try SQLiteDB.bind(stmt, 3, offset)
223. 
224.         var out: [VocabCard] = []
225.         while sqlite3_step(stmt) == SQLITE_ROW {
226.             out.append(VocabCard(
227.                 id: SQLiteDB.columnInt(stmt, 0),
228.                 lemma: SQLiteDB.columnText(stmt, 1) ?? "",
229.                 pos: SQLiteDB.columnText(stmt, 2),
230.                 definition: SQLiteDB.columnText(stmt, 3),
231.                 example: SQLiteDB.columnText(stmt, 4),
232.                 imageFilename: SQLiteDB.columnText(stmt, 5)
233.             ))
234.         }
235.         return out
236.     }
237. 
238.     // MARK: - Words
239. 
240.     func fetchWordById(wordId: Int) throws -> VocabCard? {
241.         let sql = """
242.         SELECT id, lemma, pos, definition, example, image_filename
243.         FROM words
244.         WHERE id = ?
245.         LIMIT 1;
246.         """
247.         let stmt = try db.prepare(sql)
248.         defer { stmt?.finalize() }
249. 
250.         try SQLiteDB.bind(stmt, 1, wordId)
251.         if sqlite3_step(stmt) == SQLITE_ROW {
252.             return VocabCard(
253.                 id: SQLiteDB.columnInt(stmt, 0),
254.                 lemma: SQLiteDB.columnText(stmt, 1) ?? "",
255.                 pos: SQLiteDB.columnText(stmt, 2),
256.                 definition: SQLiteDB.columnText(stmt, 3),
257.                 example: SQLiteDB.columnText(stmt, 4),
258.                 imageFilename: SQLiteDB.columnText(stmt, 5)
259.             )
260.         }
261.         return nil
262.     }
263. 
264.     // MARK: - Contexts
265. 
266.     func randomSatContext(wordId: Int) throws -> String? {
267.         let sql = """
268.         SELECT context
269.         FROM sat_contexts
270.         WHERE word_id = ?
271.         ORDER BY RANDOM()
272.         LIMIT 1;
273.         """
274.         let stmt = try db.prepare(sql)
275.         defer { stmt?.finalize() }
276.         try SQLiteDB.bind(stmt, 1, wordId)
277.         if sqlite3_step(stmt) == SQLITE_ROW {
278.             return SQLiteDB.columnText(stmt, 0)
279.         }
280.         return nil
281.     }
282. 
283.     func fetchCollocations(wordId: Int, limit: Int = 6) throws -> [String] {
284.         let sql = """
285.         SELECT phrase
286.         FROM collocations
287.         WHERE word_id = ?
288.         ORDER BY id
289.         LIMIT ?;
290.         """
291.         let stmt = try db.prepare(sql)
292.         defer { stmt?.finalize() }
293.         try SQLiteDB.bind(stmt, 1, wordId)
294.         try SQLiteDB.bind(stmt, 2, limit)
295. 
296.         var out: [String] = []
297.         while sqlite3_step(stmt) == SQLITE_ROW {
298.             if let phrase = SQLiteDB.columnText(stmt, 0), !phrase.isEmpty {
299.                 out.append(phrase)
300.             }
301.         }
302.         return out
303.     }
304. 
305.     // MARK: - Review Log
306. 
307.     func logReview(userId: String, wordId: Int, listId: Int?, outcome: ReviewOutcome, durationMs: Int, reviewedAt: Date, deviceId: String) throws {
308.         let sql = """
309.         INSERT INTO review_log(user_id, word_id, list_id, outcome, duration_ms, reviewed_at, device_id)
310.         VALUES (?, ?, ?, ?, ?, ?, ?);
311.         """
312.         let stmt = try db.prepare(sql)
313.         defer { stmt?.finalize() }
314. 
315.         let iso = ISO8601DateFormatter()
316.         let reviewedAtStr = iso.string(from: reviewedAt)
317. 
318.         try SQLiteDB.bind(stmt, 1, userId)
319.         try SQLiteDB.bind(stmt, 2, wordId)
320.         try SQLiteDB.bind(stmt, 3, listId)
321.         try SQLiteDB.bind(stmt, 4, outcome.rawValue)
322.         try SQLiteDB.bind(stmt, 5, durationMs)
323.         try SQLiteDB.bind(stmt, 6, reviewedAtStr)
324.         try SQLiteDB.bind(stmt, 7, deviceId)
325. 
326.         if sqlite3_step(stmt) != SQLITE_DONE {
327.             throw SQLiteError.stepFailed(message: db.errorMessage())
328.         }
329.     }
330. 
331.     // MARK: - Session
332. 
333.     func startSession(userId: String, listId: Int?, itemsTotal: Int, startedAt: Date = Date()) throws -> Int {
334.         let sql = """
335.         INSERT INTO session(user_id, list_id, started_at, items_total, items_correct)
336.         VALUES (?, ?, ?, ?, 0);
337.         """
338.         let stmt = try db.prepare(sql)
339.         defer { stmt?.finalize() }
340. 
341.         let iso = ISO8601DateFormatter()
342.         let startedAtStr = iso.string(from: startedAt)
343. 
344.         try SQLiteDB.bind(stmt, 1, userId)
345.         try SQLiteDB.bind(stmt, 2, listId)
346.         try SQLiteDB.bind(stmt, 3, startedAtStr)
347.         try SQLiteDB.bind(stmt, 4, itemsTotal)
348. 
349.         if sqlite3_step(stmt) != SQLITE_DONE {
350.             throw SQLiteError.stepFailed(message: db.errorMessage())
351.         }
352.         return Int(db.lastInsertRowId())
353.     }
354. 
355.     func finishSession(sessionId: Int, itemsCorrect: Int, endedAt: Date = Date()) throws {
356.         let sql = """
357.         UPDATE session
358.         SET ended_at = ?, items_correct = ?
359.         WHERE id = ?;
360.         """
361.         let stmt = try db.prepare(sql)
362.         defer { stmt?.finalize() }
363. 
364.         let iso = ISO8601DateFormatter()
365.         let endedAtStr = iso.string(from: endedAt)
366. 
367.         try SQLiteDB.bind(stmt, 1, endedAtStr)
368.         try SQLiteDB.bind(stmt, 2, itemsCorrect)
369.         try SQLiteDB.bind(stmt, 3, sessionId)
370. 
371.         if sqlite3_step(stmt) != SQLITE_DONE {
372.             throw SQLiteError.stepFailed(message: db.errorMessage())
373.         }
374.     }
375. 
376.     // MARK: - Progress Snapshot
377. 
378.     func ensureProgressSnapshot(userId: String, listId: Int) throws {
379.         let sql = """
380.         INSERT OR IGNORE INTO progress_snapshot(user_id, list_id, mastered_count, total_seen, streak_days, last_reviewed_at, version)
381.         VALUES (?, ?, 0, 0, 0, NULL, 1);
382.         """
383.         let stmt = try db.prepare(sql)
384.         defer { stmt?.finalize() }
385.         try SQLiteDB.bind(stmt, 1, userId)
386.         try SQLiteDB.bind(stmt, 2, listId)
387.         if sqlite3_step(stmt) != SQLITE_DONE {
388.             throw SQLiteError.stepFailed(message: db.errorMessage())
389.         }
390.     }
391. 
392.     func fetchProgressSnapshot(userId: String, listId: Int) throws -> ProgressSnapshot? {
393.         let sql = """
394.         SELECT user_id, list_id, mastered_count, total_seen, streak_days, last_reviewed_at, version
395.         FROM progress_snapshot
396.         WHERE user_id = ? AND list_id = ?
397.         LIMIT 1;
398.         """
399.         let stmt = try db.prepare(sql)
400.         defer { stmt?.finalize() }
401.         try SQLiteDB.bind(stmt, 1, userId)
402.         try SQLiteDB.bind(stmt, 2, listId)
403.         if sqlite3_step(stmt) == SQLITE_ROW {
404.             let userId = SQLiteDB.columnText(stmt, 0) ?? ""
405.             let listId = SQLiteDB.columnInt(stmt, 1)
406.             let mastered = SQLiteDB.columnInt(stmt, 2)
407.             let totalSeen = SQLiteDB.columnInt(stmt, 3)
408.             let streak = SQLiteDB.columnInt(stmt, 4)
409.             let lastStr = SQLiteDB.columnText(stmt, 5)
410.             let version = SQLiteDB.columnInt(stmt, 6)
411. 
412.             var lastDate: Date? = nil
413.             if let lastStr {
414.                 lastDate = ISO8601DateFormatter().date(from: lastStr)
415.             }
416. 
417.             return ProgressSnapshot(userId: userId, listId: listId, masteredCount: mastered, totalSeen: totalSeen, streakDays: streak, lastReviewedAt: lastDate, version: version)
418.         }
419.         return nil
420.     }
421. 
422.     func updateProgressAfterSession(userId: String, listId: Int, itemsTotal: Int, itemsCorrect: Int, finishedAt: Date = Date()) throws {
423.         try ensureProgressSnapshot(userId: userId, listId: listId)
424. 
425.         let iso = ISO8601DateFormatter()
426.         let finishedStr = iso.string(from: finishedAt)
427. 
428.         let current = try fetchProgressSnapshot(userId: userId, listId: listId)
429.         let calendar = Calendar.current
430. 
431.         var newStreak = current?.streakDays ?? 0
432.         if let last = current?.lastReviewedAt {
433.             if calendar.isDateInToday(last) {
434.                 // keep streak
435.             } else if calendar.isDate(last, inSameDayAs: calendar.date(byAdding: .day, value: -1, to: finishedAt) ?? last) {
436.                 newStreak += 1
437.             } else {
438.                 newStreak = 1
439.             }
440.         } else {
441.             newStreak = 1
442.         }
443. 
444.         let sql = """
445.         UPDATE progress_snapshot
446.         SET mastered_count = mastered_count + ?,
447.             total_seen = total_seen + ?,
448.             streak_days = ?,
449.             last_reviewed_at = ?
450.         WHERE user_id = ? AND list_id = ?;
451.         """
452.         let stmt = try db.prepare(sql)
453.         defer { stmt?.finalize() }
454. 
455.         try SQLiteDB.bind(stmt, 1, itemsCorrect)
456.         try SQLiteDB.bind(stmt, 2, itemsTotal)
457.         try SQLiteDB.bind(stmt, 3, newStreak)
458.         try SQLiteDB.bind(stmt, 4, finishedStr)
459.         try SQLiteDB.bind(stmt, 5, userId)
460.         try SQLiteDB.bind(stmt, 6, listId)
461. 
462.         if sqlite3_step(stmt) != SQLITE_DONE {
463.             throw SQLiteError.stepFailed(message: db.errorMessage())
464.         }
465.     }
466. 
467.     // MARK: - Task 3
468. 
469.     func fetchWeakWords(userId: String, listId: Int, limit: Int) throws -> [Int] {
470.         // Weak words heuristic:
471.         // - at least 3 attempts
472.         // - correct_rate < 0.7
473.         // Ordered by worst first.
474.         let sql = """
475.         SELECT rl.word_id
476.         FROM review_log rl
477.         JOIN word_list wl ON wl.word_id = rl.word_id AND wl.list_id = ?
478.         WHERE rl.user_id = ?
479.         GROUP BY rl.word_id
480.         HAVING COUNT(*) >= 3
481.            AND (SUM(CASE WHEN rl.outcome='correct' THEN 1 ELSE 0 END) * 1.0 / COUNT(*)) < 0.7
482.         ORDER BY (SUM(CASE WHEN rl.outcome='correct' THEN 1 ELSE 0 END) * 1.0 / COUNT(*)) ASC
483.         LIMIT ?;
484.         """
485.         let stmt = try db.prepare(sql)
486.         defer { stmt?.finalize() }
487. 
488.         try SQLiteDB.bind(stmt, 1, listId)
489.         try SQLiteDB.bind(stmt, 2, userId)
490.         try SQLiteDB.bind(stmt, 3, limit)
491. 
492.         var out: [Int] = []
493.         while sqlite3_step(stmt) == SQLITE_ROW {
494.             out.append(SQLiteDB.columnInt(stmt, 0))
495.         }
496.         return out
497.     }
498. 
499.     func fetchDistractors(listId: Int, pos: String?, excludeWordId: Int, limit: Int) throws -> [VocabCard] {
500.         // Prefer same POS if available.
501.         let sqlWithPos = """
502.         SELECT w.id, w.lemma, w.pos, w.definition, w.example, w.image_filename
503.         FROM word_list wl
504.         JOIN words w ON w.id = wl.word_id
505.         WHERE wl.list_id = ? AND w.id != ? AND w.pos = ?
506.         ORDER BY RANDOM()
507.         LIMIT ?;
508.         """
509.         let sqlNoPos = """
510.         SELECT w.id, w.lemma, w.pos, w.definition, w.example, w.image_filename
511.         FROM word_list wl
512.         JOIN words w ON w.id = wl.word_id
513.         WHERE wl.list_id = ? AND w.id != ?
514.         ORDER BY RANDOM()
515.         LIMIT ?;
516.         """
517. 
518.         var out: [VocabCard] = []
519. 
520.         if let pos, !pos.isEmpty {
521.             let stmt = try db.prepare(sqlWithPos)
522.             defer { stmt?.finalize() }
523.             try SQLiteDB.bind(stmt, 1, listId)
524.             try SQLiteDB.bind(stmt, 2, excludeWordId)
525.             try SQLiteDB.bind(stmt, 3, pos)
526.             try SQLiteDB.bind(stmt, 4, limit)
527.             while sqlite3_step(stmt) == SQLITE_ROW {
528.                 out.append(VocabCard(
529.                     id: SQLiteDB.columnInt(stmt, 0),
530.                     lemma: SQLiteDB.columnText(stmt, 1) ?? "",
531.                     pos: SQLiteDB.columnText(stmt, 2),
532.                     definition: SQLiteDB.columnText(stmt, 3),
533.                     example: SQLiteDB.columnText(stmt, 4),
534.                     imageFilename: SQLiteDB.columnText(stmt, 5)
535.                 ))
536.             }
537.         }
538. 
539.         if out.count < limit {
540.             let remaining = limit - out.count
541.             let stmt = try db.prepare(sqlNoPos)
542.             defer { stmt?.finalize() }
543.             try SQLiteDB.bind(stmt, 1, listId)
544.             try SQLiteDB.bind(stmt, 2, excludeWordId)
545.             try SQLiteDB.bind(stmt, 3, remaining)
546.             while sqlite3_step(stmt) == SQLITE_ROW {
547.                 out.append(VocabCard(
548.                     id: SQLiteDB.columnInt(stmt, 0),
549.                     lemma: SQLiteDB.columnText(stmt, 1) ?? "",
550.                     pos: SQLiteDB.columnText(stmt, 2),
551.                     definition: SQLiteDB.columnText(stmt, 3),
552.                     example: SQLiteDB.columnText(stmt, 4),
553.                     imageFilename: SQLiteDB.columnText(stmt, 5)
554.                 ))
555.             }
556.         }
557. 
558.         // Ensure uniqueness by id.
559.         var seen = Set<Int>()
560.         return out.filter { seen.insert($0.id).inserted }.prefix(limit).map { $0 }
561.     }
562. 
563.     func fetchSatQuestionsForWord(wordId: Int, limit: Int, verifiedOnly: Bool) throws -> [SatQuestion] {
564.         let lemma = (try fetchWordById(wordId: wordId)?.lemma ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
565. 
566.          let sql = """
567.          WITH fb AS (
568.              SELECT question_id,
569.                  answer AS deepseek_answer,
570.                  background AS deepseek_background,
571.                  reason_for_answer AS deepseek_reason,
572.                  ROW_NUMBER() OVER (PARTITION BY question_id ORDER BY created_at DESC, id DESC) AS rn
573.              FROM deepseek_sat_feedback
574.              WHERE ai_source = 'deepseek'
575.          )
576.          SELECT q.id, q.word_id, q.target_word, q.section, q.module, q.q_type,
577.              q.passage, q.question, q.option_a, q.option_b, q.option_c, q.option_d,
578.              q.answer, q.source_pdf, q.page,
579.              q.feedback_generated, q.answer_verified,
580.              fb.deepseek_answer, fb.deepseek_background, fb.deepseek_reason
581.          FROM sat_question_bank q
582.          JOIN word_questions wq ON wq.question_id = q.id
583.          LEFT JOIN fb ON fb.question_id = q.id AND fb.rn = 1
584.          WHERE wq.word_id = ?
585.            AND (? = 0 OR q.answer_verified = 1)
586.            AND q.answer IS NOT NULL AND TRIM(q.answer) <> ''
587.            AND q.option_a IS NOT NULL AND TRIM(q.option_a) <> ''
588.            AND q.option_b IS NOT NULL AND TRIM(q.option_b) <> ''
589.            AND q.option_c IS NOT NULL AND TRIM(q.option_c) <> ''
590.            AND q.option_d IS NOT NULL AND TRIM(q.option_d) <> ''
591.          ORDER BY RANDOM()
592.          LIMIT ?;
593.          """
594.         let stmt = try db.prepare(sql)
595.         defer { stmt?.finalize() }
596. 
597.         try SQLiteDB.bind(stmt, 1, wordId)
598.         try SQLiteDB.bind(stmt, 2, verifiedOnly ? 1 : 0)
599.         try SQLiteDB.bind(stmt, 3, limit)
600. 
601.         var out: [SatQuestion] = []
602.         while sqlite3_step(stmt) == SQLITE_ROW {
603.             out.append(SatQuestion(
604.                 id: SQLiteDB.columnText(stmt, 0) ?? "",
605.                 wordId: sqlite3_column_type(stmt, 1) == SQLITE_NULL ? nil : SQLiteDB.columnInt(stmt, 1),
606.                 targetWord: SQLiteDB.columnText(stmt, 2),
607.                 section: SQLiteDB.columnText(stmt, 3),
608.                 module: sqlite3_column_type(stmt, 4) == SQLITE_NULL ? nil : SQLiteDB.columnInt(stmt, 4),
609.                 qType: SQLiteDB.columnText(stmt, 5),
610.                 passage: SQLiteDB.columnText(stmt, 6),
611.                 question: SQLiteDB.columnText(stmt, 7),
612.                 optionA: SQLiteDB.columnText(stmt, 8),
613.                 optionB: SQLiteDB.columnText(stmt, 9),
614.                 optionC: SQLiteDB.columnText(stmt, 10),
615.                 optionD: SQLiteDB.columnText(stmt, 11),
616.                 answer: SQLiteDB.columnText(stmt, 12),
617.                 sourcePdf: SQLiteDB.columnText(stmt, 13),
618.                 page: sqlite3_column_type(stmt, 14) == SQLITE_NULL ? nil : SQLiteDB.columnInt(stmt, 14),
619.                 feedbackGenerated: SQLiteDB.columnInt(stmt, 15),
620.                 answerVerified: SQLiteDB.columnInt(stmt, 16),
621.                 deepseekAnswer: SQLiteDB.columnText(stmt, 17),
622.                 deepseekBackground: SQLiteDB.columnText(stmt, 18),
623.                 deepseekReason: SQLiteDB.columnText(stmt, 19)
624.             ))
625.         }
626. 
627.         // Prefer questions where the *correct* answer is the target lemma.
628.         // This keeps Task 4 aligned: keyword == the word you're trying to pick.
629.         if !lemma.isEmpty {
630.             let preferred = out.filter { q in
631.                 Self.answerMatchesTargetWord(answer: q.answer, targetWord: lemma)
632.             }
633.             if !preferred.isEmpty {
634.                 return Array(preferred.prefix(limit))
635.             }
636.         }
637. 
638.         return out
639.     }
640. 
641.     private static func normalizedComparable(_ s: String) -> String {
642.         var t = s.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
643.         // Collapse whitespace
644.         t = t.split(whereSeparator: { $0.isWhitespace }).joined(separator: " ")
645. 
646.         // Trim leading/trailing punctuation/quotes (so "Indeed," matches "indeed")
647.         let trimSet = CharacterSet.punctuationCharacters
648.             .union(.whitespacesAndNewlines)
649.             .union(CharacterSet(charactersIn: "\"\u{201C}\u{201D}\u{2018}\u{2019}"))
650. 
651.         while let first = t.unicodeScalars.first, trimSet.contains(first) {
652.             t = String(t.unicodeScalars.dropFirst())
653.         }
654.         while let last = t.unicodeScalars.last, trimSet.contains(last) {
655.             t = String(t.unicodeScalars.dropLast())
656.         }
657.         return t
658.     }
659. 
660.     private static func answerMatchesTargetWord(answer: String?, targetWord: String) -> Bool {
661.         let a = normalizedComparable(answer ?? "")
662.         let w = normalizedComparable(targetWord)
663.         guard !a.isEmpty, !w.isEmpty else { return false }
664. 
665.         if a == w { return true }
666. 
667.         // If the answer is longer text (rare), allow whole-word containment.
668.         if w.contains(" ") {
669.             return a.contains(w)
670.         }
671. 
672.         let pattern = "\\b" + NSRegularExpression.escapedPattern(for: w) + "\\b"
673.         let re = (try? NSRegularExpression(pattern: pattern, options: [.caseInsensitive]))
674.         let range = NSRange(location: 0, length: (a as NSString).length)
675.         return re?.firstMatch(in: a, range: range) != nil
676.     }
677. }
678.
```

</details>


---

<sub>⏱️ 2m 16s</sub>

### ✅ `view`

**view the file at /Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Views/Flashcard/FlashcardCardView.swift.**

/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Views/Flashcard/FlashcardCardView.swift

<details>
<summary>54 lines</summary>

```
1. import SwiftUI
2. 
3. struct FlashcardCardView: View {
4.     let card: VocabCard
5.     let cardIndex: Int
6.     let totalCards: Int
7.     let boxLevel: Int
8.     let memoryStatus: MemoryStatus
9.     let isReadOnly: Bool
10.     let onShowAgain: () -> Void
11.     let onGotIt: () -> Void
12. 
13.     @State private var isFlipped = false
14. 
15.     var body: some View {
16.         ZStack {
17.             if !isFlipped {
18.                 FlashcardFrontView(
19.                     card: card,
20.                     cardIndex: cardIndex,
21.                     totalCards: totalCards
22.                 )
23.             } else {
24.                 FlashcardBackView(
25.                     card: card,
26.                     cardIndex: cardIndex,
27.                     totalCards: totalCards,
28.                     boxLevel: boxLevel,
29.                     memoryStatus: memoryStatus,
30.                     isReadOnly: isReadOnly,
31.                     onShowAgain: onShowAgain,
32.                     onGotIt: onGotIt
33.                 )
34.                 .rotation3DEffect(.degrees(180), axis: (x: 0, y: 1, z: 0))
35.             }
36.         }
37.         .rotation3DEffect(
38.             .degrees(isFlipped ? 180 : 0),
39.             axis: (x: 0, y: 1, z: 0),
40.             perspective: 0.75
41.         )
42.         .animation(.spring(response: 0.4, dampingFraction: 0.8), value: isFlipped)
43.         .contentShape(Rectangle())
44.         .onTapGesture {
45.             isFlipped.toggle()
46.         }
47.         .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
48.     }
49. 
50.     func resetFlip() {
51.         isFlipped = false
52.     }
53. }
54.
```

</details>


---

<sub>⏱️ 2m 16s</sub>

### ✅ `view`

**view the file at /Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Views/Flashcard/FlashcardFrontView.swift.**

/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Views/Flashcard/FlashcardFrontView.swift

<details>
<summary>101 lines</summary>

```
1. import SwiftUI
2. 
3. struct FlashcardFrontView: View {
4.     let card: VocabCard
5.     let cardIndex: Int
6.     let totalCards: Int
7. 
8.     var body: some View {
9.         GeometryReader { geo in
10.             ZStack {
11.                 // Full-bleed image
12.                 if let ui = ImageResolver.uiImage(for: card.imageFilename) {
13.                     Image(uiImage: ui)
14.                         .resizable()
15.                         .scaledToFill()
16.                         .frame(width: geo.size.width, height: geo.size.height)
17.                         .clipped()
18.                 } else {
19.                     // Fallback gradient
20.                     LinearGradient(
21.                         colors: [Color(hex: "#4A90D9"), Color(hex: "#2C5F8A")],
22.                         startPoint: .topLeading,
23.                         endPoint: .bottomTrailing
24.                     )
25.                     Text(card.lemma.uppercased())
26.                         .font(.system(size: 32, weight: .black))
27.                         .foregroundColor(.white.opacity(0.3))
28.                 }
29. 
30.                 // Top gradient
31.                 VStack {
32.                     LinearGradient(
33.                         gradient: Gradient(colors: [
34.                             Color.black.opacity(0.4),
35.                             Color.black.opacity(0.0)
36.                         ]),
37.                         startPoint: .top,
38.                         endPoint: .bottom
39.                     )
40.                     .frame(height: 50)
41.                     Spacer()
42.                 }
43. 
44.                 // Bottom gradient for sentence
45.                 VStack {
46.                     Spacer()
47.                     LinearGradient(
48.                         gradient: Gradient(stops: [
49.                             .init(color: .clear, location: 0),
50.                             .init(color: Color.black.opacity(0.12), location: 0.25),
51.                             .init(color: Color.black.opacity(0.45), location: 0.55),
52.                             .init(color: Color.black.opacity(0.78), location: 0.85),
53.                             .init(color: Color.black.opacity(0.88), location: 1.0),
54.                         ]),
55.                         startPoint: .top,
56.                         endPoint: .bottom
57.                     )
58.                     .frame(height: geo.size.height * 0.5)
59.                 }
60. 
61.                 // Sentence overlay
62.                 VStack {
63.                     Spacer()
64.                     if let example = card.example, !example.isEmpty {
65.                         Text(highlightedSentence(example, word: card.lemma))
66.                             .font(.system(size: 22, weight: .medium))
67.                             .foregroundColor(.white.opacity(0.9))
68.                             .lineSpacing(5)
69.                             .padding(.horizontal, 14)
70.                             .padding(.bottom, 6)
71.                             .shadow(color: .black.opacity(0.8), radius: 4, x: 0, y: 1)
72.                     }
73.                     Text("tap to flip \u{00B7} swipe next \u{2192}")
74.                         .font(.system(size: 11, weight: .medium))
75.                         .foregroundColor(.white.opacity(0.45))
76.                         .padding(.horizontal, 10)
77.                         .padding(.vertical, 4)
78.                         .background(Color.black.opacity(0.2))
79.                         .clipShape(Capsule())
80.                         .padding(.bottom, 12)
81.                 }
82. 
83.                 // Top header removed — SessionHeaderView handles this
84.             }
85.         }
86.     }
87. 
88.     private func highlightedSentence(_ text: String, word: String) -> AttributedString {
89.         // Strip markdown bold markers ** from example sentences
90.         let cleanText = text.replacingOccurrences(of: "**", with: "")
91.         var attr = AttributedString(cleanText)
92.         if let range = attr.range(of: word, options: .caseInsensitive) {
93.             attr[range].font = .system(size: 28, weight: .black)
94.             attr[range].foregroundColor = Color(hex: "#FFC800")
95.             attr[range].underlineStyle = .single
96.             attr[range].underlineColor = .init(Color(hex: "#FFC800").opacity(0.4))
97.         }
98.         return attr
99.     }
100. }
101.
```

</details>


---

<sub>⏱️ 2m 16s</sub>

### ✅ `view`

**view the file at /Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Views/Flashcard/FlashcardBackView.swift.**

/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Views/Flashcard/FlashcardBackView.swift

<details>
<summary>205 lines</summary>

```
1. import SwiftUI
2. 
3. struct FlashcardBackView: View {
4.     let card: VocabCard
5.     let cardIndex: Int
6.     let totalCards: Int
7.     let boxLevel: Int
8.     let memoryStatus: MemoryStatus
9.     let isReadOnly: Bool
10.     let onShowAgain: () -> Void
11.     let onGotIt: () -> Void
12. 
13.     var body: some View {
14.         VStack(spacing: 0) {
15.             // Header removed — SessionHeaderView handles this
16. 
17.             ScrollView {
18.                 VStack(alignment: .leading, spacing: 16) {
19.                     // Thumbnail + Word + POS + Strength
20.                     HStack(alignment: .top, spacing: 12) {
21.                         if let ui = ImageResolver.uiImage(for: card.imageFilename) {
22.                             Image(uiImage: ui)
23.                                 .resizable()
24.                                 .scaledToFill()
25.                                 .frame(width: 60, height: 60)
26.                                 .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
27.                         } else {
28.                             RoundedRectangle(cornerRadius: 12, style: .continuous)
29.                                 .fill(Color(hex: "#E8ECF0"))
30.                                 .frame(width: 60, height: 60)
31.                                 .overlay(
32.                                     Text(String(card.lemma.prefix(1)).uppercased())
33.                                         .font(.system(size: 24, weight: .bold))
34.                                         .foregroundColor(Color(hex: "#AFAFAF"))
35.                                 )
36.                         }
37. 
38.                         VStack(alignment: .leading, spacing: 4) {
39.                             Text(card.lemma.uppercased())
40.                                 .font(.system(size: 26, weight: .black, design: .rounded))
41.                                 .foregroundColor(Color(hex: "#FFC800"))
42.                                 .tracking(0.5)
43. 
44.                             if let pos = card.pos, !pos.isEmpty {
45.                                 Text(pos)
46.                                     .font(.system(size: 12, weight: .medium))
47.                                     .foregroundColor(Color(hex: "#AFAFAF"))
48.                             }
49. 
50.                             if boxLevel > 0 {
51.                                 WordStrengthMeter(boxLevel: boxLevel, memoryStatus: memoryStatus)
52.                                     .frame(width: 140)
53.                             }
54.                         }
55.                     }
56.                     .padding(.horizontal, 16)
57. 
58.                     // Definition
59.                     sectionView(label: "DEFINITION") {
60.                         Text(card.definition ?? "")
61.                             .font(.system(size: 24, weight: .semibold))
62.                             .foregroundColor(Color(hex: "#1A1A2E"))
63.                             .lineSpacing(4)
64.                             .fixedSize(horizontal: false, vertical: true)
65.                     }
66. 
67.                     // Example
68.                     if let example = card.example, !example.isEmpty {
69.                         sectionView(label: "EXAMPLE") {
70.                             HStack(spacing: 0) {
71.                                 Rectangle()
72.                                     .fill(Color(hex: "#FFC800"))
73.                                     .frame(width: 4)
74.                                 Text(highlightedExample(example, word: card.lemma))
75.                                     .font(.system(size: 21, weight: .regular))
76.                                     .foregroundColor(Color(hex: "#4B4B4B"))
77.                                     .lineSpacing(4)
78.                                     .padding(12)
79.                             }
80.                             .background(Color(hex: "#FFFDE7"))
81.                             .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
82.                         }
83.                     }
84. 
85.                     // Collocations
86.                     if let collocations = card.collocations, !collocations.isEmpty {
87.                         sectionView(label: "COLLOCATIONS") {
88.                             FlowLayout(spacing: 8) {
89.                                 ForEach(collocations, id: \.self) { phrase in
90.                                     Text(phrase)
91.                                         .font(.system(size: 19, weight: .medium))
92.                                         .foregroundColor(Color(hex: "#4B4B4B"))
93.                                         .padding(.horizontal, 12)
94.                                         .padding(.vertical, 8)
95.                                         .background(Color(hex: "#FFF8E1"))
96.                                         .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
97.                                 }
98.                             }
99.                         }
100.                     }
101. 
102.                     // SAT Context
103.                     if let satContext = card.satContext, !satContext.isEmpty {
104.                         sectionView(label: "SAT CONTEXT") {
105.                             Text(satContext)
106.                                 .font(.system(size: 19, weight: .regular))
107.                                 .foregroundColor(Color(hex: "#666666"))
108.                                 .lineSpacing(3)
109.                                 .fixedSize(horizontal: false, vertical: true)
110.                         }
111.                     }
112.                 }
113.                 .padding(.bottom, 16)
114.             }
115.             .frame(minHeight: UIScreen.main.bounds.height * 0.7 - 80)
116. 
117.             Spacer(minLength: 0)
118. 
119.             // Bottom buttons
120.             VStack(spacing: 6) {
121.                 Text("tap to flip back \u{00B7} swipe \u{2192}")
122.                     .font(.system(size: 11, weight: .medium))
123.                     .foregroundColor(Color(hex: "#AFAFAF"))
124. 
125.                 HStack(spacing: 10) {
126.                     if !isReadOnly {
127.                         Button3D("SHOW AGAIN",
128.                                 color: .white,
129.                                 pressedColor: Color(hex: "#E5E5E5"),
130.                                 textColor: Color(hex: "#AFAFAF"),
131.                                 action: onShowAgain)
132.                     }
133.                     Button3D("GOT IT \u{2192}", action: onGotIt)
134.                 }
135.                 .padding(.horizontal, 16)
136.             }
137.             .padding(.bottom, 12)
138.         }
139.         .background(Color.white)
140.     }
141. 
142.     @ViewBuilder
143.     private func sectionView(label: String, @ViewBuilder content: () -> some View) -> some View {
144.         VStack(alignment: .leading, spacing: 6) {
145.             Text(label)
146.                 .font(.system(size: 10, weight: .semibold, design: .rounded))
147.                 .foregroundColor(Color(hex: "#AFAFAF"))
148.                 .tracking(0.5)
149.             content()
150.         }
151.         .padding(.horizontal, 16)
152.     }
153. 
154.     private func highlightedExample(_ text: String, word: String) -> AttributedString {
155.         let cleanText = text.replacingOccurrences(of: "**", with: "")
156.         var attr = AttributedString(cleanText)
157.         if let range = attr.range(of: word, options: .caseInsensitive) {
158.             attr[range].font = .system(size: 24, weight: .bold)
159.             attr[range].foregroundColor = Color(hex: "#FFC800")
160.         }
161.         return attr
162.     }
163. }
164. 
165. // Simple flow layout for collocations
166. struct FlowLayout: Layout {
167.     var spacing: CGFloat = 6
168. 
169.     func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
170.         let result = arrange(proposal: proposal, subviews: subviews)
171.         return result.size
172.     }
173. 
174.     func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
175.         let result = arrange(proposal: proposal, subviews: subviews)
176.         for (index, origin) in result.origins.enumerated() {
177.             subviews[index].place(at: CGPoint(x: bounds.minX + origin.x, y: bounds.minY + origin.y), proposal: .unspecified)
178.         }
179.     }
180. 
181.     private func arrange(proposal: ProposedViewSize, subviews: Subviews) -> (size: CGSize, origins: [CGPoint]) {
182.         let maxWidth = proposal.width ?? .infinity
183.         var origins: [CGPoint] = []
184.         var x: CGFloat = 0
185.         var y: CGFloat = 0
186.         var rowHeight: CGFloat = 0
187.         var maxX: CGFloat = 0
188. 
189.         for subview in subviews {
190.             let size = subview.sizeThatFits(.unspecified)
191.             if x + size.width > maxWidth && x > 0 {
192.                 x = 0
193.                 y += rowHeight + spacing
194.                 rowHeight = 0
195.             }
196.             origins.append(CGPoint(x: x, y: y))
197.             rowHeight = max(rowHeight, size.height)
198.             x += size.width + spacing
199.             maxX = max(maxX, x)
200.         }
201. 
202.         return (CGSize(width: maxX, height: y + rowHeight), origins)
203.     }
204. }
205.
```

</details>


---

<sub>⏱️ 2m 34s</sub>

### ✅ `view`

**view the file at /Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Models/AdventureSchedule.swift.**

/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Models/AdventureSchedule.swift

<details>
<summary>49 lines</summary>

```
1. import Foundation
2. 
3. enum AdventureSchedule {
4.     static let totalDays = 20
5.     static let daysPerZone = 4
6. 
7.     static let totalZones = totalDays / daysPerZone
8.     
9.     static let zoneNames: [String] = [
10.         "Foundation",
11.         "Cloud Realm",
12.         "Island",
13.         "Space",
14.         "Future City"
15.     ]
16.     
17.     static func zoneTitle(zoneIndex: Int) -> String {
18.         let idx = min(max(0, zoneIndex), totalZones - 1)
19.         let name = zoneNames.indices.contains(idx) ? zoneNames[idx] : "Zone \(idx + 1)"
20.         return "Zone \(idx + 1): \(name)"
21.     }
22. 
23.     static func clampDayIndex(_ dayIndex: Int) -> Int {
24.         min(max(0, dayIndex), totalDays - 1)
25.     }
26. 
27.     static func dayIndexForToday(today: Date = Date()) -> Int {
28.         let cal = Calendar.current
29.         let start = cal.startOfDay(for: LocalIdentity.learningStartDate())
30.         let end = cal.startOfDay(for: today)
31.         let day = cal.dateComponents([.day], from: start, to: end).day ?? 0
32.         return clampDayIndex(day)
33.     }
34. 
35.     static func zoneIndex(forDayIndex dayIndex: Int) -> Int {
36.         let d = clampDayIndex(dayIndex)
37.         return d / daysPerZone
38.     }
39. 
40.     static func dayNumberInZone(forDayIndex dayIndex: Int) -> Int {
41.         let d = clampDayIndex(dayIndex)
42.         return (d % daysPerZone) + 1
43.     }
44. 
45.     static func globalDayNumber(forDayIndex dayIndex: Int) -> Int {
46.         clampDayIndex(dayIndex) + 1
47.     }
48. }
49.
```

</details>


---

<sub>⏱️ 2m 34s</sub>

### ✅ `view`

**view the file at /Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Data/ZoneStore.swift.**

/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Data/ZoneStore.swift

<details>
<summary>99 lines</summary>

```
1. import Foundation
2. import SQLite3
3. 
4. actor ZoneStore {
5.     static let shared = ZoneStore()
6. 
7.     private var db: SQLiteDB { DataManager.shared.db }
8. 
9.     private init() {}
10. 
11.     // MARK: - Zone State
12. 
13.     func getZoneState(userId: String, zoneIndex: Int) throws -> ZoneState? {
14.         let sql = """
15.         SELECT id, user_id, zone_index, unlocked, test_passed, test_attempts, test_best_score
16.         FROM zone_state
17.         WHERE user_id = ? AND zone_index = ?
18.         LIMIT 1;
19.         """
20.         let stmt = try db.prepare(sql)
21.         defer { stmt?.finalize() }
22.         try SQLiteDB.bind(stmt, 1, userId)
23.         try SQLiteDB.bind(stmt, 2, zoneIndex)
24.         if sqlite3_step(stmt) == SQLITE_ROW {
25.             return parseZoneState(stmt)
26.         }
27.         return nil
28.     }
29. 
30.     func isZoneUnlocked(userId: String, zoneIndex: Int) throws -> Bool {
31.         if zoneIndex == 0 { return true }
32.         guard let state = try getZoneState(userId: userId, zoneIndex: zoneIndex) else {
33.             return false
34.         }
35.         return state.unlocked
36.     }
37. 
38.     func unlockZone(userId: String, zoneIndex: Int) throws {
39.         let sql = """
40.         INSERT INTO zone_state(user_id, zone_index, unlocked, unlocked_at)
41.         VALUES (?, ?, 1, datetime('now'))
42.         ON CONFLICT(user_id, zone_index) DO UPDATE SET unlocked = 1, unlocked_at = datetime('now');
43.         """
44.         let stmt = try db.prepare(sql)
45.         defer { stmt?.finalize() }
46.         try SQLiteDB.bind(stmt, 1, userId)
47.         try SQLiteDB.bind(stmt, 2, zoneIndex)
48.         if sqlite3_step(stmt) != SQLITE_DONE {
49.             throw SQLiteError.stepFailed(message: db.errorMessage())
50.         }
51.     }
52. 
53.     func recordTestAttempt(userId: String, zoneIndex: Int, score: Double, passed: Bool) throws {
54.         // Ensure row exists first
55.         let insertSQL = """
56.         INSERT OR IGNORE INTO zone_state(user_id, zone_index, unlocked)
57.         VALUES (?, ?, 0);
58.         """
59.         let s1 = try db.prepare(insertSQL)
60.         defer { s1?.finalize() }
61.         try SQLiteDB.bind(s1, 1, userId)
62.         try SQLiteDB.bind(s1, 2, zoneIndex)
63.         if sqlite3_step(s1) != SQLITE_DONE {
64.             throw SQLiteError.stepFailed(message: db.errorMessage())
65.         }
66. 
67.         let updateSQL = """
68.         UPDATE zone_state
69.         SET test_attempts = test_attempts + 1,
70.             test_best_score = MAX(test_best_score, ?),
71.             test_passed = CASE WHEN ? = 1 THEN 1 ELSE test_passed END
72.         WHERE user_id = ? AND zone_index = ?;
73.         """
74.         let s2 = try db.prepare(updateSQL)
75.         defer { s2?.finalize() }
76.         try SQLiteDB.bind(s2, 1, score)
77.         try SQLiteDB.bind(s2, 2, passed ? 1 : 0)
78.         try SQLiteDB.bind(s2, 3, userId)
79.         try SQLiteDB.bind(s2, 4, zoneIndex)
80.         if sqlite3_step(s2) != SQLITE_DONE {
81.             throw SQLiteError.stepFailed(message: db.errorMessage())
82.         }
83.     }
84. 
85.     // MARK: - Private
86. 
87.     private func parseZoneState(_ stmt: OpaquePointer?) -> ZoneState {
88.         ZoneState(
89.             id: SQLiteDB.columnInt(stmt, 0),
90.             userId: SQLiteDB.columnText(stmt, 1) ?? "",
91.             zoneIndex: SQLiteDB.columnInt(stmt, 2),
92.             unlocked: SQLiteDB.columnInt(stmt, 3) != 0,
93.             testPassed: SQLiteDB.columnInt(stmt, 4) != 0,
94.             testAttempts: SQLiteDB.columnInt(stmt, 5),
95.             testBestScore: SQLiteDB.columnDouble(stmt, 6)
96.         )
97.     }
98. }
99.
```

</details>


---

<sub>⏱️ 2m 35s</sub>

### ℹ️ Notification

Background agent "Review data model" (explore) completed

<details>
<summary>Detail</summary>

Review the Swift implementation in /Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources against /Users/jiong/myprojects/satspell/docs/ui-design-spec.md, focusing only on the data model and config requirements implied by the spec. Inspect models, stores, config, and related view models for day/session state, zone navigation/test availability, review counts, paused session persistence, XP/streak data, and configurable thresholds. Identify mismatches or missing fields/structures versus what the UI spec requires. Return specific findings with file+line references. Do not modify files.

</details>

---

<sub>⏱️ 2m 39s</sub>

### 💬 Copilot

One review track finished; I’m pulling its findings in now while the screen/lifecycle tracks keep running.

---

<sub>⏱️ 2m 39s</sub>

### ✅ `read_agent`

**Explore agent (Review data model)**

<details>
<summary>Arguments</summary>

```json
{
  "agent_id": "data-model-review",
  "wait": true,
  "timeout": 10
}
```

</details>

<details>
<summary>194 lines</summary>

````
Agent completed. agent_id: data-model-review, agent_type: explore, status: completed, description: Review data model, elapsed: 98s, total_turns: 0, duration: 91s

Now let me create a comprehensive report:

## Summary of Findings

I've reviewed the Swift implementation against the UI design spec. Here are the specific mismatches and missing implementations:

### **CRITICAL MISMATCHES**

#### 1. **Missing Practice State Cases in PracticeStateResolver** 
📄 `/Users/jiong/myprojects/satspell/ios/SATVocabApp/Views/Practice/PracticeStateResolver.swift` (lines 3-9)

The spec defines **10 possible states** for the Practice tab (Section 3.2, priority resolver in 3.4):
- State A: Morning Available, Evening Locked
- State B: Paused Session (Resume Card)
- State C: Morning Done, Evening Locked
- State D: Morning Done, Evening Available
- State E: Both Sessions Complete
- **State F1: Recovery Evening (missed last evening only)** ❌ **NOT IMPLEMENTED**
- **State F2: Catch-Up Day (missed 1 full day)** ❌ **NOT IMPLEMENTED**
- **State F3: Re-entry Day (missed 3+ days)** ❌ **NOT IMPLEMENTED**
- **State G: Back-Pressure / Review-Only Day** ❌ **NOT IMPLEMENTED**
- **State H: Late Night Session** ❌ **NOT IMPLEMENTED**

**Current implementation only has 5 cases:** `morningAvailable`, `paused`, `morningDoneEveningLocked`, `eveningAvailable`, `bothComplete`

---

#### 2. **Missing PracticeState Priority Resolver Logic**
📄 `/Users/jiong/myprojects/satspell/ios/SATVocabApp/Views/Practice/PracticeStateResolver.swift` (entire file)

The spec defines (Section 3.4) a **strict 10-step priority order**:
1. Paused session (highest priority) — IMPLEMENTED ✓
2. Missed 3+ days → Re-entry Day — **NOT IMPLEMENTED** ❌
3. Missed 1-2 days → Catch-Up Day — **NOT IMPLEMENTED** ❌
4. Missed evening only → Recovery Evening — **NOT IMPLEMENTED** ❌
5. Back-pressure triggered (overdue > 30) → Review-Only Day — **NOT IMPLEMENTED** ❌
6. Current time ≥ 8 PM and morning not done → Late Night — **NOT IMPLEMENTED** ❌
7. Morning available, evening locked (normal morning) — IMPLEMENTED ✓
8. Morning done, evening locked (waiting) — IMPLEMENTED ✓
9. Morning done, evening unlocked (normal evening) — IMPLEMENTED ✓
10. Both sessions done (day complete) — IMPLEMENTED ✓

**The resolver only checks paused session and basic morning/evening completion, missing 6 critical state transitions.**

---

#### 3. **Missing Day State Flags for Recovery/Catch-Up Determination**
📄 `/Users/jiong/myprojects/satspell/ios/SATVocabApp/Models/Models.swift` (lines 86-103)

The spec requires detecting **missed days** to trigger F1/F2/F3 recovery states. The `DayState` struct has:
- `isRecoveryDay: Bool` (line 101) — vague, not specific to F1/F2/F3
- `isReviewOnlyDay: Bool` (line 102) — conflates multiple states

**Missing context needed:**
- Last session completion timestamp to detect gap duration (F1 = 1 day gap, F2 = 1-2 days, F3 = 3+ days)
- No calculation logic for detecting "missed evening from yesterday" → Recovery Evening state

---

#### 4. **Incomplete PracticeTabViewModel State Resolution**
📄 `/Users/jiong/myprojects/satspell/ios/SATVocabApp/ViewModels/PracticeTabViewModel.swift` (lines 38-41)

```swift
state = PracticeStateResolver.resolve(
    dayState: dayState,
    activeSession: activeSession
)
```

The resolver receives **only 3 inputs** but the spec requires evaluating **7 conditions**:
1. Paused session ✓
2. Days missed (requires historical day state data) ❌
3. Overdue review count for back-pressure ❌
4. Current time for late night check ❌
5. Zone test availability ❌
6. Session completion context ❌

**Missing parameters:**
- `overdueDueCount: Int` (needed for back-pressure state G)
- `now: Date` (present but may not capture all contexts)
- Historical context to detect missed days

---

#### 5. **SessionType Enum Has Recovery Types But No Routes to Them**
📄 `/Users/jiong/myprojects/satspell/ios/SATVocabApp/Models/Enums.swift` (lines 3-13)

Session types exist:
```swift
case recoveryEvening = "recovery_evening"
case catchUp = "catch_up"
case reEntry = "re_entry"
case reviewOnly = "review_only"
```

But `PracticeStateResolver` **never returns these session types** (only returns boolean states like `.paused` or `.bothComplete`). The mismatch is architectural:
- The enum is defined at lines 3-13
- But no `PracticeState` case exists to route to these sessions
- No UI components exist to handle `recoveryEvening`, `catchUp`, `reEntry`, `reviewOnly` session cards

---

### **MISSING CONFIGURATION VALUES**

#### 6. **Missing Config for Back-Pressure Reduced Word Count**
📄 `/Users/jiong/myprojects/satspell/ios/SATVocabApp/Data/AppConfig.swift` (line 52)

Spec line 126: `Back-pressure: reduced count | 12 new ⚙️ | Reduced day`

**Missing:** `static let backPressureReducedNewWords = 12` (or similar)

Current config has thresholds (lines 43-44) but no reduced count value.

---

#### 7. **Missing Config for Flashcard Rush Detection Threshold**
📄 `/Users/jiong/myprojects/satspell/ios/SATVocabApp/Data/AppConfig.swift` (line 52)

Spec line 128: `Rush detection: flashcard min | 3 seconds ⚙️ | Toast trigger`

**Missing:** `static let rushMinFlashcardMs = 3000`

Current config has:
- `rushMinGameMs = 1000` (line 46) ✓
- `rushMinSATMs = 3000` (line 47) ✓
- **No flashcard threshold** ❌

---

#### 8. **Missing Config for Background Resume Threshold**
📄 `/Users/jiong/myprojects/satspell/ios/SATVocabApp/Data/AppConfig.swift` (line 52)

Spec line 130: `Background resume threshold | 30 minutes ⚙️ | Resume vs in-place`

**Missing:** `static let backgroundResumeThresholdMinutes = 30`

Current config has no reference to this threshold. Spec Section 5.3 requires:
- < 30 min: resume in-place (stay on activity screen)
- ≥ 30 min: navigate to Practice tab with Resume card

---

### **MISSING UI STATE AND COMPONENTS**

#### 9. **No Recovery/Catch-Up/Re-entry Banner or Card Components**
📄 `/Users/jiong/myprojects/satspell/ios/SATVocabApp/Views/Practice/` directory

Spec defines components:
- `RecoveryBanner(type:)` (Section 3.3, line 429) — controls icon, title, subtitle, gradient
- `RecoverySessionCard(type:)` (Section 3.3, line 430) — controls session structure, button label

**Missing files:**
- No `RecoveryBanner.swift`
- No `RecoverySessionCard.swift`
- No `CatchUpCard.swift`
- No `ReEntryCard.swift`
- No `ReviewOnlyCard.swift`
- No `LateNightCard.swift`

Current Practice view only renders (line 42-98 in PracticeTabView.swift):
- `MorningSessionCard`
- `EveningSessionCard`
- `MorningCompleteCard`
- `EveningCompleteCard`
- `ResumeCard`
- `DayCompleteSummary`

---

#### 10. **No Recovery Enum Type for State Differentiation**
📄 No file found

Spec defines (Section 3.3, lines 421-426):
```swift
enum RecoveryType {
    case recoveryEvening   // F1
    case catchUpDay        // F2
    case reEntryDay        // F3
}
```

**Missing from codebase.** This enum would allow `RecoveryBanner` and `RecoverySessionCard` to customize UI per recovery scenario.

---

### **MISSING SESSION STATE CONTEXT**

#### 11. **DayState Missing Last Session End Timestamp**
📄 `/Users/jiong/myprojects/satspell/ios/SATVocabApp/Models/Models.swift` (lines 86-103)

To determine recovery state (F1/F2/F3), the resolver needs to:
1. Detect if **yesterday's evening was not completed** → F1 (Recovery Evening)
2. Detect if **a full day was missed** (morning not started) → F2 (Catch-Up)
3. Detect if **3+ days missed** → F3 (Re-entry)

**Missing fields in `DayState`:**
- `lastEveningCompletionTime: Date?` — to detect incomplete evening
- No way to query "was yesterday's evening completed?"

Current fields only track completion flags **for the current day**, not historical context to detect gaps.

---

#### 12. **SessionStateStore Missing Daily Gap Detection Methods**
📄 `/Users/jiong/myprojects/satspell/ios/SATVocabApp/Data/SessionStateStore.swift`

The store has methods like `getCurrentDayState()` but **no methods to**:
- Get the **previous day's state** to detect gaps
- Detect **missed session sequence** (days passed since last study)
- Calculate **days since last completion** for F1/F2/F3 detection

Needed methods:
```swift
func getPreviousDayState(userId: String) throws -> DayState?
func getDaysSinceLastStudy(userId: String) throws -> Int
func getLastCompletedDayState(userId: String) throws -> DayState?
```

---

### **MISSING LATE NIGHT STATE DETECTION**

#### 13. **No Late Night Hour Check in PracticeStateResolver**
📄 `/Users/jiong/myprojects/satspell/ios/SATVocabApp/Views/Practice/PracticeStateResolver.swift`

Spec Section 3.2 (State H):
- Triggered when: **current time ≥ 8 PM AND morning not done**
- Config available: `AppConfig.lateNightHour = 20` (line 51 in AppConfig.swift) ✓
- Logic: **NOT IMPLEMENTED** ❌

Current resolver (line 45-68) only checks evening unlock time, not current hour.

---

### **MISSING BACK-PRESSURE STATE DETECTION**

#### 14. **No Back-Pressure Day Logic in PracticeStateResolver**
📄 `/Users/jiong/myprojects/satspell/ios/SATVocabApp/Views/Practice/PracticeStateResolver.swift`

Spec Section 3.2 (State G):
- Triggered when: **overdue review count > 30** (or `backPressureStopAt`)
- Thresholds: `backPressureReduceAt = 18`, `backPressureStopAt = 30` (AppConfig, lines 43-44) ✓
- Logic to check `overdueDueCount`: **NOT IMPLEMENTED** ❌

Resolver never receives overdue count as parameter.

---

### **SUMMARY TABLE**

| Component | Location | Issue | Severity |
|-----------|----------|-------|----------|
| PracticeState enum | PracticeStateResolver.swift:3-9 | Missing 6 of 10 spec states (F1-F3, G, H) | 🔴 CRITICAL |
| PracticeStateResolver | PracticeStateResolver.swift | Missing priority logic for missed days, back-pressure, late night | 🔴 CRITICAL |
| RecoveryType enum | Not found | Missing required enum to differentiate F1/F2/F3 | 🔴 CRITICAL |
| RecoveryBanner view | Not found | Missing component for recovery UI | 🔴 CRITICAL |
| RecoverySessionCard view | Not found | Missing component for recovery UI | 🔴 CRITICAL |
| backPressureReducedNewWords | AppConfig.swift | Missing config value (spec requires "12 new") | 🟡 HIGH |
| rushMinFlashcardMs | AppConfig.swift | Missing config value (spec requires "3 seconds") | 🟡 HIGH |
| backgroundResumeThresholdMinutes | AppConfig.swift | Missing config value (spec requires "30 minutes") | 🟡 HIGH |
| DayState | Models.swift:86-103 | Missing historical context fields to detect missed days | 🟡 HIGH |
| SessionStateStore | SessionStateStore.swift | Missing methods to detect multi-day gaps | 🟡 HIGH |
| PracticeTabViewModel | PracticeTabViewModel.swift | Not passing overdue count to resolver | 🟡 HIGH |

---

**All findings are view-only; no files were modified as requested.**
````

</details>


---

<sub>⏱️ 2m 39s</sub>

### ✅ `read_agent`

**Explore agent (Review screens/actions)**

<details>
<summary>Arguments</summary>

```json
{
  "agent_id": "screen-review",
  "wait": false
}
```

</details>

```
Agent is still running. agent_id: screen-review, agent_type: explore, status: running, description: Review screens/actions, elapsed: 98s, total_turns: 0, tool_calls_completed: 52. You will be automatically notified when this agent completes — no need to poll.
```


---

<sub>⏱️ 2m 39s</sub>

### ✅ `read_agent`

**Explore agent (Review lifecycle edges)**

<details>
<summary>Arguments</summary>

```json
{
  "agent_id": "lifecycle-review",
  "wait": false
}
```

</details>

```
Agent is still running. agent_id: lifecycle-review, agent_type: explore, status: running, description: Review lifecycle edges, elapsed: 98s, total_turns: 0, tool_calls_completed: 51. You will be automatically notified when this agent completes — no need to poll.
```


---

<sub>⏱️ 3m 57s</sub>

### ✅ `view`

**view the file at /Users/jiong/myprojects/satspell/docs/ui-design-spec.md.**

/Users/jiong/myprojects/satspell/docs/ui-design-spec.md (lines 954-999)

<details>
<summary>46 lines</summary>

```
954. ## 9. Zone Test Session
955. 
956. ### 9.1 Structure (reduced from original)
957. 
958. Zone test is a single session, shorter than a normal daily session:
959. 
960. | Step | Activity | Items | Source |
961. |------|----------|-------|--------|
962. | 1 | Quick recall | 10 words ⚙️ | Random sample from all zone words |
963. | 2 | Image-to-word game | 10 rounds ⚙️ | Zone words |
964. | 3 | SAT questions | 5 questions ⚙️ | Zone words |
965. 
966. **Total: 25 items, ~12 minutes.**
967. 
968. ### 9.2 Scoring & Remediation
969. 
970. - Minimum 80% ⚙️ accuracy across all steps to pass
971. - Score shown on completion screen
972. 
973. **Pass:**
974. - Celebration + zone unlock animation + "Zone X Unlocked. New territory."
975. - Words scored correctly are promoted one box level
976. - Share Report offered
977. 
978. **Fail (1st attempt):**
979. - Encouraging message: "Not yet. Let's work on the ones you missed."
980. - Missed words go to Box 1
981. - Student enters **remediation round**: short flashcard review + image game round on ONLY missed words
982. - After remediation, a **focused retest**: 10-item recall test on previously missed words
983. - Pass focused retest (80% ⚙️) → zone unlocks
984. - Fail focused retest → can retry remediation + retest (same day)
985. 
986. **Fail (3rd+ attempt same day):**
987. - Message: "Take a break. These words need time to settle. Try again tomorrow."
988. - Next study day becomes a remediation day for this zone's weak words before retesting
989. 
990. ### 9.3 Zone Test UI Differences
991. 
992. - Header shows: "ZONE 1 TEST" instead of "STEP X OF Y"
993. - Progress bar: purple/indigo fill
994. - Completion screen shows pass/fail verdict prominently
995. - No Share Report on fail (only on pass or daily sessions)
996. 
997. ---
998. 
999. ## 10. Final Review Days (19-20)
```

</details>


---

<sub>⏱️ 3m 57s</sub>

### ✅ `view`

**view the file at /Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Views/Map/ZoneProgressBar.swift.**

/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Views/Map/ZoneProgressBar.swift

<details>
<summary>39 lines</summary>

```
1. import SwiftUI
2. 
3. struct ZoneProgressBar: View {
4.     let familiarCount: Int
5.     let totalCount: Int
6. 
7.     private var progress: Double {
8.         guard totalCount > 0 else { return 0 }
9.         return min(1.0, Double(familiarCount) / Double(totalCount))
10.     }
11. 
12.     var body: some View {
13.         VStack(spacing: 6) {
14.             HStack {
15.                 Text("\(familiarCount)/\(totalCount) words learned")
16.                     .font(.system(.caption, design: .rounded).weight(.semibold))
17.                     .foregroundStyle(.secondary)
18.                 Spacer()
19.                 Text("\(Int(progress * 100))%")
20.                     .font(.system(.caption, design: .rounded).weight(.bold))
21.                     .foregroundStyle(Color(hex: "#58CC02"))
22.             }
23. 
24.             GeometryReader { geo in
25.                 ZStack(alignment: .leading) {
26.                     RoundedRectangle(cornerRadius: 4, style: .continuous)
27.                         .fill(Color.gray.opacity(0.15))
28.                         .frame(height: 8)
29. 
30.                     RoundedRectangle(cornerRadius: 4, style: .continuous)
31.                         .fill(Color(hex: "#58CC02"))
32.                         .frame(width: geo.size.width * progress, height: 8)
33.                 }
34.             }
35.             .frame(height: 8)
36.         }
37.     }
38. }
39.
```

</details>


---

<sub>⏱️ 3m 58s</sub>

### ℹ️ Notification

Background agent "Review lifecycle edges" (explore) completed

<details>
<summary>Detail</summary>

Review the Swift implementation in /Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources against /Users/jiong/myprojects/satspell/docs/ui-design-spec.md, focusing only on pause/resume/recovery and backgrounding edge cases. Inspect views, view models, and persistence/store code that govern pausing, resuming, restoring active sessions, and any recovery flow. Check whether the implementation handles the spec's pause, resume, recovery, rush detection/resume thresholds, evening unlock/let-it-marinate, and app relaunch restoration behavior. Return specific findings with file+line references. Do not modify files.

</details>

---

<sub>⏱️ 4m 0s</sub>

### 💬 Copilot

The lifecycle track just finished too; I’m folding that into the final write-up now.

---

<sub>⏱️ 4m 0s</sub>

### ✅ `read_agent`

**Explore agent (Review lifecycle edges)**

<details>
<summary>Arguments</summary>

```json
{
  "agent_id": "lifecycle-review",
  "wait": true,
  "timeout": 10
}
```

</details>

<details>
<summary>188 lines</summary>

````
Agent completed. agent_id: lifecycle-review, agent_type: explore, status: completed, description: Review lifecycle edges, elapsed: 179s, total_turns: 0, duration: 125s

Perfect. Now let me make a comprehensive summary document with my findings:

## Summary of Findings: Swift Implementation vs. UI Design Spec

### **CRITICAL GAPS IDENTIFIED:**

---

#### **1. MISSING: Background/Relaunch 30-Minute Threshold Logic ⚠️**

**Spec Requirement (Lines 770-775):**
- If app backgrounded < 30 min: Resume in-place (stay on activity screen)
- If app backgrounded ≥ 30 min: Navigate to Practice tab, show Resume card
- If iOS kills app or force-quit: Next launch shows Resume card
- Implementation: Save session state on every `scenePhase` change to `.background`, check elapsed time on launch/foreground

**Current Implementation:** ❌ **NOT IMPLEMENTED**
- No `scenePhase` observer in any view or app-level lifecycle
- No background/foreground handlers
- No `pausedAt` timestamp comparison logic
- `SessionStateStore.swift` stores `pausedAt: Date?` (line 116 in Models.swift, line 334 in SessionStateStore.swift) but it's never used for threshold calculations
- No elapsed time checking on app resume/launch

**Files Missing Implementation:**
- `/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/SATVocabAppApp.swift` (app-level lifecycle)
- `/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Views/Session/SessionFlowView.swift` (no scenePhase observer)

---

#### **2. MISSING: Recovery State Resolution (F1/F2/F3) ⚠️**

**Spec Requirement (Lines 321-415, 417-450):**
- **State F1 (Recovery Evening):** Missed last evening only → Show recovery banner + recovery session
- **State F2 (Catch-Up Day):** Missed 1-2 full days → Catch-up session with reduced new words
- **State F3 (Re-entry Day):** Missed 3+ days → Diagnostic review, review-only
- **Priority Order (Line 434-447):** Paused (B) > F3 > F2 > F1 > Back-pressure (G) > Late Night (H) > A-E states
- Implementation: `PracticeTabStateResolver` evaluates conditions in priority order

**Current Implementation:** ❌ **INCOMPLETE**
- `PracticeState` enum (lines 3-9 in PracticeStateResolver.swift) only defines: `morningAvailable`, `paused`, `morningDoneEveningLocked`, `eveningAvailable`, `bothComplete`
- **Missing states:** F1, F2, F3 (recovery variants), G (back-pressure), H (late night)
- `PracticeStateResolver.resolve()` (lines 12-43) only checks:
  1. Paused session ✓
  2. Both complete ✓
  3. Morning complete → evening unlock time
  4. Morning not done → morning available
- **No logic for:** Recovery detection, catching up missed days, review-only pressure, late-night sessions
- `DayState` model includes `isRecoveryDay`, `isReviewOnlyDay` flags (lines 101-102 in Models.swift) but resolver never reads them
- `SessionType` enum includes `recoveryEvening`, `catchUp`, `reEntry` (lines 7-9 in Enums.swift) but they're never instantiated by resolver

**Files Affected:**
- `/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Views/Practice/PracticeStateResolver.swift` (incomplete implementation)
- `/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/ViewModels/PracticeTabViewModel.swift` (doesn't check recovery conditions)

---

#### **3. MISSING: Recovery Evening Edge Case (Pause During Evening, Resume Next Day) ⚠️**

**Spec Requirement (Lines 777-784):**
- If evening paused and not resumed until next day:
  - Paused evening becomes **Recovery Evening (State F1)**
  - Resume card should show: "🔄 Continue Yesterday's Evening Session"
  - After completing, today's morning becomes available
  - Same-day Box 2 acceleration does NOT apply
  - Words enter Box 1, not Box 2

**Current Implementation:** ❌ **NOT IMPLEMENTED**
- No logic to detect "paused evening + next day" condition
- `ResumeCard.swift` (lines 3-81) shows: "Paused: \(session.sessionType.rawValue.capitalized) Session" (line 21) — static text, doesn't detect "yesterday's session"
- No conversion of paused evening to Recovery Evening state when resumed the next day
- No Box 1 insertion logic for incomplete evening words

---

#### **4. INCOMPLETE: Pause Confirmation Dialog Variation ⚠️**

**Spec Requirement (Lines 724-740):**
- Dialog content varies by progress:
  - < 50% of step: "Pause Session?" + "Progress saved automatically." + KEEP GOING button
  - ≥ 50% of step: "Almost there." + "X left. ~Y min." + FINISH IT button
  - Between steps: "Pause Session?" + step checklist (✓ done, ○ pending) + CONTINUE TO STEP X button
- All variants include: current step, items done/total, estimated time remaining, focus tip

**Current Implementation:** ⚠️ **SIMPLIFIED, NOT SPEC-COMPLIANT**
- `PauseSheet.swift` (lines 3-64) shows **static content only:**
  - Title: "Take a break?" (hardcoded, line 16)
  - Subtitle: "Your progress is saved..." (generic, line 20)
  - No progress calculation or conditional text
  - No step checklist or time estimate
  - Buttons: "Keep Going" + "Pause & Exit" (generic, not context-aware)
- `PauseSheet` is called identically from all step views:
  - `FlashcardStepView.swift` line 113-118
  - `ImageGameStepView.swift` (same pattern)
  - `QuickRecallStepView.swift` (same pattern)
  - `SATQuestionStepView.swift` (same pattern)
- No parameters passed to customize based on step progress

---

#### **5. INCOMPLETE: Resume Card Display ⚠️**

**Spec Requirement (Lines 751-758):**
- Gold border card with:
  - ▶️ icon with gold gradient circle ✓ (line 11-18 in ResumeCard.swift)
  - "Continue [Morning/Evening] Session" text (implemented)
  - "Paused at Step X: [Activity] · Y/Z" — partial (line 23 shows "Step X, Item Y" but not activity type or total items)
  - **Segmented progress bar** (done=green, remaining=gold, unstarted=gray) ❌ **MISSING**
  - **Step activity tags showing remaining steps** ❌ **MISSING**
  - RESUME button (gold 3D) ✓ (line 36-50)
  - "Restart from beginning" text link ❌ **MISSING** (has Start Over button instead, line 52-68)

**Files Affected:**
- `/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Views/Practice/ResumeCard.swift` (incomplete UI)

---

#### **6. INCOMPLETE: Session State Restoration on Resume ⚠️**

**Spec Requirement (Lines 761-764):**
- On RESUME button: 
  1. Read saved step index + item index ✓ (SessionFlowViewModel.loadWords line 102-109)
  2. Navigate directly to that step's view ✓ (SessionFlowView line 35, navigates via SessionFlowViewModel)
  3. Set current item to saved index ✓ (line 108: `resumeItemIndex = existingSession.itemIndex`)
  4. Continue session as normal ✓

**Current Implementation:** ✓ **MOSTLY CORRECT**
- `SessionFlowViewModel.loadWords()` (lines 102-122) correctly:
  - Checks for existing paused session matching sessionType and studyDay
  - Restores `currentStepIndex`, `resumeItemIndex`, `showAgainWordIds`
  - Calls `resumeSession()` to unset paused flag
  - Restores scoring totals from `daily_stats`
- Step views use `startItemIndex` parameter (e.g., FlashcardStepView line 53) to resume at correct position
- **However:** No elapsed-time check for 30-minute threshold (see Gap #1)

---

#### **7. INCOMPLETE: Pause Progress Auto-Save ⚠️**

**Spec Requirement (Lines 742-744):**
1. Save current step index + item index to UserDefaults (or persistent store)
2. Log all completed reviews to SQLite (already done per-item)
3. Navigate back to Practice tab

**Current Implementation:** ⚠️ **Partially implemented in SQLite, missing UserDefaults as spec suggests**
- `SessionFlowViewModel.autoSaveProgress()` (lines 266-277) calls `SessionStateStore.saveProgress()` on each item advance
- `SessionStateStore.saveProgress()` (lines 234-257) updates step/item to SQLite and sets `is_paused = 1` (line 242)
- Reviews are logged per-item (SessionFlowViewModel.recordAnswer calls ReviewLogger)
- **Gap:** Spec suggests UserDefaults as faster fallback, but implementation uses only SQLite (acceptable but different approach)

---

#### **8. INCOMPLETE: Restart Session Semantics ⚠️**

**Spec Requirement (Lines 788-796):**
1. Show confirmation: "Restart session? Your previous answers are kept for practice, but scoring starts fresh."
2. On confirm:
   - Mark previous scored events as `superseded` in review log
   - Only latest attempt's scored events count toward box progression
   - Preserve previous exposure events
   - Clear saved step/item index, start from Step 1 item 0
3. Subtract XP from superseded attempt (net zero until earned back)

**Current Implementation:** ⚠️ **Partially implemented**
- `PracticeTabView.swift` (lines 55-64) implements restart via `discardSession()`:
  ```swift
  try? await SessionStateStore.shared.discardSession(
      userId: vm.userId,
      studyDay: session.studyDay,
      sessionType: session.sessionType
  )
  navigateToSession = session.sessionType
  ```
- `SessionStateStore.discardSession()` (lines 259-273) **deletes entire session from DB**
- **Missing:**
  - Confirmation dialog (spec line 790)
  - `superseded` flag in review log (would require schema change)
  - XP rollback logic (XP is not subtracted)
  - Exposure event preservation (entire session deleted)

---

#### **9. INCOMPLETE: Evening Unlock "Let It Marinate" Message ⚠️**

**Spec References (Lines 101, 201, 245):**
- Evening locked state should show: "Let it marinate. Back at 5 PM." or similar
- Customizable evening unlock time (V1 uses simple toggle)

**Current Implementation:** ⚠️ **Partial**
- `EveningSessionCard.swift` shows lock icon and unlock time (not visible in ResumeCard view, but likely in main card)
- No "Let it marinate" copy visible in code review
- Unlock time calculated in `PracticeStateResolver.calculateEveningUnlock()` (lines 45-68)
- Config has `eveningUnlockHours = 4` and `eveningUnlockFallbackHour = 17` (AppConfig.swift lines 41-42) ✓

---

#### **10. MISSING: Back-Pressure and Late-Night States (G, H) ⚠️**

**Spec Requirement (Lines 380-415, 432-446):**
- **State G (Back-Pressure/Review-Only):** When overdue reviews > threshold (30 items?) → no new words, review-only
- **State H (Late Night):** When current time ≥ 8 PM and morning not done → late night session, no same-day Box 2 acceleration
- **Priority:** Back-pressure (G) comes before late night (H) in resolver

**Current Implementation:** ❌ **NOT IMPLEMENTED**
- No State G or H in `PracticeState` enum (PracticeStateResolver.swift)
- `AppConfig` has placeholders:
  - `backPressureReduceAt = 18` (line 43)
  - `backPressureStopAt = 30` (line 44)
  - `lateNightHour = 20` (line 51)
- These configs are **never referenced** in resolver logic
- No check for overdue review count or current time in `PracticeStateResolver.resolve()`

---

### **SUMMARY TABLE:**

| Feature | Location | Status | Issue |
|---------|----------|--------|-------|
| Pause/Resume Core | SessionStateStore, SessionFlowVM | ✓ Works | Missing 30-min threshold |
| Recovery States (F1/F2/F3) | PracticeStateResolver | ❌ Missing | Enum cases defined but resolver doesn't handle them |
| Recovery Evening Edge Case | PracticeStateResolver, ResumeCard | ❌ Missing | No next-day detection |
| Pause Dialog Variation | PauseSheet | ⚠️ Simplified | Static text, no progress-based variation |
| Resume Card UI | ResumeCard | ⚠️ Incomplete | Missing progress bar, activity tags, "restart" link |
| Session Restoration | SessionFlowViewModel | ✓ Works | No 30-min threshold check |
| Auto-Save on Item Advance | SessionFlowViewModel | ✓ Works | Uses SQLite, not UserDefaults as spec suggests |
| Restart Confirmation | PracticeTabView | ⚠️ Incomplete | No dialog, deletes instead of marking superseded |
| Evening Unlock "Marinate" | EveningSessionCard | ⚠️ Partial | Time calculated correctly, copy unclear |
| Back-Pressure (State G) | PracticeStateResolver | ❌ Missing | Config exists, logic absent |
| Late Night (State H) | PracticeStateResolver | ❌ Missing | Config exists, logic absent |
| scenePhase Handling | App-level | ❌ Missing | No background/foreground lifecycle |

---

### **RECOMMENDED PRIORITY FIXES:**

1. **P0 (Blocker):** Implement 30-minute background threshold + Recovery state priority resolver (Gaps 1, 2, 3, 10)
2. **P1 (Core Loop):** Complete recovery evening edge case, pause dialog variation, restart semantics (Gaps 4, 6, 8)
3. **P2 (Polish):** Resume card UI (progress bar, tags), evening unlock copy (Gaps 5, 9)
````

</details>


---

<sub>⏱️ 4m 0s</sub>

### ✅ `read_agent`

**Explore agent (Review screens/actions)**

<details>
<summary>Arguments</summary>

```json
{
  "agent_id": "screen-review",
  "wait": false
}
```

</details>

```
Agent is still running. agent_id: screen-review, agent_type: explore, status: running, description: Review screens/actions, elapsed: 179s, total_turns: 0, tool_calls_completed: 53. You will be automatically notified when this agent completes — no need to poll.
```


---

<sub>⏱️ 4m 7s</sub>

### 💬 Copilot

I’ve got enough to draft the review already; I’m just giving the screen-inventory pass a last chance to finish so I can fold in any extra mismatches before I save the markdown.

---

<sub>⏱️ 4m 27s</sub>

### ✅ `read_agent`

**Explore agent (Review screens/actions)**

<details>
<summary>Arguments</summary>

```json
{
  "agent_id": "screen-review",
  "wait": true,
  "timeout": 20
}
```

</details>

```
Agent is still running after waiting 20s. agent_id: screen-review, agent_type: explore, status: running, description: Review screens/actions, elapsed: 206s, total_turns: 0, tool_calls_completed: 53, (timed out waiting for completion) You will be automatically notified when this agent completes — no need to poll.
```


---

<sub>⏱️ 4m 7s</sub>

### ✅ `view`

**view the file at /Users/jiong/myprojects/satspell/docs/reviews/.**

/Users/jiong/myprojects/satspell/docs/reviews/

<details>
<summary>8 lines</summary>

```
activities-ui-polished.html
code-review-impl.md
code-review-implementation.md
final-gap-audit.md
plan1-impl-review.md
plan1-implementation-review.md
quick-impl-check.md
schema-audit.md
```

</details>


---

<sub>⏱️ 5m 44s</sub>

### ✅ `apply_patch`

<details>
<summary>Arguments</summary>

```json
"*** Begin Patch\n*** Add File: /Users/jiong/myprojects/satspell/docs/reviews/implementation-review-default-20260412-211754.md\n+# Implementation Review vs `docs/ui-design-spec.md`\n+\n+**Verdict:** The Swift code covers the basic P0 shell, but it does **not** fully match the spec's screen inventory, several required button actions are missing or wired differently, pause/resume/recovery handling is only partial, and the data model still reflects an older/ad hoc flow in a few key places.\n+\n+Two important scope notes from the spec:\n+- `docs/ui-design-spec.md:1025-1060` lists the **full** inventory, including P1/P2 views.\n+- `docs/ui-design-spec.md:1233-1247` narrows P0 to the simpler A-E Practice states and explicitly defers recovery, back-pressure, late-night, bonus practice, rush toasts, and some other pieces.\n+\n+## 1. Screen inventory\n+\n+### What is present\n+- The app has the required 4-tab shell: `RootTabView.swift:14-47` creates Map, Practice, Stats, and Profile tabs.\n+- The main P0 session surfaces exist in some form: `PracticeTabView.swift:41-98`, `ResumeCard.swift:3-81`, `SessionFlowView.swift:30-125`, `FlashcardStepView.swift:38-120`, `ImageGameStepView.swift:24-82`, `QuickRecallStepView.swift:23-79`, `SATQuestionStepView.swift:23-83`, `SessionCompleteView.swift:17-90`, `PauseSheet.swift:8-63`.\n+- The tab bar is hidden during active sessions via `SessionFlowView.swift:124-125`.\n+\n+### Where the inventory diverges\n+- **AdventureMapView is missing major spec surfaces.** The spec requires header badges, context-aware CTA, richer node states, and zone/test gating (`docs/ui-design-spec.md:136-206`). The implementation only renders the zone header, progress bar, and node map (`AdventureMapView.swift:27-126`). There is **no map CTA button at all**.\n+- **Map node states are incomplete.** The spec includes completed, morning-done split, current, available, locked, and zone-test states (`docs/ui-design-spec.md:162-178`). The code only models `.completed`, `.current`, `.available`, `.locked`, and `.zoneTest` (`MapDayNode.swift:4-10`), and `AdventureMapView.swift:165-174` never produces a morning-done split state.\n+- **Practice only implements A-E.** `PracticeStateResolver.swift:3-43` defines and resolves only `morningAvailable`, `paused`, `morningDoneEveningLocked`, `eveningAvailable`, and `bothComplete`. Full-spec states F1/F2/F3/G/H (`docs/ui-design-spec.md:321-447`) and the inventory items that support them (`docs/ui-design-spec.md:1037-1040`) are absent.\n+- **Stats is only a partial redesign.** `StatsView.swift:16-133` renders hero tiles, a box bar, stubborn words, and best streak, but the spec also calls for a weekly calendar, zone progress list, and a zone-mastery drill-down (`docs/ui-design-spec.md:802-870`). There is no `WeeklyCalendarView`, `ZoneMasteryListView`, or tappable zone row.\n+- **Profile is also partial.** `ProfileView.swift:28-211` provides avatar/name editing, sharing, and two toggles, but the V1 layout also requires a danger-zone reset action (`docs/ui-design-spec.md:875-907`), which is missing.\n+- **Zone test is not implemented as specified.** The inventory expects a zone test session plus remediation flow (`docs/ui-design-spec.md:1056-1057`, `954-995`). The shipped view is `ZoneReviewSessionView.swift:16-70`, which is a flashcard-only review of previously incorrect words backed by `ZoneReviewSessionViewModel.swift:28-96`; it is not the 3-step quick-recall/image/SAT test from the spec.\n+- **Parent report card exists only as a simplified renderer.** `ReportCardGenerator.swift:3-49` renders a generic streak/XP card, but the spec calls for a report with sessions, accuracy, mastery bar, stubborn words, and milestone content (`docs/ui-design-spec.md:917-950`).\n+\n+## 2. Button actions\n+\n+### Map / navigation actions\n+- **Day-node tap behavior is wrong.** The spec's current resolution says current-day tap switches to Practice, past days show a read-only summary, future unlocked days are disabled, and locked days do nothing (`docs/ui-design-spec.md:1196-1204`). In code, every non-locked node in an unlocked zone routes to `.day(dayIndex)` (`AdventureMapView.swift:84-103`), and `.day` pushes a new `PracticeTabView()` in the map stack instead of switching the selected tab (`AdventureMapView.swift:129-138`, `RootTabView.swift:11-47`).\n+- **Future unlocked days are incorrectly tappable.** `AdventureMapView.swift:170-174` marks any incomplete day in an unlocked zone as `.available`, and `MapDayNode.swift:128-133` only disables `.locked`.\n+- **Zone test is enterable too early.** The spec says the zone test node is distinct and availability-driven (`docs/ui-design-spec.md:172-178`). The code allows tap whenever the zone is unlocked (`AdventureMapView.swift:111-117`), not when the test is actually available.\n+- **The spec's START/RESUME/RECOVERY map CTA is missing entirely.** Nothing in `AdventureMapView.swift:27-126` corresponds to `docs/ui-design-spec.md:196-206`.\n+\n+### Practice / session actions\n+- **Restart-from-beginning is not implemented as specified.** The spec requires a confirmation dialog and `superseded` scoring semantics (`docs/ui-design-spec.md:451-465`, `786-796`). In code, `PracticeTabView.swift:55-64` directly calls `SessionStateStore.discardSession(...)`, and `SessionStateStore.swift:259-273` deletes the session row. `ReviewLogger.swift:45-60` has a `supersedeSession` helper, but it is never used.\n+- **Both-complete share flow is missing on the Practice tab.** Spec state E includes a share CTA (`docs/ui-design-spec.md:298-318`, `704-707`). The implementation shows `DayCompleteSummary` and `ReviewsDueRow` only (`PracticeTabView.swift:89-97`); `DayCompleteSummary.swift:10-55` has no share button.\n+- **Session-complete share is a placeholder and always visible.** The spec allows sharing only for evening completion or day-complete states, and explicitly says no share on morning-only completion (`docs/ui-design-spec.md:679-707`). `SessionFlowView.swift:31-38` always builds the same `SessionCompleteView`, and `SessionCompleteView.swift:59-74` renders a share button with no action.\n+- **SAT wrong-answer flow does not match the spec.** The spec says wrong SAT answers should show explanation and then advance with NEXT (`docs/ui-design-spec.md:608-613`). In `SATQuestionView.swift:111-127`, wrong answers show a sheet and then reset for another try; only correct answers call `onAnswer(true)` at line 119. Incorrect SAT attempts are never reported upward.\n+- **Stats button actions cannot match because the rows are missing.** The spec expects zone-row navigation (`docs/ui-design-spec.md:860-870`), but `StatsView.swift:16-133` has no zones section to tap.\n+- **Profile reminder toggles are UI-only.** The spec says toggling reminders should request permission and schedule notifications (`docs/ui-design-spec.md:899-907`). The view only mutates `@State` booleans (`ProfileView.swift:12-13`, `136-158`), and there is no notification API usage anywhere in `ios/SATVocabApp/Sources`.\n+- **Profile reset action is missing.** The spec requires a destructive reset flow (`docs/ui-design-spec.md:894-907`), but there is no reset button or reset handler in `ProfileView.swift:28-248`.\n+\n+## 3. Edge cases: pause, resume, recovery\n+\n+### What works\n+- The app does persist session position and can resume at the saved step/item. `SessionFlowViewModel.swift:102-122` restores `currentStepIndex` and `resumeItemIndex`, and each step view accepts `startItemIndex` (`FlashcardStepView.swift:7-10`, `ImageGameStepView.swift:8-12`, `QuickRecallStepView.swift:7-11`, `SATQuestionStepView.swift:7-11`).\n+- Progress is autosaved during a session via `SessionFlowViewModel.swift:264-277` and `SessionStateStore.swift:234-257`.\n+\n+### What is missing or off-spec\n+- **No 30-minute background/foreground policy.** The spec requires in-place resume for short interruptions and a Resume card after longer ones (`docs/ui-design-spec.md:766-775`). There is no `scenePhase` handling in `SATVocabAppApp.swift:7-28`, `SessionFlowView.swift:9-135`, or anywhere else in `Sources`.\n+- **Paused-evening-next-day recovery is not handled.** The spec requires converting that case into Recovery Evening (`docs/ui-design-spec.md:777-784`). `PracticeStateResolver.swift:17-43` has no date-gap or prior-day logic, and `ResumeCard.swift:20-25` only shows generic paused-session text.\n+- **Pause sheet is static, not progress-aware.** The spec varies title, encouragement, and primary action based on step progress (`docs/ui-design-spec.md:724-745`). `PauseSheet.swift:16-57` always shows the same copy and buttons.\n+- **Resume card is much lighter than specified.** The spec calls for a segmented progress bar, step tags, and a text restart link (`docs/ui-design-spec.md:747-764`). `ResumeCard.swift:20-68` only shows a title, \"Step X, Item Y\", a Resume button, and a Start Over button.\n+- **Restart semantics are incomplete.** The spec requires confirmation, `superseded` logs, and XP rollback (`docs/ui-design-spec.md:786-796`). Current behavior just deletes `session_state` (`PracticeTabView.swift:55-64`, `SessionStateStore.swift:259-273`).\n+- **Step transitions do not auto-advance after 3 seconds.** The spec says they should (`docs/ui-design-spec.md:653-677`), but `StepTransitionView.swift:3-61` only offers a manual Continue button.\n+- **Rush detection is effectively unimplemented.** The spec requires timing checks and warnings (`docs/ui-design-spec.md:709-719`). `SessionFlowView.swift:73-75`, `91-93`, and `109-111` always pass `durationMs: 0` into `recordAnswer`, so timing-based logic cannot work; there is also no toast/banner UI in the active flow.\n+\n+## 4. Data model\n+\n+- **The map is still driven by an older 4-task-per-day model, not the spec's day/session model.** `AdventureProgressStore.swift:17-35` stores `[Bool]` task arrays in `UserDefaults`, and `AdventureMapView.swift:87-100` reads those booleans to decide node state. The spec expects map state to come from `DayState` morning/evening completion plus zone/test data (`docs/ui-design-spec.md:1071-1087`).\n+- **Map locking is bypassed in shipping config.** `AppConfig.swift:10-12` sets `unlockAllAdventureForTesting = true`, and `AdventureProgressStore.swift:47-55` short-circuits zone locking when that flag is true. That makes the spec's locked-zone states impossible to exercise.\n+- **Practice-state data is incomplete for full-spec resolution.** `DayState` in `Models.swift:86-103` has only `isRecoveryDay`/`isReviewOnlyDay` booleans, and `PracticeStateResolver.swift:12-43` does not accept overdue counts, prior-day context, or a recovery type. The spec explicitly calls for `RecoveryState` and a priority resolver over multiple overlapping conditions (`docs/ui-design-spec.md:417-447`, `1077-1086`).\n+- **Session composition does not match the required queues.** `SessionFlowViewModel.swift:66-86` defines 12 image-game rounds for morning and evening, but `loadWords()` only fills `newWords` and `morningWords` (`124-143`); `reviewWords` is never populated beyond a stub (`159-164`). As a result, the actual image-game rounds are just one per `newWords` entry (`ImageGameStepView.swift:84-109`), so morning runs 11 rounds and evening 10, not the spec's 12 mixed new/review rounds.\n+- **Zone progress is not zone-scoped.** `AdventureMapView.swift:149-158` computes `familiarCount` from the global box distribution and uses that for the current zone's progress bar, so the displayed value is not \"familiar+ words in this zone\" as required by `docs/ui-design-spec.md:183-184`.\n+- **The report-card model is too thin for the spec.** `ReportCardGenerator.swift:15-49` only consumes `StreakInfo` and `userId`; it does not pull `DailyStats`, mastery distribution, stubborn words, or milestones required by `docs/ui-design-spec.md:923-945`.\n+- **A raw 0-based study-day leaks into the UI.** `PracticeHeader.swift:13-17` renders `Day \\(studyDay)` directly, while map labels use `AdventureSchedule.globalDayNumber(...)` (`AdventureMapView.swift:91`). If `studyDay` is stored 0-based (as implied by `SessionFlowViewModel.swift:125-135` and `AdventureSchedule.swift:45-46`), the Practice tab and completion summary can display \"Day 0\" instead of \"Day 1\".\n+- **Default profile identity does not match the spec.** `LocalIdentity.swift:10-12` defaults the display name to `\"SAT Learner\"`, while the spec's first-launch profile default is `\"Student\"` (`docs/ui-design-spec.md:1094-1100`).\n+\n+## Bottom line\n+\n+- **Screen inventory:** partially aligned for the core P0 shell, but still missing several spec screens and major parts of Map/Stats/Profile/Zone Test.\n+- **Button actions:** several important actions are missing or miswired (map day navigation, map CTA, practice-share, session-share, restart semantics, reminder scheduling, reset progress).\n+- **Pause/resume/recovery:** basic resume works, but the spec's interruption/recovery behavior is only partially implemented.\n+- **Data model:** the Practice/session pipeline mostly uses the new stores, but the Map still relies on old task-based `UserDefaults`, and the session queues/reporting data do not yet support the full spec.\n*** End Patch\n"
```

</details>

```
Added 1 file(s): /Users/jiong/myprojects/satspell/docs/reviews/implementation-review-default-20260412-211754.md
```


---

<sub>⏱️ 5m 44s</sub>

### ℹ️ Notification

Background agent "Review screens/actions" (explore) completed

<details>
<summary>Detail</summary>

Review the Swift implementation in /Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources against /Users/jiong/myprojects/satspell/docs/ui-design-spec.md, focusing only on: (1) screen inventory and screen/state coverage, and (2) button actions/navigation behavior. Identify which Swift files implement the Map, Practice, Stats, Profile, session, and completion screens. Compare them to the UI spec sections, especially tab structure, map behavior, practice states/cards, and session step screens. Return a concise review with concrete mismatches and file+line references from the Swift code and spec section references where helpful. Do not modify files.

</details>

---

<sub>⏱️ 5m 48s</sub>

### 💬 Copilot

The last review track finished after I saved the first draft. I’m reading it now and will only adjust the markdown if it surfaces anything materially new.

---

<sub>⏱️ 5m 48s</sub>

### ✅ `read_agent`

**Explore agent (Review screens/actions)**

<details>
<summary>Arguments</summary>

```json
{
  "agent_id": "screen-review",
  "wait": true,
  "timeout": 10
}
```

</details>

<details>
<summary>9 lines</summary>

```
Output too large to read at once (20.8 KB). Saved to: /var/folders/lw/yv880yw12w36hj114qn16_g00000gn/T/1776043423917-copilot-tool-output-e2qjtm.txt
Consider using tools like grep (for searching), head/tail (for viewing start/end), view with view_range (for specific sections), or jq (for JSON) to examine portions of the output.

Preview (first 500 chars):
Agent completed. agent_id: screen-review, agent_type: explore, status: completed, description: Review screens/actions, elapsed: 286s, total_turns: 0, duration: 207s

I'll provide the review directly in text format:

---

# SWIFT IMPLEMENTATION vs UI DESIGN SPEC — COMPREHENSIVE REVIEW

## EXECUTIVE SUMMARY
The Swift implementation covers **core screen structures** (Map, Practice, Stats, Profile, sessions) with the basic 5 practice states present. However, it is **incomplete on 5 critical practice
```

</details>


---

<sub>⏱️ 5m 51s</sub>

### ✅ `view`

**view the file at /var/folders/lw/yv880yw12w36hj114qn16_g00000gn/T/1776043423917-copilot-tool-output-e2qjtm.txt.**

/var/folders/lw/yv880yw12w36hj114qn16_g00000gn/T/1776043423917-copilot-tool-output-e2qjtm.txt (lines 1-220)

<details>
<summary>220 lines</summary>

````
1. Agent completed. agent_id: screen-review, agent_type: explore, status: completed, description: Review screens/actions, elapsed: 286s, total_turns: 0, duration: 207s
2. 
3. I'll provide the review directly in text format:
4. 
5. ---
6. 
7. # SWIFT IMPLEMENTATION vs UI DESIGN SPEC — COMPREHENSIVE REVIEW
8. 
9. ## EXECUTIVE SUMMARY
10. The Swift implementation covers **core screen structures** (Map, Practice, Stats, Profile, sessions) with the basic 5 practice states present. However, it is **incomplete on 5 critical practice states and several edge cases** defined in the spec. Key gaps: Recovery modes (F1/F2/F3), Back-Pressure (State G), Late Night (State H), weekly calendar, zone word list, rush detection, and bonus practice.
11. 
12. ---
13. 
14. ## 1. TAB BAR STRUCTURE ✅ COMPLETE
15. 
16. **Spec (Section 1.1, lines 13-28):** 4 tabs (Map, Practice, Stats, Profile), hidden during sessions, green (#58CC02) active indicator
17. 
18. **Implementation:** `/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Views/RootTabView.swift` (lines 3-48)
19. - All 4 tabs defined in `enum Tab` ✅
20. - Tab bar hidden via `.toolbar(.hidden, for: .tabBar)` in SessionFlowView (line 124) ✅
21. - Active tab color green (#58CC02) via `.tint()` (line 47) ✅
22. 
23. **STATUS:** ✅ COMPLETE
24. 
25. ---
26. 
27. ## 2. ADVENTURE MAP ✅ COMPLETE
28. 
29. **Spec (Section 2, lines 134-196):** Zone header, day nodes, navigation buttons, tappable days
30. 
31. **Implementation:** `/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Views/AdventureMapView.swift`
32. - Zone header with prev/next navigation (lines 34-59) ✅
33. - ZoneProgressBar component (line 64) ✅
34. - Day nodes with state indicators (lines 84-100) ✅
35. - Tappable day routing (line 100) ✅
36. 
37. **STATUS:** ✅ COMPLETE
38. 
39. ---
40. 
41. ## 3. PRACTICE TAB ⚠️ PARTIAL — 50% COVERAGE
42. 
43. ### SPEC: 10 Possible States (Section 3, lines 227-446)
44. 
45. | State | Name | Swift File | Status |
46. |-------|------|-----------|--------|
47. | **A** | Morning Available, Evening Locked | PracticeStateResolver.swift:4 | ✅ `.morningAvailable` |
48. | **B** | Morning In Progress (Paused) | PracticeStateResolver.swift:5 | ✅ `.paused(session)` |
49. | **C** | Morning Done, Evening Locked | PracticeStateResolver.swift:6 | ✅ `.morningDoneEveningLocked(unlockAt)` |
50. | **D** | Morning Done, Evening Available | PracticeStateResolver.swift:7 | ✅ `.eveningAvailable` |
51. | **E** | Both Sessions Complete | PracticeStateResolver.swift:8 | ✅ `.bothComplete` |
52. | **F1** | Recovery Evening (missed evening only) | PracticeStateResolver.swift | ❌ NOT IN ENUM |
53. | **F2** | Catch-Up Day (missed 1 full day) | PracticeStateResolver.swift | ❌ NOT IN ENUM |
54. | **F3** | Re-entry Day (missed 3+ days) | PracticeStateResolver.swift | ❌ NOT IN ENUM |
55. | **G** | Back-Pressure/Review-Only Day | PracticeStateResolver.swift | ❌ NOT IN ENUM |
56. | **H** | Late Night Session (after 8 PM) | PracticeStateResolver.swift | ❌ NOT IN ENUM |
57. 
58. ### ✅ STATES A-E IMPLEMENTED
59. 
60. **File:** `/Users/jiong/myprojects/satspell/ios/SATVocabApp/Views/Practice/PracticeStateResolver.swift` (lines 3-9)
61. ```swift
62. enum PracticeState {
63.     case morningAvailable                           // A
64.     case paused(SessionState)                       // B
65.     case morningDoneEveningLocked(unlockAt: Date)   // C
66.     case eveningAvailable                           // D
67.     case bothComplete                               // E
68. }
69. ```
70. 
71. **Resolver logic (lines 12-42):**
72. - Priority 1: Paused → State B ✅
73. - Both complete → State E ✅
74. - Morning done, evening unlock calc → C or D ✅
75. - Default → A ✅
76. 
77. **Evening unlock:** 4-hour gap OR 5:00 PM fallback (lines 45-68) ✅
78. 
79. **File:** `/Users/jiong/myprojects/satspell/ios/SATVocabApp/Views/Practice/PracticeTabView.swift` (lines 40-99)
80. - State A: MorningSessionCard + locked evening (lines 42-47) ✅
81. - State B: ResumeCard (lines 49-71) ✅
82. - State C: MorningCompleteCard + locked evening (lines 73-78) ✅
83. - State D: Both cards active (lines 80-86) ✅
84. - State E: Summary + no bonus visible (lines 89-98) ⚠️
85. 
86. ### ❌ STATES F1-H MISSING
87. 
88. **Gap Details:**
89. 
90. 1. **State F1 (Recovery Evening, Spec 321-342):** 
91.    - No enum case; no `RecoveryBanner` or `RecoverySessionCard` components
92.    - SessionType enum HAS `case recoveryEvening` (Enums.swift:7) but never used by resolver
93.    - RecoverySessionCard NOT IN UI layers
94. 
95. 2. **State F2 (Catch-Up Day, Spec 343-363):**
96.    - No enum case; SessionType has `case catchUp` (Enums.swift:8) but unused
97.    - No reduced word count logic (spec: "~50% new words")
98. 
99. 3. **State F3 (Re-entry Day, Spec 365-383):**
100.    - No enum case; SessionType has `case reEntry` (Enums.swift:9) but unused
101.    - No "review-only, no new words" logic
102. 
103. 4. **State G (Back-Pressure, Spec 385-398):**
104.    - No overdue threshold check (spec: > 30 overdue = review-only)
105.    - DayState HAS `isReviewOnlyDay` field (Models.swift:102) but never checked
106.    - SessionType has `case reviewOnly` (Enums.swift:10) but unused
107. 
108. 5. **State H (Late Night, Spec 400-415):**
109.    - No time-of-day check (spec: current time ≥ 8 PM and morning not done)
110.    - No "words enter Box 1, review due tomorrow" logic
111. 
112. **ACTION REQUIRED:**
113. - Update `PracticeState` enum to include F1-H cases
114. - Enhance `PracticeStateResolver` to detect: missed days, overdue count, time-of-day
115. - Create UI components: `RecoveryBanner`, `RecoverySessionCard`, `ReviewSessionCard`, `LateNightSessionCard`
116. - Link SessionType values (recoveryEvening, catchUp, reEntry, reviewOnly) to UI rendering
117. 
118. **STATUS:** ⚠️ **INCOMPLETE** — 5/10 states missing (50%)
119. 
120. ---
121. 
122. ## 4. SESSION FLOW ✅ MOSTLY COMPLETE
123. 
124. ### SESSION STRUCTURE (Spec Lines 470-487)
125. 
126. **Morning: 3 steps** ✅
127. - Step 1: Flashcard (11 words) — `StepType.flashcard` ✅
128. - Step 2: Image Game (12 rounds) — `StepType.imageGame` ✅
129. - Step 3: SAT Questions (3) — `StepType.satQuestion` ✅
130. 
131. **Evening: 4 steps** ✅
132. - Step 1: Flashcard (10 words) — `StepType.flashcard` ✅
133. - Step 2: Quick Recall (11) — `StepType.quickRecall` ✅
134. - Step 3: Image Game (12) — `StepType.imageGame` ✅
135. - Step 4: SAT Questions (2) — `StepType.satQuestion` ✅
136. 
137. **File:** `/Users/jiong/myprojects/satspell/ios/SATVocabApp/ViewModels/SessionFlowViewModel.swift` (lines 66-86) ✅
138. 
139. **Recovery/review sessions (line 81):** "simplified" to generic 2 steps (image game + SAT) — does NOT match spec complexity for F1-F3 ⚠️
140. 
141. **STATUS:** ✅ Morning/evening complete; ⚠️ recovery sessions oversimplified
142. 
143. ### SESSION HEADER ✅ COMPLETE (Spec Lines 493-505)
144. 
145. **File:** `/Users/jiong/myprojects/satspell/ios/SATVocabApp/Views/Session/SessionHeaderView.swift` (lines 1-90)
146. - ✕ close button ✅
147. - "STEP X/Y" label ✅
148. - Activity label + word ✅
149. - Progress bar with proportional fill ✅
150. - 🔊 text-to-speech button ✅
151. 
152. **STATUS:** ✅ COMPLETE
153. 
154. ### STEP 1: FLASHCARD ✅ COMPLETE (Spec Lines 507-549)
155. 
156. **File:** `/Users/jiong/myprojects/satspell/ios/SATVocabApp/Views/Flashcard/FlashcardBackView.swift` (lines 127-133)
157. - "SHOW AGAIN" button ✅ (line 127)
158. - "GOT IT →" button ✅ (line 133)
159. - **Critical:** Spec 546 states these are "soft signals for within-session ordering only. They do NOT affect box progression." — **Implementation correctly treats as non-scoring** ✅
160. 
161. **STATUS:** ✅ COMPLETE
162. 
163. ### STEP 2: IMAGE GAME ⚠️ MOSTLY COMPLETE (Spec Lines 551-580)
164. 
165. **Files:** `ImageGameStepView.swift`, `ImageGameView.swift`
166. - Image + cloze sentence + 2x2 grid ✅
167. - Correct/wrong feedback via `AnswerFeedbackView` ✅
168. - Calls `onAnswer(correct, wordId)` to record score ✅
169. 
170. **Spec line 580:** Minimum response time 1 second check for rush detection — **NOT VISIBLE** in code ⚠️
171. 
172. **STATUS:** ⚠️ MOSTLY COMPLETE (rush check missing)
173. 
174. ### STEP 3: SAT QUESTION ✅ COMPLETE (Spec Lines 582-613)
175. 
176. **Files:** `SATQuestionStepView.swift`, `SATQuestionView.swift`
177. - Passage with warm yellow (#FFF8E1) background ✅
178. - Split scroll: passage scrollable, question fixed ✅
179. - 4 MCQ options with (A)/(B)/(C)/(D) labels ✅
180. - Selected option: blue border ✅
181. - CHECK button (green when selected) ✅
182. 
183. **STATUS:** ✅ COMPLETE
184. 
185. ### STEP 4: QUICK RECALL ✅ MOSTLY COMPLETE (Spec Lines 615-651)
186. 
187. **Files:** `QuickRecallStepView.swift`, `QuickRecallView.swift`
188. - Word display (28px, weight 800) ✅
189. - Definition choices as 3D buttons ✅
190. - Scoring & same-day promotion ✅
191. 
192. **Spec line 621:** "from this morning" label (purple, 11px) — **NOT VISIBLE** in code ⚠️
193. 
194. **STATUS:** ✅ MOSTLY COMPLETE
195. 
196. ### STEP TRANSITION ⚠️ PARTIAL (Spec Lines 653-677)
197. 
198. **File:** `/Users/jiong/myprojects/satspell/ios/SATVocabApp/Views/Session/StepTransitionView.swift` (lines 1-61)
199. - "Step X Complete!" title ✅
200. - Step dots (filled = done) ✅
201. - "UP NEXT" card ✅
202. - CONTINUE button ✅
203. 
204. **Spec line 657:** Celebration emoji (🎉, 💪, 🏆 per step) — **MISSING** ❌
205. 
206. **STATUS:** ⚠️ PARTIAL (emoji missing)
207. 
208. ### SESSION COMPLETE ⚠️ PARTIAL (Spec Lines 679-707)
209. 
210. **File:** `/Users/jiong/myprojects/satspell/ios/SATVocabApp/Views/Session/SessionCompleteView.swift` (lines 1-80)
211. 
212. **Implemented:**
213. - Title: "Session Complete!" (line 22) — not "Done. Your brain just leveled up." ✅
214. - XP earned tile (lines 31-40) ✅
215. - Accuracy stat (line 44) ✅
216. - Promoted/Demoted stats (lines 49-54) ✅
217. - DONE button (line 77) ✅
218. 
219. **Missing:**
220. - Celebration emoji (🎉) ❌
````

</details>


---

<sub>⏱️ 5m 51s</sub>

### ✅ `view`

**view the file at /var/folders/lw/yv880yw12w36hj114qn16_g00000gn/T/1776043423917-copilot-tool-output-e2qjtm.txt.**

/var/folders/lw/yv880yw12w36hj114qn16_g00000gn/T/1776043423917-copilot-tool-output-e2qjtm.txt (lines 221-440)

<details>
<summary>220 lines</summary>

```
221. - Confetti animation (spec 697: "particles falling") ❌
222. - Rotating microcopy variants — currently static "Great work today" ⚠️
223. 
224. **Spec 704-707 — Share Button Visibility:**
225. Spec: Only appears after **evening session complete** OR **State E (both sessions complete)** OR **Profile tab**
226. 
227. Code: SessionCompleteView always shows share button placeholder (lines 60-74) — **NO conditional logic for morning-only** ❌
228. 
229. **ACTION REQUIRED:**
230. - Pass `sessionType` to SessionCompleteView
231. - Hide share button when `sessionType == .morning`
232. 
233. **STATUS:** ⚠️ PARTIAL — missing emoji, confetti, conditional share
234. 
235. ---
236. 
237. ## 5. RUSH DETECTION ❌ NOT IMPLEMENTED (Spec Section 4.9, Lines 709-718)
238. 
239. ### SPEC REQUIREMENT:
240. - Game answer in < 1 second → toast "Too fast. Take a moment."
241. - Quick Recall answer in < 1 second → same toast
242. - SAT question answered in < 3 seconds → toast "Slow down — your brain needs a second."
243. - Non-blocking; rushed answers don't count toward same-day promotion
244. - After 3 rush warnings in session: larger banner (dismissible)
245. 
246. ### SWIFT IMPLEMENTATION:
247. **Search results: ZERO references** to "rushDetection", "rush", or response time validation
248. 
249. **SessionFlowViewModel.recordAnswer():** Records correct/wrong but **no duration_ms check** and **no rush flag**
250. 
251. **GameView files:** No toast component, no response time validation
252. 
253. **ACTION REQUIRED:**
254. - Capture response time in `recordAnswer(duration_ms)`
255. - Create `RushDetectionToast` component
256. - Validate: game/recall < 1s, SAT < 3s
257. - Track rush count per session
258. - Exclude rushed answers from same-day box promotion
259. - Show larger banner after 3 rushes
260. 
261. **STATUS:** ❌ **NOT IMPLEMENTED** (0% coverage)
262. 
263. ---
264. 
265. ## 6. STATS TAB ⚠️ PARTIAL — 67% COVERAGE (Spec Section 6)
266. 
267. ### IMPLEMENTED ✅
268. 
269. **File:** `/Users/jiong/myprojects/satspell/ios/SATVocabApp/Views/StatsView.swift` (lines 1-135)
270. - Hero tiles: Streak (🔥), XP (⚡), Words (📚) (lines 20-23) ✅
271. - Word Strength stacked bar (lines 27-31) ✅
272. - Words Fighting Back list (lines 42-90) ✅
273. - Best Streak stat (lines 92-107) ✅
274. 
275. ### MISSING ❌
276. 
277. 1. **Weekly Calendar (Spec 819-823):**
278.    - "This Week" calendar view (M T W T F S S)
279.    - Day indicators: ✓ (complete), ☀️ (morning-only), ○ (missed)
280.    - Session dots below each day (☀️🌙 pairs)
281.    - **NOT IN CODE** — only stub loading logic
282. 
283. 2. **Zone Progress List (Spec 831-835, 858-859):**
284.    - Zone rows with completion % (familiar+ / total)
285.    - Tappable rows → navigate to zone word list
286.    - **NOT IN CODE** — StatsView has no zone section
287. 
288. 3. **Zone Word List View (Spec 858):**
289.    - Deferred component; should show all words in zone with box levels
290.    - **NOT IMPLEMENTED**
291. 
292. **STATUS:** ⚠️ **PARTIAL** — 67% UI present, weekly calendar + zone navigation missing
293. 
294. ---
295. 
296. ## 7. PROFILE TAB ✅ COMPLETE (Spec Section 7)
297. 
298. **File:** `/Users/jiong/myprojects/satspell/ios/SATVocabApp/Views/ProfileView.swift` (lines 1-300+)
299. 
300. **Implemented:**
301. - Editable avatar & name (lines 34-86) ✅
302. - Streak, XP, Days stats (lines 88-110) ✅
303. - Share Today's Progress button (lines 114-130) ✅
304. - Morning/Evening notification toggles (lines 132-165) ✅
305. - About section (lines 168-180) ✅
306. 
307. **Bonus features (not in spec):**
308. - Avatar emoji picker (21 emojis) ✅
309. - Name editing inline ✅
310. 
311. **STATUS:** ✅ **COMPLETE**
312. 
313. ---
314. 
315. ## 8. PAUSE/RESUME ✅ COMPLETE (Spec Section 5)
316. 
317. **Pause Sheet:** `/Users/jiong/myprojects/satspell/ios/SATVocabApp/Views/Session/PauseSheet.swift` (lines 1-64)
318. - "Take a break?" title ✅
319. - "Your progress is saved" message ✅
320. - Focus tip callout ✅
321. - "Keep Going" + "Pause & Exit" buttons ✅
322. 
323. **Resume Card:** `/Users/jiong/myprojects/satspell/ios/SATVocabApp/Views/Practice/ResumeCard.swift`
324. - Shows paused session (step + item) ✅
325. - [RESUME] button ✅
326. - "Restart from beginning" link ✅
327. 
328. **STATUS:** ✅ **COMPLETE**
329. 
330. ---
331. 
332. ## 9. BUTTON ACTIONS (Spec Sections 3.5, 4.8, 6.3, 7.2)
333. 
334. ### PRACTICE TAB ACTIONS
335. 
336. | Button | Spec Action | Implementation | Status |
337. |--------|-------------|-----------------|--------|
338. | START (morning) | Begin morning → Step 1 | `navigateToSession = .morning` | ✅ |
339. | START (evening) | Begin evening → Step 1 | `navigateToSession = .evening` | ✅ |
340. | RESUME | Navigate to paused step/item | `ResumeCard.onResume` | ✅ |
341. | SHARE TODAY'S | Generate image → share sheet | `ProfileView.generateAndShare()` | ✅ |
342. | RESTART | Clear session → Step 1 | `ResumeCard.onRestart` | ✅ |
343. | START RECOVERY | Begin recovery session (F1) | NOT IMPLEMENTED | ❌ |
344. | START CATCH-UP | Begin catch-up (F2) | NOT IMPLEMENTED | ❌ |
345. | START RE-ENTRY | Begin re-entry review (F3) | NOT IMPLEMENTED | ❌ |
346. | START REVIEW | Begin review-only (State G) | NOT IMPLEMENTED | ❌ |
347. | PRACTICE MORE | Begin bonus session | NOT VISIBLE | ❌ |
348. 
349. **STATUS:** 5/10 actions (50%)
350. 
351. ### STATS TAB ACTIONS
352. 
353. **Spec (line 869):** Zone row → tappable, navigate to zone word list
354. 
355. **Implementation:** No `.navigationDestination` for zones ❌
356. 
357. **STATUS:** 0/1 actions (0%)
358. 
359. ---
360. 
361. ## 10. SCREEN INVENTORY
362. 
363. | Screen / Component | File | Status |
364. |--------------------|------|--------|
365. | RootTabView | RootTabView.swift | ✅ Complete |
366. | Adventure Map | AdventureMapView.swift | ✅ Complete |
367. | Practice Tab (A-E) | PracticeTabView.swift | ⚠️ Partial (missing F-H) |
368. | Practice Header | PracticeHeader.swift | ✅ Complete |
369. | Morning Session Card | MorningSessionCard.swift | ✅ Complete |
370. | Evening Session Card | EveningSessionCard.swift | ✅ Complete |
371. | Resume Card | ResumeCard.swift | ✅ Complete |
372. | Morning Complete Card | MorningCompleteCard.swift | ✅ Complete |
373. | Evening Complete Card | EveningCompleteCard.swift | ✅ Complete |
374. | Day Complete Summary | DayCompleteSummary.swift | ✅ Complete |
375. | **Recovery Banner (F1-F3)** | **NOT FOUND** | ❌ Missing |
376. | **Recovery Session Card** | **NOT FOUND** | ❌ Missing |
377. | **Review Session Card (G)** | **NOT FOUND** | ❌ Missing |
378. | Stats Tab | StatsView.swift | ⚠️ Partial (missing calendar, zones) |
379. | **Weekly Calendar** | **NOT FOUND** | ❌ Missing |
380. | **Zone List** | **NOT FOUND** | ❌ Missing |
381. | **Zone Word List** | **NOT FOUND** | ❌ Missing |
382. | Profile Tab | ProfileView.swift | ✅ Complete |
383. | Session Flow (routing) | SessionFlowView.swift | ✅ Complete |
384. | Session Header | SessionHeaderView.swift | ✅ Complete |
385. | Flashcard Step | FlashcardStepView.swift | ✅ Complete |
386. | Flashcard Card | FlashcardCardView.swift | ✅ Complete |
387. | Flashcard Front | FlashcardFrontView.swift | ✅ Complete |
388. | Flashcard Back | FlashcardBackView.swift | ✅ Complete |
389. | Image Game Step | ImageGameStepView.swift | ⚠️ Partial (no rush check) |
390. | Image Game | ImageGameView.swift | ⚠️ Partial (no rush check) |
391. | SAT Question Step | SATQuestionStepView.swift | ✅ Complete |
392. | SAT Question | SATQuestionView.swift | ✅ Complete |
393. | Quick Recall Step | QuickRecallStepView.swift | ✅ Complete |
394. | Quick Recall | QuickRecallView.swift | ✅ Complete |
395. | Step Transition | StepTransitionView.swift | ⚠️ Partial (missing emoji) |
396. | Session Complete | SessionCompleteView.swift | ⚠️ Partial (missing emoji, confetti, conditional share) |
397. | Answer Feedback | AnswerFeedbackView.swift | ✅ Complete |
398. | Pause Sheet | PauseSheet.swift | ✅ Complete |
399. | **Rush Detection Toast** | **NOT FOUND** | ❌ Missing |
400. 
401. **SCREEN COVERAGE:** 23 of 31 screens = **74%**
402. 
403. ---
404. 
405. ## CRITICAL GAPS & PRIORITY ACTIONS
406. 
407. ### PRIORITY 1: Missing Practice States (F1-H) — **HIGH IMPACT**
408. **Impact:** Students who miss days, hit back-pressure, or study late receive NO guidance
409. **Files to modify:** PracticeStateResolver.swift, PracticeTabView.swift, Models.swift
410. **Components to create:** RecoveryBanner, RecoverySessionCard, ReviewSessionCard, LateNightSessionCard
411. **Estimated effort:** 3-5 days
412. - [ ] Update `PracticeState` enum: add `recovery(RecoveryType)`, `reviewOnly`, `lateNight`
413. - [ ] Extend resolver: check missed days (dayState.isRecoveryDay), overdue count, time-of-day
414. - [ ] Create banner + card components per Spec 3.3
415. - [ ] Render states in PracticeTabView.stateContent switch
416. 
417. ### PRIORITY 2: Rush Detection & Validation — **HIGH IMPACT**
418. **Impact:** Students get no feedback on rushed answers; rushed answers incorrectly count toward promotion
419. **Files to modify:** SessionFlowViewModel.swift, ImageGameView.swift, QuickRecallView.swift, SATQuestionView.swift
420. **Components to create:** RushDetectionToast
421. **Estimated effort:** 2-3 days
422. - [ ] Add `durationMs` parameter to `recordAnswer()`
423. - [ ] Create `RushDetectionToast` component
424. - [ ] Validate response times: game/recall < 1s, SAT < 3s
425. - [ ] Track and show after-3 larger banner
426. - [ ] Exclude rushed answers from same-day promotion logic
427. 
428. ### PRIORITY 3: Stats Tab Calendar & Zone Navigation — **MEDIUM IMPACT**
429. **Impact:** Students can't visualize weekly progress or explore zone details
430. **Files to create:** WeeklyCalendarView.swift, ZoneWordListView.swift
431. **Files to modify:** StatsView.swift
432. **Estimated effort:** 2-3 days
433. - [ ] Create `WeeklyCalendarView` (current week, ✓/☀️/○ indicators, session dots)
434. - [ ] Add zone list section to StatsView
435. - [ ] Create `.navigationDestination` to ZoneWordListView
436. - [ ] Implement zone word list with box levels
437. 
438. ### PRIORITY 4: Session Complete Screen Polish — **MEDIUM IMPACT**
439. **Impact:** Milestone celebrations missing; share button appears inappropriately
440. **Files to modify:** SessionCompleteView.swift
```

</details>


---

<sub>⏱️ 5m 57s</sub>

### ✅ `view`

**view the file at /Users/jiong/myprojects/satspell/docs/reviews/implementation-review-default-20260412-211754.md.**

/Users/jiong/myprojects/satspell/docs/reviews/implementation-review-default-20260412-211754.md

<details>
<summary>74 lines</summary>

```
1. # Implementation Review vs `docs/ui-design-spec.md`
2. 
3. **Verdict:** The Swift code covers the basic P0 shell, but it does **not** fully match the spec's screen inventory, several required button actions are missing or wired differently, pause/resume/recovery handling is only partial, and the data model still reflects an older/ad hoc flow in a few key places.
4. 
5. Two important scope notes from the spec:
6. - `docs/ui-design-spec.md:1025-1060` lists the **full** inventory, including P1/P2 views.
7. - `docs/ui-design-spec.md:1233-1247` narrows P0 to the simpler A-E Practice states and explicitly defers recovery, back-pressure, late-night, bonus practice, rush toasts, and some other pieces.
8. 
9. ## 1. Screen inventory
10. 
11. ### What is present
12. - The app has the required 4-tab shell: `RootTabView.swift:14-47` creates Map, Practice, Stats, and Profile tabs.
13. - The main P0 session surfaces exist in some form: `PracticeTabView.swift:41-98`, `ResumeCard.swift:3-81`, `SessionFlowView.swift:30-125`, `FlashcardStepView.swift:38-120`, `ImageGameStepView.swift:24-82`, `QuickRecallStepView.swift:23-79`, `SATQuestionStepView.swift:23-83`, `SessionCompleteView.swift:17-90`, `PauseSheet.swift:8-63`.
14. - The tab bar is hidden during active sessions via `SessionFlowView.swift:124-125`.
15. 
16. ### Where the inventory diverges
17. - **AdventureMapView is missing major spec surfaces.** The spec requires header badges, context-aware CTA, richer node states, and zone/test gating (`docs/ui-design-spec.md:136-206`). The implementation only renders the zone header, progress bar, and node map (`AdventureMapView.swift:27-126`). There is **no map CTA button at all**.
18. - **Map node states are incomplete.** The spec includes completed, morning-done split, current, available, locked, and zone-test states (`docs/ui-design-spec.md:162-178`). The code only models `.completed`, `.current`, `.available`, `.locked`, and `.zoneTest` (`MapDayNode.swift:4-10`), and `AdventureMapView.swift:165-174` never produces a morning-done split state.
19. - **Practice only implements A-E.** `PracticeStateResolver.swift:3-43` defines and resolves only `morningAvailable`, `paused`, `morningDoneEveningLocked`, `eveningAvailable`, and `bothComplete`. Full-spec states F1/F2/F3/G/H (`docs/ui-design-spec.md:321-447`) and the inventory items that support them (`docs/ui-design-spec.md:1037-1040`) are absent.
20. - **Stats is only a partial redesign.** `StatsView.swift:16-133` renders hero tiles, a box bar, stubborn words, and best streak, but the spec also calls for a weekly calendar, zone progress list, and a zone-mastery drill-down (`docs/ui-design-spec.md:802-870`). There is no `WeeklyCalendarView`, `ZoneMasteryListView`, or tappable zone row.
21. - **Profile is also partial.** `ProfileView.swift:28-211` provides avatar/name editing, sharing, and two toggles, but the V1 layout also requires a danger-zone reset action (`docs/ui-design-spec.md:875-907`), which is missing.
22. - **Zone test is not implemented as specified.** The inventory expects a zone test session plus remediation flow (`docs/ui-design-spec.md:1056-1057`, `954-995`). The shipped view is `ZoneReviewSessionView.swift:16-70`, which is a flashcard-only review of previously incorrect words backed by `ZoneReviewSessionViewModel.swift:28-96`; it is not the 3-step quick-recall/image/SAT test from the spec.
23. - **Parent report card exists only as a simplified renderer.** `ReportCardGenerator.swift:3-49` renders a generic streak/XP card, but the spec calls for a report with sessions, accuracy, mastery bar, stubborn words, and milestone content (`docs/ui-design-spec.md:917-950`).
24. 
25. ## 2. Button actions
26. 
27. ### Map / navigation actions
28. - **Day-node tap behavior is wrong.** The spec's current resolution says current-day tap switches to Practice, past days show a read-only summary, future unlocked days are disabled, and locked days do nothing (`docs/ui-design-spec.md:1196-1204`). In code, every non-locked node in an unlocked zone routes to `.day(dayIndex)` (`AdventureMapView.swift:84-103`), and `.day` pushes a new `PracticeTabView()` in the map stack instead of switching the selected tab (`AdventureMapView.swift:129-138`, `RootTabView.swift:11-47`).
29. - **Future unlocked days are incorrectly tappable.** `AdventureMapView.swift:170-174` marks any incomplete day in an unlocked zone as `.available`, and `MapDayNode.swift:128-133` only disables `.locked`.
30. - **Zone test is enterable too early.** The spec says the zone test node is distinct and availability-driven (`docs/ui-design-spec.md:172-178`). The code allows tap whenever the zone is unlocked (`AdventureMapView.swift:111-117`), not when the test is actually available.
31. - **The spec's START/RESUME/RECOVERY map CTA is missing entirely.** Nothing in `AdventureMapView.swift:27-126` corresponds to `docs/ui-design-spec.md:196-206`.
32. 
33. ### Practice / session actions
34. - **Restart-from-beginning is not implemented as specified.** The spec requires a confirmation dialog and `superseded` scoring semantics (`docs/ui-design-spec.md:451-465`, `786-796`). In code, `PracticeTabView.swift:55-64` directly calls `SessionStateStore.discardSession(...)`, and `SessionStateStore.swift:259-273` deletes the session row. `ReviewLogger.swift:45-60` has a `supersedeSession` helper, but it is never used.
35. - **Both-complete share flow is missing on the Practice tab.** Spec state E includes a share CTA (`docs/ui-design-spec.md:298-318`, `704-707`). The implementation shows `DayCompleteSummary` and `ReviewsDueRow` only (`PracticeTabView.swift:89-97`); `DayCompleteSummary.swift:10-55` has no share button.
36. - **Session-complete share is a placeholder and always visible.** The spec allows sharing only for evening completion or day-complete states, and explicitly says no share on morning-only completion (`docs/ui-design-spec.md:679-707`). `SessionFlowView.swift:31-38` always builds the same `SessionCompleteView`, and `SessionCompleteView.swift:59-74` renders a share button with no action.
37. - **SAT wrong-answer flow does not match the spec.** The spec says wrong SAT answers should show explanation and then advance with NEXT (`docs/ui-design-spec.md:608-613`). In `SATQuestionView.swift:111-127`, wrong answers show a sheet and then reset for another try; only correct answers call `onAnswer(true)` at line 119. Incorrect SAT attempts are never reported upward.
38. - **Stats button actions cannot match because the rows are missing.** The spec expects zone-row navigation (`docs/ui-design-spec.md:860-870`), but `StatsView.swift:16-133` has no zones section to tap.
39. - **Profile reminder toggles are UI-only.** The spec says toggling reminders should request permission and schedule notifications (`docs/ui-design-spec.md:899-907`). The view only mutates `@State` booleans (`ProfileView.swift:12-13`, `136-158`), and there is no notification API usage anywhere in `ios/SATVocabApp/Sources`.
40. - **Profile reset action is missing.** The spec requires a destructive reset flow (`docs/ui-design-spec.md:894-907`), but there is no reset button or reset handler in `ProfileView.swift:28-248`.
41. 
42. ## 3. Edge cases: pause, resume, recovery
43. 
44. ### What works
45. - The app does persist session position and can resume at the saved step/item. `SessionFlowViewModel.swift:102-122` restores `currentStepIndex` and `resumeItemIndex`, and each step view accepts `startItemIndex` (`FlashcardStepView.swift:7-10`, `ImageGameStepView.swift:8-12`, `QuickRecallStepView.swift:7-11`, `SATQuestionStepView.swift:7-11`).
46. - Progress is autosaved during a session via `SessionFlowViewModel.swift:264-277` and `SessionStateStore.swift:234-257`.
47. 
48. ### What is missing or off-spec
49. - **No 30-minute background/foreground policy.** The spec requires in-place resume for short interruptions and a Resume card after longer ones (`docs/ui-design-spec.md:766-775`). There is no `scenePhase` handling in `SATVocabAppApp.swift:7-28`, `SessionFlowView.swift:9-135`, or anywhere else in `Sources`.
50. - **Paused-evening-next-day recovery is not handled.** The spec requires converting that case into Recovery Evening (`docs/ui-design-spec.md:777-784`). `PracticeStateResolver.swift:17-43` has no date-gap or prior-day logic, and `ResumeCard.swift:20-25` only shows generic paused-session text.
51. - **Pause sheet is static, not progress-aware.** The spec varies title, encouragement, and primary action based on step progress (`docs/ui-design-spec.md:724-745`). `PauseSheet.swift:16-57` always shows the same copy and buttons.
52. - **Resume card is much lighter than specified.** The spec calls for a segmented progress bar, step tags, and a text restart link (`docs/ui-design-spec.md:747-764`). `ResumeCard.swift:20-68` only shows a title, "Step X, Item Y", a Resume button, and a Start Over button.
53. - **Restart semantics are incomplete.** The spec requires confirmation, `superseded` logs, and XP rollback (`docs/ui-design-spec.md:786-796`). Current behavior just deletes `session_state` (`PracticeTabView.swift:55-64`, `SessionStateStore.swift:259-273`).
54. - **Step transitions do not auto-advance after 3 seconds.** The spec says they should (`docs/ui-design-spec.md:653-677`), but `StepTransitionView.swift:3-61` only offers a manual Continue button.
55. - **Rush detection is effectively unimplemented.** The spec requires timing checks and warnings (`docs/ui-design-spec.md:709-719`). `SessionFlowView.swift:73-75`, `91-93`, and `109-111` always pass `durationMs: 0` into `recordAnswer`, so timing-based logic cannot work; there is also no toast/banner UI in the active flow.
56. 
57. ## 4. Data model
58. 
59. - **The map is still driven by an older 4-task-per-day model, not the spec's day/session model.** `AdventureProgressStore.swift:17-35` stores `[Bool]` task arrays in `UserDefaults`, and `AdventureMapView.swift:87-100` reads those booleans to decide node state. The spec expects map state to come from `DayState` morning/evening completion plus zone/test data (`docs/ui-design-spec.md:1071-1087`).
60. - **Map locking is bypassed in shipping config.** `AppConfig.swift:10-12` sets `unlockAllAdventureForTesting = true`, and `AdventureProgressStore.swift:47-55` short-circuits zone locking when that flag is true. That makes the spec's locked-zone states impossible to exercise.
61. - **Practice-state data is incomplete for full-spec resolution.** `DayState` in `Models.swift:86-103` has only `isRecoveryDay`/`isReviewOnlyDay` booleans, and `PracticeStateResolver.swift:12-43` does not accept overdue counts, prior-day context, or a recovery type. The spec explicitly calls for `RecoveryState` and a priority resolver over multiple overlapping conditions (`docs/ui-design-spec.md:417-447`, `1077-1086`).
62. - **Session composition does not match the required queues.** `SessionFlowViewModel.swift:66-86` defines 12 image-game rounds for morning and evening, but `loadWords()` only fills `newWords` and `morningWords` (`124-143`); `reviewWords` is never populated beyond a stub (`159-164`). As a result, the actual image-game rounds are just one per `newWords` entry (`ImageGameStepView.swift:84-109`), so morning runs 11 rounds and evening 10, not the spec's 12 mixed new/review rounds.
63. - **Zone progress is not zone-scoped.** `AdventureMapView.swift:149-158` computes `familiarCount` from the global box distribution and uses that for the current zone's progress bar, so the displayed value is not "familiar+ words in this zone" as required by `docs/ui-design-spec.md:183-184`.
64. - **The report-card model is too thin for the spec.** `ReportCardGenerator.swift:15-49` only consumes `StreakInfo` and `userId`; it does not pull `DailyStats`, mastery distribution, stubborn words, or milestones required by `docs/ui-design-spec.md:923-945`.
65. - **A raw 0-based study-day leaks into the UI.** `PracticeHeader.swift:13-17` renders `Day \(studyDay)` directly, while map labels use `AdventureSchedule.globalDayNumber(...)` (`AdventureMapView.swift:91`). If `studyDay` is stored 0-based (as implied by `SessionFlowViewModel.swift:125-135` and `AdventureSchedule.swift:45-46`), the Practice tab and completion summary can display "Day 0" instead of "Day 1".
66. - **Default profile identity does not match the spec.** `LocalIdentity.swift:10-12` defaults the display name to `"SAT Learner"`, while the spec's first-launch profile default is `"Student"` (`docs/ui-design-spec.md:1094-1100`).
67. 
68. ## Bottom line
69. 
70. - **Screen inventory:** partially aligned for the core P0 shell, but still missing several spec screens and major parts of Map/Stats/Profile/Zone Test.
71. - **Button actions:** several important actions are missing or miswired (map day navigation, map CTA, practice-share, session-share, restart semantics, reminder scheduling, reset progress).
72. - **Pause/resume/recovery:** basic resume works, but the spec's interruption/recovery behavior is only partially implemented.
73. - **Data model:** the Practice/session pipeline mostly uses the new stores, but the Map still relies on old task-based `UserDefaults`, and the session queues/reporting data do not yet support the full spec.
74.
```

</details>


---

<sub>⏱️ 5m 58s</sub>

### ✅ `bash`

**Check review file status**

$ cd /Users/jiong/myprojects/satspell && git --no-pager status --short docs/reviews/implementation-review-default-20260412-211754.md

```
?? docs/reviews/implementation-review-default-20260412-211754.md
<exited with exit code 0>
```


---

<sub>⏱️ 6m 4s</sub>

### 💬 Copilot

Saved the review to `docs/reviews/implementation-review-default-20260412-211754.md`.

Main findings: the app has the 4-tab shell and basic P0 session flow, but it diverges from the spec in several important places — the Map is missing its CTA and uses the wrong tap/gating behavior, Practice only implements states A-E, pause/resume exists without the spec’s 30-minute/background/recovery handling, share/restart actions are incomplete, Stats/Profile are only partial, and the data model still mixes the newer `DayState` flow with the older task-based `AdventureProgressStore`.

---

<sub>Generated by [GitHub Copilot CLI](https://github.com/features/copilot/cli)</sub>
