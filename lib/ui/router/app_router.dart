import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../models/document_asset.dart';
import '../../providers/auth_provider.dart';
import '../screens/auth_gate_screen.dart';
import '../screens/portfolio_dashboard_screen.dart';
import '../screens/portfolio_detail_screen.dart';
import '../screens/ai_generation_screen.dart';
import '../screens/document_viewer_screen.dart';
import '../screens/settings_screen.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authStateProvider);

  return GoRouter(
    initialLocation: '/',
    redirect: (context, state) {
      final isLoggedIn = authState.value != null;
      final isAuthRoute = state.matchedLocation == '/auth';
      if (!isLoggedIn && !isAuthRoute) return '/auth';
      if (isLoggedIn && isAuthRoute) return '/';
      return null;
    },
    routes: [
      GoRoute(
        path: '/auth',
        builder: (_, __) => const AuthGateScreen(),
      ),
      GoRoute(
        path: '/settings',
        builder: (_, __) => const SettingsScreen(),
      ),
      GoRoute(
        path: '/',
        builder: (_, __) => const PortfolioDashboardScreen(),
        routes: [
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
                builder: (context, state) {
                  final asset = state.extra as DocumentAsset;
                  return DocumentViewerScreen(asset: asset);
                },
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