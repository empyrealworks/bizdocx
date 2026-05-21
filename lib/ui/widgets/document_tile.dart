import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/app_colors.dart';
import '../../core/extensions/context_extensions.dart';
import '../../models/document_asset.dart';
import '../../providers/document_generation_provider.dart';

class DocumentTile extends ConsumerStatefulWidget {
  const DocumentTile({
    super.key,
    required this.asset,
    required this.onTap,
    this.selectionMode = false,
    this.isSelected = false,
    this.onSelect,
    this.onLongPress,
  });

  final DocumentAsset asset;
  final VoidCallback onTap;
  final bool selectionMode;
  final bool isSelected;
  final ValueChanged<String>? onSelect;
  final VoidCallback? onLongPress;

  @override
  ConsumerState<DocumentTile> createState() => _DocumentTileState();
}

class _DocumentTileState extends ConsumerState<DocumentTile> {
  bool _showDelete = false;

  Future<void> _confirmDelete() async {
    final c = context.colors;
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: c.card,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Delete Document?'),
        content: Text(
          'This will permanently remove "${widget.asset.title}". This action cannot be undone.',
          style: TextStyle(color: c.textBody, fontSize: 14),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text('Cancel', style: TextStyle(color: c.textMuted)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Delete', style: TextStyle(color: AppColors.error)),
          ),
        ],
      ),
    );

    if (ok == true && mounted) {
      setState(() => _showDelete = false);
      await ref
          .read(documentGenerationProvider(widget.asset.portfolioId).notifier)
          .deleteDocument(widget.asset);
    }
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return GestureDetector(
      onTap: widget.selectionMode ? () => widget.onSelect?.call(widget.asset.id) : widget.onTap,
      onLongPress: widget.selectionMode ? null : widget.onLongPress ?? () => setState(() => _showDelete = !_showDelete),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: widget.isSelected ? context.colors.textPrimary.withValues(alpha: 0.05) : c.card,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: widget.isSelected 
              ? context.colors.textPrimary 
              : (_showDelete ? AppColors.error.withValues(alpha: 0.5) : c.border),
            width: (widget.isSelected || _showDelete) ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            if (widget.selectionMode) ...[
               Icon(
                 widget.isSelected ? Icons.check_circle : Icons.radio_button_unchecked,
                 color: widget.isSelected ? context.colors.textPrimary : c.textMuted,
                 size: 20,
               ),
               const SizedBox(width: 14),
            ],
            _TypeIcon(type: widget.asset.type),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.asset.title,
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge
                        ?.copyWith(fontSize: 15),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 3),
                  Text(_subtitle, style: Theme.of(context).textTheme.bodyMedium),
                ],
              ),
            ),
            const SizedBox(width: 8),
            if (_showDelete)
              IconButton(
                icon: const Icon(Icons.delete_outline_rounded, color: AppColors.error),
                onPressed: _confirmDelete,
                visualDensity: VisualDensity.compact,
              )
            else if (!widget.selectionMode)
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  if (widget.asset.isCached)
                    const Icon(Icons.offline_pin_rounded,
                        size: 14, color: AppColors.success),
                  if (widget.asset.isScanned)
                    const Icon(Icons.document_scanner, size: 12, color: AppColors.silver),
                  const SizedBox(height: 4),
                  Icon(Icons.arrow_forward_ios, size: 12, color: c.textMuted),
                ],
              ),
          ],
        ),
      ),
    );
  }

  String get _subtitle {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    final dt = widget.asset.createdAt;
    return '${widget.asset.type.name} • ${dt.day} ${months[dt.month - 1]}';
  }
}

class _TypeIcon extends StatelessWidget {
  const _TypeIcon({required this.type});
  final DocumentType type;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: c.chipFill,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: c.border),
      ),
      child: Icon(_icon, color: c.iconSecondary, size: 20),
    );
  }

  IconData get _icon {
    switch (type) {
      case DocumentType.invoice:      return Icons.receipt_long_outlined;
      case DocumentType.proposal:     return Icons.assignment_outlined;
      case DocumentType.letterhead:   return Icons.article_outlined;
      case DocumentType.businessCard: return Icons.badge_outlined;
      case DocumentType.contract:     return Icons.handshake_outlined;
      case DocumentType.logo:         return Icons.auto_awesome_outlined;
      case DocumentType.icon:         return Icons.interests_outlined;
      case DocumentType.other:        return Icons.description_outlined;
    }
  }
}
