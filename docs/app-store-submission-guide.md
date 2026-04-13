# WordScholar / SATVocabApp — App Store Submission Guide

This guide is for **this repository's current iOS app** and the workflow where:

1. **You log in** to Apple Developer / App Store Connect in Chrome.
2. **I use `self-chrome-mcp`** to complete the web steps for you.
3. We finish the binary upload in **Xcode**.

---

## 1. Current project facts

From the current project files:

| Item | Current value | Source |
|---|---|---|
| Xcode target | `SATVocabApp` | `ios/SATVocabApp/project.yml` |
| App display name | `WordScholar` | `ios/SATVocabApp/Resources/Info.plist` |
| Main bundle ID | `com.satspell.SATVocabApp` | `ios/SATVocabApp/project.yml` |
| Widget bundle ID | `com.satspell.SATVocabApp.Widgets` | `ios/SATVocabApp/project.yml` |
| Version | `1.0` | `ios/SATVocabApp/Resources/Info.plist` |
| Build | `1` | `ios/SATVocabApp/Resources/Info.plist` |
| Deployment target | `iOS 17.0` | `ios/SATVocabApp/project.yml` |
| Team ID | `W6BCH2M54V` | `ios/SATVocabApp/project.yml` |
| Live Activities | Enabled | `ios/SATVocabApp/Resources/Info.plist` |

**Important:** decide the final bundle ID **before** creating the App Store Connect record. If you want to keep the current shipping ID, use `com.satspell.SATVocabApp`. If you want a cleaner public ID, change the project first, then register that new ID.

---

## 2. What I can do vs. what you need to do

### You do
- Log in to **developer.apple.com**
- Log in to **appstoreconnect.apple.com**
- Approve any Apple 2FA prompts
- Confirm any irreversible choices:
  - final bundle ID
  - final app name
  - pricing / availability
  - whether we are submitting now or just creating the app record

### I do
- Use **`self-chrome-mcp`** to navigate the Apple web portals
- Create or verify the App ID
- Create the App Store Connect app record
- Fill in listing metadata
- Fill in App Privacy answers based on the codebase
- Upload screenshots and app icon in App Store Connect once assets exist

### Still done in Xcode
- Signing / capabilities verification
- Archive
- Upload build to App Store Connect
- Final build selection if not already processed

---

## 3. Minimum things needed before we start

## Required accounts
- Active Apple Developer membership
- Access to App Store Connect for the target team

## Required assets
- **1024 x 1024 app icon** (PNG, no transparency)
- **iPhone screenshots**
  - 6.7" required
  - 6.1" required
- **Privacy Policy URL**
- **Support URL**

## Strongly recommended before submission
- Final app name / subtitle
- Final App Store description
- Keyword list
- Category choice
- Release plan: TestFlight only vs submit for review

---

## 4. Recommended submission order

1. Finalize bundle ID decision.
2. Register the App ID in Apple Developer.
3. Create the app record in App Store Connect.
4. Prepare icon, screenshots, privacy URL, support URL.
5. Fill metadata and App Privacy.
6. Archive/upload a build from Xcode.
7. Attach the build in App Store Connect.
8. Complete export compliance / content rights / age rating.
9. Submit to TestFlight or App Review.

---

## 5. Browser automation workflow with `self-chrome-mcp`

When you are ready, the browser-assisted workflow is:

1. Open Chrome in the profile connected to your MCP setup.
2. Log in to:
   - `https://developer.apple.com/account/`
   - `https://appstoreconnect.apple.com/`
3. Tell me that login is complete.
4. I will then use **`self-chrome-mcp`** to:
   - create or verify the Identifier
   - create the App Store Connect app
   - fill the listing pages
   - upload metadata assets if they already exist locally

**Good handoff message to use later:**

```text
I’m logged into Apple Developer and App Store Connect in Chrome. Use self-chrome-mcp and create the app record with the current bundle ID.
```

---

## 6. App ID registration

## Recommended choice
Use the current bundle ID unless you explicitly want to rename it:

- **Main app:** `com.satspell.SATVocabApp`
- **Widget extension:** `com.satspell.SATVocabApp.Widgets`

## Capabilities to verify
- App ID exists for the main app
- Widget extension App ID exists if the widget target is included in release builds
- Live Activities / ActivityKit capability is aligned with the widget/live activity setup

**Do not create the App Store Connect app before the final bundle ID is settled.**

---

