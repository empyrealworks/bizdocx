import 'package:flutter/material.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../onboarding_components.dart';

class SmartFieldsSlide extends StatelessWidget {
  const SmartFieldsSlide({super.key, required this.anim});
  final AnimationController anim;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return OnboardingPageShell(
      anim: anim,
      eyebrow: l.smartTitle,
      headline: l.smartHeadline,
      body: l.smartBody,
      accentColor: const Color(0xFF6C7FFF),
      illustration: const _SmartFieldsIllustration(),
    );
  }
}

class _SmartFieldsIllustration extends StatelessWidget {
  const _SmartFieldsIllustration();

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return Center(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade200),
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10)],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l.totalDue, style: const TextStyle(color: Colors.grey, fontSize: 10, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFF6C7FFF).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: const Color(0xFF6C7FFF)),
              ),
              child: Text('\$1,200.00', style: const TextStyle(color: Color(0xFF6C7FFF), fontWeight: FontWeight.bold, fontSize: 18)),
            ),
            const SizedBox(height: 12),
            Text(l.client, style: const TextStyle(color: Colors.grey, fontSize: 10, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Container(
              width: 120, height: 12,
              decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(2)),
            ),
          ],
        ),
      ),
    );
  }
}
