import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/user_profile.dart';
import '../services/firebase_service.dart';
import 'auth_provider.dart';

final userProfileProvider = StreamProvider<UserProfile?>((ref) {
  final user = ref.watch(currentUserProvider);
  if (user == null) return Stream.value(null);
  return FirebaseService.instance.watchProfile();
});

final tierLimitsProvider = Provider<TierLimits?>((ref) {
  final profile = ref.watch(userProfileProvider).value;
  if (profile == null) return null;
  return TierLimits.get(profile.tier);
});
