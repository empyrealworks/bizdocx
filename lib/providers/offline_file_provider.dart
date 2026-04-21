import 'dart:io';
import 'dart:typed_data';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/utils/html_to_pdf_pipeline.dart';
import '../models/document_asset.dart';
import '../services/local_cache_service.dart';
import 'auth_provider.dart';

/// Resolves whether a document has a local cache hit,
/// and downloads from Storage if not.
final offlineFileProvider =
FutureProvider.family.autoDispose<File?, DocumentAsset>((ref, asset) async {
  final user = ref.watch(currentUserProvider);
  if (user == null) return null;

  final cache = LocalCacheService.instance;
  final uid = user.uid;
  final pid = asset.portfolioId;

  if (asset.isStructural) {
    final cached = await cache.getCachedPdf(uid, pid, asset.id);
    if (cached != null) return cached;

    // If HTML is available, re-render to PDF offline
    if (asset.htmlContent != null) {
      // Re-derive from locally stored HTML if available
      final html = await cache.readCachedHtml(uid, pid, asset.id);
      if (html != null) {
        // Lazy re-conversion (no network needed)
        return HtmlToPdfPipeline.instance.convert(
          html: html,
          uid: uid,
          pid: pid,
          docId: asset.id,
        );
      }
    }
    return null;
  }

  if (asset.isGraphical) {
    final cached = await cache.getCachedImage(uid, pid, asset.id);
    if (cached != null) return cached;

    // Download from Storage if online
    if (asset.storageUrl != null) {
      // Using HttpClient for direct download — no dependency bloat
      final client = HttpClient();
      try {
        final request =
        await client.getUrl(Uri.parse(asset.storageUrl!));
        final response = await request.close();
        final bytes = await response
            .fold<List<int>>([], (a, b) => a..addAll(b));
        return cache.cacheImageBytes(
            Uint8List.fromList(bytes), uid, pid, asset.id);
      } finally {
        client.close();
      }
    }
  }
  return null;
});
