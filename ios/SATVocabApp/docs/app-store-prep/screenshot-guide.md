# Screenshot Guide for App Store

## Required Sizes

| Display Size | Device | Resolution | Simulator Name |
|---|---|---|---|
| 6.7" | iPhone 17 Pro Max | 1320 x 2868 | iPhone 17 Pro Max |
| 6.1" | iPhone 17 Pro | 1206 x 2622 | iPhone 17 Pro |

You need screenshots for both sizes. Take 6.7" first, then repeat for 6.1".

## Boot Simulators

```bash
# List available simulators
xcrun simctl list devices available | grep "iPhone 17"

# Boot the 6.7" simulator
xcrun simctl boot "iPhone 17 Pro Max"

# Boot the 6.1" simulator
xcrun simctl boot "iPhone 17 Pro"
```

## Screenshots to Take (8 total)

### 1. Practice Tab - Morning Session Card
**Caption:** "Daily SAT vocab sessions -- morning and evening"
**Navigation:** Launch app, land on Practice tab. Show the morning session card with "Start Morning Session" button.

```bash
xcrun simctl io "iPhone 17 Pro Max" screenshot ~/Desktop/screenshots/01-practice-tab.png
```

### 2. Flashcard - Word Learning
**Caption:** "Learn words with definitions, examples, and pronunciation"
**Navigation:** Start a morning session, reach the flashcard step. Show a word with its definition visible.

```bash
xcrun simctl io "iPhone 17 Pro Max" screenshot ~/Desktop/screenshots/02-flashcard.png
```

### 3. Game Round - Fill in the Blank (Cloze)
**Caption:** "Test your knowledge with interactive games"
**Navigation:** Continue through the session to a cloze/fill-in-the-blank round.

```bash
xcrun simctl io "iPhone 17 Pro Max" screenshot ~/Desktop/screenshots/03-cloze-game.png
```

### 4. SAT Question - Multiple Choice
**Caption:** "Practice with real SAT-style questions"
**Navigation:** Continue to an SAT MCQ round showing a passage and answer choices.

```bash
xcrun simctl io "iPhone 17 Pro Max" screenshot ~/Desktop/screenshots/04-sat-question.png
```

### 5. Adventure Map
**Caption:** "Journey through 4 themed zones across 20 days"
**Navigation:** Tap the Map tab. Show the adventure map with zone background and day nodes.

```bash
xcrun simctl io "iPhone 17 Pro Max" screenshot ~/Desktop/screenshots/05-adventure-map.png
```

### 6. Stats View
**Caption:** "Track streaks, XP, and word strength"
**Navigation:** Tap the Stats tab. Best if some progress exists to show non-zero values.

```bash
xcrun simctl io "iPhone 17 Pro Max" screenshot ~/Desktop/screenshots/06-stats.png
```

### 7. Session Complete
**Caption:** "Earn XP and build streaks with every session"
**Navigation:** Complete a session to reach the SessionCompleteView with XP animation.

```bash
xcrun simctl io "iPhone 17 Pro Max" screenshot ~/Desktop/screenshots/07-session-complete.png
```

### 8. Profile Tab
**Caption:** "Customize your profile and send parent reports"
**Navigation:** Tap the Profile tab. Show avatar, name, notification toggles, and parent report section.

```bash
xcrun simctl io "iPhone 17 Pro Max" screenshot ~/Desktop/screenshots/08-profile.png
```

## Repeat for 6.1" Device

```bash
# Repeat all screenshots on the smaller device
xcrun simctl io "iPhone 17 Pro" screenshot ~/Desktop/screenshots-6.1/01-practice-tab.png
xcrun simctl io "iPhone 17 Pro" screenshot ~/Desktop/screenshots-6.1/02-flashcard.png
xcrun simctl io "iPhone 17 Pro" screenshot ~/Desktop/screenshots-6.1/03-cloze-game.png
xcrun simctl io "iPhone 17 Pro" screenshot ~/Desktop/screenshots-6.1/04-sat-question.png
xcrun simctl io "iPhone 17 Pro" screenshot ~/Desktop/screenshots-6.1/05-adventure-map.png
xcrun simctl io "iPhone 17 Pro" screenshot ~/Desktop/screenshots-6.1/06-stats.png
xcrun simctl io "iPhone 17 Pro" screenshot ~/Desktop/screenshots-6.1/07-session-complete.png
xcrun simctl io "iPhone 17 Pro" screenshot ~/Desktop/screenshots-6.1/08-profile.png
```

## Batch Setup

```bash
# Create output directories
mkdir -p ~/Desktop/screenshots ~/Desktop/screenshots-6.1

# Install and run the app on both simulators
xcrun simctl install "iPhone 17 Pro Max" build/Build/Products/Debug-iphonesimulator/SATVocabApp.app
xcrun simctl launch "iPhone 17 Pro Max" com.WordScholar.WordScholarApp

xcrun simctl install "iPhone 17 Pro" build/Build/Products/Debug-iphonesimulator/SATVocabApp.app
xcrun simctl launch "iPhone 17 Pro" com.WordScholar.WordScholarApp
```

## Tips

- Use the app for a few sessions first so Stats and streaks show meaningful data.
- For the session complete screenshot, complete at least one full session.
- Screenshots should show light mode (the app forces `UIUserInterfaceStyle = Light`).
- Status bar will show simulator time -- set it to a clean time with:
  ```bash
  xcrun simctl status_bar "iPhone 17 Pro Max" override --time "9:41"
  xcrun simctl status_bar "iPhone 17 Pro" override --time "9:41"
  ```
