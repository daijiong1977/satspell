# SATVocabApp (SwiftUI + SQLite)

This folder contains the first SwiftUI app implementation wired to your existing SQLite schema (`data.db`) and local images referenced by `words.image_filename`.

## How to run (Xcode)

1) In Xcode: **File → New → Project → iOS → App**
- Product Name: `SATVocabApp`
- Interface: SwiftUI
- Language: Swift

2) Copy these sources into your Xcode project:
- Copy everything from `ios/SATVocabApp/Sources/SATVocabApp/` into your project (keep the folder structure).

3) Add seed database to the app bundle:
- Add `/Users/jidai/sat_spell/data.db` to the Xcode project.
- Ensure it is in **Copy Bundle Resources**.

4) Add images to the app bundle:
- Create a folder reference `Images/` in Xcode (blue folder) and add `/Users/jidai/sat_spell/image/` contents.
- Ensure images are in **Copy Bundle Resources**.

5) Ensure SQLite is linked:
- In Build Phases → **Link Binary With Libraries**, add `libsqlite3.tbd` if needed.

6) Build & run on device/simulator.

## Defaults
- Task 1: Flashcards (10 cards)
- Task 2: Flashcards (10 cards)
- Task 3: Game (5 sets; each set = 1 Cloze + 2 SAT MCQ)
- SAT MCQ uses verified-only questions by default (`answer_verified=1`).

## Notes
- The app reads one random SAT context from `sat_contexts` and reuses it on both sides of the flashcard (image caption on front, SAT Context on back).
- Pronunciation uses on-device `AVSpeechSynthesizer`.
