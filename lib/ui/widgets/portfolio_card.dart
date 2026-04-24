import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../core/extensions/context_extensions.dart';
import '../../models/business_portfolio.dart';

class PortfolioCard extends StatelessWidget {
  const PortfolioCard({
    super.key,
    required this.portfolio,
    required this.onTap,
  });

  final BusinessPortfolio portfolio;
  final VoidCallback onTap;

  static Color? _parseHex(String hex) {
    try {
      final clean = hex.replaceAll('#', '').trim();
      if (clean.length == 6) return Color(int.parse('FF$clean', radix: 16));
      if (clean.length == 8) return Color(int.parse(clean, radix: 16));
    } catch (_) {}
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;

    final brandColors = portfolio.brandColors
        .map(_parseHex)
        .whereType<Color>()
        .toList();

    final primary = brandColors.isNotEmpty ? brandColors.first : null;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          // If we have brand colors, use them as a gradient for the "border"
          gradient: brandColors.length > 1
              ? LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: brandColors,
                )
              : (primary != null
                  ? LinearGradient(
                      colors: [primary, primary.withValues(alpha: 0.5)])
                  : null),
          // Fallback to standard border color if no brand colors
          color: primary == null ? c.border : null,
        ),
        child: Container(
          // Margin creates the border effect
          margin: const EdgeInsets.all(1.5),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: c.card, // Neutral background for readability
            borderRadius: BorderRadius.circular(12.5),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  _ColorDots(colors: portfolio.brandColors),
                  const Spacer(),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: context.isDark
                          ? Colors.white.withValues(alpha: 0.08)
                          : Colors.black.withValues(alpha: 0.05),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      '${portfolio.documentIds.length} docs',
                      style: TextStyle(
                        color: c.textBody,
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 14,
                    color: primary?.withValues(alpha: 0.7) ?? c.textMuted,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(portfolio.name,
                  style: Theme.of(context).textTheme.titleLarge),
              if (portfolio.description.isNotEmpty) ...[
                const SizedBox(height: 4),
                Text(
                  portfolio.description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
              if (portfolio.targetAudience.isNotEmpty) ...[
                const SizedBox(height: 12),
                Row(
                  children: [
                    Icon(Icons.trending_up_rounded,
                        size: 12,
                        color: primary?.withValues(alpha: 0.8) ?? c.textMuted),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        portfolio.targetAudience,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: primary?.withValues(alpha: 0.8) ?? c.textMuted,
                          fontSize: 12,
                          letterSpacing: 0.2,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _ColorDots extends StatelessWidget {
  const _ColorDots({required this.colors});
  final List<String> colors;

  static Color _parse(String hex) {
    try {
      return Color(int.parse('FF${hex.replaceAll('#', '').trim()}', radix: 16));
    } catch (_) {
      return AppColors.silver;
    }
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    if (colors.isEmpty) {
      return Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(color: c.chipFill, shape: BoxShape.circle),
        child: Icon(Icons.business_center_outlined,
            size: 16, color: c.iconSecondary),
      );
    }
    return Row(
      children: colors.take(4).map((hex) {
        return Container(
          width: 24,
          height: 24,
          margin: const EdgeInsets.only(right: 4),
          decoration: BoxDecoration(
            color: _parse(hex),
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
          ),
        );
      }).toList(),
    );
  }
}
