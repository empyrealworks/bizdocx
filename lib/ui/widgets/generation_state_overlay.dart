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
    return Material(
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
                _title(context),
                style: TextStyle(
                  color: c.textPrimary,
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                  letterSpacing: -0.3,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                _subtitle(context),
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
                child: Text(context.l10n.cancel),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _title(BuildContext context) {
    final l = context.l10n;
    switch (phase) {
      case GenerationPhase.fetchingContext: return l.phaseLoadingContext;
      case GenerationPhase.generating:     return l.phaseGenerating;
      case GenerationPhase.converting:     return l.phaseRendering;
      case GenerationPhase.saving:         return l.phaseSaving;
      case GenerationPhase.savingVersion:  return l.phaseSavingVersion;
      default:                             return l.phaseWorking;
    }
  }

  String _subtitle(BuildContext context) {
    final l = context.l10n;
    switch (phase) {
      case GenerationPhase.fetchingContext:
        return l.phaseLoadingContextSub;
      case GenerationPhase.generating:
        return l.phaseGeneratingSub;
      case GenerationPhase.converting:
        return l.phaseRenderingSub;
      case GenerationPhase.saving:
        return l.phaseSavingSub;
      case GenerationPhase.savingVersion:
        return l.phaseSavingVersionSub;
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