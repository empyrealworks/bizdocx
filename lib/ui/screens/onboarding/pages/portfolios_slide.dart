import 'package:flutter/material.dart';
import '../onboarding_components.dart';
import '../../../../core/extensions/context_extensions.dart';

class PortfoliosSlide extends StatelessWidget {
  const PortfoliosSlide({super.key, required this.anim});
  final AnimationController anim;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return OnboardingPageShell(
      anim: anim,
      eyebrow: 'Portfolios',
      headline: 'One hub for\nevery business.',
      body:
      'Create separate portfolios for each brand. Each one keeps its own documents, brand colours, mission, and AI context — all in one place.',
      accentColor: const Color(0xFF4ECDC4),
      illustration: _PortfoliosIllustration(c: c),
    );
  }
}

class _PortfoliosIllustration extends StatelessWidget {
  const _PortfoliosIllustration({required this.c});
  final dynamic c;

  static const _portfolios = [
    (name: 'Acme Ceramics', colors: [Color(0xFF2C3E50), Color(0xFFE74C3C)]),
    (name: 'Luxe Retail Co.', colors: [Color(0xFFFFBE0B), Color(0xFFFB5607)]),
    (name: 'Nova Tech Ltd', colors: [Color(0xFF6C7FFF), Color(0xFF4ECDC4)]),
  ];

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Container(
      color: c.card,
      child: Stack(
        children: [
          // Background grid lines
          CustomPaint(
            size: Size.infinite,
            painter: _GridPainter(color: c.border),
          ),

          // Stacked portfolio cards
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(_portfolios.length, (i) {
                final p = _portfolios[i];
                final offset = (i - 1) * 0.5;
                return Transform.translate(
                  offset: Offset(offset * 8, 0),
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: _MiniPortfolioCard(
                      name: p.name,
                      colors: p.colors,
                      docCount: 3 + i * 2,
                      elevation: (2 - i).toDouble(),
                    ),
                  ),
                );
              }),
            ),
          ),

          // "+" badge
          Positioned(
            bottom: 28, right: 32,
            child: Container(
              width: 44, height: 44,
              decoration: BoxDecoration(
                color: const Color(0xFF4ECDC4),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF4ECDC4).withValues(alpha: 0.35),
                    blurRadius: 16,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: const Icon(Icons.add, color: Colors.white, size: 22),
            ),
          ),
        ],
      ),
    );
  }
}

class _MiniPortfolioCard extends StatelessWidget {
  const _MiniPortfolioCard({
    required this.name,
    required this.colors,
    required this.docCount,
    required this.elevation,
  });
  final String name;
  final List<Color> colors;
  final int docCount;
  final double elevation;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            colors[0].withValues(alpha: 0.18),
            colors[1].withValues(alpha: 0.06),
            c.surface,
          ],
          stops: const [0.0, 0.4, 1.0],
        ),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: colors[0].withValues(alpha: 0.35), width: 1.2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06 + elevation * 0.02),
            blurRadius: 12 + elevation * 4,
            offset: Offset(0, 4 + elevation),
          ),
        ],
      ),
      child: Row(
        children: [
          Row(
            children: colors.map((col) => Container(
              width: 20, height: 20,
              margin: const EdgeInsets.only(right: 5),
              decoration: BoxDecoration(
                color: col, shape: BoxShape.circle,
                border: Border.all(color: c.border.withValues(alpha: 0.5)),
              ),
            )).toList(),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(name,
                style: TextStyle(
                  color: c.textPrimary,
                  fontSize: 14, fontWeight: FontWeight.w600,
                )),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: c.chipFill,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text('$docCount docs',
                style: TextStyle(color: c.textMuted, fontSize: 11)),
          ),
        ],
      ),
    );
  }
}

class _GridPainter extends CustomPainter {
  const _GridPainter({required this.color});
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color.withValues(alpha: 0.5)..strokeWidth = 0.5;
    const step = 36.0;
    for (double x = 0; x < size.width; x += step) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y < size.height; y += step) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(_GridPainter old) => old.color != color;
}
