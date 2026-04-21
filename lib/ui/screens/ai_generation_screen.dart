import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/app_colors.dart';
import '../../models/document_asset.dart';
import '../../providers/document_generation_provider.dart';
import '../widgets/generation_state_overlay.dart';

class AiGenerationScreen extends ConsumerStatefulWidget {
  const AiGenerationScreen({super.key, required this.portfolioId});
  final String portfolioId;

  @override
  ConsumerState<AiGenerationScreen> createState() =>
      _AiGenerationScreenState();
}

class _AiGenerationScreenState
    extends ConsumerState<AiGenerationScreen> {
  final _promptCtrl = TextEditingController();
  final _titleCtrl = TextEditingController();
  DocumentType _selectedType = DocumentType.invoice;
  AssetPipeline _selectedPipeline = AssetPipeline.structural;

  @override
  void dispose() {
    _promptCtrl.dispose();
    _titleCtrl.dispose();
    super.dispose();
  }

  Future<void> _generate() async {
    // 1. Dismiss keyboard and wait for layout to settle
    FocusScope.of(context).unfocus();
    
    if (_promptCtrl.text.trim().isEmpty || _titleCtrl.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a title and prompt.')),
      );
      return;
    }

    final notifier = ref.read(
        documentGenerationProvider(widget.portfolioId).notifier);

    // Give a small frame for keyboard animation to finish
    await Future.delayed(const Duration(milliseconds: 300));

    final asset = await notifier.generate(
      prompt: _promptCtrl.text.trim(),
      type: _selectedType,
      pipeline: _selectedPipeline,
      title: _titleCtrl.text.trim(),
    );

    if (asset != null && mounted) {
      context.go(
        '/portfolio/${widget.portfolioId}/doc/${asset.id}',
        extra: asset,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final genState =
    ref.watch(documentGenerationProvider(widget.portfolioId));

    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            title: const Text('Generate Document'),
            leading: BackButton(
              onPressed: () =>
                  context.go('/portfolio/${widget.portfolioId}'),
            ),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _SectionLabel('Document Type'),
                const SizedBox(height: 12),
                _TypeSelector(
                  selected: _selectedType,
                  pipeline: _selectedPipeline,
                  onTypeChanged: (t) =>
                      setState(() => _selectedType = t),
                  onPipelineChanged: (p) =>
                      setState(() => _selectedPipeline = p),
                ),
                const SizedBox(height: 24),
                _SectionLabel('Document Title'),
                const SizedBox(height: 12),
                TextField(
                  controller: _titleCtrl,
                  decoration: const InputDecoration(
                    hintText: 'e.g. Invoice for Acme Corp — June 2025',
                  ),
                ),
                const SizedBox(height: 24),
                _SectionLabel('Prompt'),
                const SizedBox(height: 8),
                Text(
                  'Describe what you need. Your business context is automatically included.',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _promptCtrl,
                  maxLines: 7,
                  decoration: const InputDecoration(
                    hintText:
                    'e.g. Create a professional invoice for a shipment of 200 units of blue ceramic vases at \$45 each. Bill to: Luxe Home Decor Ltd, payment due in 30 days.',
                  ),
                ),
                const SizedBox(height: 32),
                FilledButton.icon(
                  onPressed: genState.isLoading ? null : _generate,
                  icon: const Icon(Icons.auto_awesome, size: 18),
                  label: const Text('Generate'),
                ),
              ],
            ),
          ),
        ),
        if (genState.isLoading)
          GenerationStateOverlay(
            phase: genState.phase,
            onCancel: () => ref
                .read(documentGenerationProvider(widget.portfolioId).notifier)
                .cancel(),
          ),
        if (genState.hasError)
          _ErrorOverlay(
            error: genState.error.toString(),
            onDismiss: () => ref
                .read(documentGenerationProvider(widget.portfolioId)
                .notifier)
                .reset(),
          ),
        if (genState.isCancelled)
           _CancelledOverlay(
            onDismiss: () => ref
                .read(documentGenerationProvider(widget.portfolioId)
                .notifier)
                .reset(),
          ),
      ],
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.text);
  final String text;

  @override
  Widget build(BuildContext context) => Text(
    text.toUpperCase(),
    style: Theme.of(context).textTheme.labelSmall,
  );
}

