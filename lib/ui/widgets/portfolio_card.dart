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

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                _ColorDots(colors: portfolio.brandColors),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.graphite,
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
                const Icon(Icons.arrow_forward_ios,
                    size: 14, color: AppColors.muted),
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
              Text(
                '↗ ${portfolio.targetAudience}',
                style: const TextStyle(
                    color: AppColors.muted,
                    fontSize: 12,
                    letterSpacing: 0.2),
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

  @override
  Widget build(BuildContext context) {
    if (colors.isEmpty) {
      return Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: AppColors.graphite,
          shape: BoxShape.circle,
        ),
        child: const Icon(Icons.business_center_outlined,
            size: 16, color: AppColors.silver),
      );
    }
    return Row(
      children: colors.take(4).map((hex) {
        Color? color;
        try {
          color = Color(
              int.parse(hex.replaceAll('#', ''), radix: 16) + 0xFF000000);
        } catch (_) {
          color = AppColors.silver;
        }
        return Container(
          width: 24,
          height: 24,
          margin: const EdgeInsets.only(right: 4),
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.border),
          ),
        );
      }).toList(),
    );
  }
}