import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:printing/printing.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../core/constants/app_colors.dart';
import '../../core/extensions/context_extensions.dart';
import '../../core/utils/html_to_pdf_pipeline.dart';
import '../../core/utils/ui_utils.dart';
import '../../models/document_asset.dart';
import '../../models/user_profile.dart';
import '../../providers/auth_provider.dart';
import '../../providers/document_generation_provider.dart';
import '../../providers/offline_file_provider.dart';
import '../../providers/profile_provider.dart';
import '../../services/prefs_service.dart';
import '../../services/review_service.dart';
import '../sheets/lifecycle_workflow_sheet.dart';
import '../sheets/signature_sheet.dart';
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
  bool _exporting = false;

  final GlobalKey _reuseKey = GlobalKey();
  final GlobalKey _aiKey = GlobalKey();
  final GlobalKey _signKey = GlobalKey();
  final GlobalKey _historyKey = GlobalKey();
  final GlobalKey _exportKey = GlobalKey();

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
        ..enableZoom(true)
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

  void _showSignature() async {
    final result = await showModalBottomSheet<DocumentAsset>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      enableDrag: false,
      builder: (ctx) => SignatureSheet(asset: _asset),
    );
    if (result != null && mounted) _applyUpdated(result);
  }

  Future<void> _export() async {
    final user = ref.read(currentUserProvider);
    if (user == null) return;

    if (_asset.isStructural && _asset.htmlContent != null) {
      setState(() => _exporting = true);
      try {
        final file = await HtmlToPdfPipeline.instance.convert(
          html: _asset.htmlContent!,
          uid: user.uid,
          pid: _asset.portfolioId,
          docId: _asset.id,
          paperSize: _asset.paperSize,
        );
        final safeTitle = _asset.title.replaceAll(RegExp(r'[/\\]'), '-');
        await Printing.sharePdf(
          bytes: await file.readAsBytes(),
          filename: '$safeTitle.pdf',
        );
        
        // Track first export for review prompt
        await ReviewService.instance.markFirstExportDone();
        _checkReviewPrompt();
      } catch (e) {
        if (mounted) {
          UiUtils.showErrorSnackBar(context, context.l10n.exportFailed(e.toString()));
        }
      } finally {
        if (mounted) setState(() => _exporting = false);
      }
    } else if (_asset.isGraphical) {
      ref.read(offlineFileProvider(_asset)).whenData((file) async {
        if (file != null) {
          final safeTitle = _asset.title.replaceAll(RegExp(r'[/\\]'), '-');
          await Printing.sharePdf(
            bytes: await file.readAsBytes(),
            filename: '$safeTitle.png',
          );

          // Track first export for review prompt
          await ReviewService.instance.markFirstExportDone();
          _checkReviewPrompt();
        }
      });
    }
  }

  Future<void> _checkReviewPrompt() async {
    if (!mounted) return;
    final shouldPrompt = await ReviewService.instance.shouldPromptReview();
    if (shouldPrompt && mounted) {
      await ReviewService.instance.markReviewPrompted();
      _showReviewDialog();
    }
  }

  void _showReviewDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Enjoying BizDocx?'),
        content: const Text('You just exported your first document! Would you mind taking a moment to rate the app?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(context.l10n.maybeLater),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              // In a real app, this would trigger in_app_review
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Thank you for your feedback!')),
              );
            },
            child: const Text('Rate Now'),
          ),
        ],
      ),
    );
  }

  int get _refinementCost {
    if (_asset.isComplexType && _asset.revisionCount < 3) return 0;
    return CreditCosts.minorRevision;
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(documentListProvider(_asset.portfolioId), (prev, next) {
      next.whenData((docs) {
        final remote = docs.where((d) => d.id == _asset.id).firstOrNull;
        if (remote != null && remote.htmlContent != _asset.htmlContent) {
          _applyUpdated(remote);
        }
      });
    });

    return ShowCaseWidget(
      onFinish: () => PrefsService.instance.markViewerTutorialSeen(),
      builder: (context) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!PrefsService.instance.hasSeenViewerTutorial) {
            ShowCaseWidget.of(context).startShowCase([
              _reuseKey,
              _aiKey,
              _signKey,
              _historyKey,
              _exportKey,
            ]);
          }
        });
        return _buildScaffold(context);
      },
    );
  }

  Widget _buildScaffold(BuildContext context) {
    final c = context.colors;
    final l = context.l10n;
    final genState = ref.watch(documentGenerationProvider(_asset.portfolioId));
    final profile = ref.watch(userProfileProvider).value;
    final busy = genState.isLoading || _exporting;
    final isSigned = _asset.status == DocumentStatus.signed;

    return Stack(children: [
      Scaffold(
        appBar: AppBar(
          title: Text(_asset.title,
              maxLines: 1, overflow: TextOverflow.ellipsis),
          leading: BackButton(
              onPressed: () =>
                  context.go('/portfolio/${_asset.portfolioId}')),
          actions: [
            if (_asset.isStructural && !isSigned)
              Showcase(
                key: _signKey,
                description: 'Capture a secure, hand-drawn e-signature to finalize and lock this document.',
                child: IconButton(
                  icon: const Icon(Icons.draw_rounded, size: 22),
                  tooltip: l.signDocument,
                  onPressed: busy ? null : _showSignature,
                ),
              ),
            Showcase(
              key: _historyKey,
              description: 'Travel back in time and restore any previous version of your document.',
              child: IconButton(
                icon: const Icon(Icons.history_rounded, size: 22),
                tooltip: l.versionHistory,
                onPressed: busy ? null : _showHistory,
              ),
            ),
            if (_asset.isStructural) ...[
              Showcase(
                key: _reuseKey,
                description: 'Duplicate this layout for a new project or fix typos instantly without using AI credits.',
                child: IconButton(
                  icon: const Icon(Icons.transform_rounded, size: 22),
                  tooltip: 'Re-use or Modify',
                  onPressed: busy 
                    ? null 
                    : () async {
                        final router = GoRouter.of(context);
                        final result = await showModalBottomSheet<DocumentAsset>(
                          context: context,
                          isScrollControlled: true,
                          builder: (ctx) => LifecycleWorkflowSheet(asset: _asset),
                        );
                        if (result != null && mounted) {
                          if (result.id == _asset.id) {
                            _applyUpdated(result);
                          } else {
                            router.pushReplacement(
                              '/portfolio/${result.portfolioId}/doc/${result.id}',
                              extra: result,
                            );
                          }
                        }
                      },
                ),
              ),
              if (!isSigned)
                Showcase(
                  key: _aiKey,
                  description: 'Chat with AI to make deep structural changes or design updates to your document.',
                  child: IconButton(
                    icon: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 200),
                      child: Icon(
                        _refineBarVisible
                            ? Icons.keyboard_hide_outlined
                            : Icons.auto_awesome,
                        key: ValueKey(_refineBarVisible),
                        size: 22,
                      ),
                    ),
                    tooltip: 'AI Refinement',
                    onPressed: busy
                        ? null
                        : () => setState(
                            () => _refineBarVisible = !_refineBarVisible),
                  ),
                ),
            ],
            Showcase(
              key: _exportKey,
              description: 'Export your high-fidelity document as a PDF or share it with clients.',
              child: IconButton(
                icon: const Icon(Icons.ios_share_rounded),
                tooltip: 'Export / Share',
                onPressed: busy ? null : _export,
              ),
            ),
          ],
        ),
        body: Column(children: [
          if (isSigned) const _SignedBadge(),
          if (profile != null && profile.totalCredits < 150)
             _LowBalanceBanner(balance: profile.totalCredits),
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
              cost: _refinementCost,
              revisionCount: _asset.isComplexType ? _asset.revisionCount : null,
            ),
        ]),
        bottomNavigationBar: _DocInfoBar(asset: _asset),
      ),
      if (genState.isLoading)
        GenerationStateOverlay(
          phase: genState.phase,
          onCancel: () => ref
              .read(documentGenerationProvider(_asset.portfolioId).notifier)
              .cancel(),
        ),
      if (_exporting)
        const _ExportOverlay(),
      if (genState.hasError)
        _SmartErrorBanner(
          error: genState.error.toString(),
          onDismiss: () => ref
              .read(documentGenerationProvider(_asset.portfolioId).notifier)
              .reset(),
          onUpgrade: () {
            ref.read(documentGenerationProvider(_asset.portfolioId).notifier).reset();
            context.push('/settings/subscription');
          },
        ),
    ]);
  }
}

