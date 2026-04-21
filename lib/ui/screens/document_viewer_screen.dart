import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:printing/printing.dart';
import 'package:share_plus/share_plus.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../core/constants/app_colors.dart';
import '../../core/utils/html_to_pdf_pipeline.dart';
import '../../models/document_asset.dart';
import '../../providers/auth_provider.dart';
import '../../providers/document_generation_provider.dart';
import '../../providers/offline_file_provider.dart';
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
  late DocumentAsset _currentAsset;
  bool _webReady = false;
  final _refineCtrl = TextEditingController();
  bool _refineBarVisible = false;

  @override
  void initState() {
    super.initState();
    _currentAsset = widget.asset;
    _initWebView(_currentAsset);
  }

  void _initWebView(DocumentAsset asset) {
    if (asset.isStructural && asset.htmlContent != null) {
      _webCtrl = WebViewController()
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..setBackgroundColor(Colors.white)
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

  // ── Refinement ──────────────────────────────────────────────────────────────
  Future<void> _submitRefinement() async {
    final prompt = _refineCtrl.text.trim();
    if (prompt.isEmpty) return;
    FocusScope.of(context).unfocus();
    _refineCtrl.clear();

    final notifier = ref.read(
        documentGenerationProvider(_currentAsset.portfolioId).notifier);
    final refined = await notifier.refineDocument(
      existingAsset: _currentAsset,
      refinementPrompt: prompt,
    );

    if (refined != null && mounted) {
      setState(() {
        _webReady = false;
        _currentAsset = refined;
      });
      _webCtrl?.loadHtmlString(refined.htmlContent!);
    }
  }

  // ── Export ──────────────────────────────────────────────────────────────────
  Future<void> _export() async {
    final user = ref.read(currentUserProvider);
    if (user == null) return;

    final asset = _currentAsset;

    if (asset.isStructural && asset.htmlContent != null) {
      try {
        final file = await HtmlToPdfPipeline.instance.convert(
          html: asset.htmlContent!,
          uid: user.uid,
          pid: asset.portfolioId,
          docId: asset.id,
        );
        await Printing.sharePdf(
          bytes: await file.readAsBytes(),
          filename: '${asset.title}.pdf',
        );
      } catch (e) {
        // Fallback: share as HTML file
        final tempDir = Directory.systemTemp;
        final htmlFile =
        File('${tempDir.path}/${asset.title.replaceAll(' ', '_')}.html');
        await htmlFile.writeAsString(asset.htmlContent!);
        await Share.shareXFiles(
          [XFile(htmlFile.path)],
          text: asset.title,
        );
      }
    } else if (asset.isGraphical) {
      final fileAsync = ref.read(offlineFileProvider(asset));
      fileAsync.whenData((file) async {
        if (file != null) {
          await Share.shareXFiles(
            [XFile(file.path)],
            text: asset.title,
          );
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final asset = _currentAsset;
    final genState =
    ref.watch(documentGenerationProvider(asset.portfolioId));
    final isRefining = genState.isLoading;

    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            title: Text(asset.title,
                maxLines: 1, overflow: TextOverflow.ellipsis),
            leading: BackButton(
              onPressed: () => context.go('/portfolio/${asset.portfolioId}'),
            ),
            actions: [
              if (asset.isStructural)
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
                  onPressed: () => setState(
                          () => _refineBarVisible = !_refineBarVisible),
                ),
              IconButton(
                icon: const Icon(Icons.ios_share_rounded),
                tooltip: 'Export',
                onPressed: isRefining ? null : _export,
              ),
            ],
          ),
          body: Column(
            children: [
              Expanded(
                child: asset.isStructural
                    ? _StructuralViewer(
                    controller: _webCtrl!, isReady: _webReady)
                    : _GraphicalViewer(asset: asset),
              ),
              if (asset.isStructural && _refineBarVisible)
                _RefinementBar(
                  controller: _refineCtrl,
                  onSubmit: isRefining ? null : _submitRefinement,
                  isLoading: isRefining,
                ),
            ],
          ),
          bottomNavigationBar: _DocInfoBar(asset: asset),
        ),
        if (isRefining)
          GenerationStateOverlay(
            phase: genState.phase,
            onCancel: () => ref
                .read(documentGenerationProvider(asset.portfolioId).notifier)
                .cancel(),
          ),
        if (genState.hasError)
          _ErrorBanner(
            error: genState.error.toString(),
            onDismiss: () => ref
                .read(documentGenerationProvider(asset.portfolioId).notifier)
                .reset(),
          ),
      ],
    );
  }
}

