import 'package:flutter/material.dart';
import '../onboarding_components.dart';
import '../../../../core/extensions/context_extensions.dart';

class ScanDigitizeSlide extends StatelessWidget {
  const ScanDigitizeSlide({super.key, required this.anim});
  final AnimationController anim;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return OnboardingPageShell(
      anim: anim,
      eyebrow: l.scanTitle,
      headline: l.scanHeadline,
      body: l.scanBody,
      accentColor: const Color(0xFFFF6B35),
      illustration: const _ScanIllustration(),
    );
  }
}

class _ScanIllustration extends StatelessWidget {
  const _ScanIllustration();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Background Paper
          Container(
            width: 140, height: 180,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(4),
              boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 10)],
            ),
            child: Column(
              children: List.generate(8, (i) => Container(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                height: 4, color: Colors.grey.shade200,
              )),
            ),
          ),
          // Scanning Line
          _ScanningLine(),
          // Result Icon
          Positioned(
            bottom: 20, right: 0,
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFFF6B35),
                shape: BoxShape.circle,
                boxShadow: [BoxShadow(color: const Color(0xFFFF6B35).withValues(alpha: 0.3), blurRadius: 12)],
              ),
              child: const Icon(Icons.check_rounded, color: Colors.white, size: 24),
            ),
          ),
        ],
      ),
    );
  }
}

class _ScanningLine extends StatefulWidget {
  @override
  State<_ScanningLine> createState() => _ScanningLineState();
}

class _ScanningLineState extends State<_ScanningLine> with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(seconds: 2))..repeat(reverse: true);
  }
  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }
  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _ctrl,
      builder: (_, __) => Positioned(
        top: 20 + (_ctrl.value * 140),
        child: Container(
          width: 160, height: 2,
          decoration: BoxDecoration(
            color: const Color(0xFFFF6B35),
            boxShadow: [BoxShadow(color: const Color(0xFFFF6B35).withValues(alpha: 0.5), blurRadius: 8, spreadRadius: 1)],
          ),
        ),
      ),
    );
  }
}
