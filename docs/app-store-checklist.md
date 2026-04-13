# WordScholar — App Store Submission Checklist

## Account Status
- [x] Paid Apple Developer Account ($99/year)
- [x] Development certificate: `Apple Development: jiong dai (6CB2D2J3PV)`
- [x] Team ID: `W6BCH2M54V`
- [ ] Distribution certificate (create in Xcode → Settings → Accounts → Manage Certificates)
- [ ] App Store Connect: create new app record for "WordScholar"

## Bundle ID
- Current: `com.satspell.SATVocabApp`
- **Change to:** `com.wordscholar.app` (or `com.daijiong.wordscholar`)
- Update in: `project.yml` → `PRODUCT_BUNDLE_IDENTIFIER`
- Register in Apple Developer Portal → Identifiers

## App Store Listing

### Required Info
- **App Name:** WordScholar
- **Subtitle:** SAT Vocabulary Mastery (30 chars max)
- **Category:** Education
- **Sub-category:** Language Learning
- **Age Rating:** 4+ (no objectionable content)
- **Price:** Free (or $4.99 — typical for SAT prep apps)
- **Privacy Policy URL:** Required — host at daijiong.com or GitHub Pages

### Description (4000 chars max)
```
Master SAT vocabulary with WordScholar — the gamified learning app that makes word mastery fun and effective.

SMART LEARNING
• Leitner 5-box spaced repetition system backed by cognitive science
• Two daily sessions (morning learn + evening review) for optimal retention
• Same-day acceleration — words you nail move up faster

4 ENGAGING ACTIVITIES
• Image Flashcards — vivid photos with example sentences
• Image Game — match words to visual cues
• Quick Recall — fast-paced definition matching
• Real SAT Questions — practice with actual SAT-style passages

ADVENTURE MAP
• Journey through 4 themed zones: Enchanted Forest, Cloud Kingdom, Crystal Caverns, Starlight Summit
• Track progress with XP, streaks, and zone mastery
• Zone tests to prove your knowledge before advancing

PARENT REPORTS
• Send progress reports directly to parents via email
• Track streaks, XP earned, and study consistency

372 carefully curated SAT vocabulary words with images, collocations, SAT contexts, and real practice questions. Built for high school students who want to boost their SAT verbal score.
```

### Keywords (100 chars max)
```
SAT,vocabulary,vocab,spelling,study,flashcard,learn,words,test prep,education,high school,GRE
```

### Screenshots Needed
| Size | Device | Required |
|------|--------|----------|
| 6.7" | iPhone 17 Pro Max | Yes (required) |
| 6.1" | iPhone 17 Pro | Yes (required) |
| 5.5" | iPhone 8 Plus | Optional |

**Screenshot list (6 required, 10 max):**
1. Practice tab — "Day 1" with morning session card
2. Flashcard front — image with word highlighted in sentence
3. Flashcard back — definition, example, collocations, SAT context
4. Image Game — 2x2 grid with cloze sentence
5. SAT Question — passage with 4 options
6. Adventure Map — Enchanted Forest zone with day nodes
7. Profile — avatar, stats, parent email
8. Session Complete — XP earned, accuracy

### App Icon
- 1024×1024 PNG, no transparency, no rounded corners (Apple adds them)
- Design: "W" or "📚" motif with green (#58CC02) and gold (#FFC800) theme
- Need to create and add to `Resources/Assets.xcassets/AppIcon.appiconset/`

## Technical Requirements

### Before Archive
- [ ] Change bundle ID to final one
- [ ] Create Distribution provisioning profile
- [ ] Set version to 1.0.0, build to 1
- [ ] Remove `unlockAllAdventureForTesting` flag entirely
- [ ] Remove all `print()` debug statements
- [ ] Test on iPhone with Release build config
- [ ] Verify no crashes on fresh install (delete app, reinstall)

### Archive & Upload
```bash
# 1. Archive
xcodebuild archive \
  -scheme SATVocabApp \
  -archivePath ~/Desktop/WordScholar.xcarchive \
  -destination 'generic/platform=iOS' \
  -allowProvisioningUpdates

# 2. Export for App Store
xcodebuild -exportArchive \
  -archivePath ~/Desktop/WordScholar.xcarchive \
  -exportPath ~/Desktop/WordScholar-export \
  -exportOptionsPlist ExportOptions.plist \
  -allowProvisioningUpdates

# 3. Upload via xcrun
xcrun altool --upload-app \
  -f ~/Desktop/WordScholar-export/WordScholar.ipa \
  -t ios \
  -u daedal1977@gmail.com \
  -p @keychain:AC_PASSWORD
```

Or just use **Xcode → Product → Archive → Distribute App → App Store Connect**.

## Privacy Policy
Needed even for free apps. Minimal version:

```
WordScholar Privacy Policy

WordScholar stores all learning data locally on your device. 
No personal data is collected or transmitted to our servers.

Optional features:
- Parent email reports: If you enter a parent email address, 
  we send progress reports via email. The email address is stored 
  only on your device and is not shared with third parties.

Contact: self@daijiong.com
Last updated: April 2026
```

Host this at: `https://daijiong.com/wordscholar/privacy` or use GitHub Pages.

## Timeline Estimate
1. Create distribution cert + provisioning profile (10 min)
2. Register bundle ID + create app in App Store Connect (15 min)
3. Take 6-8 screenshots on simulator (30 min)
4. Create app icon (30 min — can use Figma or AI generation)
5. Write listing + upload privacy policy (30 min)
6. Archive + upload build (15 min)
7. Apple review: 24-48 hours typical

**Total active work: ~2-3 hours once privacy policy and icon are ready.**
