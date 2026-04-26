import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../../env/env.dart';
import '../../services/local_cache_service.dart';

/// Converts Gemini-generated HTML to a PDF File using a remote Playwright microservice.
class HtmlToPdfPipeline {
  HtmlToPdfPipeline._();
  static final HtmlToPdfPipeline instance = HtmlToPdfPipeline._();

  // PDF Engine URL injected via envied.
  static final _pdfEngineUrl = Env.pdfEngineUrl;

  final _cache = LocalCacheService.instance;

  Future<File> convert({
    required String html,
    required String uid,
    required String pid,
    required String docId,
  }) async {
    debugPrint('[Pipeline] Converting HTML → PDF via Remote Engine for doc: $docId');

    if (html.trim().isEmpty) throw Exception('Empty HTML content');

    // 1. Check Cache
    final cached = await _cache.getCachedPdf(uid, pid, docId);
    if (cached != null) {
      debugPrint('[Pipeline] PDF cache hit');
      return cached;
    }

    // 2. Prepare HTML (Ensuring standard dimensions are respected by the browser)
    final processedHtml = _prepareHtml(html);

    try {
      // 3. Request PDF from Microservice
      final response = await http.post(
        Uri.parse(_pdfEngineUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'html': processedHtml}),
      );

      if (response.statusCode != 200) {
        throw Exception(
          'Failed to generate PDF. Engine returned ${response.statusCode}: ${response.body}',
        );
      }

      final bytes = response.bodyBytes;

      // 4. Cache and Return
      final file = await _cache.cachePdfBytes(bytes, uid, pid, docId);
      await _cache.cacheHtml(html, uid, pid, docId);

      debugPrint('[Pipeline] PDF saved — ${bytes.length} bytes');
      return file;
    } catch (e) {
      debugPrint('[Pipeline] Engine error: $e');
      rethrow;
    }
  }

  /// Deletes the cached PDF so the next export re-renders fresh content.
  Future<void> invalidate(String uid, String pid, String docId) async {
    final path = await _cache.pdfPath(uid, pid, docId);
    final file = File(path);
    if (file.existsSync()) {
      await file.delete();
      debugPrint('[Pipeline] PDF cache invalidated: $docId');
    }
  }

  /// Injects print-safe CSS to ensure Chromium renders high-fidelity backgrounds.
  String _prepareHtml(String html) {
    // Remove HTML comments
    final commentRegex = RegExp(r'<!--[\s\S]*?-->');
    String cleanedHtml = html.replaceAll(commentRegex, '');

    const injection = '''
<style>
  @media print {
    * {
      -webkit-print-color-adjust: exact !important;
      print-color-adjust: exact !important;
    }
  }
  body {
    margin: 0 !important;
    padding: 0 !important;
  }
</style>
''';

    if (cleanedHtml.contains('</head>')) {
      return cleanedHtml.replaceFirst('</head>', '$injection</head>');
    } else if (cleanedHtml.contains('<body')) {
      return cleanedHtml.replaceFirst('<body', '<head>$injection</head><body');
    } else {
      return '<html><head>$injection</head><body>$cleanedHtml</body></html>';
    }
  }
}
