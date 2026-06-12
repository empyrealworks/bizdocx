import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/app_colors.dart';
import '../../core/extensions/context_extensions.dart';
import '../../providers/theme_provider.dart';
import '../../providers/locale_provider.dart';
import '../../providers/app_lock_provider.dart';
import '../../services/firebase_service.dart';
import '../../services/local_cache_service.dart';
import '../../services/auth_security_service.dart';
import '../../l10n/app_localizations.dart';
import '../widgets/confirm_dialog.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  String _cacheSize = 'Calculating...';

  @override
  void initState() {
    super.initState();
    _loadCacheSize();
  }

  Future<void> _loadCacheSize() async {
    try {
      final bytes = await LocalCacheService.instance.getCacheSizeBytes(FirebaseService.instance.currentUid);
      if (mounted) {
        setState(() {
          _cacheSize = '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
        });
      }
    } catch (_) {
      if (mounted) setState(() => _cacheSize = context.l10n.error);
    }
  }

  Future<void> _clearCache() async {
    showDialog(
      context: context,
      builder: (ctx) => ConfirmDialog(
        title: context.l10n.clearCacheConfirm,
        message: context.l10n.clearCacheMessage,
        actionLabel: context.l10n.clearCache,
        icon: Icons.delete_sweep_outlined,
        onConfirm: () async {
           ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(context.l10n.done)));
           _loadCacheSize();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final l = context.l10n;
    final themeMode = ref.watch(themeModeProvider);
    final currentLocale = ref.watch(localeProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l.settings),
        leading: BackButton(onPressed: () => context.go('/')),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _SectionHeader(context, l.appearance),
          const SizedBox(height: 8),
          _card(
            context,
            children: [
              _ThemeTile(
                context: context,
                label: l.system,
                subtitle: l.systemSubtitle,
                icon: Icons.brightness_auto_outlined,
                selected: themeMode == ThemeMode.system,
                onTap: () =>
                    ref.read(themeModeProvider.notifier).setThemeMode(ThemeMode.system),
                isFirst: true,
              ),
              Divider(height: 1, color: c.border),
              _ThemeTile(
                context: context,
                label: l.light,
                subtitle: l.lightSubtitle,
                icon: Icons.light_mode_outlined,
                selected: themeMode == ThemeMode.light,
                onTap: () =>
                    ref.read(themeModeProvider.notifier).setThemeMode(ThemeMode.light),
              ),
              Divider(height: 1, color: c.border),
              _ThemeTile(
                context: context,
                label: l.dark,
                subtitle: l.darkSubtitle,
                icon: Icons.dark_mode_outlined,
                selected: themeMode == ThemeMode.dark,
                onTap: () =>
                    ref.read(themeModeProvider.notifier).setThemeMode(ThemeMode.dark),
                isLast: true,
              ),
            ],
          ),

          const SizedBox(height: 32),
          _SectionHeader(context, l.language),
          const SizedBox(height: 8),
          _card(
            context,
            children: [
              _LanguageTile(
                label: l.english,
                selected: currentLocale.languageCode == 'en',
                onTap: () => ref.read(localeProvider.notifier).setLocale(const Locale('en')),
                isFirst: true,
              ),
              Divider(height: 1, color: c.border),
              _LanguageTile(
                label: l.french,
                selected: currentLocale.languageCode == 'fr',
                onTap: () => ref.read(localeProvider.notifier).setLocale(const Locale('fr')),
              ),
              Divider(height: 1, color: c.border),
              _LanguageTile(
                label: l.spanish,
                selected: currentLocale.languageCode == 'es',
                onTap: () => ref.read(localeProvider.notifier).setLocale(const Locale('es')),
                isLast: true,
              ),
            ],
          ),

          const SizedBox(height: 32),
          _SectionHeader(context, l.security),
          const SizedBox(height: 8),
          _card(
            context,
            children: [
              _SwitchTile(
                label: l.appLock,
                subtitle: l.appLockDescription,
                value: ref.watch(appLockProvider).isEnabled,
                onChanged: (val) => _toggleAppLock(context, ref, val),
                isFirst: true,
                isLast: !ref.watch(appLockProvider).isEnabled,
              ),
              if (ref.watch(appLockProvider).isEnabled) ...[
                Divider(height: 1, color: c.border),
                _ActionTile(
                  label: l.lockTimeout,
                  value: _getTimeoutLabel(l, ref.watch(appLockProvider).timeout),
                  onTap: () => _showTimeoutPicker(context, ref),
                ),
                Divider(height: 1, color: c.border),
                _ActionTile(
                  label: l.changePin,
                  onTap: () => _showPinSetup(context, ref),
                  isLast: true,
                ),
              ],
            ],
          ),

          const SizedBox(height: 32),
          _SectionHeader(context, l.subscription),
          const SizedBox(height: 8),
          _card(
            context,
            children: [
              _ActionTile(
                label: l.plansAndCredits,
                icon: Icons.star_outline_rounded,
                onTap: () => context.push('/settings/subscription'),
                isFirst: true,
                isLast: true,
              ),
            ],
          ),

          const SizedBox(height: 32),
          _SectionHeader(context, l.storage),
          const SizedBox(height: 8),
          _card(
            context,
            children: [
              _InfoRow(context, l.localCache, _cacheSize, trailing: TextButton(
                onPressed: _clearCache,
                child: Text(l.clear),
              )),
            ],
          ),

          const SizedBox(height: 32),
          _SectionHeader(context, l.supportAndLegal),
          const SizedBox(height: 8),
          _card(
            context,
            children: [
              _ActionTile(
                label: l.contactUs,
                icon: Icons.support_agent_rounded,
                onTap: () => context.push('/settings/contact'),
                isFirst: true,
              ),
              Divider(height: 1, color: c.border),
              _ActionTile(
                label: l.privacyPolicy,
                icon: Icons.privacy_tip_outlined,
                onTap: () => context.push('/settings/privacy'),
                isLast: true,
              ),
            ],
          ),

          const SizedBox(height: 32),
          _SectionHeader(context, l.account),
          const SizedBox(height: 8),
          _card(
            context,
            children: [
              _ActionTile(
                label: l.deleteMyData,
                icon: Icons.delete_forever_outlined,
                color: AppColors.error,
                onTap: () => _confirmDeleteAccount(context),
                isFirst: true,
                isLast: true,
              ),
            ],
          ),

          const SizedBox(height: 32),
          _SectionHeader(context, l.about),
          const SizedBox(height: 8),
          _card(
            context,
            children: [
              _InfoRow(context, l.app, l.appTitle),
              Divider(height: 1, color: c.border),
              _InfoRow(context, l.version, '1.0.0'),
              Divider(height: 1, color: c.border),
              _InfoRow(context, l.aiEngine, l.aiEngineSubtitle),
            ],
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  void _confirmDeleteAccount(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => ConfirmDialog(
        title: context.l10n.deleteAccount,
        message: context.l10n.deleteAccountMessage,
        actionLabel: context.l10n.deleteEverything,
        isDestructive: true,
        icon: Icons.delete_forever_outlined,
        onConfirm: () async {
          try {
            await FirebaseService.instance.deleteUserAccount();
          } catch (e) {
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(context.l10n.deletionFailed(e.toString())),
                backgroundColor: AppColors.error,
              ));
            }
          }
        },
      ),
    );
  }

  Future<void> _toggleAppLock(BuildContext context, WidgetRef ref, bool enabled) async {
    if (!enabled) {
      await ref.read(appLockProvider.notifier).setEnabled(false);
      return;
    }

    final l = context.l10n;
    final canBio = await AuthSecurityService.instance.canCheckBiometrics();
    if (!context.mounted) return;

    final method = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l.appLock),
        content: Text(l.authenticateToContinue),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, 'pin'),
            child: Text(l.pinAuth),
          ),
          if (canBio)
            TextButton(
              onPressed: () => Navigator.pop(ctx, 'bio'),
              child: Text(l.biometricAuth),
            ),
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(l.cancel),
          ),
        ],
      ),
    );

    if (method == 'pin') {
      if (!context.mounted) return;
      final success = await _showPinSetup(context, ref);
      if (success) {
        await ref.read(appLockProvider.notifier).setEnabled(true);
      }
    } else if (method == 'bio') {
      if (!context.mounted) return;
      final success = await AuthSecurityService.instance.authenticateWithBiometrics(
        localizedReason: context.l10n.authenticateToContinue,
      );
      if (success) {
        await AuthSecurityService.instance.setBiometricsEnabled(true);
        await ref.read(appLockProvider.notifier).setEnabled(true);
      }
    }
  }

  Future<bool> _showPinSetup(BuildContext context, WidgetRef ref) async {
    final pin = await showDialog<String>(
      context: context,
      builder: (ctx) => const _PinSetupDialog(),
    );

    if (pin != null) {
      await AuthSecurityService.instance.setPin(pin);
      return true;
    }
    return false;
  }

  String _getTimeoutLabel(AppLocalizations l, AppLockTimeout timeout) {
    switch (timeout) {
      case AppLockTimeout.immediate:
        return l.immediate;
      case AppLockTimeout.oneMinute:
        return l.after1Min;
      case AppLockTimeout.thirtyMinutes:
        return l.after30Min;
    }
  }

  void _showTimeoutPicker(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    showModalBottomSheet(
      context: context,
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: AppLockTimeout.values.map((t) {
            return ListTile(
              title: Text(_getTimeoutLabel(l, t)),
              onTap: () {
                ref.read(appLockProvider.notifier).setTimeout(t);
                Navigator.pop(ctx);
              },
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _card(BuildContext context, {required List<Widget> children}) {
    final c = context.colors;
    return Container(
      decoration: BoxDecoration(
        color: c.card,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: c.border),
      ),
      child: Column(children: children),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader(this.context, this.text);
  final BuildContext context;
  final String text;

  @override
  Widget build(BuildContext ctx) => Text(
        text.toUpperCase(),
        style: Theme.of(ctx).textTheme.labelSmall,
      );
}

class _ThemeTile extends StatelessWidget {
  const _ThemeTile({
    required this.context,
    required this.label,
    required this.subtitle,
    required this.icon,
    required this.selected,
    required this.onTap,
    this.isFirst = false,
    this.isLast = false,
  });

  final BuildContext context;
  final String label;
  final String subtitle;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;
  final bool isFirst;
  final bool isLast;

  @override
  Widget build(BuildContext ctx) {
    final c = ctx.colors;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.vertical(
        top: isFirst ? const Radius.circular(12) : Radius.zero,
        bottom: isLast ? const Radius.circular(12) : Radius.zero,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Icon(icon, size: 20, color: selected ? c.textPrimary : c.iconSecondary),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label,
                      style: TextStyle(
                        color: selected ? c.textPrimary : c.textBody,
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      )),
                  Text(subtitle, style: TextStyle(color: c.textMuted, fontSize: 12)),
                ],
              ),
            ),
            if (selected) const Icon(Icons.check_circle_rounded, size: 20, color: AppColors.success),
          ],
        ),
      ),
    );
  }
}

