# App Store Submission Checklist

## Pre-Submission

- [ ] All tests pass (`Cmd+U` in Xcode)
- [ ] Run on a physical device to verify
- [ ] Set `AppConfig.unlockAllTasksForTesting = false` (currently `true` in `Sources/SATVocabApp/Data/AppConfig.swift`)
- [ ] Set `AppConfig.unlockAllAdventureForTesting = false` (already `false`)
- [ ] Verify bundle version is correct in `Resources/Info.plist` (currently 1.0 build 1)
- [ ] Privacy policy HTML is hosted at a public URL

---

## Step 1: Archive the App

1. In Xcode, select the **SATVocabApp** scheme
2. Set destination to **Any iOS Device (arm64)**
3. Go to **Product > Archive**
4. Wait for the archive to complete (appears in Organizer)

---

## Step 2: Upload to App Store Connect

1. In Xcode Organizer, select the new archive
2. Click **Distribute App**
3. Select **App Store Connect** > **Upload**
4. Follow the prompts (automatic signing is fine)
5. Wait for upload and processing to complete

### Alternative: Command-line upload

```bash
# Build archive
xcodebuild archive \
  -project SATVocabApp.xcodeproj \
  -scheme SATVocabApp \
  -archivePath build/WordScholar.xcarchive \
  -destination "generic/platform=iOS"

# Export IPA
xcodebuild -exportArchive \
  -archivePath build/WordScholar.xcarchive \
  -exportPath build/export \
  -exportOptionsPlist docs/app-store-prep/ExportOptions.plist

# Upload via altool or Transporter
xcrun altool --upload-app \
  -f build/export/SATVocabApp.ipa \
  -t ios \
  -u YOUR_APPLE_ID \
  -p YOUR_APP_SPECIFIC_PASSWORD
```

---

## Step 3: Create App Record in App Store Connect

1. Go to [App Store Connect](https://appstoreconnect.apple.com)
2. Click **My Apps** > **+** > **New App**
3. Fill in:
   - **Platform:** iOS
   - **Name:** WordScholar
   - **Primary Language:** English (U.S.)
   - **Bundle ID:** com.WordScholar.WordScholarApp
   - **SKU:** wordscholar-ios-v1
   - **User Access:** Full Access

---

## Step 4: Fill In App Information

### App Information Tab
- **Category:** Education
- **Content Rights:** Does not contain, show, or access third-party content
- **Age Rating:** (see below)

### Age Rating Questionnaire Answers
| Question | Answer |
|---|---|
| Cartoon or Fantasy Violence | None |
| Realistic Violence | None |
| Prolonged Graphic or Sadistic Realistic Violence | None |
| Profanity or Crude Humor | None |
| Mature/Suggestive Themes | None |
| Horror/Fear Themes | None |
| Medical/Treatment Information | None |
| Alcohol, Tobacco, or Drug Use or References | None |
| Simulated Gambling | None |
| Sexual Content and Nudity | None |
| Graphic Sexual Content and Nudity | None |
| Unrestricted Web Access | No |
| Gambling and Contests | No |

**Result: Rated 4+**

### Pricing and Availability
- **Price:** Free
- **Availability:** All territories

---

## Step 5: App Store Listing (Version Page)

Copy from `listing.md`:

- [ ] **App Name:** WordScholar
- [ ] **Subtitle:** SAT Vocab with Spaced Practice
- [ ] **Promotional Text:** (from listing.md)
- [ ] **Description:** (from listing.md)
- [ ] **Keywords:** (from listing.md)
- [ ] **What's New:** (from listing.md)
- [ ] **Support URL:** mailto:self@daijiong.com (or a web page)
- [ ] **Marketing URL:** (optional)
- [ ] **Privacy Policy URL:** (URL where privacy-policy.html is hosted)

---

## Step 6: Upload Screenshots

- [ ] Upload 8 screenshots for 6.7" display (iPhone 17 Pro Max)
- [ ] Upload 8 screenshots for 6.1" display (iPhone 17 Pro)
- [ ] Add captions from `screenshot-guide.md`
- [ ] Set screenshot order to match the guide

See `screenshot-guide.md` for exact commands and captions.

---

## Step 7: App Review Information

- [ ] **Contact First Name:** Jiong
- [ ] **Contact Last Name:** Dai
- [ ] **Contact Phone:** (your phone number)
- [ ] **Contact Email:** self@daijiong.com
- [ ] **Notes for Reviewer:** (paste content from `review-notes.md`)
- [ ] **Sign-In Required:** No

---

## Step 8: App Privacy Questionnaire

Answer the App Privacy questions in App Store Connect as follows:

### Do you or your third-party partners collect data from this app?
**Yes** (only for the optional email report feature)

### Data Types Collected

| Data Type | Collected? | Details |
|---|---|---|
| Contact Info (email) | Yes | Parent/tutor email entered by the user for optional progress reports |
| Health & Fitness | No | |
| Financial Info | No | |
| Location | No | |
| Sensitive Info | No | |
| Contacts | No | |
| User Content | No | |
| Browsing History | No | |
| Search History | No | |
| Identifiers | No | |
| Purchases | No | |
| Usage Data | No | |
| Diagnostics | No | |
| Other Data | No | |

### For "Contact Info - Email Address":

| Question | Answer |
|---|---|
| Is this data linked to the user's identity? | No |
| Is this data used for tracking? | No |
| What is the purpose? | App Functionality |
| Is collection required or optional? | Optional (user can choose not to use this feature) |

---

## Step 9: Submit for Review

- [ ] Select the uploaded build
- [ ] Verify all fields are complete (green checkmarks)
- [ ] Set release method: **Manually release this version** (recommended for v1.0)
- [ ] Click **Submit for Review**

---

## Post-Submission

- [ ] Monitor App Store Connect for review status
- [ ] Respond promptly to any reviewer questions at self@daijiong.com
- [ ] Once approved, click **Release This Version** to publish