// ── Refinement Bar ───────────────────────────────────────────────────────────

class _RefinementBar extends StatelessWidget {
  const _RefinementBar({
    required this.controller,
    required this.onSubmit,
    required this.isLoading,
  });

  final TextEditingController controller;
  final VoidCallback? onSubmit;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(
          16, 12, 16, 12 + MediaQuery.of(context).viewInsets.bottom),
      decoration: const BoxDecoration(
        color: AppColors.card,
        border: Border(top: BorderSide(color: AppColors.border)),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              maxLines: 3,
              minLines: 1,
              autofocus: true,
              style: const TextStyle(fontSize: 14),
              decoration: const InputDecoration(
                hintText:
                'Describe a change… e.g. "Change the due date to June 30" or "Add a 10% VAT line"',
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
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: onSubmit != null ? AppColors.white : AppColors.graphite,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                Icons.send_rounded,
                size: 18,
                color:
                onSubmit != null ? AppColors.black : AppColors.muted,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Viewers ──────────────────────────────────────────────────────────────────

class _StructuralViewer extends StatelessWidget {
  const _StructuralViewer({required this.controller, required this.isReady});
  final WebViewController controller;
  final bool isReady;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
            color: Colors.white,
            child: WebViewWidget(controller: controller)),
        if (!isReady)
          Container(
            color: AppColors.surface,
            child: const Center(child: CircularProgressIndicator()),
          ),
      ],
    );
  }
}

class _GraphicalViewer extends ConsumerWidget {
  const _GraphicalViewer({required this.asset});
  final DocumentAsset asset;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final fileAsync = ref.watch(offlineFileProvider(asset));
    return fileAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(
        child: Text('Could not load image: $e',
            style: const TextStyle(color: AppColors.error)),
      ),
      data: (file) {
        if (file != null) {
          return Center(
            child: InteractiveViewer(
                child: Image.file(file, fit: BoxFit.contain)),
          );
        }
        if (asset.storageUrl != null) {
          return Center(
            child: InteractiveViewer(
                child: Image.network(asset.storageUrl!, fit: BoxFit.contain)),
          );
        }
        return const Center(
          child: Text('No preview available.',
              style: TextStyle(color: AppColors.muted)),
        );
      },
    );
  }
}

// ── Info Bar ─────────────────────────────────────────────────────────────────

class _DocInfoBar extends StatelessWidget {
  const _DocInfoBar({required this.asset});
  final DocumentAsset asset;

  @override
  Widget build(BuildContext context) {
    final updated = asset.updatedAt;
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
      decoration: const BoxDecoration(
        color: AppColors.card,
        border: Border(top: BorderSide(color: AppColors.border)),
      ),
      child: Row(
        children: [
          _Chip(asset.type.name),
          const SizedBox(width: 8),
          _Chip(asset.pipeline.name),
          if (updated != null) ...[
            const SizedBox(width: 8),
            _Chip('edited ${_formatDate(updated)}'),
          ],
          const Spacer(),
          Text(
            _formatDate(asset.createdAt),
            style: Theme.of(context).textTheme.labelSmall,
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime dt) {
    const m = [
      'Jan','Feb','Mar','Apr','May','Jun',
      'Jul','Aug','Sep','Oct','Nov','Dec'
    ];
    return '${dt.day} ${m[dt.month - 1]}';
  }
}

class _Chip extends StatelessWidget {
  const _Chip(this.label);
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: AppColors.graphite,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: AppColors.border),
      ),
      child: Text(label.toUpperCase(),
          style: Theme.of(context).textTheme.labelSmall),
    );
  }
}

// ── Error Banner ─────────────────────────────────────────────────────────────

class _ErrorBanner extends StatelessWidget {
  const _ErrorBanner({required this.error, required this.onDismiss});
  final String error;
  final VoidCallback onDismiss;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onDismiss,
      child: Container(
        color: Colors.black87,
        child: Center(
          child: Container(
            margin: const EdgeInsets.all(32),
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppColors.card,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.error_outline,
                    color: AppColors.error, size: 36),
                const SizedBox(height: 16),
                Text('Refinement Failed',
                    style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 8),
                Text(error,
                    style: const TextStyle(
                        color: AppColors.error, fontSize: 13),
                    textAlign: TextAlign.center),
                const SizedBox(height: 20),
                FilledButton(
                    onPressed: onDismiss, child: const Text('Dismiss')),
              ],
            ),
          ),
        ),
      ),
    );
  }
}