## 7. App Store Connect app record

Recommended initial values:

| Field | Recommended value |
|---|---|
| Platform | iOS |
| Name | `WordScholar` |
| Primary Language | English (U.S.) |
| Bundle ID | `com.satspell.SATVocabApp` unless changed first |
| SKU | `satspell-wordscholar-ios-1` |

---

## 8. Listing draft for this app

These are working defaults; adjust before final submission if you want different marketing language.

## Subtitle

`SAT Vocabulary Practice`

## Category

- Primary: **Education**
- Secondary: **Reference** (optional)

## Description draft

```text
Build stronger SAT vocabulary with WordScholar.

WordScholar helps students learn, review, and retain high-value SAT words through short daily sessions and repeated practice.

Features:
- image-based flashcards
- quick review games
- SAT-style reading questions
- progress tracking with streaks and XP
- structured day-by-day practice flow
- offline-first learning data stored on device

Designed for students who want a more engaging way to strengthen vocabulary for SAT Reading and Writing.
```

## Keywords draft

```text
SAT,vocabulary,study,flashcards,word practice,test prep,reading,writing,education
```

## Promotional text draft

```text
Train SAT vocabulary with daily practice, image flashcards, and SAT-style questions.
```

---

## 9. URLs you still need

The repo does **not** give me a confirmed production Support URL or Privacy Policy URL for this app. Have these ready before final submission:

| Item | Needed |
|---|---|
| Support URL | required |
| Privacy Policy URL | required |
| Marketing URL | optional |

If you do not already have them, host lightweight pages first and use those URLs in App Store Connect.

---

## 10. App Privacy and review questionnaire

Based on the current codebase, the likely starting answers are:

- **Tracking:** No
- **Third-party advertising:** No
- **Analytics SDK:** None visible in the app code
- **Account creation:** No in-app account system visible
- **Sensitive permissions:** no camera / microphone / tracking usage strings present in the app `Info.plist`
- **Core data storage:** local on-device storage

### Things to verify before answering App Privacy
- whether any backend or email/report service is actually used in the release build
- whether notifications are enabled in the final release
- whether the widget / Live Activities are included in production

Do **not** answer the privacy questionnaire from older docs without confirming the current build.

---

## 11. Screenshots and icon

## App icon
- 1024 x 1024 PNG
- no transparency
- no rounded corners

## Screenshot set to prepare
Recommended first batch:

1. Practice tab
2. Adventure map
3. Flashcard front
4. Flashcard back
5. Image game
6. SAT question
7. Session complete
8. Profile / progress

## Required device sizes
- 6.7" iPhone screenshots
- 6.1" iPhone screenshots

If you want, I can help produce the final screenshot shot list and captions once the UI is locked.

---

## 12. Xcode upload steps

The browser cannot replace the Xcode archive/upload step.

## In Xcode
1. Select the `SATVocabApp` scheme.
2. Confirm:
   - correct team
   - release signing works
   - final bundle IDs are correct
   - version/build are correct
3. Run:
   - **Product → Archive**
4. In Organizer:
   - **Distribute App**
   - **App Store Connect**
   - **Upload**

## After upload
1. Wait for processing in App Store Connect.
2. Attach the processed build to the iOS version.
3. Complete:
   - export compliance
   - content rights
   - age rating
   - app review information
4. Submit to:
   - **TestFlight**, or
   - **App Review**

---

## 13. Suggested first live run

For the first pass, use this scope:

1. Keep the current bundle ID unless you want to rename it.
2. Use `WordScholar` as the App Store name.
3. Create the app record only.
4. Do **not** submit yet until:
   - icon exists
   - screenshots exist
   - privacy/support URLs exist
   - archive uploads cleanly

That is the safest path if the goal right now is to **register the project into Apple systems** rather than submit the app immediately.

---

## 14. Fast checklist

- [ ] Final bundle ID chosen
- [ ] Apple Developer login ready in Chrome
- [ ] App Store Connect login ready in Chrome
- [ ] App ID registered
- [ ] App Store Connect app created
- [ ] Icon ready
- [ ] Screenshots ready
- [ ] Privacy URL ready
- [ ] Support URL ready
- [ ] Archive uploaded from Xcode
- [ ] Build attached
- [ ] Submission forms completed

---

## 15. Exact next step

When you are ready, log in to Apple Developer and App Store Connect in Chrome, then I can use **`self-chrome-mcp`** to do the browser work for you.
