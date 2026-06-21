# App Lock Stability & Settings Sync

This plan addresses the App Lock infinite loop bug and implements remote settings synchronization with Firestore.

## User Review Required

- **Settings Reset**: Tapping "Sign Out" will clear local `SharedPreferences` and reset the app state to defaults. This prevents "locking a signed-out app".
- **Account Linking**: The previously implemented linking flow already ensures guests don't lose data. Their guest settings will be uploaded to Firestore upon linking.

## Proposed Changes

### App Lock Stability Fix

#### [app_lock_provider.dart](file:///home/keyturn/StudioProjects/bizdocx/lib/providers/app_lock_provider.dart)

- **Ignore "Immediate" Lock after Biometrics**: Add an `isAuthenticating` flag to the state.
- **Refine Lifecycle Listener**: Do not set `backgroundTime` if `isAuthenticating` is true.

```dart
class AppLockState {
  final bool isLocked;
  final bool isEnabled;
  final AppLockTimeout timeout;
  final DateTime? backgroundTime;
  final bool isAuthenticating; // NEW
  // ...
}
```

### Remote Settings Sync

#### [user_profile.dart](file:///home/keyturn/StudioProjects/bizdocx/lib/models/user_profile.dart)

- Add a `settings` field (Map or specialized class) to `UserProfile`.

```dart
@freezed
abstract class UserProfile with _$UserProfile {
  const factory UserProfile({
    // ... existing fields
    @Default({}) Map<String, dynamic> settings,
  }) = _UserProfile;
  // ...
}
```

#### [firebase_service.dart](file:///home/keyturn/StudioProjects/bizdocx/lib/services/firebase_service.dart)

- Add `updateSettings(Map<String, dynamic> settings)` method.
- Update `signOut()` to also clear local preferences.

#### [Settings Notifiers (Theme, Locale, AppLock)]

- Update each notifier to listen to `userProfileProvider`.
- When the profile changes, if remote settings differ from local state, update local state.
- When local state changes, update both `PrefsService` AND Firestore (via `FirebaseService`).

### UI Refinements

#### [settings_screen.dart](file:///home/keyturn/StudioProjects/bizdocx/lib/ui/screens/settings_screen.dart)

- Ensure the "Sign Out" logic calls a method that properly cleans up.

## Verification Plan

### Manual Verification
1.  **App Lock Shortcut**:
    *   Enable App Lock (Immediate).
    *   Launch app from home screen shortcut.
    *   Authenticate via biometrics.
    *   Verify it **stays unlocked**.
2.  **Settings Sync**:
    *   Change Theme to Dark and Locale to Spanish.
    *   Sign Out.
    *   Verify app resets to Light/English.
    *   Sign In with the same account.
    *   Verify app automatically switches back to Dark/Spanish.
3.  **Guest Upgrade Settings**:
    *   As a Guest, set Theme to Dark.
    *   Upgrade to permanent account.
    *   Verify Dark theme is preserved and now saved to the permanent Firestore profile.
