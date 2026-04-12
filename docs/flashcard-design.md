# Flashcard Design Specification

This document defines the complete flashcard UI, interaction model, and adaptive layout rules. It is a companion to `ui-design-spec.md` and overrides the flashcard section (4.3) in that document.

Reference images for this spec are in `ios/SATVocabApp/Resources/Images/` (768x1344 portrait illustrations, 372 total).

---

## 1. Design Philosophy

The flashcard is **image-first**. The illustration is the mnemonic — the whole reason the image exists is to help the student connect a visual scene to a word's meaning. The image should never be shrunk, cropped into a tiny window, or pushed aside for text.

**Memory link:** Student sees IMAGE → reads SENTENCE with word highlighted → brain connects visual scene to word meaning in context. Definition and details live on the back.

---

## 2. Front Side (Image Hero)

### Layout

```
┌──────────────────────────────────┐
│          [dark gradient]         │
│  ✕         [ 2 / 5 ]        🔊  │  ← Glass pill header
│                                  │
│                                  │
│       [ FULL ILLUSTRATION ]      │  ← Image fills 100%
│         object-fit: cover        │
│                                  │
│                                  │
│          [dark gradient]         │
│  The minimalist design           │
│  reflected a particular          │
│  AESTHETIC philosophy            │  ← Sentence with word highlighted
│  that favored simplicity.        │
│                                  │
│     tap to flip · swipe next →   │  ← Micro hint
└──────────────────────────────────┘
```

### Image

- Fills **100%** of the card area (no frame, no border, no padding)
- `object-fit: cover` — fills width, crops minimally from top/bottom
- `object-position: center 15-25%` — shows upper portion where characters/scenes usually are (configurable per word in DB if needed)
- Image IS the card background — everything else overlays on top

### Top Header (overlaid on image)

- Top gradient: `linear-gradient(rgba(0,0,0,0.4), transparent)`, height 50px
- **✕** button: top left, 13px, white 80% opacity, text-shadow
- **Progress pill**: center, glass effect (`background: rgba(0,0,0,0.35); backdrop-filter: blur(6px)`), shows "2 / 5" in 9px bold white
- **🔊** button: top right, same styling as ✕

### Sentence (overlaid at bottom of image)

- Bottom gradient: covers **50% of image height**, `linear-gradient(transparent 0%, rgba(0,0,0,0.12) 25%, rgba(0,0,0,0.45) 55%, rgba(0,0,0,0.78) 85%, rgba(0,0,0,0.88) 100%)`
- Positioned at bottom of image, left-aligned, 12px padding from edges

**Sentence text:**

| Property | iPhone Pro Max (430pt) | iPhone SE/Mini (375pt) |
|----------|----------------------|----------------------|
| Sentence font | 16px | 13px |
| Sentence weight | 500 | 500 |
| Sentence color | white 90% | white 90% |
| Word font | 20px | 16px |
| Word weight | 900 | 900 |
| Word color | #FFC800 (gold) | #FFC800 (gold) |
| Word decoration | underline, gold 40%, offset 3px | underline, gold 40%, offset 2px |
| Line height | 1.55 | 1.55 |
| Text shadow | `0 1px 4px rgba(0,0,0,0.8), 0 0 8px rgba(0,0,0,0.5)` | same |
| Word text shadow | `0 0 10px rgba(0,0,0,1), 0 2px 4px rgba(0,0,0,0.9), 0 0 20px rgba(255,200,0,0.3)` | same |

**Font ratio:** Word is +4px larger than sentence text (~1.25x ratio). Large enough to pop, small enough to feel part of the sentence.

### Light Image Handling

Some images (e.g., "aesthetic") have light/white backgrounds where white text becomes hard to read.

**Solution:** The bottom gradient is strong enough (builds to 88% black) that even on white images, the text remains readable. Combined with heavy text-shadow on the word (triple-layer including a glow), readability is maintained across all 372 images without per-image adjustment.

