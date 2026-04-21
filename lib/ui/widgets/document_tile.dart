import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../models/document_asset.dart';

class DocumentTile extends StatelessWidget {
  const DocumentTile({super.key, required this.asset, required this.onTap});
  final DocumentAsset asset;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          children: [
            _TypeIcon(type: asset.type, pipeline: asset.pipeline),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(asset.title,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontSize: 15),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 3),
                  Text(_subtitle,
                      style: Theme.of(context).textTheme.bodyMedium),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                if (asset.isCached)
                  const Icon(Icons.offline_pin_rounded,
                      size: 14, color: AppColors.success),
                const SizedBox(height: 4),
                const Icon(Icons.arrow_forward_ios,
                    size: 12, color: AppColors.muted),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String get _subtitle {
    final parts = [
      asset.type.name,
      '•',
      _formatDate(asset.createdAt),
    ];
    return parts.join(' ');
  }

  String _formatDate(DateTime dt) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${dt.day} ${months[dt.month - 1]}';
  }
}

class _TypeIcon extends StatelessWidget {
  const _TypeIcon({required this.type, required this.pipeline});
  final DocumentType type;
  final AssetPipeline pipeline;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: AppColors.graphite,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.border),
      ),
      child: Icon(_icon, color: AppColors.silver, size: 20),
    );
  }

  IconData get _icon {
    switch (type) {
      case DocumentType.invoice: return Icons.receipt_long_outlined;
      case DocumentType.proposal: return Icons.assignment_outlined;
      case DocumentType.letterhead: return Icons.article_outlined;
      case DocumentType.businessCard: return Icons.badge_outlined;
      case DocumentType.contract: return Icons.handshake_outlined;
      case DocumentType.logo: return Icons.auto_awesome_outlined;
      case DocumentType.icon: return Icons.interests_outlined;
      case DocumentType.other: return Icons.description_outlined;
    }
  }
}