class _SignedBadge extends StatelessWidget {
  const _SignedBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: AppColors.success.withValues(alpha: 0.1),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          const Icon(Icons.verified_rounded, color: AppColors.success, size: 14),
          const SizedBox(width: 8),
          Text(
            context.l10n.signedAndLocked,
            style: const TextStyle(color: AppColors.success, fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 0.5),
          ),
        ],
      ),
    );
  }
}

class _LowBalanceBanner extends StatelessWidget {
  const _LowBalanceBanner({required this.balance});
  final int balance;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: const Color(0xFFFF6B35).withValues(alpha: 0.1),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          const Icon(Icons.warning_amber_rounded, color: Color(0xFFFF6B35), size: 14),
          const SizedBox(width: 8),
          Expanded(child: Text(context.l10n.lowBalance(balance), style: const TextStyle(color: Color(0xFFFF6B35), fontSize: 11, fontWeight: FontWeight.w600))),
          GestureDetector(
            onTap: () => context.push('/settings/subscription'),
            child: Text(context.l10n.topUp, style: const TextStyle(color: Color(0xFFFF6B35), fontSize: 11, fontWeight: FontWeight.bold, decoration: TextDecoration.underline)),
          )
        ],
      ),
    );
  }
}

// ── Export Overlay ────────────────────────────────────────────────────────────