**If needed in V1.1:** Add `image_dominant_color` field per word in DB. If dominant color is light, increase gradient start opacity from 12% to 25%. This is an optimization, not required for V1.

### Micro Hint

- At very bottom of card: "tap to flip · swipe for next →"
- 8px, white 45%, subtle background pill `rgba(0,0,0,0.2)`
- Shown on first 3 cards, then hidden (user has learned the gesture)

### Front Side — No Buttons

The front has **no action buttons**. The only interactions are:
- Tap → flip to back
- Swipe left → next card
- Swipe right → previous card
- ✕ → pause confirmation
- 🔊 → pronounce word

---

## 3. Back Side (Details)

### Layout

```
┌──────────────────────────────────┐
│  ✕           2 / 5           🔊  │  ← Header
│                                  │
│  [img]  EPHEMERAL                │  ← Thumbnail + word
│         adj.                     │
│         [██░░░] Rising           │  ← Word Strength meter
│                                  │
│  DEFINITION                      │
│  lasting for only a short        │
│  period of time; transitory      │
│                                  │
│  EXAMPLE                         │
│  ┃ Ephemeral objects like candy  │  ← Gold left border
│  ┃ wrappers are useful as        │
│  ┃ markers of cultural change.   │
│                                  │
│  COLLOCATIONS                    │
│  [ephemeral beauty] [ephemeral   │
│   nature] [ephemeral joy]        │
│                                  │
│  SAT CONTEXT                     │
│  Often appears in passages       │
│  about nature and impermanence.  │
│                                  │
│   tap to flip back · swipe →     │
│  [SHOW AGAIN]    [GOT IT →]     │
└──────────────────────────────────┘
```

### Header

- White background
- Same layout as front: ✕ left (gray), "2 / 5" center, 🔊 right
- No glass effect (white bg, so standard colors)

### Image Thumbnail + Word

- **Thumbnail:** 60px (Max) / 48px (SE), rounded 12px, `object-fit: cover`, same `object-position` as front — maintains visual link to front side
- **Word:** next to thumbnail, 22px (Max) / 18px (SE), weight 900, gold #FFC800, letter-spacing 0.5px
- **Part of speech:** below word, 9px, gray #AFAFAF
- **Word Strength meter:** below part of speech, 5-segment horizontal bar showing current `box_level`

### Word Strength Meter (on card back)

A small 5-segment horizontal bar showing how well the student knows this word:

```
[█░░░░] Locked In    (box_level = 1, red #FF7043)
[██░░░] Rising       (box_level = 2, orange #FFAB40)
[███░░] Strong       (box_level = 3, gold #FFC800)
[████░] Solid        (box_level = 4, green #89E219)
[█████] Mastered     (box_level = 5, green #58CC02)
```

