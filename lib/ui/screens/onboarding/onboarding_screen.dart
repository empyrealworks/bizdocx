import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/extensions/context_extensions.dart';
import '../../../providers/onboarding_provider.dart';
import 'onboarding_components.dart';
import 'pages/welcome_slide.dart';
import 'pages/portfolios_slide.dart';
import 'pages/generation_slide.dart';
import 'pages/assets_slide.dart';
import 'pages/refinement_slide.dart';
import 'pages/get_started_slide.dart';

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
      await ref.read(onboardingSeenProvider.notifier).markSeen();
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
                WelcomeSlide(anim: _slideCtrl),
                PortfoliosSlide(anim: _slideCtrl),
                GenerationSlide(anim: _slideCtrl),
                AssetsSlide(anim: _slideCtrl),
                RefinementSlide(anim: _slideCtrl),
                GetStartedSlide(anim: _slideCtrl, onTap: _complete),
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
                    OnboardingPageDots(current: _page, total: _totalPages),
                    const Spacer(),
                    OnboardingNextButton(
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
