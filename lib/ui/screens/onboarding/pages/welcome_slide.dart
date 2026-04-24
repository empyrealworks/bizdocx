import 'package:flutter/material.dart';
import '../onboarding_components.dart';
import '../../../../core/extensions/context_extensions.dart';

class WelcomeSlide extends StatelessWidget {
  const WelcomeSlide({super.key, required this.anim});
  final AnimationController anim;

  @override
  Widget build(BuildContext context) {
    return OnboardingPageShell(
      anim: anim,
      eyebrow: 'Welcome to BizDocx',
      headline: 'Business documents,\nbeautifully made.',
      body:
      'Generate professional invoices, proposals, logos, and more — powered by AI and tailored to your brand.',
      accentColor: const Color(0xFF6C7FFF),
      illustration: const _WelcomeIllustration(),
    );
  }
}

class _WelcomeIllustration extends StatefulWidget {
  const _WelcomeIllustration({super.key});

  @override
  State<_WelcomeIllustration> createState() => _WelcomeIllustrationState();
}

class _WelcomeIllustrationState extends State<_WelcomeIllustration>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulse;

  @override
  void initState() {
    super.initState();
    _pulse = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulse.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final isDark = context.isDark;

    return Container(
      color: c.card,
      child: Stack(
        children: [
          // Large tonal circle backdrop
          Positioned.fill(
            child: AnimatedBuilder(
              animation: _pulse,
              builder: (_, __) => CustomPaint(
                painter: _CircleRingPainter(
                  progress: _pulse.value,
                  color: const Color(0xFF6C7FFF),
                ),
              ),
            ),
          ),
          // Centre logo card
          Center(
            child: AnimatedBuilder(
              animation: _pulse,
              builder: (_, __) => Transform.scale(
                scale: 1.0 + _pulse.value * 0.015,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 32, vertical: 32),
                  decoration: BoxDecoration(
                    color: c.surface,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: c.border, width: 1.5),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF6C7FFF).withValues(alpha: 0.18),
                        blurRadius: 40,
                        spreadRadius: 4,
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset(
                        'assets/images/logo.png',
                        height: 100,
                        width: 100,
                        fit: BoxFit.contain,
                        // Invert logo color for dark mode (tint black line-art to white)
                        color: isDark ? Colors.white : null,
                        colorBlendMode: isDark ? BlendMode.srcIn : null,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'BizDocx',
                        style: TextStyle(
                          color: c.textPrimary,
                          fontSize: 28,
                          fontWeight: FontWeight.w800,
                          letterSpacing: -1.0,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          // Floating document chips
          Positioned(
            top: 48, left: 28,
            child: _FloatingChip(
              icon: Icons.receipt_long_outlined,
              label: 'Invoice',
              delay: 0,
              accent: const Color(0xFF6C7FFF),
            ),
          ),
          Positioned(
            top: 60, right: 24,
            child: _FloatingChip(
              icon: Icons.auto_awesome_outlined,
              label: 'Logo',
              delay: 400,
              accent: const Color(0xFFFF6B6B),
            ),
          ),
          Positioned(
            bottom: 52, left: 36,
            child: _FloatingChip(
              icon: Icons.assignment_outlined,
              label: 'Proposal',
              delay: 200,
              accent: const Color(0xFF4ECDC4),
            ),
          ),
          Positioned(
            bottom: 44, right: 28,
            child: _FloatingChip(
              icon: Icons.handshake_outlined,
              label: 'Contract',
              delay: 600,
              accent: const Color(0xFFFFBE0B),
            ),
          ),
        ],
      ),
    );
  }
}

class _CircleRingPainter extends CustomPainter {
  const _CircleRingPainter({required this.progress, required this.color});
  final double progress;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    for (int i = 0; i < 3; i++) {
      final r = 60.0 + i * 55.0 + progress * 12.0;
      final paint = Paint()
        ..color = color.withValues(alpha: 0.04 - i * 0.01)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5;
      canvas.drawCircle(center, r, paint);
    }
  }

  @override
  bool shouldRepaint(_CircleRingPainter old) =>
      old.progress != progress;
}

class _FloatingChip extends StatefulWidget {
  const _FloatingChip({
    required this.icon,
    required this.label,
    required this.delay,
    required this.accent,
  });
  final IconData icon;
  final String label;
  final int delay;
  final Color accent;

  @override
  State<_FloatingChip> createState() => _FloatingChipState();
}

class _FloatingChipState extends State<_FloatingChip>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2800),
    );
    Future.delayed(Duration(milliseconds: widget.delay), () {
      if (mounted) _ctrl.repeat(reverse: true);
    });
    _anim = Tween<double>(begin: 0, end: 6).animate(
        CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return AnimatedBuilder(
      animation: _anim,
      builder: (_, __) => Transform.translate(
        offset: Offset(0, -_anim.value),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
          decoration: BoxDecoration(
            color: c.card,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: widget.accent.withValues(alpha: 0.4)),
            boxShadow: [
              BoxShadow(
                color: widget.accent.withValues(alpha: 0.12),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(mainAxisSize: MainAxisSize.min, children: [
            Icon(widget.icon, size: 14, color: widget.accent),
            const SizedBox(width: 6),
            Text(
              widget.label,
              style: TextStyle(
                color: c.textSecondary,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
