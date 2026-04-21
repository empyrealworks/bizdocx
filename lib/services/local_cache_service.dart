import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

/// Manages all local file caching for PDFs, PNGs, and HTML snapshots.
/// Structure: <appDocDir>/bizdocx/<uid>/<pid>/documents/<filename>
class LocalCacheService {
  LocalCacheService._();
  static final LocalCacheService instance = LocalCacheService._();

  static const _rootDir = 'bizdocx';

  Future<Directory> _ensureDir(String relativePath) async {
    final base = await getApplicationDocumentsDirectory();
    final dir = Directory(p.join(base.path, _rootDir, relativePath));
    if (!dir.existsSync()) await dir.create(recursive: true);
    return dir;
  }

  // ── PDF ────────────────────────────────────────────────────────────────────
  Future<String> pdfPath(String uid, String pid, String docId) async {
    final dir = await _ensureDir('$uid/$pid/documents');
    return p.join(dir.path, '$docId.pdf');
  }

  Future<File?> getCachedPdf(String uid, String pid, String docId) async {
    final path = await pdfPath(uid, pid, docId);
    final file = File(path);
    return file.existsSync() ? file : null;
  }

  Future<File> cachePdfBytes(
      Uint8List bytes, String uid, String pid, String docId) async {
    final path = await pdfPath(uid, pid, docId);
    final file = File(path);
    await file.writeAsBytes(bytes, flush: true);
    debugPrint('[Cache] PDF saved: $path');
    return file;
  }

  // ── PNG / Image ────────────────────────────────────────────────────────────
  Future<String> imagePath(String uid, String pid, String assetId) async {
    final dir = await _ensureDir('$uid/$pid/images');
    return p.join(dir.path, '$assetId.png');
  }

  Future<File?> getCachedImage(String uid, String pid, String assetId) async {
    final path = await imagePath(uid, pid, assetId);
    final file = File(path);
    return file.existsSync() ? file : null;
  }

  Future<File> cacheImageBytes(
      Uint8List bytes, String uid, String pid, String assetId) async {
    final path = await imagePath(uid, pid, assetId);
    final file = File(path);
    await file.writeAsBytes(bytes, flush: true);
    debugPrint('[Cache] Image saved: $path');
    return file;
  }

  // ── HTML Snapshot ──────────────────────────────────────────────────────────
  Future<String> htmlPath(String uid, String pid, String docId) async {
    final dir = await _ensureDir('$uid/$pid/html');
    return p.join(dir.path, '$docId.html');
  }

  Future<File> cacheHtml(
      String html, String uid, String pid, String docId) async {
    final path = await htmlPath(uid, pid, docId);
    final file = File(path);
    await file.writeAsString(html, flush: true);
    return file;
  }

  Future<String?> readCachedHtml(String uid, String pid, String docId) async {
    final path = await htmlPath(uid, pid, docId);
    final file = File(path);
    if (!file.existsSync()) return null;
    return file.readAsString();
  }

  // ── Utilities ──────────────────────────────────────────────────────────────
  Future<void> evictPortfolioCache(String uid, String pid) async {
    final base = await getApplicationDocumentsDirectory();
    final dir = Directory(p.join(base.path, _rootDir, uid, pid));
    if (dir.existsSync()) await dir.delete(recursive: true);
    debugPrint('[Cache] Evicted portfolio cache: $uid/$pid');
  }

  Future<int> getCacheSizeBytes(String uid) async {
    final base = await getApplicationDocumentsDirectory();
    final dir = Directory(p.join(base.path, _rootDir, uid));
    if (!dir.existsSync()) return 0;
    int size = 0;
    await for (final entity in dir.list(recursive: true)) {
      if (entity is File) size += await entity.length();
    }
    return size;
  }
}