import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/prefs_service.dart';
import '../services/auth_security_service.dart';

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

  AppLockState({
    required this.isLocked,
    required this.isEnabled,
    required this.timeout,
    this.backgroundTime,
  });

  AppLockState copyWith({
    bool? isLocked,
    bool? isEnabled,
    AppLockTimeout? timeout,
    DateTime? backgroundTime,
  }) {
    return AppLockState(
      isLocked: isLocked ?? this.isLocked,
      isEnabled: isEnabled ?? this.isEnabled,
      timeout: timeout ?? this.timeout,
      backgroundTime: backgroundTime ?? this.backgroundTime,
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
    if (!state.isEnabled) return;

    if (lifecycleState == AppLifecycleState.paused || lifecycleState == AppLifecycleState.hidden) {
      state = state.copyWith(backgroundTime: DateTime.now());
    } else if (lifecycleState == AppLifecycleState.resumed) {
      _checkLockTimeout();
    }
  }

  void _checkLockTimeout() {
    if (!state.isEnabled || state.isLocked) return;
    
    // If backgroundTime is null, it means the app was either just started 
    // or just unlocked. In both cases, we don't need to re-lock based on timeout.
    if (state.backgroundTime == null) return;

    final diff = DateTime.now().difference(state.backgroundTime!);
    if (diff >= state.timeout.duration) {
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
    state = state.copyWith(isLocked: false, backgroundTime: null);
  }

  void lock() {
    if (state.isEnabled) {
      state = state.copyWith(isLocked: true);
    }
  }
}

final appLockProvider = NotifierProvider<AppLockNotifier, AppLockState>(AppLockNotifier.new);