class _ExportOverlay extends StatelessWidget {
  const _ExportOverlay();

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Material(
      type: MaterialType.transparency,
      child: Container(
        color: c.overlayBarrier,
        child: Center(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
            decoration: BoxDecoration(
              color: c.card,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const CircularProgressIndicator(strokeWidth: 3),
                const SizedBox(height: 20),
                Text(
                  context.l10n.preparingPdf,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  context.l10n.convertingLayout,
                  style: TextStyle(color: context.colors.textMuted, fontSize: 13),
                ),
              ],
            ),
          ),
        ),
      ),
    );
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
    required this.cost,
    this.revisionCount,
  });

  final TextEditingController controller;
  final VoidCallback? onSubmit;
  final Color bgColor, borderColor, btnBg, btnFg;
  final int cost;
  final int? revisionCount;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(
          16, 12, 16, 12 + MediaQuery.of(context).viewInsets.bottom),
      decoration: BoxDecoration(
          color: bgColor,
          border: Border(top: BorderSide(color: borderColor))),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (revisionCount != null && revisionCount! < 3)
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0, left: 4),
              child: Text(
                context.l10n.freeRevision(revisionCount! + 1),
                style: const TextStyle(color: AppColors.success, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 0.5),
              ),
            ),
          Row(children: [
            Expanded(
              child: TextField(
                controller: controller,
                maxLines: 3, minLines: 1,
                autofocus: true,
                style: const TextStyle(fontSize: 14),
                decoration: InputDecoration(
                  hintText:
                  context.l10n.describeAChange,
                  contentPadding:
                  const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
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
                padding: const EdgeInsets.symmetric(horizontal: 12),
                height: 44,
                decoration: BoxDecoration(
                  color: onSubmit != null ? btnBg : borderColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.auto_fix_high_rounded,
                          size: 16,
                          color: onSubmit != null ? btnFg : context.colors.textMuted),
                      if (onSubmit != null) ...[
                        const SizedBox(width: 6),
                        Text(
                          cost == 0 ? context.l10n.free : '$cost',
                          style: TextStyle(
                            color: btnFg,
                            fontSize: 11,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ]
                    ],
                  ),
                ),
              ),
            ),
          ]),
        ],
      ),
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
    final l = context.l10n;
    return ref.watch(offlineFileProvider(asset)).when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(
        child: Text(l.couldNotLoad(e.toString()),
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
        return Center(child: Text(l.noPreviewAvailable,
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
    final l = context.l10n;
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
          _Chip(l.edited(_fmt(asset.updatedAt!))),
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

// ── Smart Error Banner ────────────────────────────────────────────────────────

class _SmartErrorBanner extends StatelessWidget {
  const _SmartErrorBanner({
    required this.error, 
    required this.onDismiss,
    required this.onUpgrade,
  });
  
  final String error;
  final VoidCallback onDismiss;
  final VoidCallback onUpgrade;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final l = context.l10n;
    final isLimitError = error.contains('limit') || error.contains('credits');

    return Material(
      type: MaterialType.transparency,
      child: GestureDetector(
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
                Icon(
                  isLimitError ? Icons.stars_rounded : Icons.error_outline,
                  color: isLimitError ? const Color(0xFFFFD60A) : AppColors.error, 
                  size: 48
                ),
                const SizedBox(height: 16),
                Text(
                  isLimitError ? l.limitReached : l.operationFailed,
                  style: Theme.of(context).textTheme.titleLarge
                ),
                const SizedBox(height: 12),
                Text(
                  error.replaceAll('Exception: ', ''),
                  style: TextStyle(
                      color: isLimitError ? c.textSecondary : AppColors.error, 
                      fontSize: 14,
                      height: 1.5
                  ),
                  textAlign: TextAlign.center
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: onDismiss, 
                        child: Text(l.dismiss)
                      ),
                    ),
                    if (isLimitError) ...[
                      const SizedBox(width: 12),
                      Expanded(
                        child: FilledButton(
                          onPressed: onUpgrade, 
                          style: FilledButton.styleFrom(backgroundColor: const Color(0xFFFF6B35)),
                          child: Text(l.viewPlans)
                        ),
                      ),
                    ],
                  ],
                ),
              ]),
            ),
          ),
        ),
      ),
    );
  }
}
