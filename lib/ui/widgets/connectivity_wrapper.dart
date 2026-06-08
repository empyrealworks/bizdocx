import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/extensions/context_extensions.dart';
import '../../providers/connectivity_provider.dart';
import '../../core/constants/app_colors.dart';

class ConnectivityWrapper extends ConsumerWidget {
  const ConnectivityWrapper({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final connectivityAsync = ref.watch(connectivityProvider);
    final isOffline = connectivityAsync.value == ConnectivityStatus.offline;
    final l = context.l10n;

    return Column(
      children: [
        if (isOffline)
          Material(
            child: SafeArea(
              bottom: false,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 8),
                color: AppColors.error,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.wifi_off_rounded, color: Colors.white, size: 16),
                    const SizedBox(width: 8),
                    Text(
                      l.offlineBanner,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        Expanded(
          child: MediaQuery.removePadding(
            context: context,
            removeTop: isOffline,
            child: child,
          ),
        ),
      ],
    );
  }
}
