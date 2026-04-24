import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:printing/printing.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../core/constants/app_colors.dart';
import '../../core/extensions/context_extensions.dart';
import '../../core/utils/html_to_pdf_pipeline.dart';
import '../../models/document_asset.dart';
import '../../providers/auth_provider.dart';
import '../../providers/document_generation_provider.dart';
import '../../providers/offline_file_provider.dart';
import '../sheets/version_history_sheet.dart';
import '../widgets/generation_state_overlay.dart';

class DocumentViewerScreen extends ConsumerStatefulWidget {
  const DocumentViewerScreen({super.key, required this.asset});
  final DocumentAsset asset;

  @override
  ConsumerState<DocumentViewerScreen> createState() =>
      _DocumentViewerScreenState();
}

class _DocumentViewerScreenState
    extends ConsumerState<DocumentViewerScreen> {
  late WebViewController? _webCtrl;
  late DocumentAsset _asset;
  bool _webReady = false;
  final _refineCtrl = TextEditingController();
  bool _refineBarVisible = false;

  @override
  void initState() {
    super.initState();
    _asset = widget.asset;
    _initWeb(_asset);
  }

  void _initWeb(DocumentAsset asset) {
    if (asset.isStructural && asset.htmlContent != null) {
      _webCtrl = WebViewController()
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..setBackgroundColor(Colors.white)
        ..enableZoom(true) // Ensure zooming is enabled for fixed-width docs
        ..setNavigationDelegate(NavigationDelegate(
          onPageFinished: (_) => setState(() => _webReady = true),
        ))
        ..loadHtmlString(asset.htmlContent!);
    } else {
      _webCtrl = null;
    }
  }

  @override
  void dispose() {
    _refineCtrl.dispose();
    super.dispose();
  }

  void _applyUpdated(DocumentAsset updated) {
    final user = ref.read(currentUserProvider);
    if (user != null) {
      HtmlToPdfPipeline.instance
          .invalidate(user.uid, updated.portfolioId, updated.id);
    }
    setState(() { _webReady = false; _asset = updated; });
    if (updated.htmlContent != null) {
      _webCtrl?.loadHtmlString(updated.htmlContent!);
    }
  }

  Future<void> _submitRefinement() async {
    final prompt = _refineCtrl.text.trim();
    if (prompt.isEmpty) return;
    FocusScope.of(context).unfocus();
    _refineCtrl.clear();
    final refined = await ref
        .read(documentGenerationProvider(_asset.portfolioId).notifier)
        .refineDocument(existingAsset: _asset, refinementPrompt: prompt);
    if (refined != null && mounted) _applyUpdated(refined);
  }

  void _showHistory() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => VersionHistorySheet(
        asset: _asset,
        onVersionRestored: _applyUpdated,
      ),
    );
  }

  Future<void> _export() async {
    final user = ref.read(currentUserProvider);
    if (user == null) return;

    if (_asset.isStructural && _asset.htmlContent != null) {
      try {
        final file = await HtmlToPdfPipeline.instance.convert(
          html: _asset.htmlContent!,
          uid: user.uid,
          pid: _asset.portfolioId,
          docId: _asset.id,
        );
        await Printing.sharePdf(
          bytes: await file.readAsBytes(),
          filename: '${_asset.title}.pdf',
        );
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Export failed: $e'),
            backgroundColor: AppColors.error,
          ));
        }
      }
    } else if (_asset.isGraphical) {
      ref.read(offlineFileProvider(_asset)).whenData((file) async {
        if (file != null) {
          await Printing.sharePdf(
            bytes: await file.readAsBytes(),
            filename: '${_asset.title}.png',
          );
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final genState = ref.watch(documentGenerationProvider(_asset.portfolioId));
    final busy = genState.isLoading;

    return Stack(children: [
      Scaffold(
        appBar: AppBar(
          title: Text(_asset.title,
              maxLines: 1, overflow: TextOverflow.ellipsis),
          leading: BackButton(
              onPressed: () =>
                  context.go('/portfolio/${_asset.portfolioId}')),
          actions: [
            if (_asset.isStructural) ...[
              IconButton(
                icon: const Icon(Icons.history_rounded, size: 22),
                tooltip: 'Version history',
                onPressed: busy ? null : _showHistory,
              ),
              IconButton(
                icon: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  child: Icon(
                    _refineBarVisible
                        ? Icons.keyboard_hide_outlined
                        : Icons.edit_note_rounded,
                    key: ValueKey(_refineBarVisible),
                    size: 22,
                  ),
                ),
                tooltip: 'Refine document',
                onPressed: busy
                    ? null
                    : () => setState(
                        () => _refineBarVisible = !_refineBarVisible),
              ),
            ],
            IconButton(
              icon: const Icon(Icons.ios_share_rounded),
              tooltip: 'Export / Share',
              onPressed: busy ? null : _export,
            ),
          ],
        ),
        body: Column(children: [
          Expanded(
            child: _asset.isStructural
                ? _StructuralViewer(
              controller: _webCtrl!,
              isReady: _webReady,
              bgColor: c.surface,
            )
                : _GraphicalViewer(asset: _asset),
          ),
          if (_asset.isStructural && _refineBarVisible)
            _RefinementBar(
              controller: _refineCtrl,
              onSubmit: busy ? null : _submitRefinement,
              bgColor: c.card,
              borderColor: c.border,
              btnBg: c.filledButtonBg,
              btnFg: c.filledButtonFg,
            ),
        ]),
        bottomNavigationBar: _DocInfoBar(asset: _asset),
      ),
      if (busy)
        GenerationStateOverlay(
          phase: genState.phase,
          onCancel: () => ref
              .read(documentGenerationProvider(_asset.portfolioId).notifier)
              .cancel(),
        ),
      if (genState.hasError)
        _ErrorBanner(
          error: genState.error.toString(),
          onDismiss: () => ref
              .read(documentGenerationProvider(_asset.portfolioId).notifier)
              .reset(),
        ),
    ]);
  }
}

// ── Refinement Bar ────────────────────────────────────────────────────────────

class _RefinementBar extends StatelessWidget {
  const _RefinementBar({
    required this.controller,
    required this.onSubmit,
    required this.bgColor,
    required this.borderColor,
    required this.btnBg,
    required this.btnFg,
  });

  final TextEditingController controller;
  final VoidCallback? onSubmit;
  final Color bgColor, borderColor, btnBg, btnFg;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(
          16, 12, 16, 12 + MediaQuery.of(context).viewInsets.bottom),
      decoration: BoxDecoration(
          color: bgColor,
          border: Border(top: BorderSide(color: borderColor))),
      child: Row(children: [
        Expanded(
          child: TextField(
            controller: controller,
            maxLines: 3, minLines: 1,
            autofocus: true,
            style: const TextStyle(fontSize: 14),
            decoration: const InputDecoration(
              hintText:
              'Describe a change… e.g. "Change due date to 30 June"',
              contentPadding:
              EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            ),
            textInputAction: TextInputAction.send,
            onSubmitted: (_) => onSubmit?.call(),
          ),
        ),
        const SizedBox(width: 10),
        GestureDetector(
          onTap: onSubmit,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            width: 44, height: 44,
            decoration: BoxDecoration(
              color: onSubmit != null ? btnBg : borderColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(Icons.send_rounded,
                size: 18,
                color: onSubmit != null ? btnFg : context.colors.textMuted),
          ),
        ),
      ]),
    );
  }
}

