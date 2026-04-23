import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/app_colors.dart';
import '../../core/extensions/context_extensions.dart';
import '../../providers/onboarding_provider.dart';

// ── Entry point ───────────────────────────────────────────────────────────────

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen>
    with TickerProviderStateMixin {
  final _controller = PageController();
  late final AnimationController _fadeCtrl;
  late final AnimationController _slideCtrl;
  int _page = 0;

  static const _totalPages = 6;

  @override
  void initState() {
    super.initState();
    _fadeCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 600));
    _slideCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500));
    _fadeCtrl.forward();
    _slideCtrl.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    _fadeCtrl.dispose();
    _slideCtrl.dispose();
    super.dispose();
  }

  Future<void> _advance() async {
    if (_page < _totalPages - 1) {
      await _controller.nextPage(
        duration: const Duration(milliseconds: 420),
        curve: Curves.easeInOutCubic,
      );
    } else {
      await _complete();
    }
  }

  Future<void> _complete() async {
    try {
      // 1. Mark onboarding as seen via the notifier
      await ref.read(onboardingSeenProvider.notifier).markSeen();

      // 2. Navigate to the root
      if (mounted) {
        context.go('/');
      }
    } catch (e) {
      debugPrint('Onboarding completion error: $e');
      if (mounted) context.go('/');
    }
  }

  void _onPageChanged(int page) {
    setState(() => _page = page);
    _slideCtrl.forward(from: 0);
    _fadeCtrl.forward(from: 0);
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final isLast = _page == _totalPages - 1;

    return Scaffold(
      backgroundColor: c.surface,
      body: SafeArea(
        child: Stack(
          children: [
            // ── Page content ────────────────────────────────────────────
            PageView(
              controller: _controller,
              onPageChanged: _onPageChanged,
              physics: const BouncingScrollPhysics(),
              children: [
                _WelcomePage(anim: _slideCtrl),
                _PortfoliosPage(anim: _slideCtrl),
                _GenerationPage(anim: _slideCtrl),
                _AssetsPage(anim: _slideCtrl),
                _RefinementPage(anim: _slideCtrl),
                _GetStartedPage(anim: _slideCtrl, onTap: _complete),
              ],
            ),

            // ── Top bar: Skip ────────────────────────────────────────────
            if (!isLast)
              Positioned(
                top: 12,
                right: 20,
                child: TextButton(
                  onPressed: _complete,
                  style: TextButton.styleFrom(
                    foregroundColor: c.textMuted,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 6),
                  ),
                  child: const Text('Skip',
                      style: TextStyle(
                          fontSize: 14, fontWeight: FontWeight.w500)),
                ),
              ),

            // ── Bottom bar: Indicator + Next ─────────────────────────────
            Positioned(
              left: 0,
              right: 0,
              bottom: 24,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 28),
                child: Row(
                  children: [
                    _PageDots(current: _page, total: _totalPages),
                    const Spacer(),
                    _NextButton(
                      isLast: isLast,
                      onTap: _advance,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Page Dots ─────────────────────────────────────────────────────────────────

class _PageDots extends StatelessWidget {
  const _PageDots({required this.current, required this.total});
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

class _NextButton extends StatelessWidget {
  const _NextButton({required this.isLast, required this.onTap});
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

// ── Shared page scaffold ──────────────────────────────────────────────────────

class _PageShell extends StatelessWidget {
  const _PageShell({
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

// ═════════════════════════════════════════════════════════════════════════════
// SLIDE 1 — Welcome
// ═════════════════════════════════════════════════════════════════════════════

class _WelcomePage extends StatelessWidget {
  const _WelcomePage({required this.anim});
  final AnimationController anim;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return _PageShell(
      anim: anim,
      eyebrow: 'Welcome to BizDocx',
      headline: 'Business documents,\nbeautifully made.',
      body:
      'Generate professional invoices, proposals, logos, and more — powered by AI and tailored to your brand.',
      accentColor: const Color(0xFF6C7FFF),
      illustration: _WelcomeIllustration(c: c),
    );
  }
}

class _WelcomeIllustration extends StatefulWidget {
  const _WelcomeIllustration({required this.c});
  final dynamic c;

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
          // Centre wordmark card
          Center(
            child: AnimatedBuilder(
              animation: _pulse,
              builder: (_, __) => Transform.scale(
                scale: 1.0 + _pulse.value * 0.015,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 32, vertical: 22),
                  decoration: BoxDecoration(
                    color: c.surface,
                    borderRadius: BorderRadius.circular(20),
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
                      Text(
                        'BizDocx',
                        style: TextStyle(
                          color: c.textPrimary,
                          fontSize: 36,
                          fontWeight: FontWeight.w800,
                          letterSpacing: -1.5,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Your AI document hub',
                        style: TextStyle(
                          color: c.textMuted,
                          fontSize: 13,
                          letterSpacing: 0.2,
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

// ═════════════════════════════════════════════════════════════════════════════
// SLIDE 2 — Portfolios
// ═════════════════════════════════════════════════════════════════════════════

class _PortfoliosPage extends StatelessWidget {
  const _PortfoliosPage({required this.anim});
  final AnimationController anim;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return _PageShell(
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

// ═════════════════════════════════════════════════════════════════════════════
// SLIDE 3 — AI Generation
// ═════════════════════════════════════════════════════════════════════════════

class _GenerationPage extends StatelessWidget {
  const _GenerationPage({required this.anim});
  final AnimationController anim;

  @override
  Widget build(BuildContext context) {
    return _PageShell(
      anim: anim,
      eyebrow: 'AI Generation',
      headline: 'From a prompt\nto a document.',
      body:
      'Describe what you need. BizDocx generates print-ready documents with AI, or high-quality visuals like logos.',
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
            sublabel: 'Gemini 3.1 Pro',
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
            sublabel: 'Imagen 4',
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

// ═════════════════════════════════════════════════════════════════════════════
// SLIDE 4 — Brand Assets & Logo
// ═════════════════════════════════════════════════════════════════════════════

class _AssetsPage extends StatelessWidget {
  const _AssetsPage({required this.anim});
  final AnimationController anim;

  @override
  Widget build(BuildContext context) {
    return _PageShell(
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

// ═════════════════════════════════════════════════════════════════════════════
// SLIDE 5 — Refinement & History
// ═════════════════════════════════════════════════════════════════════════════

class _RefinementPage extends StatelessWidget {
  const _RefinementPage({required this.anim});
  final AnimationController anim;

  @override
  Widget build(BuildContext context) {
    return _PageShell(
      anim: anim,
      eyebrow: 'Refine & History',
      headline: 'Iterate until\nit\'s perfect.',
      body:
      'Send follow-up prompts to adjust any detail. Every change is versioned — preview and restore any previous state with one tap.',
      accentColor: const Color(0xFF4ECDC4),
      illustration: const _RefinementIllustration(),
    );
  }
}

class _RefinementIllustration extends StatefulWidget {
  const _RefinementIllustration();

  @override
  State<_RefinementIllustration> createState() =>
      _RefinementIllustrationState();
}

class _RefinementIllustrationState extends State<_RefinementIllustration>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  int _activeVersion = 2;

  static const _versions = [
    (label: 'Version 3', prompt: '"Change due date to June 30"'),
    (label: 'Version 2', prompt: '"Add 10% VAT line"'),
    (label: 'Original',  prompt: null),
  ];

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 1800))
      ..addStatusListener((s) {
        if (s == AnimationStatus.completed && mounted) {
          setState(() => _activeVersion = (_activeVersion - 1 + 3) % 3);
          _ctrl.forward(from: 0);
        }
      });
    Future.delayed(const Duration(milliseconds: 800), () {
      if (mounted) _ctrl.forward();
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    const accent = Color(0xFF4ECDC4);

    return Container(
      color: c.surface,
      child: Column(
        children: [
          // Top: refinement prompt bar
          Container(
            margin: const EdgeInsets.fromLTRB(20, 24, 20, 0),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: c.card,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: accent.withValues(alpha: 0.4)),
              boxShadow: [
                BoxShadow(
                  color: accent.withValues(alpha: 0.1),
                  blurRadius: 16, offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    '"${_versions[_activeVersion].prompt ?? 'Initial generation'}"',
                    style: TextStyle(
                      color: c.textBody,
                      fontSize: 13,
                      fontStyle: FontStyle.italic,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  width: 32, height: 32,
                  decoration: BoxDecoration(
                    color: accent, borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.send_rounded,
                      size: 15, color: Colors.white),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Version list
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
              itemCount: _versions.length,
              physics: const NeverScrollableScrollPhysics(),
              separatorBuilder: (_, __) => Container(
                margin: const EdgeInsets.only(left: 17),
                width: 1, height: 16,
                color: c.border,
              ),
              itemBuilder: (context, i) {
                final v = _versions[i];
                final isCurrent = i == 0;
                final isActive = i == _activeVersion;
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 14, vertical: 12),
                  decoration: BoxDecoration(
                    color: isActive
                        ? accent.withValues(alpha: 0.08)
                        : c.card,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: isActive
                          ? accent.withValues(alpha: 0.4)
                          : c.border,
                    ),
                  ),
                  child: Row(
                    children: [
                      // Dot
                      Container(
                        width: 10, height: 10,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isCurrent ? AppColors.success : c.border,
                          border: Border.all(
                            color: isCurrent
                                ? AppColors.success
                                : c.borderStrong,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(children: [
                              Text(v.label,
                                  style: TextStyle(
                                    color: isActive
                                        ? c.textPrimary
                                        : c.textBody,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                  )),
                              if (isCurrent) ...[
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 6, vertical: 1),
                                  decoration: BoxDecoration(
                                    color: AppColors.success
                                        .withValues(alpha: 0.15),
                                    borderRadius:
                                    BorderRadius.circular(4),
                                  ),
                                  child: const Text('current',
                                      style: TextStyle(
                                        color: AppColors.success,
                                        fontSize: 9,
                                        fontWeight: FontWeight.w600,
                                      )),
                                ),
                              ],
                            ]),
                            if (v.prompt != null)
                              Text(v.prompt!,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: c.textMuted, fontSize: 11,
                                    fontStyle: FontStyle.italic,
                                  )),
                          ],
                        ),
                      ),
                      if (!isCurrent)
                        Text('Restore',
                            style: TextStyle(
                              color: accent, fontSize: 12,
                              fontWeight: FontWeight.w600,
                            )),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// ═════════════════════════════════════════════════════════════════════════════
// SLIDE 6 — Get Started
// ═════════════════════════════════════════════════════════════════════════════

class _GetStartedPage extends StatefulWidget {
  const _GetStartedPage({required this.anim, required this.onTap});
  final AnimationController anim;
  final VoidCallback onTap;

  @override
  State<_GetStartedPage> createState() => _GetStartedPageState();
}

class _GetStartedPageState extends State<_GetStartedPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulse;

  @override
  void initState() {
    super.initState();
    _pulse = AnimationController(
        vsync: this, duration: const Duration(seconds: 2))
      ..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulse.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;

    final fadeAnim = CurvedAnimation(parent: widget.anim, curve: Curves.easeOut);
    final slideAnim = Tween<Offset>(
      begin: const Offset(0, 0.06),
      end: Offset.zero,
    ).animate(CurvedAnimation(
        parent: widget.anim, curve: Curves.easeOutCubic));

    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 96),
      child: Column(
        children: [
          // Full illustration
          Expanded(
            flex: 50,
            child: Container(
              color: c.card,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Animated concentric circles
                  AnimatedBuilder(
                    animation: _pulse,
                    builder: (_, __) => CustomPaint(
                      size: Size.infinite,
                      painter: _CircleRingPainter(
                        progress: _pulse.value,
                        color: AppColors.success,
                      ),
                    ),
                  ),
                  // Checkmark circle
                  AnimatedBuilder(
                    animation: _pulse,
                    builder: (_, __) => Container(
                      width: 100 + _pulse.value * 4,
                      height: 100 + _pulse.value * 4,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.success.withValues(alpha: 0.12),
                        border: Border.all(
                            color: AppColors.success.withValues(alpha: 0.4),
                            width: 2),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.success.withValues(alpha: 0.2),
                            blurRadius: 32, spreadRadius: 4,
                          ),
                        ],
                      ),
                      child: const Icon(Icons.check_rounded,
                          size: 48, color: AppColors.success),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Text + CTA
          Expanded(
            flex: 50,
            child: FadeTransition(
              opacity: fadeAnim,
              child: SlideTransition(
                position: slideAnim,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(28, 28, 28, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'READY'.toUpperCase(),
                        style: TextStyle(
                          color: AppColors.success,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 1.4,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Let\'s build something\nbeautiful.',
                        style: TextStyle(
                          color: c.textPrimary,
                          fontSize: 28,
                          fontWeight: FontWeight.w700,
                          letterSpacing: -0.8,
                          height: 1.15,
                        ),
                      ),
                      const SizedBox(height: 14),
                      Text(
                        'Sign in or create a free account to start generating documents for your business in seconds.',
                        style: TextStyle(
                          color: c.textBody,
                          fontSize: 15,
                          height: 1.6,
                        ),
                      ),
                      const SizedBox(height: 28),
                      // Large CTA — overrides the bottom bar button for this page
                      SizedBox(
                        width: double.infinity,
                        child: FilledButton(
                          onPressed: widget.onTap,
                          style: FilledButton.styleFrom(
                            backgroundColor: AppColors.success,
                            foregroundColor: Colors.white,
                            minimumSize: const Size.fromHeight(56),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                          child: const Text(
                            'Create Account',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              letterSpacing: -0.2,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Center(
                        child: TextButton(
                          onPressed: widget.onTap,
                          child: Text(
                            'I already have an account  →',
                            style: TextStyle(
                              color: c.textMuted,
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
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
