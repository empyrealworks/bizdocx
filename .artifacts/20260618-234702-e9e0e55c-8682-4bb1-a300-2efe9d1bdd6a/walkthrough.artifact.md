# Walkthrough - Security & Settings Synchronization

I have fixed the persistent App Lock loop and implemented remote settings synchronization with Firestore.

## 1. App Lock Infinite Loop Fix
The issue where the app would relock immediately after biometric authentication (especially when opened via shortcuts) was caused by rapid lifecycle transitions.
- **Grace Period**: Added a **1-second grace period** to the "Immediate" lock logic. If the app is in the background for less than a second (e.g., during a dialog dismissal), it won't relock.
- **Authentication Guard**: Added an `isAuthenticating` flag to [app_lock_provider.dart](file:///home/keyturn/StudioProjects/bizdocx/lib/providers/app_lock_provider.dart). Lifecycle events are ignored while the biometric dialog is active.

## 2. Remote Settings Sync
Your app preferences are now synchronized with your Firestore profile, ensuring a consistent experience across devices.
- **Firestore Sync**: Updated `ThemeModeNotifier` and `LocaleNotifier` to listen for remote changes and upload local changes to the user's Firestore document.
- **Profile Model**: Updated [user_profile.dart](file:///home/keyturn/StudioProjects/bizdocx/lib/models/user_profile.dart) to include a `settings` map.

## 3. Sign-Out Cleanup
Addressed the concern about "locking a signed-out app".
- **Deep Clean**: Updated `FirebaseService.signOut()` to clear all local `SharedPreferences`, delete secure PIN storage, and disable biometric flags.
- **State Reset**: Notifiers now listen to the auth state and reset to default values (Light theme, English, App Lock disabled) immediately upon sign-out.

## 4. Engagament & UX (Recap)
- **Review Prompt**: Users are asked for a rating after their first successful document export.
- **Guest Upgrade**: Seamless account linking preserves guest data when they sign up.
- **Privacy Overlay**: Automatic blur in the app switcher remains active.

## Verification Summary
- **App Lock**: Tested the "Immediate" setting to ensure it ignores dialog dismissals but still locks when switching to other apps.
- **Sign Out**: Verified that signing out removes the PIN and resets the app to the "Onboarding/Auth" state without any residual lock screens.
- **Settings Persistence**: Verified that changing the theme to Dark, signing out, and signing back in restores the Dark theme automatically from Firestore.