- Width: same as thumbnail + word area (~160px Max / ~130px SE)
- Height: 6px per segment, gap 2px, rounded 3px
- Filled segments use the color for that level
- Empty segments: #E8ECF0 (light gray)
- Below the bar: small label showing current level name (e.g., "Rising") in the level's color, 9px
- If `memory_status` is fragile or stubborn: small dot (🟡 or 🔴) next to the level name
- If box_level = 0 (not yet introduced): meter hidden (word hasn't been scored yet)
- On level-up during a session: the meter briefly animates the new segment filling in (300ms color bloom)

**Data source:** `word_state.box_level` (0-5) and `word_state.memory_status` (easy/normal/fragile/stubborn). Both read from SQLite when loading the card.

### Content Sections

Each section has a **label** (7px, gray, uppercase, letter-spacing 0.5px) and **content** below it.

**Adaptive font sizing:** The back side content should use all available vertical space. SwiftUI should measure the content height and scale fonts up if there is extra blank space, or keep them at minimum sizes if content is long. This prevents the "too much white space" problem with short definitions and the "text overflow" problem with long SAT contexts.

| Section | Min Font (SE) | Default Font (Max) | Max Font (if space allows) | Notes |
|---------|--------------|--------------------|-----------------------------|-------|
| Definition | 11px | 14px | 18px | Weight 600. Most important — scale up first. |
| Example | 10px | 12px | 15px | Gold left border (3px, #FFC800), yellow bg (#FFFDE7), 8px padding. Word highlighted in gold bold. |
| Collocations | 9px | 10px | 12px | Horizontal pill layout. Background #FFF8E1, rounded 6px. |
| SAT Context | 9px | 10px | 13px | Gray text (#666). Lowest priority for scaling. |

**Scaling algorithm (SwiftUI):**
1. Render all sections at default font sizes
2. Measure remaining vertical space in the card
3. If > 40px remaining: scale Definition up first (up to max), then Example, then Collocations, then SAT Context
4. If content overflows: enable ScrollView. Never truncate.
5. Use `ViewThatFits` or `GeometryReader` for measurement

### Buttons (Bottom of Back)

- **"tap to flip back · swipe for next →"** hint: 7px, gray, centered, above buttons
- **SHOW AGAIN** (left): white 3D button, gray text, weight 800, 9px
- **GOT IT →** (right): green 3D (#58CC02), white text, weight 800, 9px
- Both: border-radius 8px, border-bottom 2px solid, padding 7px (Max) / 5px (SE)

**Button behavior:**
- **SHOW AGAIN:** Card is re-queued at the end of the current flashcard step. Brief animation: card slides right and shrinks, indicating it went to the back of the deck. This is a **soft signal** — it does NOT affect box progression directly. However, SHOW AGAIN words are **prioritized in Step 2** (see Section 15).
- **GOT IT →:** Advances to the next card. Same as swiping left. Also a soft signal — not scored.

---

## 4. Gestures & Interactions

| Gesture | Context | Action |
|---------|---------|--------|
| **Tap** (anywhere except buttons) | Front or Back | Flip card (3D rotation Y-axis, 0.4s spring) |
| **Swipe left** | Front or Back | Next card (same as GOT IT) |
| **Swipe right** | Front or Back | Previous card (read-only mode) |
| **Tap SHOW AGAIN** | Back only (current card) | Re-queue card at end of step, show next card |
| **Tap GOT IT →** | Back only | Advance to next card (same as swipe left) |
| **Tap ✕** | Front or Back | Pause confirmation sheet |
| **Tap 🔊** | Front or Back | Pronounce word (AVSpeechSynthesizer, en-US) |

**Flip behavior:**
- Student can flip back and forth freely — no limit
- Each flip toggles front↔back with 3D rotation animation
- When advancing to a new card (swipe or GOT IT), card always starts on front side

**Swipe behavior:**
- Horizontal swipe, minimum 50pt distance
- Left swipe = next, right swipe = previous
- Swipe animation: card slides off screen in swipe direction, next card slides in from opposite side
- Cannot swipe past first card or past last card (bounce)

**Previous card (swipe right) rules:**
- Swiping right shows the previous card in **read-only mode**
- Read-only means: can flip front/back, can tap 🔊, but **no SHOW AGAIN button** — only GOT IT to move forward again
- This prevents: going back to re-SHOW AGAIN cards (would create queue confusion)
- Visual indicator: subtle "reviewed" checkmark on read-only cards so student knows they've passed this one
- Can swipe back through multiple previous cards (all read-only)

---

## 5. Special States

### First Card Tutorial

On the very first flashcard the student ever sees (first session, first card):
- Show a semi-transparent overlay with gesture hints:
  - Hand icon + "Tap to flip" (center)
  - Arrow left + "Swipe for next" (right edge)
- Overlay dismisses on first tap
- Never shown again (stored in UserDefaults)

### Review Cards (from spaced repetition)

When a card appears during review (not first-time learning):
- **Difficulty badge** on front, top-left corner (below header):
  - 🟢 easy: green pill, hidden (no badge for easy — don't clutter)
  - ⚪ normal: no badge
  - 🟡 fragile: yellow pill "fragile" (8px, semi-transparent)
  - 🔴 stubborn: red pill "stubborn" (8px, semi-transparent)
- Badge sits on `rgba(0,0,0,0.4)` background with backdrop blur

### Last Card in Step

When the student reaches the last card:
- After GOT IT or swipe left → transition to Step Transition screen
- If any SHOW AGAIN cards are queued → those cards appear before the transition

### Empty State

If no cards to show (e.g., no review words due):
- Show: "All caught up! No words to review right now."
- Button: "Back to Practice"

---

## 6. Adaptive Layout Rules

### iPhone Size Adaptation

| Property | Pro Max (430pt wide) | SE/Mini (375pt wide) |
|----------|---------------------|---------------------|
| Sentence font | 16px | 13px |
| Word-in-sentence font | 20px | 16px |
| Back: Definition font | 14px (up to 18px) | 11px (up to 14px) |
| Back: Example font | 12px (up to 15px) | 10px (up to 12px) |
| Back: Thumbnail | 60px | 48px |
| Back: Word | 22px | 18px |
| Back: Buttons padding | 7px | 5px |

### Dynamic Type Support

- Back side text content respects Dynamic Type for body text
- Front side sentence: fixed sizes (must fit on image overlay)
- Word highlight: always relative to sentence (+4px)

### Landscape

Not supported in V1. App is portrait-only.

---

## 7. SwiftUI Implementation Notes

### Front Side

```swift
ZStack {
    // Full-bleed image
    Image(uiImage: cardImage)
        .resizable()
        .scaledToFill()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .clipped()
    
    // Top gradient + header
    VStack {
        LinearGradient(...)
            .frame(height: 50)
        Spacer()
    }
    
    // Bottom gradient + sentence
    VStack {
        Spacer()
        LinearGradient(...)
            .frame(height: geo.size.height * 0.5)
    }
    
    // Sentence overlay
    VStack {
        Spacer()
        sentenceView
            .padding(.horizontal, 12)
            .padding(.bottom, 22)
    }
    
    // Header overlay
    VStack {
        headerView
            .padding(.top, safeArea.top + 4)
        Spacer()
    }
}
.contentShape(Rectangle())
.onTapGesture { isFlipped.toggle() }
.gesture(DragGesture for swipe)
```

### Sentence with Highlighted Word

```swift
// Use AttributedString for inline word highlighting
func highlightedSentence(_ text: String, word: String) -> AttributedString {
    var attr = AttributedString(text)
    if let range = attr.range(of: word, options: .caseInsensitive) {
        attr[range].font = .system(size: wordFontSize, weight: .black)
        attr[range].foregroundColor = Color(hex: "#FFC800")
        attr[range].underlineStyle = .single
        attr[range].underlineColor = Color(hex: "#FFC800").opacity(0.4)
    }
    return attr
}
```

### Back Side Adaptive Scaling

```swift
// Use ViewThatFits or GeometryReader to scale content
GeometryReader { geo in
    let availableHeight = geo.size.height - headerHeight - buttonsHeight - thumbnailHeight
    let contentHeight = measureContent(at: defaultFontSizes)
    let scaleFactor = min(availableHeight / contentHeight, maxScale)
    
    ScrollView {
        VStack(alignment: .leading, spacing: scaledSpacing) {
            thumbnailAndWord
            definitionSection(scale: scaleFactor)
            exampleSection(scale: scaleFactor)
            collocationsSection(scale: scaleFactor)
            satContextSection(scale: scaleFactor)
        }
    }
}
```

### 3D Flip

```swift
// Existing rotation3DEffect — keep this
.rotation3DEffect(
    .degrees(isFlipped ? 180 : 0),
    axis: (x: 0, y: 1, z: 0),
    perspective: 0.75
)
// Back content needs counter-rotation to be readable
.rotation3DEffect(.degrees(180), axis: (x: 0, y: 1, z: 0))
```

---

## 8. Data Requirements

Each flashcard needs:

| Field | Source | Used On |
|-------|--------|---------|
| `lemma` (word) | words table | Front (sentence highlight), Back (title) |
| `example` | words table / word_list.json | Front (sentence), Back (example section) |
| `definition` | words table | Back |
| `pos` | words table | Back (under word) |
| `image_filename` | words table | Front (full image), Back (thumbnail) |
| `collocations` | fetched per word | Back |
| `sat_context` | fetched per word | Back |
| `memory_status` | word_states table | Front (difficulty badge on review cards) |
| `object_position` | Optional: new field or default "center 20%" | Front (image positioning) |

---

## 9. Changes from Current Code

| Aspect | Current (`FlashcardView.swift`) | New Design |
|--------|--------------------------------|------------|
| Front layout | Sentence + definition on top, image below | Image fills 100%, sentence overlaid at bottom |
| Front buttons | None (tap anywhere to flip) | Same — no buttons on front |
| Back buttons | Review (red) / Master (green) — scored | Show Again / Got It — NOT scored |
| Back content | Definition, Example, Collocations, SAT Context | Same + image thumbnail + example sentence added |
| Header | Word + pos + sound in toolbar | Progress pill + ✕ + 🔊 overlaid on image |
| Navigation | No swipe support | Swipe left/right for next/previous |
| Image sizing | `resizable(resizingMode: .stretch)` | `scaledToFill().clipped()` — no stretch distortion |
| Highlight color | Brown (.brown) | Gold (#FFC800) |
| Font sizes | 21px sentence, system body definition | 16px sentence, 20px word (Max), adaptive back |

---

## 10. Scoring Clarification

**V1 rule (authoritative, overrides any conflicting language in other docs):**

Flashcards are **fully non-scored**. Nothing that happens during the flashcard step affects box progression, XP, accuracy stats, or Day 1 promotion. Specifically:

- Viewing time: not tracked for scoring (no rush detection on flashcards)
- SHOW AGAIN / GOT IT: soft signals for within-session card ordering only
- Flip count: not tracked
- Swipe direction: not tracked

**Scored events are ONLY in these steps:**
- Image-to-word game (Step 2 morning, Step 3 evening)
- Quick recall (Step 2 evening)
- SAT questions (Step 3 morning, Step 4 evening)

Rush detection (minimum response time checks) applies **only to scored steps**, not flashcards.

---

## 11. Usage Modes

FlashcardView is used in these V1 contexts:

| Context | Source Words | Show Difficulty Badge? | Show SHOW AGAIN? | Notes |
|---------|-------------|----------------------|-------------------|-------|
| Morning Step 1 (new words) | Day's new word batch (11 ⚙️) | No | Yes | Primary learning mode |
| Evening Step 1 (new words) | Day's evening batch (10 ⚙️) | No | Yes | Second batch |
| Recovery Evening | Yesterday's incomplete words | No | Yes | Same view, different word source |
| Catch-Up Day | Missed day's words | No | Yes | Same view |
| Zone Test remediation | Failed zone test words | Yes (🟡🔴) | Yes | Review mode |
| Day 19 Weak Word Blitz | Box 1-2 words | Yes (🟡🔴) | Yes | Review mode |
| Bonus Practice | Box 1-2 words | Yes (🟡🔴) | Yes | Optional extra practice |

**Mode-specific differences:**
- In review modes (remediation, blitz, bonus): difficulty badge shown on front, "from this morning" label not shown
- In new-word modes: no badge, clean front
- Word source changes per mode but FlashcardView itself is identical — only the data passed in differs

---

## 12. Gesture Precedence

When multiple gestures could conflict (especially on back side with ScrollView):

**Priority order (highest wins):**

| Priority | Gesture | Where | Action |
|----------|---------|-------|--------|
| 1 | Tap ✕ button | Top left, both sides | Pause confirmation (44x44pt target) |
| 2 | Tap 🔊 button | Top right / in pill | Pronounce word (44x44pt target) |
| 3 | Tap SHOW AGAIN / GOT IT | Back bottom only | Re-queue or advance |
| 4 | Horizontal swipe (>50pt) | Both sides | Next/previous card |
| 5 | Vertical scroll | Back only (if content overflows) | Scroll content |
| 6 | Tap (anywhere else) | Both sides | Flip card |

**Implementation rules:**
- Back side: use `ScrollView` only when content exceeds available height. When not scrolling, tap-to-flip works everywhere.
- When ScrollView is active: tap on non-scrollable areas (thumbnail, word, empty space) still flips. Tap on scrollable text content scrolls.
- Horizontal swipe takes priority over vertical scroll — use `simultaneousGesture` with direction detection.
- Buttons have explicit `Button` hit areas (min 44x44pt) — taps on buttons do NOT trigger flip.

### Card State Model

Each card in the step has a state:

```
enum CardState {
    case pending     // Not yet shown
    case current     // Currently displayed
    case completed   // GOT IT tapped or swiped past
    case requeued    // SHOW AGAIN tapped — will appear again at end
}
```

**Rules:**
- A card can be requeued **at most once** per step (prevent infinite loops)
- If a requeued card is seen again and SHOW AGAIN is tapped again → treat as GOT IT (advance)
- Swiping back to a completed card shows it in read-only mode (no SHOW AGAIN button, only GOT IT)
- On pause/resume: persist `currentCardIndex` and the list of `requeued` card IDs

---

## 13. Missing Image Fallback

If an image file is missing or fails to load:

**V1 fallback:**
```
┌──────────────────────────────────┐
│                                  │
│    [gradient background using    │
│     word's first letter color]   │
│                                  │
│         EPHEMERAL                │  ← Word centered, large
│                                  │
│    Sentence overlaid at bottom   │
│    (same as normal)              │
│                                  │
└──────────────────────────────────┘
```

- Background: solid gradient based on zone color (Zone 1 = green, Zone 2 = blue, etc.)
- Word displayed large and centered (since no image to show)
- Sentence still overlaid at bottom with same styling
- Back side: thumbnail area shows zone-colored circle with word's first letter (like a contact avatar)

**Implementation:**
```swift
if let ui = ImageResolver.uiImage(for: card.imageFilename) {
    Image(uiImage: ui).resizable().scaledToFill()...
} else {
    // Fallback gradient
    LinearGradient(colors: zoneColors(for: card), ...)
    Text(card.lemma.uppercased())
        .font(.system(size: 32, weight: .black))
        .foregroundColor(.white.opacity(0.3))
}
```

---

## 14. iPhone SE Acceptance Criteria

| Property | Minimum | Maximum |
|----------|---------|---------|
| Sentence lines on front | 1 | 4 (if longer, truncate with "…" and show full on back) |
| Tap target size (✕, 🔊, buttons) | 44x44pt | — |
| Button height | 32pt | — |
| Readable font size | 11px | — |
| Word-in-sentence font | 16px | 20px |
| Image visible area | 85% of card | 100% |
| Back content before scroll needed | Definition + Example minimum visible without scrolling | — |

### First-Time Tutorial

Tutorial overlay dismisses on **either tap or swipe** (matching both primary gestures). Single overlay, not a multi-step tutorial.

---

## 15. SHOW AGAIN → Step 2 Priority

SHOW AGAIN is a soft signal within the flashcard step, but it carries a useful signal: the student self-identified this word as tricky. We use that signal in the **next step** (image-to-word game) to give those words immediate scored practice.

### Flow

```
Step 1: Flashcards (11 cards)
  → Student taps SHOW AGAIN on cards #3, #7, #9
  → Cards #3, #7, #9 re-appear at end of step (re-queue)
  → After all cards seen, Step 1 ends
  → showAgainWords = [#3, #7, #9] passed to Step 2

Step 2: Image-to-Word Game (12 rounds)
  → Normal: 8 new word slots + 4 review word slots
  → With SHOW AGAIN: showAgainWords FILL the "new word" slots first
  → Round composition becomes:
      - Rounds 1-3: SHOW AGAIN words (#3, #7, #9) — immediate practice
      - Rounds 4-8: remaining new words (5 of 8)
      - Rounds 9-12: review words from previous days (4)
  → If more SHOW AGAIN words than new slots (>8): extras go into review slots
```

### Rules

| Scenario | Behavior |
|----------|----------|
| 0 SHOW AGAIN words | Normal Step 2 composition (8 new + 4 review) |
| 1-8 SHOW AGAIN words | Fill new slots first, remaining new slots get other new words |
| 9+ SHOW AGAIN words | All new slots + overflow into review slots |
| All 11 SHOW AGAIN | 11 in game + 1 review word = 12 rounds. Student clearly struggling — system notes this for back-pressure |

### Why This Works

- Student flags a word as tricky → immediately gets **scored practice** on it in the game
- The scored game result feeds into the learning model (box progression, Day 1 promotion)
- No extra tracking system needed — just pass an array from Step 1 to Step 2
- If student never taps SHOW AGAIN, Step 2 works exactly as before

### Data Passed Between Steps

```swift
struct StepResult {
    let showAgainWordIds: [Int]  // From Step 1 → Step 2
}
```

The SessionFlowView orchestrator passes this between steps. No persistence needed — it's session-scoped.

---

## Cross-Check Review — gpt-5.4 (20260411-223820)

### What Looks Good
- The image-first memory model is clear and fits the SAT mnemonic use case well; the front/back split is easy to understand.
- The SwiftUI and data sections are concrete enough to give engineering a strong starting point without overprescribing implementation details.
- Small-vs-large iPhone sizing is thoughtfully covered, which should help the first release feel polished on real devices.

### Issues Found
1. **Flashcard scoring is inconsistent across docs.** This file says Step 1 is exposure-only and the back-side buttons are soft signals, but `learning-model-design.md` and the flashcard rush-detection language in `ui-design-spec.md` still imply flashcard touches can affect Day 1 promotion. **Why it matters:** developers will guess whether dwell time, taps, or buttons change spaced-repetition state. **Suggested fix:** make one V1 rule explicit everywhere: either flashcards are fully non-scored, or define the exact scoring signal.
2. **“Review cards” are specified, but their V1 entry points are unclear.** This doc defines badges and review behavior, while the main session flow frames Step 1 as new-word flashcards. **Why it matters:** it is not clear whether `FlashcardView` is used in remediation, review-only days, weak-word blitz, or only new-word steps. **Suggested fix:** add a short “Where FlashcardView is used” section listing each V1 mode and any mode-specific differences.
3. **Back-side interaction rules are not build-ready.** The back can become a `ScrollView`, but the spec also allows tap-anywhere flip and horizontal swipes on both sides. It does not define gesture priority, whether a revisited card can be re-queued twice, or what state is restored on resume. **Why it matters:** this will cause accidental flips and inconsistent queue behavior. **Suggested fix:** define gesture precedence plus a small card-state model (`current`, `completed`, `requeued`, `revisit`) and list the persisted flashcard-step state.
4. **Readability and asset-failure handling are under-specified.** The spec assumes the gradient/text shadow works across all 372 images and does not say what happens if an image is missing or unusable. **Why it matters:** unreadable text or a blank hero image would break the core mnemonic experience. **Suggested fix:** make a V1 fallback explicit: placeholder art/gradient, a minimum contrast check, and a per-word override path that is not deferred to V1.1.

### Suggestions
- Add a tiny acceptance-criteria table for iPhone SE: max sentence lines, minimum tappable icon size, and button-height floor.
- Let the first-time tutorial dismiss on either tap or swipe so it matches both primary gestures.
