import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/app_colors.dart';
import '../../core/extensions/context_extensions.dart';
import '../../providers/theme_provider.dart';
import '../../services/firebase_service.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.colors;
    final themeMode = ref.watch(themeModeProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        leading: BackButton(onPressed: () => context.go('/')),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _SectionHeader(context, 'Appearance'),
          const SizedBox(height: 8),
          _card(
            context,
            children: [
              _ThemeTile(
                context: context,
                label: 'System',
                subtitle: 'Follow device setting',
                icon: Icons.brightness_auto_outlined,
                selected: themeMode == ThemeMode.system,
                onTap: () =>
                    ref.read(themeModeProvider.notifier).state = ThemeMode.system,
                isFirst: true,
              ),
              Divider(height: 1, color: c.border),
              _ThemeTile(
                context: context,
                label: 'Light',
                subtitle: 'Always light',
                icon: Icons.light_mode_outlined,
                selected: themeMode == ThemeMode.light,
                onTap: () =>
                    ref.read(themeModeProvider.notifier).state = ThemeMode.light,
              ),
              Divider(height: 1, color: c.border),
              _ThemeTile(
                context: context,
                label: 'Dark',
                subtitle: 'Always dark',
                icon: Icons.dark_mode_outlined,
                selected: themeMode == ThemeMode.dark,
                onTap: () =>
                    ref.read(themeModeProvider.notifier).state = ThemeMode.dark,
                isLast: true,
              ),
            ],
          ),

          const SizedBox(height: 32),
          _SectionHeader(context, 'Support & Legal'),
          const SizedBox(height: 8),
          _card(
            context,
            children: [
              _ActionTile(
                label: 'Contact Us',
                icon: Icons.support_agent_rounded,
                onTap: () => context.push('/settings/contact'),
                isFirst: true,
              ),
              Divider(height: 1, color: c.border),
              _ActionTile(
                label: 'Privacy Policy',
                icon: Icons.privacy_tip_outlined,
                onTap: () => context.push('/settings/privacy'),
                isLast: true,
              ),
            ],
          ),

          const SizedBox(height: 32),
          _SectionHeader(context, 'Account'),
          const SizedBox(height: 8),
          _card(
            context,
            children: [
              _ActionTile(
                label: 'Delete My Data',
                icon: Icons.delete_forever_outlined,
                color: AppColors.error,
                onTap: () => _confirmDeleteAccount(context),
                isFirst: true,
                isLast: true,
              ),
            ],
          ),

          const SizedBox(height: 32),
          _SectionHeader(context, 'About'),
          const SizedBox(height: 8),
          _card(
            context,
            children: [
              _InfoRow(context, 'App', 'BizDocx'),
              Divider(height: 1, color: c.border),
              _InfoRow(context, 'Version', '1.0.0'),
              Divider(height: 1, color: c.border),
              _InfoRow(context, 'AI Models', 'Gemini 3.1 Pro + Imagen 4'),
            ],
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Future<void> _confirmDeleteAccount(BuildContext context) async {
    final c = context.colors;
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Account & Data?'),
        content: const Text(
          'This will permanently delete your account and all associated portfolios and documents. This action cannot be undone.',
          style: TextStyle(fontSize: 14, height: 1.5),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text('Cancel', style: TextStyle(color: c.textBody)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Delete Everything', style: TextStyle(color: AppColors.error)),
          ),
        ],
      ),
    );

    if (ok == true) {
      try {
        await FirebaseService.instance.deleteUserAccount();
        // The router will automatically redirect to auth because the auth state changed.
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Deletion failed. You may need to re-authenticate: $e'),
            backgroundColor: AppColors.error,
          ));
        }
      }
    }
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
  const _InfoRow(this.context, this.label, this.value);
  final BuildContext context;
  final String label;
  final String value;

  @override
  Widget build(BuildContext ctx) {
    final c = ctx.colors;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: c.textBody, fontSize: 14)),
          Text(value, style: TextStyle(color: c.textMuted, fontSize: 14)),
        ],
      ),
    );
  }
}
