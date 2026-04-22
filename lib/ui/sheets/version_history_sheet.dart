import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../core/constants/app_colors.dart';
import '../../models/document_version.dart';
import '../../providers/document_version_provider.dart';
import '../../services/firebase_service.dart';
import '../../models/document_asset.dart';

/// Callback signature: receives the restored asset so the viewer can
/// immediately update its in-memory state without waiting for the stream.
typedef OnVersionRestored = void Function(DocumentAsset restoredAsset);

class VersionHistorySheet extends ConsumerWidget {
  const VersionHistorySheet({
    super.key,
    required this.asset,
    required this.onVersionRestored,
  });

  final DocumentAsset asset;
  final OnVersionRestored onVersionRestored;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final versionsAsync = ref.watch(documentVersionsProvider(
      (portfolioId: asset.portfolioId, documentId: asset.id),
    ));

    return Container(
      decoration: const BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 36,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.border,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 4),
            child: Row(
              children: [
                const Icon(Icons.history_rounded,
                    size: 18, color: AppColors.silver),
                const SizedBox(width: 8),
                Text('Version History',
                    style: Theme.of(context).textTheme.titleLarge),
                const Spacer(),
                versionsAsync.when(
                  data: (v) => Text('${v.length} versions',
                      style: Theme.of(context).textTheme.labelSmall),
                  loading: () => const SizedBox.shrink(),
                  error: (_, __) => const SizedBox.shrink(),
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: AppColors.border),
          versionsAsync.when(
            loading: () => const Padding(
              padding: EdgeInsets.all(40),
              child: CircularProgressIndicator(),
            ),
            error: (e, _) => Padding(
              padding: const EdgeInsets.all(24),
              child: Text('Could not load versions: $e',
                  style: const TextStyle(color: AppColors.error)),
            ),
            data: (versions) {
              if (versions.isEmpty) {
                return const Padding(
                  padding: EdgeInsets.all(32),
                  child: Text('No version history yet.',
                      style: TextStyle(color: AppColors.muted)),
                );
              }
              return ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.55,
                ),
                child: ListView.separated(
                  shrinkWrap: true,
                  padding: const EdgeInsets.only(bottom: 24),
                  itemCount: versions.length,
                  separatorBuilder: (_, __) =>
                  const Divider(height: 1, color: AppColors.border),
                  itemBuilder: (context, i) {
                    final v = versions[i];
                    final isCurrent = i == 0;
                    return _VersionTile(
                      version: v,
                      isCurrent: isCurrent,
                      onPreview: () => _showPreview(context, v),
                      onRestore: isCurrent
                          ? null
                          : () => _restore(context, ref, v),
                    );
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  void _showPreview(BuildContext context, DocumentVersion version) {
    Navigator.of(context).push(MaterialPageRoute(
      fullscreenDialog: true,
      builder: (_) => _VersionPreviewScreen(version: version),
    ));
  }

  Future<void> _restore(
      BuildContext context,
      WidgetRef ref,
      DocumentVersion version,
      ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.card,
        title: const Text('Restore version?'),
        content: Text(
          'This will replace the current document with ${version.displayLabel}. '
              'The current version will remain in history.',
          style: const TextStyle(color: AppColors.silver, fontSize: 14),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel',
                style: TextStyle(color: AppColors.silver)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Restore',
                style: TextStyle(color: AppColors.white)),
          ),
        ],
      ),
    );

    if (confirmed != true || !context.mounted) return;

    try {
      final restored = await FirebaseService.instance.restoreDocumentVersion(
        currentAsset: asset,
        version: version,
      );
      if (context.mounted) {
        Navigator.pop(context); // close the sheet
        onVersionRestored(restored);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content:
          Text('Restored to ${version.displayLabel}'),
          behavior: SnackBarBehavior.floating,
        ));
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Restore failed: $e'),
          backgroundColor: AppColors.error,
          behavior: SnackBarBehavior.floating,
        ));
      }
    }
  }
}

// ── Version Tile ─────────────────────────────────────────────────────────────

