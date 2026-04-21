import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../models/business_portfolio.dart';
import '../models/user_context.dart';
import '../services/firebase_service.dart';
import 'auth_provider.dart';

// ── Portfolio Stream ──────────────────────────────────────────────────────────
final portfolioListProvider =
StreamProvider.autoDispose<List<BusinessPortfolio>>((ref) {
  final user = ref.watch(currentUserProvider);
  if (user == null) return const Stream.empty();
  return FirebaseService.instance.watchPortfolios();
});

// ── Selected Portfolio ────────────────────────────────────────────────────────
final selectedPortfolioIdProvider = StateProvider<String?>((ref) => null);

final selectedPortfolioProvider =
Provider.autoDispose<BusinessPortfolio?>((ref) {
  final id = ref.watch(selectedPortfolioIdProvider);
  if (id == null) return null;
  return ref.watch(portfolioListProvider).whenData(
        (list) => list.firstWhere((p) => p.id == id,
        orElse: () => list.first),
  ).value;
});

// ── UserContext per Portfolio ─────────────────────────────────────────────────
final userContextProvider = FutureProvider.family
    .autoDispose<UserContext, String>((ref, portfolioId) async {
  final user = ref.watch(currentUserProvider);
  if (user == null) return UserContext.empty('', portfolioId);
  return FirebaseService.instance.fetchContext(portfolioId);
});

// ── Portfolio Notifier ────────────────────────────────────────────────────────
class PortfolioNotifier extends AsyncNotifier<void> {
  @override
  Future<void> build() async {}

  Future<BusinessPortfolio> create({
    required String name,
    required String description,
    required String mission,
    required List<String> brandColors,
    required String targetAudience,
  }) async {
    state = const AsyncLoading();
    try {
      final portfolio = await FirebaseService.instance.createPortfolio(
        name: name,
        description: description,
        mission: mission,
        brandColors: brandColors,
        targetAudience: targetAudience,
      );
      state = const AsyncData(null);
      return portfolio;
    } catch (e, st) {
      state = AsyncError(e, st);
      rethrow;
    }
  }

  Future<void> updatePortfolio(BusinessPortfolio portfolio) async {
    state = const AsyncLoading();
    try {
      await FirebaseService.instance.updatePortfolio(portfolio);
      state = const AsyncData(null);
    } catch (e, st) {
      state = AsyncError(e, st);
      rethrow;
    }
  }

  Future<void> delete(String portfolioId) async {
    state = const AsyncLoading();
    try {
      await FirebaseService.instance.deletePortfolio(portfolioId);
      state = const AsyncData(null);
    } catch (e, st) {
      state = AsyncError(e, st);
      rethrow;
    }
  }
}

// In Riverpod 3.0, the provider factory takes (ref)
final portfolioNotifierProvider =
AsyncNotifierProvider<PortfolioNotifier, void>(PortfolioNotifier.new);
