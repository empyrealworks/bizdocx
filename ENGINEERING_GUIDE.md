# BizDocx Engineering Guide: Architectural Excellence in Flutter

Welcome to the **BizDocx Engineering Guide**. This document serves as a pedagogical masterclass in building scalable, secure, and reactive mobile applications using Flutter. 

Instead of a simple "how-to," this guide focuses on the **First Principles** of the BizDocx architecture, explaining the *rationale* behind every structural decision.

---

## 1. Architectural Philosophy: The Reactive Core

BizDocx is built upon the principle of **Unidirectional Data Flow (UDF)** and **Functional Reactive Programming (FRP)**. 

### Why Riverpod?
While Flutter offers multiple state management solutions (Provider, BLoC, MobX), BizDocx utilizes **Riverpod** for three critical reasons:
1.  **Compile-time Safety**: Eliminates `ProviderNotFoundException` by making providers accessible without context.
2.  **Testability**: Providers are easily overridden during unit and widget testing without complex dependency injection setups.
3.  **Refined Reactivity**: The `ref.watch` and `ref.listen` mechanics allow for precise, granular UI updates, preventing unnecessary rebuilds of heavy widget trees.

### Design Pattern: Feature-First vs. Layer-First
BizDocx employs a hybrid **Domain-Driven Design (DDD)** approach. While common utilities are layered (`core`, `services`), business logic is grouped by **Domain** (Portfolio, Documents, Auth).

---

## 2. Project Structure & Module Boundaries

The project is organized to maximize maintainability and minimize coupling between disparate features.

```text
lib/
├── core/                # System-wide invariants
│   ├── constants/       # App-wide strings, keys, and values
│   ├── theme/           # The Atomic Design foundation (Colors, Type)
│   └── utils/           # Pure functions and helpers
├── models/              # Immutable Data Layer (Freezed/JSON)
├── providers/           # Business Logic & State Controllers (Riverpod)
├── services/            # Infrastructure Adapters (Firebase, AI, IAP)
├── ui/                  # Presentation Layer
│   ├── router/          # Declarative Routing (GoRouter)
│   ├── screens/         # High-level route destinations
│   ├── widgets/         # Reusable atomic/molecular components
│   └── sheets/          # Contextual bottom sheets
├── env/                 # Environment configuration (Envied)
└── l10n/                # Internationalization
```

---

## 3. The Reactive Routing System

Navigation in BizDocx isn't just about moving between screens; it's a **function of the application state**.

### Declarative Navigation with GoRouter
We use `GoRouter` to treat the URL/Path as the source of truth. This allows for deep-linking and a more web-like navigation experience on mobile.

#### The Auth Guard Pattern
In `lib/ui/router/app_router.dart`, we implement a reactive redirect logic that monitors three distinct states:
1.  **Onboarding State**: Has the user seen the tutorial?
2.  **Auth State**: Is the user logged in?
3.  **Route Context**: Where is the user trying to go?

#### The Shell Strategy (App Lock)
One of the most advanced patterns in BizDocx is the use of a `ShellRoute` to implement the **App Lock**.

By wrapping the primary routes in a `ShellRoute`, we can overlay a `LockScreen` globally without dismantling the underlying navigation stack. This ensures that when the user unlocks the app, they are exactly where they left off.

```dart
ShellRoute(
  builder: (context, state, child) {
    final appLock = ref.watch(appLockProvider);
    return Stack(
      children: [
        child,
        if (appLock.isLocked) const LockScreen(),
      ],
    );
  },
  // ... routes
)
```

---

## 4. Security Infrastructure: App Lock & Lifecycle

Security in BizDocx extends beyond Firebase. We implement a local "App Lock" that monitors the application lifecycle to protect sensitive data.

### The App Lifecycle Observer
The `AppLockNotifier` (in `lib/providers/app_lock_provider.dart`) utilizes the `AppLifecycleListener`. This is a pedagogical example of how to respond to system events in a reactive way.

```dart
void _onStateChange(AppLifecycleState lifecycleState) {
  if (!state.isEnabled) return;

  if (lifecycleState == AppLifecycleState.paused) {
    // App moved to background: Start the timer
    state = state.copyWith(backgroundTime: DateTime.now());
  } else if (lifecycleState == AppLifecycleState.resumed) {
    // App returned: Check if we've been away too long
    _checkLockTimeout();
  }
}
```

### Biometric Integration
BizDocx combines local PIN security with Biometric authentication (FaceID/TouchID). The `LockScreen` is designed as a **Modal Overlay** rather than a separate route, maintaining the state of the app behind the security layer.

---

## 5. The AI Document Pipeline: Structural vs. Graphical

The core value proposition of BizDocx is AI-powered generation. We distinguish between two primary "Pipelines":

### 5.1 The Structural Pipeline (LLM + HTML)
For text-based business documents (Contracts, Invoices, Letters), we generate semantic HTML. 
-   **Why HTML?** It is highly portable, easy for AI to generate structured layouts, and can be converted to PDF perfectly using the `pdf` package.
-   **State Management**: The `DocumentGenerationNotifier` tracks the "Phase" of generation (e.g., `fetchingContext`, `generating`, `saving`), allowing the UI to show precise progress to the user.

### 5.2 The Graphical Pipeline (Stable Diffusion / DALL-E)
For visual assets (Logos, Social Media Posts), we generate binary image data.
-   **Storage Pattern**: Images are cached locally first (for immediate UI feedback), then uploaded to Firebase Storage, with the URL persisted in Firestore.

### 5.3 Automated Categorization & Routing
Upon generation, BizDocx doesn't just dump the file. It uses a secondary AI call to **categorize** the document.
1.  **Semantic Analysis**: AI reads the content to determine if it's "Finance," "Legal," or a specific "Client."
2.  **Folder Routing**: If a folder for that category doesn't exist, the system creates it and moves the document automatically.

---

## 6. Development Best Practices

### Immutable Data with Freezed
Every model in BizDocx is immutable.
```dart
@freezed
class DocumentAsset with _$DocumentAsset {
  const factory DocumentAsset({
    required String id,
    required String title,
    // ...
  }) = _DocumentAsset;
}
```
**Rationale**: Immutability eliminates side effects. When state changes, we create a new instance. This makes debugging easier as we can track the exact moment "State A" became "State B."

### Environment Safety
Sensitive API keys and URLs are managed via `Envied`. This ensures that secrets are obfuscated in the binary and never committed to source control in plain text.

---

> **Final Note**: Excellence in engineering is not about complexity; it's about clarity. Every line of code in BizDocx should be written such that a new engineer can understand the "Why" within 5 minutes of reading.
