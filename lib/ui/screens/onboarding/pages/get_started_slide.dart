import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/extensions/context_extensions.dart';

class GetStartedSlide extends StatefulWidget {
  const GetStartedSlide({super.key, required this.anim, required this.onTap});
  final AnimationController anim;
  final VoidCallback onTap;

  @override
  State<GetStartedSlide> createState() => _GetStartedSlideState();
}

class _GetStartedSlideState extends State<GetStartedSlide>
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
                        color: AppColors.success.withOpacity(0.12),
                        border: Border.all(
                            color: AppColors.success.withOpacity(0.4),
                            width: 2),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.success.withOpacity(0.2),
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
        ..color = color.withOpacity(0.04 - i * 0.01)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5;
      canvas.drawCircle(center, r, paint);
    }
  }

  @override
  bool shouldRepaint(_CircleRingPainter old) =>
      old.progress != progress;
}
