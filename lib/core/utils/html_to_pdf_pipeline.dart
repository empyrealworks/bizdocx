import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:htmltopdfwidgets/htmltopdfwidgets.dart';
import 'package:pdf/widgets.dart' as pw;

import '../../services/local_cache_service.dart';

/// Converts Gemini-generated HTML to a PDF File.
///
/// Uses [HTMLToPdf] from the printing / pdf packages.
///
/// ⚠️  KEY DECISIONS:
/// • `useNewEngine: false` — the new layout engine produces a single
///   unbounded-height container widget that pw.MultiPage cannot paginate
///   (throws "Widget height Infinity > page height"). The legacy engine
///   returns a flat list of bounded widgets that MultiPage handles correctly.
/// • Explicit [pw.MultiPage] margin — gives pw layout the correct available
///   height so no widget can accidentally report infinite height.
/// • Body CSS padding matches the MultiPage margin so content isn't doubled.
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
      // HTMLToPdf is imported via the printing package's HTMLtoPDFWidgets:
      //   import HTMLtoPDFWidgets
      // Legacy engine returns one pw.Widget per top-level block element,
      // each with a bounded height — exactly what pw.MultiPage needs.
      final widgets = await HTMLToPdf().convert(
        processedHtml,
        useNewEngine: false,
      );

      final pdf = pw.Document(compress: true);

      pdf.addPage(
        pw.MultiPage(
          pageFormat: format,
          // Explicit margins so pw can compute available height correctly.
          // The CSS body has no padding (we stripped it) to avoid doubling.
          margin: const pw.EdgeInsets.all(_marginPt),
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          // Generous upper bound; MultiPage will never actually need 200 pages
          // for a normal business document.
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
  /// Must be called after every refinement or version restore.
  Future<void> invalidate(String uid, String pid, String docId) async {
    final path = await _cache.pdfPath(uid, pid, docId);
    final file = File(path);
    if (file.existsSync()) {
      await file.delete();
      debugPrint('[Pipeline] PDF cache invalidated: $docId');
    }
  }

  /// Injects print-safe CSS.
  /// Note: NO body padding here — pw.MultiPage margin handles the whitespace.
  String _prepareHtml(String html) {
    // 1. Remove HTML comments to prevent 'Unknown node type' assertions
    // The regex matches <!-- followed by anything (including newlines) until -->
    final commentRegex = RegExp(r'<!--[\s\S]*?-->');
    String cleanedHtml = html.replaceAll(commentRegex, '');

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
  img { max-width: 100%; height: auto; display: block; }
  table { border-collapse: collapse; width: 100%; }
  .page-break { page-break-before: always; }
  div, section, article, main, header, footer {
    height: auto !important;
    max-height: none !important;
    overflow: visible !important;
  }
  [style*="display: grid"]  { display: block !important; }
  [style*="display:grid"]   { display: block !important; }
</style>
''';

    // 2. Inject CSS into the cleaned HTML
    if (cleanedHtml.contains('</head>')) {
      return cleanedHtml.replaceFirst('</head>', '$injection</head>');
    } else if (cleanedHtml.contains('<body')) {
      return cleanedHtml.replaceFirst('<body', '<head>$injection</head><body');
    } else {
      return '<html><head>$injection</head><body>$cleanedHtml</body></html>';
    }
  }
}