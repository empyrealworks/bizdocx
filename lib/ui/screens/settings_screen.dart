import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/app_colors.dart';
import '../../core/extensions/context_extensions.dart';
import '../../providers/theme_provider.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c         = context.colors;
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
                ref.read(themeModeProvider.notifier).state =
                    ThemeMode.system,
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
                ref.read(themeModeProvider.notifier).state =
                    ThemeMode.light,
              ),
              Divider(height: 1, color: c.border),
              _ThemeTile(
                context: context,
                label: 'Dark',
                subtitle: 'Always dark',
                icon: Icons.dark_mode_outlined,
                selected: themeMode == ThemeMode.dark,
                onTap: () =>
                ref.read(themeModeProvider.notifier).state =
                    ThemeMode.dark,
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
              _InfoRow(context, 'AI Models',
                  'Gemini 3.1 Pro + Imagen 4'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _card(BuildContext context,
      {required List<Widget> children}) {
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
    style: ctx.colors.let((_) =>
    Theme.of(ctx).textTheme.labelSmall),
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
    this.isLast  = false,
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
        top:    isFirst ? const Radius.circular(12) : Radius.zero,
        bottom: isLast  ? const Radius.circular(12) : Radius.zero,
      ),
      child: Padding(
        padding:
        const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Icon(icon,
                size: 20,
                color: selected ? c.textPrimary : c.iconSecondary),
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
                  Text(subtitle,
                      style:
                      TextStyle(color: c.textMuted, fontSize: 12)),
                ],
              ),
            ),
            if (selected)
              const Icon(Icons.check_circle_rounded,
                  size: 20, color: AppColors.success),
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

// ignore: unused_element
extension _Let<T> on T {
  R let<R>(R Function(T) fn) => fn(this);
}