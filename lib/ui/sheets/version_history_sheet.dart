import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/extensions/context_extensions.dart';
import '../../models/document_asset.dart';
import '../../models/document_version.dart';
import '../../providers/document_generation_provider.dart';
import '../../services/firebase_service.dart';

class VersionHistorySheet extends ConsumerWidget {
  const VersionHistorySheet({
    super.key,
    required this.asset,
    required this.onVersionRestored,
  });

  final DocumentAsset asset;
  final ValueChanged<DocumentAsset> onVersionRestored;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.colors;
    final versionsStream = FirebaseService.instance.watchVersions(
      portfolioId: asset.portfolioId,
      documentId: asset.id,
    );

    return Container(
      decoration: BoxDecoration(
        color: c.card,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _Handle(c: c),
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 8, 24, 20),
            child: Row(
              children: [
                const Icon(Icons.history_rounded, size: 22),
                const SizedBox(width: 12),
                Text(context.l10n.versionHistory,
                    style: Theme.of(context).textTheme.titleLarge),
              ],
            ),
          ),
          Flexible(
            child: StreamBuilder<List<DocumentVersion>>(
              stream: versionsStream,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                final versions = snapshot.data ?? [];
                if (versions.isEmpty) {
                  return _EmptyHistory(c: c);
                }

                return ListView.separated(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 40),
                  itemCount: versions.length,
                  shrinkWrap: true,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final v = versions[index];
                    return _VersionTile(
                      version: v,
                      isCurrent: v.htmlContent == asset.htmlContent || (asset.isGraphical && v.imageUrl == asset.storageUrl),
                      onRestore: () => _handleRestore(context, v),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _handleRestore(BuildContext context, DocumentVersion version) async {
    final l = context.l10n;
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l.restoreVersion),
        content: Text(l.restoreVersionMessage(version.versionNumber)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: Text(l.cancel)),
          FilledButton(onPressed: () => Navigator.pop(ctx, true), child: Text(l.restore)),
        ],
      ),
    );

    if (ok == true) {
      final restored = await FirebaseService.instance.restoreDocumentVersion(
        currentAsset: asset,
        version: version,
      );
      onVersionRestored(restored);
      if (context.mounted) Navigator.pop(context);
    }
  }
}

class _VersionTile extends StatelessWidget {
  const _VersionTile({
    required this.version,
    required this.isCurrent,
    required this.onRestore,
  });

  final DocumentVersion version;
  final bool isCurrent;
  final VoidCallback onRestore;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Container(
      decoration: BoxDecoration(
        color: isCurrent ? c.chipFill : Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: isCurrent ? c.borderStrong : c.border),
      ),
      child: InkWell(
        onTap: isCurrent ? null : onRestore,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              if (version.imageUrl != null)
                Container(
                  width: 48,
                  height: 48,
                  margin: const EdgeInsets.only(right: 16),
                  decoration: BoxDecoration(
                    color: c.chipFill,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: CachedNetworkImage(
                    imageUrl: version.imageUrl!,
                    fit: BoxFit.cover,
                  ),
                )
              else
                Container(
                  width: 48,
                  height: 48,
                  margin: const EdgeInsets.only(right: 16),
                  decoration: BoxDecoration(
                    color: c.chipFill,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(Icons.html_rounded, color: c.iconSecondary),
                ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(context.l10n.versionNumber(version.versionNumber),
                            style: const TextStyle(fontWeight: FontWeight.bold)),
                        if (isCurrent) ...[
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.green.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(context.l10n.current,
                                style: const TextStyle(color: Colors.green, fontSize: 10, fontWeight: FontWeight.w900)),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      version.refinementPrompt ?? version.label ?? context.l10n.originalGeneration,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: c.textMuted, fontSize: 12),
                    ),
                  ],
                ),
              ),
              if (!isCurrent)
                Icon(Icons.restore_page_rounded, size: 20, color: c.textMuted),
            ],
          ),
        ),
      ),
    );
  }
}

class _Handle extends StatelessWidget {
  const _Handle({required this.c});
  final dynamic c;
  @override
  Widget build(BuildContext context) => Container(
    width: 36, height: 4,
    margin: const EdgeInsets.symmetric(vertical: 12),
    decoration: BoxDecoration(color: c.border, borderRadius: BorderRadius.circular(2)),
  );
}

class _EmptyHistory extends StatelessWidget {
  const _EmptyHistory({required this.c});
  final dynamic c;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.all(40),
    child: Column(
      children: [
        Icon(Icons.history_toggle_off_rounded, size: 48, color: c.borderStrong),
        const SizedBox(height: 16),
        Text(context.l10n.noPreviousVersions, style: const TextStyle(color: Colors.grey)),
      ],
    ),
  );
}
