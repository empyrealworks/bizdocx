import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

import '../../core/extensions/context_extensions.dart';
import '../../models/document_asset.dart';
import '../../models/document_folder.dart';
import '../../services/ai_generation_service.dart';
import '../../services/firebase_service.dart';

class ScanningWorkflowSheet extends ConsumerStatefulWidget {
  const ScanningWorkflowSheet({super.key, required this.portfolioId});
  final String portfolioId;

  @override
  ConsumerState<ScanningWorkflowSheet> createState() => _ScanningWorkflowSheetState();
}

class _ScanningWorkflowSheetState extends ConsumerState<ScanningWorkflowSheet> {
  final _picker = ImagePicker();
  bool _isAnalyzing = false;
  Uint8List? _imageBytes;
  
  Map<String, dynamic>? _analysisResult;
  String? _error;

  Future<void> _pickImage(ImageSource source) async {
    try {
      final file = await _picker.pickImage(source: source, imageQuality: 85);
      if (file == null) return;

      final bytes = await file.readAsBytes();
      setState(() {
        _imageBytes = bytes;
        _isAnalyzing = true;
        _error = null;
      });

      final fb = FirebaseService.instance;
      final context = await fb.fetchContext(widget.portfolioId);
      final profile = await fb.fetchProfile();

      // Track usage for scanning (billed as structural)
      await fb.trackUsage(pipeline: AssetPipeline.structural, type: DocumentType.other);

      final result = await AiGenerationService.instance.analyzeScannedDocument(
        imageBytes: bytes,
        context: context,
        tier: profile.tier,
      );

      setState(() {
        _analysisResult = result;
        _isAnalyzing = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isAnalyzing = false;
      });
    }
  }

  Future<void> _saveDocument() async {
    if (_analysisResult == null) return;

    setState(() => _isAnalyzing = true);
    try {
      final metadata = _analysisResult!['metadata'] as Map<String, dynamic>;
      final html = _analysisResult!['html'] as String;
      
      final typeStr = metadata['type']?.toString().toLowerCase() ?? 'other';
      final type = DocumentType.values.firstWhere(
        (t) => t.name == typeStr,
        orElse: () => DocumentType.other,
      );

      final folderName = type.name.toUpperCase();
      final folders = await FirebaseService.instance.watchFolders(widget.portfolioId).first;
      var folder = folders.where((f) => f.name == folderName).firstOrNull;

      if (folder == null) {
        folder = await FirebaseService.instance.saveFolder(DocumentFolder(
          id: '',
          portfolioId: widget.portfolioId,
          name: folderName,
          createdAt: DateTime.now(),
          isAiGenerated: true,
        ));
      }

      final asset = DocumentAsset(
        id: const Uuid().v4(),
        portfolioId: widget.portfolioId,
        userId: FirebaseService.instance.currentUid,
        title: 'Scanned ${type.name} - ${DateTime.now().day}/${DateTime.now().month}',
        type: type,
        pipeline: AssetPipeline.structural,
        htmlContent: html,
        isScanned: true,
        folderId: folder.id,
        clientName: metadata['client']?.toString(),
        metadata: metadata,
        createdAt: DateTime.now(),
      );

      await FirebaseService.instance.saveDocumentAsset(asset);

      // Update recent clients
      final portfolios = await FirebaseService.instance.watchPortfolios().first;
      final portfolio = portfolios.firstWhere((p) => p.id == widget.portfolioId);
      final clientName = metadata['client']?.toString();
      if (clientName != null && !portfolio.recentClients.contains(clientName)) {
        await FirebaseService.instance.updatePortfolio(portfolio.copyWith(
          recentClients: [...portfolio.recentClients, clientName],
        ));
      }

      if (mounted) Navigator.pop(context);
    } catch (e) {
      setState(() {
        _error = 'Failed to save: $e';
        _isAnalyzing = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    
    return Container(
      padding: EdgeInsets.fromLTRB(24, 20, 24, MediaQuery.of(context).viewInsets.bottom + 40),
      decoration: BoxDecoration(
        color: c.card,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40, height: 4,
            decoration: BoxDecoration(color: c.border, borderRadius: BorderRadius.circular(2)),
          ),
          const SizedBox(height: 24),
          if (_imageBytes == null) ...[
            Text(context.l10n.scanDocument, style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: 8),
            Text(context.l10n.scanPrompt, 
              textAlign: TextAlign.center, style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(height: 32),
            Row(
              children: [
                Expanded(
                  child: _ActionCard(
                    icon: Icons.camera_alt_outlined,
                    label: context.l10n.camera,
                    onTap: () => _pickImage(ImageSource.camera),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _ActionCard(
                    icon: Icons.photo_library_outlined,
                    label: context.l10n.gallery,
                    onTap: () => _pickImage(ImageSource.gallery),
                  ),
                ),
              ],
            ),
          ] else if (_isAnalyzing) ...[
            const CircularProgressIndicator(),
            const SizedBox(height: 24),
            Text(context.l10n.analyzingDocument, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            Text(context.l10n.analyzingSub, textAlign: TextAlign.center),
          ] else if (_error != null) ...[
            const Icon(Icons.error_outline, color: Colors.red, size: 48),
            const SizedBox(height: 16),
            Text(context.l10n.analysisFailed, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            Text(_error!, textAlign: TextAlign.center, style: const TextStyle(color: Colors.red)),
            const SizedBox(height: 24),
            FilledButton(onPressed: () => setState(() => _imageBytes = null), child: Text(context.l10n.tryAgain)),
          ] else if (_analysisResult != null) ...[
            const Icon(Icons.check_circle_outline, color: Colors.green, size: 48),
            const SizedBox(height: 16),
            Text(context.l10n.scanComplete, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            _ReviewCard(result: _analysisResult!),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => setState(() => _imageBytes = null), 
                    child: Text(context.l10n.discard),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: FilledButton(
                    onPressed: _saveDocument, 
                    child: Text(context.l10n.saveDocument),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _ActionCard extends StatelessWidget {
  const _ActionCard({required this.icon, required this.label, required this.onTap});
  final IconData icon; final String label; final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 24),
        decoration: BoxDecoration(
          color: c.chipFill,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: c.border),
        ),
        child: Column(
          children: [
            Icon(icon, size: 32, color: c.iconPrimary),
            const SizedBox(height: 12),
            Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }
}

class _ReviewCard extends StatelessWidget {
  const _ReviewCard({required this.result});
  final Map<String, dynamic> result;

  @override
  Widget build(BuildContext context) {
    final meta = result['metadata'] as Map<String, dynamic>;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.colors.chipFill,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _Row(context, context.l10n.type, meta['type']?.toString().toUpperCase() ?? 'OTHER'),
          _Row(context, context.l10n.client, meta['client']?.toString() ?? context.l10n.unknownClient),
          _Row(context, context.l10n.total, meta['total']?.toString() ?? 'N/A'),
          _Row(context, context.l10n.date, meta['date']?.toString() ?? 'N/A'),
        ],
      ),
    );
  }

  Widget _Row(BuildContext context, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontSize: 12, color: context.colors.textPrimary.withValues(alpha: 0.6))),
          Text(value, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
