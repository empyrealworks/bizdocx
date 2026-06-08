import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/app_colors.dart';
import '../../core/extensions/context_extensions.dart';
import '../../providers/theme_provider.dart';
import '../../providers/locale_provider.dart';
import '../../services/firebase_service.dart';
import '../../services/local_cache_service.dart';
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
      final uid = FirebaseService.instance.currentUid;
      final bytes = await LocalCacheService.instance.getCacheSizeBytes(uid);
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
    final uid = FirebaseService.instance.currentUid;
    
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
              _InfoRow(context, 'App', l.appTitle),
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
                content: Text('Deletion failed: $e'),
                backgroundColor: AppColors.error,
              ));
            }
          }
        },
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
    required this.icon,
    required this.onTap,
    this.color,
    this.isFirst = false,
    this.isLast = false,
  });

  final String label;
  final IconData icon;
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
            Icon(icon, size: 20, color: tileColor),
            const SizedBox(width: 14),
            Expanded(
              child: Text(label,
                  style: TextStyle(
                    color: tileColor,
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  )),
            ),
            Icon(Icons.arrow_forward_ios_rounded, color: c.borderStrong, size: 14),
          ],
        ),
      ),
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
