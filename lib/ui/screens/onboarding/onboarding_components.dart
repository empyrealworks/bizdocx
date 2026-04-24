import 'package:flutter/material.dart';
import '../../../core/extensions/context_extensions.dart';

// ── Shared Page Shell ────────────────────────────────────────────────────────

class OnboardingPageShell extends StatelessWidget {
  const OnboardingPageShell({
    super.key,
    required this.illustration,
    required this.eyebrow,
    required this.headline,
    required this.body,
    required this.anim,
    this.accentColor,
  });

  final Widget illustration;
  final String eyebrow;
  final String headline;
  final String body;
  final AnimationController anim;
  final Color? accentColor;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;

    final fadeAnim = CurvedAnimation(parent: anim, curve: Curves.easeOut);
    final slideAnim = Tween<Offset>(
      begin: const Offset(0, 0.06),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: anim, curve: Curves.easeOutCubic));

    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 96),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Illustration panel — takes top 52% of screen
          Expanded(
            flex: 52,
            child: illustration,
          ),

          // Text content
          Expanded(
            flex: 48,
            child: FadeTransition(
              opacity: fadeAnim,
              child: SlideTransition(
                position: slideAnim,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(28, 28, 28, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Eyebrow
                      Text(
                        eyebrow.toUpperCase(),
                        style: TextStyle(
                          color: accentColor ?? c.textMuted,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 1.4,
                        ),
                      ),
                      const SizedBox(height: 10),
                      // Headline
                      Text(
                        headline,
                        style: TextStyle(
                          color: c.textPrimary,
                          fontSize: 28,
                          fontWeight: FontWeight.w700,
                          letterSpacing: -0.8,
                          height: 1.15,
                        ),
                      ),
                      const SizedBox(height: 14),
                      // Body
                      Text(
                        body,
                        style: TextStyle(
                          color: c.textBody,
                          fontSize: 15,
                          height: 1.6,
                          letterSpacing: -0.1,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Page Dots ─────────────────────────────────────────────────────────────────

class OnboardingPageDots extends StatelessWidget {
  const OnboardingPageDots({super.key, required this.current, required this.total});
  final int current;
  final int total;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Row(
      children: List.generate(total, (i) {
        final active = i == current;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          margin: const EdgeInsets.only(right: 6),
          width: active ? 24 : 6,
          height: 6,
          decoration: BoxDecoration(
            color: active ? c.textPrimary : c.border,
            borderRadius: BorderRadius.circular(3),
          ),
        );
      }),
    );
  }
}

// ── Next Button ───────────────────────────────────────────────────────────────

class OnboardingNextButton extends StatelessWidget {
  const OnboardingNextButton({super.key, required this.isLast, required this.onTap});
  final bool isLast;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: isLast ? 140 : 52,
        height: 52,
        decoration: BoxDecoration(
          color: c.filledButtonBg,
          borderRadius: BorderRadius.circular(26),
        ),
        child: isLast
            ? Center(
          child: Text(
            'Get Started',
            style: TextStyle(
              color: c.filledButtonFg,
              fontSize: 15,
              fontWeight: FontWeight.w600,
              letterSpacing: -0.2,
            ),
          ),
        )
            : Center(
          child: Icon(Icons.arrow_forward_rounded,
              color: c.filledButtonFg, size: 20),
        ),
      ),
    );
  }
}