class _TypeSelector extends StatelessWidget {
  const _TypeSelector({
    required this.selected,
    required this.pipeline,
    required this.onTypeChanged,
    required this.onPipelineChanged,
  });

  final DocumentType selected;
  final AssetPipeline pipeline;
  final ValueChanged<DocumentType> onTypeChanged;
  final ValueChanged<AssetPipeline> onPipelineChanged;

  static const _structural = [
    DocumentType.invoice,
    DocumentType.proposal,
    DocumentType.letterhead,
    DocumentType.businessCard,
    DocumentType.contract,
    DocumentType.other,
  ];

  static const _graphical = [
    DocumentType.logo,
    DocumentType.icon,
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Pipeline toggle
        Row(
          children: AssetPipeline.values.map((p) {
            final active = pipeline == p;
            return Expanded(
              child: GestureDetector(
                onTap: () {
                  onPipelineChanged(p);
                  if (p == AssetPipeline.structural &&
                      _graphical.contains(selected)) {
                    onTypeChanged(DocumentType.invoice);
                  } else if (p == AssetPipeline.graphical &&
                      !_graphical.contains(selected)) {
                    onTypeChanged(DocumentType.logo);
                  }
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  margin: EdgeInsets.only(right: p == AssetPipeline.structural ? 6 : 0),
                  decoration: BoxDecoration(
                    color: active ? AppColors.white : AppColors.graphite,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Text(
                      p == AssetPipeline.structural
                          ? 'Structural'
                          : 'Graphical',
                      style: TextStyle(
                        color: active ? AppColors.black : AppColors.silver,
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 12),
        // Document type chips
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: (pipeline == AssetPipeline.structural
              ? _structural
              : _graphical)
              .map((t) {
            final active = selected == t;
            return GestureDetector(
              onTap: () => onTypeChanged(t),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                padding: const EdgeInsets.symmetric(
                    horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: active ? AppColors.white : AppColors.graphite,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: active ? AppColors.white : AppColors.border,
                  ),
                ),
                child: Text(
                  _label(t),
                  style: TextStyle(
                    color:
                    active ? AppColors.black : AppColors.silver,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  String _label(DocumentType t) {
    switch (t) {
      case DocumentType.invoice: return 'Invoice';
      case DocumentType.proposal: return 'Proposal';
      case DocumentType.letterhead: return 'Letterhead';
      case DocumentType.businessCard: return 'Business Card';
      case DocumentType.contract: return 'Contract';
      case DocumentType.logo: return 'Logo';
      case DocumentType.icon: return 'Icon';
      case DocumentType.other: return 'Other';
    }
  }
}

class _ErrorOverlay extends StatelessWidget {
  const _ErrorOverlay({required this.error, required this.onDismiss});
  final String error;
  final VoidCallback onDismiss;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onDismiss,
      child: Container(
        color: Colors.black87,
        child: Center(
          child: Container(
            margin: const EdgeInsets.all(32),
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppColors.card,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.error_outline,
                    color: AppColors.error, size: 36),
                const SizedBox(height: 16),
                Text('Generation Failed',
                    style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 8),
                Text(error,
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(color: AppColors.error),
                    textAlign: TextAlign.center),
                const SizedBox(height: 20),
                FilledButton(
                    onPressed: onDismiss,
                    child: const Text('Dismiss')),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _CancelledOverlay extends StatelessWidget {
  const _CancelledOverlay({required this.onDismiss});
  final VoidCallback onDismiss;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onDismiss,
      child: Container(
        color: Colors.black87,
        child: Center(
          child: Container(
            margin: const EdgeInsets.all(32),
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppColors.card,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.cancel_outlined,
                    color: AppColors.silver, size: 36),
                const SizedBox(height: 16),
                Text('Generation Cancelled',
                    style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 8),
                const Text('The operation was cancelled by the user.',
                    style: TextStyle(color: AppColors.muted, fontSize: 14),
                    textAlign: TextAlign.center),
                const SizedBox(height: 20),
                FilledButton(
                    onPressed: onDismiss,
                    child: const Text('Dismiss')),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
