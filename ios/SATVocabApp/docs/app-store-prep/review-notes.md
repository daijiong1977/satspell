# App Review Notes for Apple

## Contact Information

- **Name:** Jiong Dai
- **Email:** self@daijiong.com

## Demo Instructions

WordScholar requires no login, no account creation, and no setup. The app is fully functional immediately after launch.

### How to test the app:

1. **Launch the app.** You will land on the Practice tab, which shows the daily study session.
2. **Tap "Start Morning Session"** to begin learning. The session walks through:
   - Flashcards (swipe to see definitions, examples, and pronunciation)
   - Interactive games (fill-in-the-blank, image matching, quick recall)
   - SAT-style multiple choice questions
3. **Switch to the Map tab** to see the 20-day adventure map with 4 themed zones.
4. **Switch to the Stats tab** to view streak, XP, word strength distribution, and stubborn words.
5. **Switch to the Profile tab** to:
   - Change display name and avatar
   - Toggle morning/evening notification reminders
   - Enter a parent email and send an optional progress report
   - View app version and local user ID

### Key points for reviewers:

- **No login required.** The app generates a local UUID on first launch. No server authentication exists.
- **All content is bundled.** The app ships with 372 SAT vocabulary words and associated SAT reading questions. No content is downloaded at runtime.
- **No in-app purchases.** All features are available for free.
- **Single network request.** The only network call is the optional "Send Report" button on the Profile tab, which sends a progress email via a Supabase edge function. This feature can be tested by entering any valid email address.
- **Local notifications only.** Morning (8:00 AM) and evening (7:00 PM) reminders use `UNCalendarNotificationTrigger`. No remote push notification server is used.

## Widget Extension

The project includes a widget extension target (`SATVocabWidgets`) for Live Activities. The widget extension is included in the build but does not appear on the home screen -- it provides only Live Activity support during active study sessions.

## Content Source

All vocabulary words and SAT questions are curated from publicly available SAT preparation materials. No copyrighted passages are reproduced in full.
