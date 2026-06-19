import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../models/document_asset.dart';
import '../../providers/auth_provider.dart';
import '../../providers/onboarding_provider.dart';
import '../../services/firebase_service.dart';
import '../screens/auth_gate_screen.dart';
import '../screens/document_viewer_screen.dart';
import '../screens/ai_generation_screen.dart';
import '../screens/onboarding/onboarding_screen.dart';
import '../screens/portfolio_dashboard_screen.dart';
import '../screens/portfolio_detail_screen.dart';
import '../screens/settings_screen.dart';
import '../screens/forgot_password_screen.dart';
import '../screens/contact_us_screen.dart';
import '../screens/subscription_screen.dart';
import '../screens/lock_screen.dart';
import '../../providers/app_lock_provider.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  final refreshListenable = ValueNotifier<int>(0);
  
  ref.listen(authStateProvider, (previous, next) {
    refreshListenable.value++;
  });
  
  ref.listen(onboardingSeenProvider, (previous, next) {
    refreshListenable.value++;
  });

  final authState       = ref.watch(authStateProvider);
  final onboardingValue = ref.watch(onboardingSeenProvider);

  return GoRouter(
    initialLocation: '/',
    refreshListenable: refreshListenable,
    redirect: (context, state) {
      final isLoggedIn   = authState.value != null;
      final seenLoading  = onboardingValue.isLoading;
      final hasSeen      = onboardingValue.value ?? false;
      final loc          = state.matchedLocation;

      if (seenLoading) return null;

      // 1. Forced Onboarding
      if (!hasSeen) {
        if (loc != '/onboarding') return '/onboarding';
        return null;
      }

      // 2. Auth Guard (only active after onboarding is seen)
      if (!isLoggedIn) {
        // If we are at root but not logged in, go to auth
        if (loc == '/') return '/auth';
        
        // Allow other public-ish routes like auth subroutes
        if (loc != '/auth' && loc != '/auth/forgot-password') return '/auth';
        return null;
      }
      
      // 3. Prevent logged-in users from seeing Auth/Onboarding pages
      // EXCEPT for guests who want to upgrade/link their account
      if (loc == '/onboarding') return '/';
      if (loc == '/auth' && isLoggedIn && !FirebaseService.instance.isAnonymous) return '/';

      return null;
    },
    routes: [
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
        routes: [
          GoRoute(
            path: '/onboarding',
            builder: (_, __) => const OnboardingScreen(),
          ),
          GoRoute(
            path: '/auth',
            builder: (_, __) => const AuthGateScreen(),
            routes: [
              GoRoute(
                path: 'forgot-password',
                builder: (_, __) => const ForgotPasswordScreen(),
              ),
            ],
          ),
          GoRoute(
            path: '/',
            builder: (_, __) => const PortfolioDashboardScreen(),
            routes: [
              GoRoute(
                path: 'settings',
                builder: (_, __) => const SettingsScreen(),
                routes: [
                  GoRoute(
                    path: 'contact',
                    builder: (_, __) => const ContactUsScreen(),
                  ),
                  GoRoute(
                    path: 'subscription',
                    builder: (_, __) => const SubscriptionScreen(),
                  ),
                ],
              ),
              GoRoute(
                path: 'portfolio/:portfolioId',
                builder: (_, state) => PortfolioDetailScreen(
                  portfolioId: state.pathParameters['portfolioId']!,
                ),
                routes: [
                  GoRoute(
                    path: 'generate',
                    builder: (_, state) => AiGenerationScreen(
                      portfolioId: state.pathParameters['portfolioId']!,
                    ),
                  ),
                  GoRoute(
                    path: 'doc/:docId',
                    builder: (_, state) =>
                        DocumentViewerScreen(asset: state.extra as DocumentAsset),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    ],
    errorBuilder: (_, state) => Scaffold(
      body: Center(child: Text('Route error: ${state.error}')),
    ),
  );
});