class _LanguageTile extends StatelessWidget {
  const _LanguageTile({
    required this.label,
    required this.selected,
    required this.onTap,
    this.isFirst = false,
    this.isLast = false,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;
  final bool isFirst;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.vertical(
        top: isFirst ? const Radius.circular(12) : Radius.zero,
        bottom: isLast ? const Radius.circular(12) : Radius.zero,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Expanded(
              child: Text(label,
                  style: TextStyle(
                    color: selected ? c.textPrimary : c.textBody,
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  )),
            ),
            if (selected) const Icon(Icons.check_circle_rounded, size: 20, color: AppColors.success),
          ],
        ),
      ),
    );
  }
}

class _ActionTile extends StatelessWidget {
  const _ActionTile({
    required this.label,
    this.value,
    this.icon,
    required this.onTap,
    this.color,
    this.isFirst = false,
    this.isLast = false,
  });

  final String label;
  final String? value;
  final IconData? icon;
  final VoidCallback onTap;
  final Color? color;
  final bool isFirst;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final tileColor = color ?? c.textPrimary;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.vertical(
        top: isFirst ? const Radius.circular(12) : Radius.zero,
        bottom: isLast ? const Radius.circular(12) : Radius.zero,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Row(
          children: [
            if (icon != null) ...[
              Icon(icon, size: 20, color: tileColor),
              const SizedBox(width: 14),
            ],
            Expanded(
              child: Text(label,
                  style: TextStyle(
                    color: tileColor,
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  )),
            ),
            if (value != null)
              Text(value!, style: TextStyle(color: c.textMuted, fontSize: 14)),
            const SizedBox(width: 8),
            Icon(Icons.arrow_forward_ios_rounded, color: c.borderStrong, size: 14),
          ],
        ),
      ),
    );
  }
}

