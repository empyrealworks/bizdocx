import 'package:flutter/material.dart';
import '../onboarding_components.dart';
import '../../../../core/extensions/context_extensions.dart';

class AssetsSlide extends StatelessWidget {
  const AssetsSlide({super.key, required this.anim});
  final AnimationController anim;

  @override
  Widget build(BuildContext context) {
    return OnboardingPageShell(
      anim: anim,
      eyebrow: 'Brand Assets',
      headline: 'Your logo,\nbuilt in.',
      body:
      'Upload your company logo once. BizDocx embeds it automatically into invoices, proposals, letterheads, and more — pixel-perfect every time.',
      accentColor: const Color(0xFFFFBE0B),
      illustration: const _AssetsIllustration(),
    );
  }
}

class _AssetsIllustration extends StatefulWidget {
  const _AssetsIllustration();

  @override
  State<_AssetsIllustration> createState() => _AssetsIllustrationState();
}

class _AssetsIllustrationState extends State<_AssetsIllustration>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
        vsync: this,
        duration: const Duration(seconds: 2))
      ..repeat(reverse: true);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    const accent = Color(0xFFFFBE0B);
    return Container(
      color: c.card,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Radial glow
          AnimatedBuilder(
            animation: _ctrl,
            builder: (_, __) => Container(
              width: 220 + _ctrl.value * 20,
              height: 220 + _ctrl.value * 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    accent.withValues(alpha: 0.1 + _ctrl.value * 0.05),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),

          // Mock document with embedded logo area
          Container(
            width: 220, height: 280,
            decoration: BoxDecoration(
              color: c.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: c.border, width: 1.5),
              boxShadow: [
                BoxShadow(
                  color: accent.withValues(alpha: 0.12),
                  blurRadius: 30, spreadRadius: 2,
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Document header with logo spot
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: c.card,
                    borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(11)),
                    border: Border(bottom: BorderSide(color: c.border)),
                  ),
                  child: Row(
                    children: [
                      // Logo slot — glowing yellow badge
                      AnimatedBuilder(
                        animation: _ctrl,
                        builder: (_, __) => Container(
                          width: 36, height: 36,
                          decoration: BoxDecoration(
                            color: accent.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color:
                              accent.withValues(alpha: 0.4 + _ctrl.value * 0.3),
                              width: 1.5,
                            ),
                          ),
                          child: Icon(Icons.star_rounded,
                              size: 18, color: accent),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(height: 8, width: 80,
                                decoration: BoxDecoration(
                                  color: c.chipFill,
                                  borderRadius: BorderRadius.circular(4),
                                )),
                            const SizedBox(height: 4),
                            Container(height: 6, width: 50,
                                decoration: BoxDecoration(
                                  color: c.border,
                                  borderRadius: BorderRadius.circular(3),
                                )),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                // Skeleton lines
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _SkeletonLine(width: 140, color: c.chipFill),
                        const SizedBox(height: 6),
                        _SkeletonLine(width: 100, color: c.border),
                        const SizedBox(height: 16),
                        _SkeletonLine(width: double.infinity, color: c.border),
                        const SizedBox(height: 5),
                        _SkeletonLine(width: double.infinity, color: c.border),
                        const SizedBox(height: 5),
                        _SkeletonLine(width: 120, color: c.border),
                        const SizedBox(height: 16),
                        Row(children: [
                          Expanded(child: _SkeletonLine(
                              width: double.infinity, color: c.chipFill, height: 28)),
                          const SizedBox(width: 8),
                          Expanded(child: _SkeletonLine(
                              width: double.infinity, color: c.chipFill, height: 28)),
                        ]),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Upload badge floating top-right
          Positioned(
            top: 28, right: 28,
            child: AnimatedBuilder(
              animation: _ctrl,
              builder: (_, __) => Transform.translate(
                offset: Offset(0, -4 * _ctrl.value),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: accent,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: accent.withValues(alpha: 0.4),
                        blurRadius: 12, offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Icon(Icons.upload_rounded,
                          size: 14, color: Colors.black),
                      SizedBox(width: 5),
                      Text('Upload Logo',
                          style: TextStyle(
                            color: Colors.black, fontSize: 12,
                            fontWeight: FontWeight.w700,
                          )),
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

class _SkeletonLine extends StatelessWidget {
  const _SkeletonLine(
      {required this.width, required this.color, this.height = 8});
  final double width;
  final Color color;
  final double height;

  @override
  Widget build(BuildContext context) => Container(
    width: width,
    height: height,
    decoration: BoxDecoration(
      color: color,
      borderRadius: BorderRadius.circular(4),
    ),
  );
}
