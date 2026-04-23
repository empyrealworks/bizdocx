import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../core/constants/app_colors.dart';
import '../../core/extensions/context_extensions.dart';
import '../../models/document_asset.dart';
import '../../models/document_version.dart';
import '../../providers/document_version_provider.dart';
import '../../services/firebase_service.dart';

typedef OnVersionRestored = void Function(DocumentAsset restoredAsset);

class VersionHistorySheet extends ConsumerWidget {
  const VersionHistorySheet(
      {super.key, required this.asset, required this.onVersionRestored});
  final DocumentAsset asset;
  final OnVersionRestored onVersionRestored;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.colors;
    final versionsAsync = ref.watch(documentVersionsProvider(
        (portfolioId: asset.portfolioId, documentId: asset.id)));

    return Container(
      decoration: BoxDecoration(
        color: c.card,
        borderRadius:
        const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        // Handle
        Container(
          margin: const EdgeInsets.only(top: 12),
          width: 36, height: 4,
          decoration: BoxDecoration(
              color: c.border, borderRadius: BorderRadius.circular(2)),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 4),
          child: Row(children: [
            Icon(Icons.history_rounded, size: 18, color: c.iconSecondary),
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
          ]),
        ),
        Divider(height: 1, color: c.border),
        versionsAsync.when(
          loading: () => const Padding(
              padding: EdgeInsets.all(40),
              child: CircularProgressIndicator()),
          error: (e, _) => Padding(
            padding: const EdgeInsets.all(24),
            child: Text('Could not load versions: $e',
                style: const TextStyle(color: AppColors.error)),
          ),
          data: (versions) {
            if (versions.isEmpty) {
              return Padding(
                padding: const EdgeInsets.all(32),
                child: Text('No version history yet.',
                    style: TextStyle(color: c.textMuted)),
              );
            }
            return ConstrainedBox(
              constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.55),
              child: ListView.separated(
                shrinkWrap: true,
                padding: const EdgeInsets.only(bottom: 24),
                itemCount: versions.length,
                separatorBuilder: (_, __) =>
                    Divider(height: 1, color: c.border),
                itemBuilder: (context, i) {
                  final v = versions[i];
                  return _VersionTile(
                    version: v,
                    isCurrent: i == 0,
                    onPreview: () => _showPreview(context, v),
                    onRestore: i == 0
                        ? null
                        : () => _restore(context, ref, v),
                  );
                },
              ),
            );
          },
        ),
      ]),
    );
  }

  void _showPreview(BuildContext context, DocumentVersion version) {
    Navigator.of(context).push(MaterialPageRoute(
      fullscreenDialog: true,
      builder: (_) => _VersionPreviewScreen(version: version),
    ));
  }

  Future<void> _restore(
      BuildContext context, WidgetRef ref, DocumentVersion version) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Restore version?'),
        content: Text(
          'This will replace the current document with ${version.displayLabel}. '
              'The current content will remain in history.',
          style: TextStyle(color: context.colors.textBody, fontSize: 14),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Cancel')),
          TextButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: const Text('Restore')),
        ],
      ),
    );
    if (confirmed != true || !context.mounted) return;
    try {
      final restored = await FirebaseService.instance
          .restoreDocumentVersion(currentAsset: asset, version: version);
      if (context.mounted) {
        Navigator.pop(context);
        onVersionRestored(restored);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Restored to ${version.displayLabel}'),
        ));
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Restore failed: $e'),
          backgroundColor: AppColors.error,
        ));
      }
    }
  }
}

// ── Version Tile ──────────────────────────────────────────────────────────────

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
    final c = context.colors;
    return InkWell(
      onTap: onPreview,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        child: Row(children: [
          Container(
            width: 10, height: 10,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isCurrent ? AppColors.success : c.chipFill,
              border: Border.all(
                  color: isCurrent ? AppColors.success : c.border),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(children: [
                Text(version.displayLabel,
                    style: TextStyle(
                      color: isCurrent ? c.textPrimary : c.textSecondary,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    )),
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
              ]),
              if (version.refinementPrompt != null)
                Text('"${version.refinementPrompt}"',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        color: c.textMuted,
                        fontSize: 12,
                        fontStyle: FontStyle.italic)),
              Text(_fmtDateTime(version.createdAt),
                  style: TextStyle(color: c.textMuted, fontSize: 11)),
            ],
          )),
          const SizedBox(width: 4),
          IconButton(
            icon: Icon(Icons.open_in_new_rounded,
                size: 16, color: c.textMuted),
            tooltip: 'Preview',
            onPressed: onPreview,
          ),
          if (onRestore != null)
            TextButton(
              onPressed: onRestore,
              style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  minimumSize: const Size(0, 32)),
              child: Text('Restore',
                  style:
                  TextStyle(color: c.textBody, fontSize: 12)),
            ),
        ]),
      ),
    );
  }

  String _fmtDateTime(DateTime dt) {
    const m = ['Jan','Feb','Mar','Apr','May','Jun',
      'Jul','Aug','Sep','Oct','Nov','Dec'];
    final h = dt.hour.toString().padLeft(2, '0');
    final min = dt.minute.toString().padLeft(2, '0');
    return '${dt.day} ${m[dt.month - 1]} ${dt.year} · $h:$min';
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
          NavigationDelegate(onPageFinished: (_) =>
              setState(() => _ready = true)))
      ..loadHtmlString(widget.version.htmlContent);
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final v = widget.version;
    return Scaffold(
      appBar: AppBar(
        title: Text(v.displayLabel),
        leading: IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => Navigator.pop(context)),
      ),
      body: Column(children: [
        Container(
          width: double.infinity,
          padding:
          const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          color: c.chipFill,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(_fmtDateTime(v.createdAt),
                  style: TextStyle(color: c.textBody, fontSize: 12)),
              if (v.refinementPrompt != null)
                Text('"${v.refinementPrompt}"',
                    style: TextStyle(
                        color: c.textMuted,
                        fontSize: 12,
                        fontStyle: FontStyle.italic)),
            ],
          ),
        ),
        Expanded(child: Stack(children: [
          Container(color: Colors.white,
              child: WebViewWidget(controller: _ctrl)),
          if (!_ready)
            Container(
              color: c.surface,
              child: const Center(child: CircularProgressIndicator()),
            ),
        ])),
      ]),
    );
  }

  String _fmtDateTime(DateTime dt) {
    const m = ['Jan','Feb','Mar','Apr','May','Jun',
      'Jul','Aug','Sep','Oct','Nov','Dec'];
    final h = dt.hour.toString().padLeft(2, '0');
    final min = dt.minute.toString().padLeft(2, '0');
    return '${dt.day} ${m[dt.month - 1]} ${dt.year} at $h:$min';
  }
}