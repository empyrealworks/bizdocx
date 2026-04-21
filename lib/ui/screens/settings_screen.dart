import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/app_colors.dart';
import '../../providers/theme_provider.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        leading: BackButton(onPressed: () => context.go('/')),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _SectionHeader('Appearance'),
          const SizedBox(height: 8),
          _ThemeCard(current: themeMode, onChanged: (m) {
            ref.read(themeModeProvider.notifier).state = m;
          }),
          const SizedBox(height: 32),
          _SectionHeader('About'),
          const SizedBox(height: 8),
          _InfoCard(
            children: [
              _InfoRow(label: 'App', value: 'BizDocx'),
              _InfoRow(label: 'Version', value: '1.0.0'),
              _InfoRow(label: 'AI Models', value: 'Gemini 3.1 Pro + Imagen 4'),
            ],
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader(this.text);
  final String text;

  @override
  Widget build(BuildContext context) => Text(
    text.toUpperCase(),
    style: Theme.of(context).textTheme.labelSmall,
  );
}

class _ThemeCard extends StatelessWidget {
  const _ThemeCard({required this.current, required this.onChanged});
  final ThemeMode current;
  final ValueChanged<ThemeMode> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          _ThemeTile(
            label: 'System',
            subtitle: 'Follow device setting',
            icon: Icons.brightness_auto_outlined,
            selected: current == ThemeMode.system,
            onTap: () => onChanged(ThemeMode.system),
          ),
          Divider(height: 1, color: AppColors.border),
          _ThemeTile(
            label: 'Light',
            subtitle: 'Always use light theme',
            icon: Icons.light_mode_outlined,
            selected: current == ThemeMode.light,
            onTap: () => onChanged(ThemeMode.light),
          ),
          Divider(height: 1, color: AppColors.border),
          _ThemeTile(
            label: 'Dark',
            subtitle: 'Always use dark theme',
            icon: Icons.dark_mode_outlined,
            selected: current == ThemeMode.dark,
            onTap: () => onChanged(ThemeMode.dark),
            isLast: true,
          ),
        ],
      ),
    );
  }
}

class _ThemeTile extends StatelessWidget {
  const _ThemeTile({
    required this.label,
    required this.subtitle,
    required this.icon,
    required this.selected,
    required this.onTap,
    this.isLast = false,
  });

  final String label;
  final String subtitle;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.vertical(
        top: label == 'System' ? const Radius.circular(12) : Radius.zero,
        bottom: isLast ? const Radius.circular(12) : Radius.zero,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Icon(icon,
                size: 20,
                color: selected ? AppColors.white : AppColors.silver),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label,
                      style: TextStyle(
                        color: selected ? AppColors.white : AppColors.silver,
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      )),
                  Text(subtitle,
                      style: const TextStyle(
                          color: AppColors.muted, fontSize: 12)),
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

class _InfoCard extends StatelessWidget {
  const _InfoCard({required this.children});
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(children: children),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: const TextStyle(color: AppColors.silver, fontSize: 14)),
          Text(value,
              style: const TextStyle(color: AppColors.muted, fontSize: 14)),
        ],
      ),
    );
  }
}