// ── Viewers ───────────────────────────────────────────────────────────────────

class _StructuralViewer extends StatelessWidget {
  const _StructuralViewer({
    required this.controller,
    required this.isReady,
    required this.bgColor,
  });
  final WebViewController controller;
  final bool isReady;
  final Color bgColor;

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Container(color: Colors.white, child: WebViewWidget(controller: controller)),
      if (!isReady)
        Container(
          color: bgColor,
          child: const Center(child: CircularProgressIndicator()),
        ),
    ]);
  }
}

class _GraphicalViewer extends ConsumerWidget {
  const _GraphicalViewer({required this.asset});
  final DocumentAsset asset;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(offlineFileProvider(asset)).when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(
        child: Text('Could not load: $e',
            style: TextStyle(
                color: Theme.of(context).colorScheme.error)),
      ),
      data: (file) {
        if (file != null) {
          return Center(child: InteractiveViewer(
              child: Image.file(file, fit: BoxFit.contain)));
        }
        if (asset.storageUrl != null) {
          return Center(child: InteractiveViewer(
              child: CachedNetworkImage(
                imageUrl: asset.storageUrl!,
                fit: BoxFit.contain,
                placeholder: (context, url) => const Center(
                    child: CircularProgressIndicator(strokeWidth: 2)),
                errorWidget: (context, url, error) => const Icon(Icons.error),
              )));
        }
        return Center(child: Text('No preview available.',
            style: TextStyle(color: context.colors.textMuted)));
      },
    );
  }
}

// ── Info Bar ──────────────────────────────────────────────────────────────────

class _DocInfoBar extends StatelessWidget {
  const _DocInfoBar({required this.asset});
  final DocumentAsset asset;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
      decoration: BoxDecoration(
          color: c.card,
          border: Border(top: BorderSide(color: c.border))),
      child: Row(children: [
        _Chip(asset.type.name),
        const SizedBox(width: 8),
        _Chip(asset.pipeline.name),
        if (asset.updatedAt != null) ...[
          const SizedBox(width: 8),
          _Chip('edited ${_fmt(asset.updatedAt!)}'),
        ],
        const Spacer(),
        Text(_fmt(asset.createdAt),
            style: Theme.of(context).textTheme.labelSmall),
      ]),
    );
  }

  String _fmt(DateTime dt) {
    const m = ['Jan','Feb','Mar','Apr','May','Jun',
      'Jul','Aug','Sep','Oct','Nov','Dec'];
    return '${dt.day} ${m[dt.month - 1]}';
  }
}

class _Chip extends StatelessWidget {
  const _Chip(this.label);
  final String label;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: c.chipFill,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: c.border),
      ),
      child: Text(label.toUpperCase(),
          style: Theme.of(context).textTheme.labelSmall),
    );
  }
}

// ── Error Banner ──────────────────────────────────────────────────────────────

class _ErrorBanner extends StatelessWidget {
  const _ErrorBanner({required this.error, required this.onDismiss});
  final String error;
  final VoidCallback onDismiss;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return GestureDetector(
      onTap: onDismiss,
      child: Container(
        color: c.overlayBarrier,
        child: Center(
          child: Container(
            margin: const EdgeInsets.all(32),
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: c.card,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              const Icon(Icons.error_outline,
                  color: AppColors.error, size: 36),
              const SizedBox(height: 16),
              Text('Operation Failed',
                  style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 8),
              Text(error,
                  style: const TextStyle(
                      color: AppColors.error, fontSize: 13),
                  textAlign: TextAlign.center),
              const SizedBox(height: 20),
              FilledButton(
                  onPressed: onDismiss,
                  child: const Text('Dismiss')),
            ]),
          ),
        ),
      ),
    );
  }
}
