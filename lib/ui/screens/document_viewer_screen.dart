import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:printing/printing.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../core/constants/app_colors.dart';
import '../../core/utils/html_to_pdf_pipeline.dart';
import '../../models/document_asset.dart';
import '../../providers/auth_provider.dart';
import '../../providers/offline_file_provider.dart';

class DocumentViewerScreen extends ConsumerStatefulWidget {
  const DocumentViewerScreen({super.key, required this.asset});
  final DocumentAsset asset;

  @override
  ConsumerState<DocumentViewerScreen> createState() =>
      _DocumentViewerScreenState();
}

class _DocumentViewerScreenState
    extends ConsumerState<DocumentViewerScreen> {
  late final WebViewController? _webCtrl;
  bool _webReady = false;

  @override
  void initState() {
    super.initState();
    if (widget.asset.isStructural && widget.asset.htmlContent != null) {
      _webCtrl = WebViewController()
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..setBackgroundColor(Colors.white)
        ..setNavigationDelegate(
          NavigationDelegate(
            onPageFinished: (_) => setState(() => _webReady = true),
          ),
        )
        ..loadHtmlString(widget.asset.htmlContent!);
    } else {
      _webCtrl = null;
    }
  }

  Future<void> _exportPdf() async {
    final user = ref.read(currentUserProvider);
    if (user == null) return;

    final asset = widget.asset;

    if (asset.isStructural && asset.htmlContent != null) {
      final file = await HtmlToPdfPipeline.instance.convert(
        html: asset.htmlContent!,
        uid: user.uid,
        pid: asset.portfolioId,
        docId: asset.id,
      );

      // Share / print using the printing package
      await Printing.sharePdf(
        bytes: await file.readAsBytes(),
        filename: '${asset.title}.pdf',
      );
    } else if (asset.isGraphical) {
      final fileAsync = ref.read(offlineFileProvider(asset));
      fileAsync.whenData((file) async {
        if (file != null) {
          await Printing.sharePdf(
              bytes: await file.readAsBytes(),
              filename: '${asset.title}.png');
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final asset = widget.asset;

    return Scaffold(
      appBar: AppBar(
        title: Text(asset.title, maxLines: 1, overflow: TextOverflow.ellipsis),
        leading: BackButton(
          onPressed: () =>
              context.go('/portfolio/${asset.portfolioId}'),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.ios_share_rounded),
            tooltip: 'Export',
            onPressed: _exportPdf,
          ),
        ],
      ),
      body: asset.isStructural
          ? _StructuralViewer(controller: _webCtrl!, isReady: _webReady)
          : _GraphicalViewer(asset: asset),
      bottomNavigationBar: _DocInfoBar(asset: asset),
    );
  }
}

class _StructuralViewer extends StatelessWidget {
  const _StructuralViewer(
      {required this.controller, required this.isReady});
  final WebViewController controller;
  final bool isReady;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(color: Colors.white, child: WebViewWidget(controller: controller)),
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
      loading: () =>
      const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(
        child: Text('Could not load image: $e',
            style: const TextStyle(color: AppColors.error)),
      ),
      data: (file) {
        if (file != null) {
          return Center(
            child: InteractiveViewer(
              child: Image.file(file, fit: BoxFit.contain),
            ),
          );
        }
        if (asset.storageUrl != null) {
          return Center(
            child: InteractiveViewer(
              child: Image.network(asset.storageUrl!, fit: BoxFit.contain),
            ),
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

class _DocInfoBar extends StatelessWidget {
  const _DocInfoBar({required this.asset});
  final DocumentAsset asset;

  @override
  Widget build(BuildContext context) {
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
          const Spacer(),
          Text(
            _formatDate(asset.createdAt),
            style: Theme.of(context).textTheme.labelSmall,
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime dt) =>
      '${dt.day} ${_months[dt.month - 1]} ${dt.year}';

  static const _months = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
  ];
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
      child: Text(
        label.toUpperCase(),
        style: Theme.of(context).textTheme.labelSmall,
      ),
    );
  }
}