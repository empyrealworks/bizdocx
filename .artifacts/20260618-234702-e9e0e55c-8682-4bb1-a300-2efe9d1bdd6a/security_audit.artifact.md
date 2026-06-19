# Security Audit & Proposed Improvements

## Existing Issues
1. **Biometric App Lock Bug**: The app relocks immediately after successful biometric authentication because the dialog dismissal triggers a lifecycle resume event, which in turn triggers a timeout check that sees a null `backgroundTime`.
2. **Missing Password Suggestions**: `TextFormField`s in `AuthGateScreen` lack `autofillHints`.
3. **No Anonymous Access**: Users must sign up before exploring features.
4. **No Email Verification**: Users can use the app without verifying their email.
5. **No Privacy Screen**: Sensitive data might be visible in the app switcher.

## Proposed Security Measures
1. **Root/Jailbreak Detection**: Use `flutter_jailbreak_detection` (if available/desired) to warn users on compromised devices.
2. **Privacy Screen**: Use `window_manager` or a platform-specific channel to enable `FLAG_SECURE` on Android and similar on iOS to hide content in the app switcher.
3. **Client-side Rate Limiting**: Limit login attempts per session to prevent brute-force (e.g., 5 attempts, then 1-minute lockout).
4. **Email Verification Guard**: Force users to verify email before accessing certain features or after a grace period.
5. **Session Timeout (App Lock)**: Improve the existing App Lock to be more robust.

## Technical Details

### App Lock Bug Fix
In `AppLockNotifier`, we should set `backgroundTime` to `DateTime.now()` when unlocking, or add a flag to ignore the next resume event if it was triggered by biometrics. Better yet, `_checkLockTimeout` should only lock if `backgroundTime` is NOT null AND the duration has passed. If `backgroundTime` is null, it means the app was either just started or just unlocked.

Wait, if it was just started, it should probably be locked if enabled.
If it was just unlocked, it should NOT be locked.

Current logic:
```dart
  void _checkLockTimeout() {
    if (!state.isEnabled || state.isLocked) return;
    if (state.backgroundTime == null) {
        // If it was just started or background time lost, we lock as a precaution if enabled
        state = state.copyWith(isLocked: true);
        return;
    }
    // ...
```
The "lock as a precaution" is what's killing it. When `unlock()` is called, `backgroundTime` is set to `null`. Then the biometric dialog closes, `resumed` is triggered, `_checkLockTimeout` sees `backgroundTime == null` and relocks.

Fix: `unlock()` should set a "justUnlocked" flag or we should refine the `backgroundTime == null` condition.

### Privacy Screen
On Android: `getWindow().addFlags(LayoutParams.FLAG_SECURE);`
On iOS: Add a blur overlay when the app enters `inactive` state.

### Rate Limiting
Maintain a counter in `AuthGateScreen` state. If it exceeds N, show a timer.
