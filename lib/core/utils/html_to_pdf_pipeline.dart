import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';

import '../../services/local_cache_service.dart';

class HtmlToPdfPipeline {
  HtmlToPdfPipeline._();
  static final HtmlToPdfPipeline instance = HtmlToPdfPipeline._();

  final _cache = LocalCacheService.instance;

  Future<File> convert({
    required String html,
    required String uid,
    required String pid,
    required String docId,
    PdfPageFormat format = PdfPageFormat.a4,
  }) async {
    debugPrint('[Pipeline] Converting HTML → PDF for doc: $docId');

    if (html.trim().isEmpty) throw Exception('Empty HTML content');

    final cached = await _cache.getCachedPdf(uid, pid, docId);
    if (cached != null) return cached;

    // 1. Prepare high-fidelity but stable HTML
    final processedHtml = _prepareHtml(html);

    try {
      // 2. Increase timeout to 45s to allow for high-quality rendering
      final bytes = await Printing.convertHtml(
        format: format,
        html: processedHtml,
      ).timeout(const Duration(seconds: 45));

      final file = await _cache.cachePdfBytes(bytes, uid, pid, docId);
      await _cache.cacheHtml(html, uid, pid, docId);

      return file;
    } on TimeoutException {
      throw Exception('PDF rendering timed out. Try a shorter prompt or simpler document type.');
    } catch (e) {
      debugPrint('[Pipeline] Rendering error: $e');
      rethrow;
    }
  }

  String _prepareHtml(String html) {
    const injection = '''
<style>
  * { -webkit-print-color-adjust: exact !important; print-color-adjust: exact !important; }
  body { margin: 0; padding: 40px; box-sizing: border-box; background: white !important; font-family: sans-serif; }
  img { max-width: 100%; height: auto; }
  /* Prevent 'infinite' page calculations on Android */
  html, body { overflow: visible !important; height: auto !important; }
  .page-break { page-break-before: always; }
  * { visibility: visible !important; opacity: 1 !important; }
</style>
''';

    // Robust injection: avoid double <html> or <head> tags
    if (html.contains('</head>')) {
      return html.replaceFirst('</head>', '$injection</head>');
    } else if (html.contains('<body')) {
      return html.replaceFirst('<body', '<head>$injection</head><body');
    } else {
      return '<html><head>$injection</head><body>$html</body></html>';
    }
  }
}