class _SwitchTile extends StatelessWidget {
  const _SwitchTile({
    required this.label,
    required this.subtitle,
    required this.value,
    required this.onChanged,
    this.isFirst = false,
    this.isLast = false,
  });

  final String label;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;
  final bool isFirst;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return InkWell(
      onTap: () => onChanged(!value),
      borderRadius: BorderRadius.vertical(
        top: isFirst ? const Radius.circular(12) : Radius.zero,
        bottom: isLast ? const Radius.circular(12) : Radius.zero,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label,
                      style: TextStyle(
                        color: c.textPrimary,
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      )),
                  Text(subtitle, style: TextStyle(color: c.textMuted, fontSize: 12)),
                ],
              ),
            ),
            Switch.adaptive(
              value: value,
              onChanged: onChanged,
              activeTrackColor: AppColors.success,
            ),
          ],
        ),
      ),
    );
  }
}

class _PinSetupDialog extends StatefulWidget {
  const _PinSetupDialog();

  @override
  State<_PinSetupDialog> createState() => _PinSetupDialogState();
}

class _PinSetupDialogState extends State<_PinSetupDialog> {
  final TextEditingController _controller = TextEditingController();
  String _pin = '';
  String _confirmPin = '';
  bool _isConfirming = false;
  String? _error;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleContinue() {
    if (_controller.text.length < 4) {
      setState(() => _error = context.l10n.min4Chars);
      return;
    }

    setState(() {
      if (!_isConfirming) {
        _pin = _controller.text;
        _controller.clear();
        _isConfirming = true;
        _error = null;
      } else {
        _confirmPin = _controller.text;
        if (_pin == _confirmPin) {
          Navigator.pop(context, _pin);
        } else {
          _error = context.l10n.pinsDoNotMatch;
          _controller.clear();
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return AlertDialog(
      title: Text(_isConfirming ? l.confirmPin : l.setPin),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _controller,
            obscureText: true,
            keyboardType: TextInputType.number,
            maxLength: 4,
            textAlign: TextAlign.center,
            style: const TextStyle(letterSpacing: 16, fontSize: 24),
            decoration: InputDecoration(
              counterText: '',
              errorText: _error,
            ),
            onChanged: (_) => setState(() => _error = null),
          ),
        ],
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: Text(l.cancel)),
        TextButton(
          onPressed: _handleContinue,
          child: Text(_isConfirming ? l.done : l.next),
        ),
      ],
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow(this.context, this.label, this.value, {this.trailing});
  final BuildContext context;
  final String label;
  final String value;
  final Widget? trailing;

  @override
  Widget build(BuildContext ctx) {
    final c = ctx.colors;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: c.textBody, fontSize: 14)),
          const Spacer(),
          Text(value, style: TextStyle(color: c.textMuted, fontSize: 14)),
          if (trailing != null) ...[
            const SizedBox(width: 8),
            trailing!,
          ],
        ],
      ),
    );
  }
}
