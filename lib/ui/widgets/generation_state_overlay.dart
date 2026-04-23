import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../core/extensions/context_extensions.dart';
import '../../providers/document_generation_provider.dart';

class GenerationStateOverlay extends StatelessWidget {
  const GenerationStateOverlay(
      {super.key, required this.phase, required this.onCancel});
  final GenerationPhase phase;
  final VoidCallback onCancel;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Container(
      color: c.overlayBarrier,
      child: Center(
        child: Container(
          margin: const EdgeInsets.all(40),
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            color: c.card,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: c.border),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: 48,
                height: 48,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: c.textPrimary,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                _title,
                style: TextStyle(
                  color: c.textPrimary,
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                  letterSpacing: -0.3,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                _subtitle,
                textAlign: TextAlign.center,
                style: TextStyle(color: c.textMuted, fontSize: 14, height: 1.4),
              ),
              const SizedBox(height: 24),
              _PhaseIndicator(phase: phase),
              const SizedBox(height: 32),
              OutlinedButton(
                onPressed: onCancel,
                style: OutlinedButton.styleFrom(
                  foregroundColor: c.textBody,
                  side: BorderSide(color: c.border),
                  minimumSize: const Size(120, 40),
                ),
                child: const Text('Cancel'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String get _title {
    switch (phase) {
      case GenerationPhase.fetchingContext: return 'Loading Context';
      case GenerationPhase.generating:     return 'Generating Document';
      case GenerationPhase.converting:     return 'Rendering Asset';
      case GenerationPhase.saving:         return 'Saving to Cloud';
      case GenerationPhase.savingVersion:  return 'Saving Version';
      default:                             return 'Working…';
    }
  }

  String get _subtitle {
    switch (phase) {
      case GenerationPhase.fetchingContext:
        return 'Retrieving your business context for personalisation.';
      case GenerationPhase.generating:
        return 'Crafting your document using your business profile.';
      case GenerationPhase.converting:
        return 'Processing and caching the generated asset.';
      case GenerationPhase.saving:
        return 'Saving to Cloud and caching locally.';
      case GenerationPhase.savingVersion:
        return 'Archiving this version in your history.';
      default:
        return '';
    }
  }
}

class _PhaseIndicator extends StatelessWidget {
  const _PhaseIndicator({required this.phase});
  final GenerationPhase phase;

  static const _phases = [
    GenerationPhase.fetchingContext,
    GenerationPhase.generating,
    GenerationPhase.saving,
    GenerationPhase.savingVersion,
  ];

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final current = _phases.indexOf(phase);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(_phases.length * 2 - 1, (i) {
        if (i.isOdd) {
          return Container(width: 20, height: 1, color: c.border);
        }
        final idx = i ~/ 2;
        final done   = idx < current;
        final active = idx == current;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: done
                ? AppColors.success
                : active
                ? c.textPrimary
                : c.chipFill,
            border: Border.all(
              color: active ? c.textPrimary : c.border,
            ),
          ),
        );
      }),
    );
  }
}