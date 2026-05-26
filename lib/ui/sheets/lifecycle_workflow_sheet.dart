import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/extensions/context_extensions.dart';
import '../../models/document_asset.dart';
import '../../services/firebase_service.dart';
import 'smart_field_editor_sheet.dart';

class LifecycleWorkflowSheet extends ConsumerWidget {
  const LifecycleWorkflowSheet({super.key, required this.asset});
  final DocumentAsset asset;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.colors;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
      decoration: BoxDecoration(
        color: c.card,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Re-use or Modify',
            style: Theme.of(context).textTheme.headlineMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'Duplicate this design for a new project or fix typos instantly.',
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          
          _WorkflowCard(
            title: 'Use for New Document',
            subtitle: 'Clone this layout for a new client. Zero credit cost.',
            icon: Icons.copy_rounded,
            onTap: () async {
              final result = await showModalBottomSheet<DocumentAsset>(
                context: context,
                isScrollControlled: true,
                builder: (ctx) => SmartFieldEditorSheet(asset: asset, isDuplicating: true),
              );
              if (context.mounted) Navigator.pop(context, result);
            },
          ),
          const SizedBox(height: 16),
          _WorkflowCard(
            title: 'Quick Local Edit',
            subtitle: asset.status == DocumentStatus.signed 
                ? 'Editing is disabled for signed documents.' 
                : 'Update names, dates, or totals locally. Zero credit cost.',
            icon: Icons.bolt_rounded,
            enabled: asset.status != DocumentStatus.signed,
            onTap: () async {
              final result = await showModalBottomSheet<DocumentAsset>(
                context: context,
                isScrollControlled: true,
                builder: (ctx) => SmartFieldEditorSheet(asset: asset),
              );
              if (context.mounted) Navigator.pop(context, result);
            },
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

class _WorkflowCard extends StatelessWidget {
  const _WorkflowCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onTap,
    this.enabled = true,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback onTap;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Opacity(
      opacity: enabled ? 1.0 : 0.5,
      child: InkWell(
        onTap: enabled ? onTap : null,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            border: Border.all(color: enabled ? c.border : c.border.withValues(alpha: 0.5)),
            borderRadius: BorderRadius.circular(16),
            color: enabled ? null : c.chipFill.withValues(alpha: 0.5),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: enabled ? c.chipFill : c.border.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  enabled ? icon : Icons.lock_outline_rounded, 
                  color: enabled ? c.iconPrimary : c.textMuted, 
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: enabled ? null : c.textMuted)),
                    const SizedBox(height: 4),
                    Text(subtitle, style: TextStyle(color: c.textMuted, fontSize: 13)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
