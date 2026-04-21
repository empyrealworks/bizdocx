import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../models/business_portfolio.dart';

class PortfolioCard extends StatelessWidget {
  const PortfolioCard({
    super.key,
    required this.portfolio,
    required this.onTap,
  });

  final BusinessPortfolio portfolio;
  final VoidCallback onTap;

  static Color _parseHex(String hex) {
    try {
      final clean = hex.replaceAll('#', '').trim();
      if (clean.length == 6) {
        return Color(int.parse('FF$clean', radix: 16));
      }
      if (clean.length == 8) {
        return Color(int.parse(clean, radix: 16));
      }
    } catch (_) {}
    return AppColors.silver;
  }

  @override
  Widget build(BuildContext context) {
    final colors = portfolio.brandColors
        .where((h) => h.isNotEmpty)
        .map(_parseHex)
        .toList();

    final primary = colors.isNotEmpty ? colors.first : null;
    final secondary = colors.length > 1 ? colors[1] : primary;

    final BoxDecoration decoration;
    if (primary != null) {
      decoration = BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            primary.withOpacity(0.18),
            secondary!.withOpacity(0.06),
            AppColors.card,
          ],
          stops: const [0.0, 0.35, 1.0],
        ),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: primary.withOpacity(0.35),
          width: 1.2,
        ),
      );
    } else {
      decoration = BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      );
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: decoration,
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
                    color: Colors.black.withOpacity(0.25),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    '${portfolio.documentIds.length} docs',
                    style: const TextStyle(
                        color: AppColors.silver,
                        fontSize: 11,
                        fontWeight: FontWeight.w500),
                  ),
                ),
                const SizedBox(width: 8),
                Icon(Icons.arrow_forward_ios,
                    size: 14,
                    color: primary != null
                        ? primary.withOpacity(0.7)
                        : AppColors.muted),
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
                      color: primary != null
                          ? primary.withOpacity(0.8)
                          : AppColors.muted),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      portfolio.targetAudience,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          color: primary != null
                              ? primary.withOpacity(0.8)
                              : AppColors.muted,
                          fontSize: 12,
                          letterSpacing: 0.2),
                    ),
                  ),
                ],
              ),
            ],
          ],
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
      final clean = hex.replaceAll('#', '').trim();
      return Color(int.parse('FF$clean', radix: 16));
    } catch (_) {
      return AppColors.silver;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (colors.isEmpty) {
      return Container(
        width: 32,
        height: 32,
        decoration: const BoxDecoration(
          color: AppColors.graphite,
          shape: BoxShape.circle,
        ),
        child: const Icon(Icons.business_center_outlined,
            size: 16, color: AppColors.silver),
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
            border: Border.all(color: Colors.white.withOpacity(0.15)),
          ),
        );
      }).toList(),
    );
  }
}