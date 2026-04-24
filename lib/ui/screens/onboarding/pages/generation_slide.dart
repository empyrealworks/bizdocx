import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../onboarding_components.dart';
import '../../../../core/extensions/context_extensions.dart';

class GenerationSlide extends StatelessWidget {
  const GenerationSlide({super.key, required this.anim});
  final AnimationController anim;

  @override
  Widget build(BuildContext context) {
    return OnboardingPageShell(
      anim: anim,
      eyebrow: 'AI Generation',
      headline: 'From a prompt\nto a document.',
      body:
      'Describe what you need. BizDocx generates print-ready HTML documents, or high-quality visuals like logos and icons.',
      accentColor: const Color(0xFF6C7FFF),
      illustration: const _GenerationIllustration(),
    );
  }
}

class _GenerationIllustration extends StatefulWidget {
  const _GenerationIllustration();

  @override
  State<_GenerationIllustration> createState() =>
      _GenerationIllustrationState();
}

class _GenerationIllustrationState extends State<_GenerationIllustration>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 2400))
      ..repeat();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Container(
      color: c.surface,
      child: Stack(children: [
        // Diagonal separator line
        CustomPaint(
          size: Size.infinite,
          painter: _DiagonalPainter(color: c.border),
        ),

        // Left panel: Structural
        Positioned(
          left: 0, top: 0, bottom: 0,
          width: MediaQuery.of(context).size.width * 0.5 - 1,
          child: _GenerationPanel(
            label: 'Structural',
            sublabel: 'Document Engine',
            icon: Icons.description_outlined,
            accent: const Color(0xFF6C7FFF),
            ctrl: _ctrl,
            items: const ['Invoice', 'Proposal', 'Contract', 'Letterhead'],
          ),
        ),

        // Right panel: Graphical
        Positioned(
          right: 0, top: 0, bottom: 0,
          width: MediaQuery.of(context).size.width * 0.5 - 1,
          child: _GenerationPanel(
            label: 'Graphical',
            sublabel: 'Visual Engine',
            icon: Icons.auto_awesome_outlined,
            accent: const Color(0xFFFF6B6B),
            ctrl: _ctrl,
            items: const ['Logo', 'Icon', 'Illustration', 'Badge'],
            reversed: true,
          ),
        ),

        // Gem icon at centre
        Center(
          child: AnimatedBuilder(
            animation: _ctrl,
            builder: (_, __) => Transform.rotate(
              angle: _ctrl.value * 2 * math.pi,
              child: Container(
                width: 44, height: 44,
                decoration: BoxDecoration(
                  color: c.card,
                  shape: BoxShape.circle,
                  border: Border.all(color: c.border, width: 2),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF6C7FFF).withValues(alpha: 0.2),
                      blurRadius: 20, spreadRadius: 2,
                    ),
                  ],
                ),
                child: const Center(
                  child: Icon(Icons.auto_fix_high_rounded,
                      size: 20, color: Color(0xFF6C7FFF)),
                ),
              ),
            ),
          ),
        ),
      ]),
    );
  }
}

class _GenerationPanel extends StatelessWidget {
  const _GenerationPanel({
    required this.label,
    required this.sublabel,
    required this.icon,
    required this.accent,
    required this.ctrl,
    required this.items,
    this.reversed = false,
  });
  final String label, sublabel;
  final IconData icon;
  final Color accent;
  final AnimationController ctrl;
  final List<String> items;
  final bool reversed;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Container(
      color: c.card,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: reversed
            ? CrossAxisAlignment.end
            : CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          // Label
          Row(
            mainAxisAlignment: reversed
                ? MainAxisAlignment.end
                : MainAxisAlignment.start,
            children: [
              if (!reversed) Icon(icon, size: 16, color: accent),
              if (!reversed) const SizedBox(width: 6),
              Column(
                crossAxisAlignment: reversed
                    ? CrossAxisAlignment.end
                    : CrossAxisAlignment.start,
                children: [
                  Text(label,
                      style: TextStyle(
                        color: c.textPrimary, fontSize: 14,
                        fontWeight: FontWeight.w700,
                      )),
                  Text(sublabel,
                      style: TextStyle(
                          color: accent, fontSize: 10,
                          fontWeight: FontWeight.w600)),
                ],
              ),
              if (reversed) const SizedBox(width: 6),
              if (reversed) Icon(icon, size: 16, color: accent),
            ],
          ),
          const SizedBox(height: 16),
          // Animated item list
          ...items.asMap().entries.map((e) {
            final delay = e.key / items.length;
            return AnimatedBuilder(
              animation: ctrl,
              builder: (_, __) {
                final t = ((ctrl.value - delay) % 1.0).clamp(0.0, 1.0);
                final opacity =
                (math.sin(t * math.pi)).clamp(0.2, 1.0).toDouble();
                return Opacity(
                  opacity: opacity,
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 7),
                    decoration: BoxDecoration(
                      color: accent.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                          color: accent.withValues(alpha: 0.2)),
                    ),
                    child: Text(e.value,
                        style: TextStyle(
                          color: c.textSecondary, fontSize: 12,
                          fontWeight: FontWeight.w500,
                        )),
                  ),
                );
              },
            );
          }),
        ],
      ),
    );
  }
}

class _DiagonalPainter extends CustomPainter {
  const _DiagonalPainter({required this.color});
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color..strokeWidth = 1;
    canvas.drawLine(
      Offset(size.width / 2, 0),
      Offset(size.width / 2, size.height),
      paint,
    );
  }

  @override
  bool shouldRepaint(_DiagonalPainter old) => old.color != color;
}
