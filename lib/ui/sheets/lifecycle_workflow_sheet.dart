import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

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
            'Choose how you want to interact with this document.',
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          
          _WorkflowCard(
            title: 'Use for New Document',
            subtitle: 'Duplicate this layout for a new client or project. 0 credit cost.',
            icon: Icons.copy_rounded,
            onTap: () => _handleDuplicate(context),
          ),
          const SizedBox(height: 16),
          _WorkflowCard(
            title: 'Modify Current Document',
            subtitle: 'Update text, dates, or remodel the entire design.',
            icon: Icons.edit_document,
            onTap: () => _showModifyOptions(context),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Future<void> _handleDuplicate(BuildContext context) async {
    // 1. Duplicate in Firestore
    final newAsset = await FirebaseService.instance.duplicateDocumentAsset(asset);
    
    // 2. Open Smart Field Editor for the new asset
    if (context.mounted) {
      Navigator.pop(context); // Close selection sheet
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (ctx) => SmartFieldEditorSheet(asset: newAsset, isNew: true),
      );
    }
  }

  void _showModifyOptions(BuildContext context) {
    Navigator.pop(context);
    showModalBottomSheet(
      context: context,
      builder: (ctx) => _ModifyOptionsSheet(asset: asset),
    );
  }
}

class _ModifyOptionsSheet extends StatelessWidget {
  const _ModifyOptionsSheet({required this.asset});
  final DocumentAsset asset;

  @override
  Widget build(BuildContext context) {
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
          Text('Modify Document', style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 24),
          _WorkflowCard(
            title: 'Quick Local Edit',
            subtitle: 'Edit names, dates, and totals locally. 0 credit cost.',
            icon: Icons.bolt_rounded,
            onTap: () {
              Navigator.pop(context);
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                builder: (ctx) => SmartFieldEditorSheet(asset: asset),
              );
            },
          ),
          const SizedBox(height: 16),
          _WorkflowCard(
            title: 'Deep AI Remodel',
            subtitle: 'Structural changes or design updates via AI. 5 credit cost.',
            icon: Icons.auto_awesome,
            onTap: () {
              // Path to Refinement Screen
              Navigator.pop(context);
              context.push('/portfolio/${asset.portfolioId}/doc/${asset.id}/refine', extra: asset);
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
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(color: c.border),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: c.chipFill,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: c.iconPrimary, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 4),
                  Text(subtitle, style: TextStyle(color: c.textMuted, fontSize: 13)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
