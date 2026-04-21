import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../providers/document_generation_provider.dart';

class GenerationStateOverlay extends StatelessWidget {
  const GenerationStateOverlay({super.key, required this.phase, required this.onCancel});
  final GenerationPhase phase;
  final VoidCallback onCancel;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black.withOpacity(0.85),
      child: Center(
        child: Container(
          margin: const EdgeInsets.all(40),
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            color: AppColors.card,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.border),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(
                width: 48,
                height: 48,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: AppColors.white,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                _title,
                style: const TextStyle(
                  color: AppColors.white,
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                  letterSpacing: -0.3,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                _subtitle,
                textAlign: TextAlign.center,
                style: const TextStyle(
                    color: AppColors.muted, fontSize: 14, height: 1.4),
              ),
              const SizedBox(height: 24),
              _PhaseIndicator(phase: phase),
              const SizedBox(height: 32),
              OutlinedButton(
                onPressed: onCancel,
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.silver,
                  side: const BorderSide(color: AppColors.border),
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
      case GenerationPhase.generating: return 'Generating Document';
      case GenerationPhase.converting: return 'Rendering PDF';
      case GenerationPhase.saving: return 'Saving to Cloud';
      default: return 'Working…';
    }
  }

  String get _subtitle {
    switch (phase) {
      case GenerationPhase.fetchingContext:
        return 'Retrieving your business context for personalisation.';
      case GenerationPhase.generating:
        return 'Gemini is crafting your document using your business profile.';
      case GenerationPhase.converting:
        return 'Converting HTML to a print-ready PDF.';
      case GenerationPhase.saving:
        return 'Saving to Firestore and caching locally.';
      default: return '';
    }
  }
}

class _PhaseIndicator extends StatelessWidget {
  const _PhaseIndicator({required this.phase});
  final GenerationPhase phase;

  static const _phases = [
    GenerationPhase.fetchingContext,
    GenerationPhase.generating,
    GenerationPhase.converting,
    GenerationPhase.saving,
  ];

  @override
  Widget build(BuildContext context) {
    final current = _phases.indexOf(phase);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(_phases.length * 2 - 1, (i) {
        if (i.isOdd) {
          return Container(
            width: 20, height: 1,
            color: AppColors.border,
          );
        }
        final phaseIndex = i ~/ 2;
        final done = phaseIndex < current;
        final active = phaseIndex == current;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: done
                ? AppColors.success
                : active
                ? AppColors.white
                : AppColors.graphite,
            border: Border.all(
              color: active ? AppColors.white : AppColors.border,
            ),
          ),
        );
      }),
    );
  }
}
