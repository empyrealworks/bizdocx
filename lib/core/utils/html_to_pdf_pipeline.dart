import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:htmltopdfwidgets/htmltopdfwidgets.dart';
import 'package:pdf/widgets.dart' as pw;

import '../../services/local_cache_service.dart';

/// Converts Gemini-generated HTML to a PDF File.
///
/// Uses [HTMLToPdf] from the printing / pdf packages.
class HtmlToPdfPipeline {
  HtmlToPdfPipeline._();
  static final HtmlToPdfPipeline instance = HtmlToPdfPipeline._();

  // Page margin in PDF points (1pt ≈ 0.353mm; 40pt ≈ 14mm)
  static const _marginPt = 40.0;

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
    if (cached != null) {
      debugPrint('[Pipeline] PDF cache hit');
      return cached;
    }

    final processedHtml = _prepareHtml(html);

    try {
      final widgets = await HTMLToPdf().convert(
        processedHtml,
        useNewEngine: false,
      );

      final pdf = pw.Document(compress: true);

      pdf.addPage(
        pw.MultiPage(
          pageFormat: format,
          margin: const pw.EdgeInsets.all(_marginPt),
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          maxPages: 200,
          build: (context) => widgets,
        ),
      );

      final bytes = await pdf.save();
      final file = await _cache.cachePdfBytes(bytes, uid, pid, docId);
      await _cache.cacheHtml(html, uid, pid, docId);

      debugPrint('[Pipeline] PDF saved — ${bytes.length} bytes');
      return file;
    } catch (e) {
      debugPrint('[Pipeline] Rendering error: $e');
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

  /// Injects print-safe CSS and strips fixed-width containers to allow
  /// the content to flow naturally into the PDF page width.
  String _prepareHtml(String html) {
    // 1. Remove HTML comments
    final commentRegex = RegExp(r'<!--[\s\S]*?-->');
    String cleanedHtml = html.replaceAll(commentRegex, '');

    // 2. Remove fixed-width "page-container" class styles for PDF export
    // This allows the MultiPage layout to use the full available width of the PDF points.
    cleanedHtml = cleanedHtml.replaceAll(
        RegExp(r'class="page-container"', caseSensitive: false),
        'class="pdf-flow-container"');

    const injection = '''
<style>
  * {
    -webkit-print-color-adjust: exact !important;
    print-color-adjust: exact !important;
    box-sizing: border-box;
  }
  html, body {
    margin: 0;
    padding: 0;
    background: white !important;
    font-family: Helvetica, Arial, sans-serif;
    overflow: visible !important;
    height: auto !important;
    max-height: none !important;
  }
  /* Strip fixed width from the wrapper for PDF generation */
  .page-container, .pdf-flow-container {
    width: 100% !important;
    max-width: none !important;
    padding: 0 !important;
    margin: 0 !important;
    height: auto !important;
  }
  img { max-width: 100%; height: auto; display: block; }
  table { border-collapse: collapse; width: 100%; }
  .page-break { page-break-before: always; }
  div, section, article, main, header, footer {
    height: auto !important;
    max-height: none !important;
    overflow: visible !important;
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
