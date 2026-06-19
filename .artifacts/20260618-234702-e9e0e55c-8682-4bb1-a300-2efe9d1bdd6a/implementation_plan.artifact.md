# Security Enhancements & App Lock Fix

This plan addresses the biometric app lock bug and implements several security improvements as requested.

## User Review Required

- **Privacy Screen Implementation**: I propose using a manual blur overlay when the app is in the background (iOS) and `FLAG_SECURE` (Android) if possible via platform channels, or a simpler Flutter-side implementation for hiding content in the app switcher. Since I cannot add new dependencies easily without user approval for each, I will start with a Flutter-side "Privacy Overlay".
- **Email Verification**: Should we block all features until verified, or just show a persistent warning banner? I'll start with a banner to minimize friction.
- **Anonymous Auth**: Guest users will have limited credits (already handled in `FirebaseService.ensureProfile` by default).

## Proposed Changes

### App Lock Fix

#### [app_lock_provider.dart](file:///home/keyturn/StudioProjects/bizdocx/lib/providers/app_lock_provider.dart)

- Modify `_checkLockTimeout` to avoid relocking when `backgroundTime` is null. A null `backgroundTime` while the app is already unlocked implies a recent unlock event (like biometric dismissal).

```dart
  void _checkLockTimeout() {
    if (!state.isEnabled || state.isLocked) return;
    if (state.backgroundTime == null) return; // Do not lock if we just unlocked

    final diff = DateTime.now().difference(state.backgroundTime!);
    if (diff >= state.timeout.duration) {
      state = state.copyWith(isLocked: true);
    }
  }
```

---

### Authentication Security

#### [auth_gate_screen.dart](file:///home/keyturn/StudioProjects/bizdocx/lib/ui/screens/auth_gate_screen.dart)

- Add `AutofillHints` to email and password fields for better password manager integration.
- Implement "Continue as Guest" button.
- Implement client-side rate limiting (lock UI for 60 seconds after 5 failed attempts).

#### [firebase_service.dart](file:///home/keyturn/StudioProjects/bizdocx/lib/services/firebase_service.dart)

- Add `sendEmailVerification` and `isEmailVerified` checks.

---

### UI & UX Security

#### [NEW] [privacy_overlay.dart](file:///home/keyturn/StudioProjects/bizdocx/lib/ui/widgets/privacy_overlay.dart)

- Create a widget that listens to `AppLifecycleState` and shows a blurred logo when the app is not `resumed`.

#### [app_router.dart](file:///home/keyturn/StudioProjects/bizdocx/lib/ui/router/app_router.dart)

- Wrap the `ShellRoute` with the `PrivacyOverlay`.

---

### Additional Security Measures

1.  **Email Verification Banner**: Add a banner to the `PortfolioDashboardScreen` for users with unverified emails.
2.  **Sensitive Data Masking**: Ensure password fields use `obscureText: true` (already done, but double-check consistency).

## Verification Plan

### Manual Verification
1.  **Biometric Lock**:
    - Enable Biometric Lock in settings.
    - Background the app and return -> Should show Lock Screen.
    - Authenticate with biometrics -> Should unlock and REMAIN unlocked.
2.  **Anonymous Auth**:
    - Click "Continue as Guest" -> Should land on Dashboard with a "Guest" profile.
3.  **Password Suggestions**:
    - Focus email/password fields -> Verify keyboard suggests saved credentials.
4.  **Rate Limiting**:
    - Enter wrong password 5 times -> Verify "Too many attempts" message and button disabled.
5.  **Privacy Screen**:
    - Open app switcher -> Verify app content is hidden/blurred (via the new overlay).