class _VersionTile extends StatelessWidget {
  const _VersionTile({
    required this.version,
    required this.isCurrent,
    required this.onPreview,
    required this.onRestore,
  });

  final DocumentVersion version;
  final bool isCurrent;
  final VoidCallback onPreview;
  final VoidCallback? onRestore;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPreview,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        child: Row(
          children: [
            // Version indicator dot
            Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isCurrent ? AppColors.success : AppColors.graphite,
                border: Border.all(
                  color: isCurrent ? AppColors.success : AppColors.border,
                ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        version.displayLabel,
                        style: TextStyle(
                          color: isCurrent
                              ? AppColors.white
                              : AppColors.offWhite,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      if (isCurrent) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppColors.success.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(
                                color: AppColors.success.withValues(alpha: 0.4)),
                          ),
                          child: const Text('current',
                              style: TextStyle(
                                  color: AppColors.success, fontSize: 10)),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 3),
                  if (version.refinementPrompt != null)
                    Text(
                      '"${version.refinementPrompt}"',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          color: AppColors.muted,
                          fontSize: 12,
                          fontStyle: FontStyle.italic),
                    ),
                  Text(
                    _formatDateTime(version.createdAt),
                    style: const TextStyle(
                        color: AppColors.muted, fontSize: 11),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            // Preview icon
            IconButton(
              icon: const Icon(Icons.open_in_new_rounded,
                  size: 16, color: AppColors.muted),
              tooltip: 'Preview this version',
              onPressed: onPreview,
            ),
            // Restore button (only for non-current)
            if (onRestore != null)
              TextButton(
                onPressed: onRestore,
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  minimumSize: const Size(0, 32),
                ),
                child: const Text('Restore',
                    style: TextStyle(color: AppColors.silver, fontSize: 12)),
              ),
          ],
        ),
      ),
    );
  }

  String _formatDateTime(DateTime dt) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    final h = dt.hour.toString().padLeft(2, '0');
    final m = dt.minute.toString().padLeft(2, '0');
    return '${dt.day} ${months[dt.month - 1]} ${dt.year} · $h:$m';
  }
}

// ── Version Preview Screen ────────────────────────────────────────────────────

class _VersionPreviewScreen extends StatefulWidget {
  const _VersionPreviewScreen({required this.version});
  final DocumentVersion version;

  @override
  State<_VersionPreviewScreen> createState() => _VersionPreviewScreenState();
}

class _VersionPreviewScreenState extends State<_VersionPreviewScreen> {
  late final WebViewController _ctrl;
  bool _ready = false;

  @override
  void initState() {
    super.initState();
    _ctrl = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.white)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageFinished: (_) => setState(() => _ready = true),
        ),
      )
      ..loadHtmlString(widget.version.htmlContent);
  }

  @override
  Widget build(BuildContext context) {
    final v = widget.version;
    return Scaffold(
      appBar: AppBar(
        title: Text(v.displayLabel),
        backgroundColor: AppColors.surface,
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          // Info banner
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            color: AppColors.graphite,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _formatDateTime(v.createdAt),
                  style: const TextStyle(
                      color: AppColors.silver, fontSize: 12),
                ),
                if (v.refinementPrompt != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 2),
                    child: Text(
                      '"${v.refinementPrompt}"',
                      style: const TextStyle(
                          color: AppColors.muted,
                          fontSize: 12,
                          fontStyle: FontStyle.italic),
                    ),
                  ),
              ],
            ),
          ),
          Expanded(
            child: Stack(
              children: [
                Container(
                    color: Colors.white,
                    child: WebViewWidget(controller: _ctrl)),
                if (!_ready)
                  Container(
                    color: AppColors.surface,
                    child:
                    const Center(child: CircularProgressIndicator()),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatDateTime(DateTime dt) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    final h = dt.hour.toString().padLeft(2, '0');
    final m = dt.minute.toString().padLeft(2, '0');
    return '${dt.day} ${months[dt.month - 1]} ${dt.year} at $h:$m';
  }
}