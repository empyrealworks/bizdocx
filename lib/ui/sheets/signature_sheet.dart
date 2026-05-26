import 'dart:convert';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/extensions/context_extensions.dart';
import '../../core/utils/smart_field_utility.dart';
import '../../models/document_asset.dart';
import '../../services/firebase_service.dart';

class SignatureSheet extends ConsumerStatefulWidget {
  const SignatureSheet({super.key, required this.asset});
  final DocumentAsset asset;

  @override
  ConsumerState<SignatureSheet> createState() => _SignatureSheetState();
}

class _SignatureSheetState extends ConsumerState<SignatureSheet> {
  final List<Offset?> _points = [];
  bool _isSaving = false;

  // Use a simple ChangeNotifier to handle repaints without full builds
  final ChangeNotifier _repaintNotifier = ChangeNotifier();

  @override
  void dispose() {
    _repaintNotifier.dispose();
    super.dispose();
  }

  Future<void> _applySignature() async {
    if (_points.isEmpty) return;
    
    final platform = Theme.of(context).platform.toString();
    final dpr = MediaQuery.of(context).devicePixelRatio;

    setState(() => _isSaving = true);

    try {
      final recorder = ui.PictureRecorder();
      final canvas = Canvas(recorder);
      final painter = SignaturePainter(points: _points, color: Colors.black, strokeWidth: 3);
      const size = Size(600, 200); 
      painter.paint(canvas, size);
      
      final picture = recorder.endRecording();
      final img = await picture.toImage(size.width.toInt(), size.height.toInt());
      final byteData = await img.toByteData(format: ui.ImageByteFormat.png);
      final bytes = byteData!.buffer.asUint8List();
      final base64 = base64Encode(bytes);

      final signatureHtml = '<img src="data:image/png;base64,$base64" alt="Signature" style="max-height: 80px; max-width: 250px; display: block;" />';
      final newHtml = SmartFieldUtility.injectSignature(widget.asset.htmlContent!, signatureHtml);

      final updated = widget.asset.copyWith(
        htmlContent: newHtml,
        status: DocumentStatus.signed,
        signatureBase64: base64,
        signedAt: DateTime.now(),
        signatureMetadata: {
          'platform': platform,
          'devicePixelRatio': dpr,
        },
      );

      await FirebaseService.instance.updateDocumentAsset(updated);

      if (mounted) {
        Navigator.pop(context, updated);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Document signed successfully.')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error signing: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
      decoration: BoxDecoration(
        color: c.card,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Sign Document', style: Theme.of(context).textTheme.headlineSmall),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Draw your signature below. Once applied, this document will be locked for further AI edits.',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 24),
          
          Container(
            height: 200,
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: c.border),
              borderRadius: BorderRadius.circular(12),
            ),
            child: GestureDetector(
              onPanUpdate: (details) {
                _points.add(details.localPosition);
                // ignore: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member
                _repaintNotifier.notifyListeners();
              },
              onPanEnd: (details) {
                _points.add(null);
                // ignore: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member
                _repaintNotifier.notifyListeners();
              },
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: ListenableBuilder(
                  listenable: _repaintNotifier,
                  builder: (context, _) {
                    return CustomPaint(
                      painter: SignaturePainter(points: List.from(_points), color: Colors.black),
                      size: Size.infinite,
                    );
                  },
                ),
              ),
            ),
          ),
          
          const SizedBox(height: 16),
          Row(
            children: [
              TextButton.icon(
                onPressed: () {
                  _points.clear();
                  // ignore: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member
                  _repaintNotifier.notifyListeners();
                },
                icon: const Icon(Icons.refresh_rounded, size: 18),
                label: const Text('Clear'),
              ),
              const Spacer(),
              FilledButton(
                onPressed: _isSaving ? null : _applySignature,
                style: FilledButton.styleFrom(
                  minimumSize: const Size(120, 44), // Override any global infinite width
                ),
                child: _isSaving
                    ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.black))
                    : const Text('Apply Signature'),
              ),
            ],
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

class SignaturePainter extends CustomPainter {
  SignaturePainter({required this.points, required this.color, this.strokeWidth = 4.0});

  final List<Offset?> points;
  final Color color;
  final double strokeWidth;

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = color
      ..strokeCap = StrokeCap.round
      ..strokeWidth = strokeWidth;

    for (int i = 0; i < points.length - 1; i++) {
      if (points[i] != null && points[i + 1] != null) {
        canvas.drawLine(points[i]!, points[i + 1]!, paint);
      }
    }
  }

  @override
  bool shouldRepaint(SignaturePainter oldDelegate) => true;
}
