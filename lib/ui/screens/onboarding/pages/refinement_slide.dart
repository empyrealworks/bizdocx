import 'package:flutter/material.dart';
import '../onboarding_components.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/constants/app_colors.dart';

class RefinementSlide extends StatelessWidget {
  const RefinementSlide({super.key, required this.anim});
  final AnimationController anim;

  @override
  Widget build(BuildContext context) {
    return OnboardingPageShell(
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
              border: Border.all(color: accent.withOpacity(0.4)),
              boxShadow: [
                BoxShadow(
                  color: accent.withOpacity(0.1),
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
                        ? accent.withOpacity(0.08)
                        : c.card,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: isActive
                          ? accent.withOpacity(0.4)
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
                                        .withOpacity(0.15),
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
