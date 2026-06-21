import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/prefs_service.dart';
import '../services/auth_security_service.dart';
import 'auth_provider.dart';

enum AppLockTimeout {
  immediate,
  oneMinute,
  thirtyMinutes;

  Duration get duration {
    switch (this) {
      case AppLockTimeout.immediate:
        return Duration.zero;
      case AppLockTimeout.oneMinute:
        return const Duration(minutes: 1);
      case AppLockTimeout.thirtyMinutes:
        return const Duration(minutes: 30);
    }
  }
}

class AppLockState {
  final bool isLocked;
  final bool isEnabled;
  final AppLockTimeout timeout;
  final DateTime? backgroundTime;
  final bool isAuthenticating;

  AppLockState({
    required this.isLocked,
    required this.isEnabled,
    required this.timeout,
    this.backgroundTime,
    this.isAuthenticating = false,
  });

  AppLockState copyWith({
    bool? isLocked,
    bool? isEnabled,
    AppLockTimeout? timeout,
    DateTime? backgroundTime,
    bool? isAuthenticating,
  }) {
    return AppLockState(
      isLocked: isLocked ?? this.isLocked,
      isEnabled: isEnabled ?? this.isEnabled,
      timeout: timeout ?? this.timeout,
      backgroundTime: backgroundTime ?? this.backgroundTime,
      isAuthenticating: isAuthenticating ?? this.isAuthenticating,
    );
  }
}

class AppLockNotifier extends Notifier<AppLockState> {
  static const _enabledKey = 'app_lock_enabled';
  static const _timeoutKey = 'app_lock_timeout';
  
  // ignore: unused_field
  late final AppLifecycleListener _listener;

  @override
  AppLockState build() {
    ref.listen(authStateProvider, (prev, next) {
      if (next.value == null && prev?.value != null) {
        // User signed out, reset state
        state = AppLockState(
          isLocked: false,
          isEnabled: false,
          timeout: AppLockTimeout.immediate,
        );
      }
    });

    final isEnabled = PrefsService.instance.getBool(_enabledKey) ?? false;
    final timeoutIndex = PrefsService.instance.getInt(_timeoutKey) ?? 0;
    final timeout = AppLockTimeout.values[timeoutIndex];

    _listener = AppLifecycleListener(
      onStateChange: _onStateChange,
    );

    return AppLockState(
      isLocked: isEnabled, // Lock on start if enabled
      isEnabled: isEnabled,
      timeout: timeout,
    );
  }

  void _onStateChange(AppLifecycleState lifecycleState) {
    if (!state.isEnabled || state.isAuthenticating) return;

    if (lifecycleState == AppLifecycleState.paused || lifecycleState == AppLifecycleState.hidden) {
      state = state.copyWith(backgroundTime: DateTime.now());
    } else if (lifecycleState == AppLifecycleState.resumed) {
      _checkLockTimeout();
    }
  }

  void _checkLockTimeout() {
    if (!state.isEnabled || state.isLocked) return;
    if (state.backgroundTime == null) return;

    final diff = DateTime.now().difference(state.backgroundTime!);
    
    // Add a small grace period (e.g. 1 second) to avoid relocking 
    // due to rapid lifecycle changes (like dialog dismissals)
    const gracePeriod = Duration(seconds: 1);
    final targetDuration = state.timeout.duration > gracePeriod 
        ? state.timeout.duration 
        : gracePeriod;

    if (diff >= targetDuration) {
      state = state.copyWith(isLocked: true);
    }
  }

  Future<void> setEnabled(bool enabled) async {
    await PrefsService.instance.setBool(_enabledKey, enabled);
    if (!enabled) {
      await AuthSecurityService.instance.clearPin();
      await AuthSecurityService.instance.setBiometricsEnabled(false);
    }
    state = state.copyWith(isEnabled: enabled, isLocked: false);
  }

  Future<void> setTimeout(AppLockTimeout timeout) async {
    await PrefsService.instance.setInt(_timeoutKey, timeout.index);
    state = state.copyWith(timeout: timeout);
  }

  void unlock() {
    state = state.copyWith(isLocked: false, backgroundTime: null, isAuthenticating: false);
  }

  void setAuthenticating(bool authenticating) {
    state = state.copyWith(isAuthenticating: authenticating);
  }

  void lock() {
    if (state.isEnabled) {
      state = state.copyWith(isLocked: true);
    }
  }
}

final appLockProvider = NotifierProvider<AppLockNotifier, AppLockState>(AppLockNotifier.new);
