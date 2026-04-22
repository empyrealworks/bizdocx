import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:htmltopdfwidgets/htmltopdfwidgets.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import '../../services/local_cache_service.dart';

/// Converts Gemini-generated HTML to a PDF File.
///
/// Uses [HTMLToPdf] from the printing package — the current supported
/// approach as of printing ^5.x. This avoids the deprecated
/// [Printing.convertHtml] that caused hangs on mobile.
///
/// Required in pubspec.yaml:
///   pdf: ^3.10.0
///   printing: ^5.12.0
///
/// Required in ios/Podfile:
///   target 'Runner' do
///     use_frameworks!   ← add this line
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

    // Return cached PDF if already rendered
    final cached = await _cache.getCachedPdf(uid, pid, docId);
    if (cached != null) {
      debugPrint('[Pipeline] PDF cache hit');
      return cached;
    }

    final processedHtml = _prepareHtml(html);

    try {
      // HTMLToPdf.convert() parses the HTML and returns a list of pw.Widget
      // objects that can be composed into a pw.Document. This runs entirely
      // in Dart — no WebView, no platform channel timeout risk.
      final widgets = await HTMLToPdf().convert(processedHtml);

      final pdf = pw.Document(
        compress: true,
        title: docId,
      );

      pdf.addPage(
        pw.MultiPage(
          pageFormat: format,
          margin: pw.EdgeInsets.zero, // We control margins in the HTML/CSS
          build: (context) => widgets,
        ),
      );

      final bytes = await pdf.save();
      final file = await _cache.cachePdfBytes(bytes, uid, pid, docId);

      // Cache HTML for offline re-render
      await _cache.cacheHtml(html, uid, pid, docId);

      debugPrint('[Pipeline] PDF saved (${bytes.length} bytes)');
      return file;
    } catch (e) {
      debugPrint('[Pipeline] Rendering error: $e');
      rethrow;
    }
  }

  /// Deletes the cached PDF for a document so it is re-rendered on next export.
  /// Call this after a refinement or restore.
  Future<void> invalidate(String uid, String pid, String docId) async {
    final path = await _cache.pdfPath(uid, pid, docId);
    final file = File(path);
    if (file.existsSync()) {
      await file.delete();
      debugPrint('[Pipeline] PDF cache invalidated: $docId');
    }
  }

  /// Injects print-safe CSS into the HTML before conversion.
  String _prepareHtml(String html) {
    const injection = '''
<style>
  * {
    -webkit-print-color-adjust: exact !important;
    print-color-adjust: exact !important;
    box-sizing: border-box;
  }
  html, body {
    margin: 0;
    padding: 40px;
    background: white !important;
    font-family: -apple-system, Helvetica, Arial, sans-serif;
    overflow: visible !important;
    height: auto !important;
  }
  img { max-width: 100%; height: auto; }
  .page-break { page-break-before: always; }
  * { visibility: visible !important; opacity: 1 !important; }
  /* Suppress grid layout which HTMLToPdf does not support */
  [style*="display: grid"] { display: block !important; }
  [style*="display:grid"] { display: block !important; }
</style>
''';

    if (html.contains('</head>')) {
      return html.replaceFirst('</head>', '$injection</head>');
    } else if (html.contains('<body')) {
      return html.replaceFirst('<body', '<head>$injection</head><body');
    } else {
      return '<html><head>$injection</head><body>$html</body></html>';
    }
  }
}