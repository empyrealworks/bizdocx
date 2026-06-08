import 'package:flutter/material.dart';
import '../onboarding_components.dart';
import '../../../../core/extensions/context_extensions.dart';

class AutonomousFilingSlide extends StatelessWidget {
  const AutonomousFilingSlide({super.key, required this.anim});
  final AnimationController anim;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return OnboardingPageShell(
      anim: anim,
      eyebrow: l.filingTitle,
      headline: l.filingHeadline,
      body: l.filingBody,
      accentColor: const Color(0xFF4ECDC4),
      illustration: const _FilingIllustration(),
    );
  }
}

class _FilingIllustration extends StatelessWidget {
  const _FilingIllustration();

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _FolderIcon(label: l.docTypeInvoice.toUpperCase(), color: const Color(0xFF4ECDC4), delay: 0),
          const SizedBox(width: 20),
          _FolderIcon(label: l.docTypeProposal.toUpperCase(), color: const Color(0xFFFFD166), delay: 400),
        ],
      ),
    );
  }
}

class _FolderIcon extends StatelessWidget {
  const _FolderIcon({required this.label, required this.color, required this.delay});
  final String label; final Color color; final int delay;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 80, height: 60,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: color, width: 2),
          ),
          child: Center(child: Icon(Icons.folder_open_rounded, color: color, size: 32)),
        ),
        const SizedBox(height: 12),
        Text(label, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1)),
      ],
    );
  }
}
