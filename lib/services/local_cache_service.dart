import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'security_service.dart';

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
    if (!file.existsSync()) return null;

    try {
      final encryptedBytes = await file.readAsBytes();
      final decryptedBytes = SecurityService.instance.decryptBytes(encryptedBytes);
      // We return a temporary file or handle decryption on the fly elsewhere?
      // Actually, if we want to return a File object that other things (like PDF viewer) can use,
      // it might need to be a decrypted temp file.
      // But the requirement is data encryption.
      // For now, let's return the file, but provide a way to read decrypted bytes.
      // Wait, if I return the File, the PDF viewer will fail because it's encrypted.
      // Better to return the decrypted bytes or a decrypted temp file.
      
      // Let's create a temp decrypted file for viewing.
      final tempDir = await getTemporaryDirectory();
      final tempFile = File(p.join(tempDir.path, 'decrypted_$docId.pdf'));
      await tempFile.writeAsBytes(decryptedBytes, flush: true);
      return tempFile;
    } catch (e) {
      debugPrint('[Cache] PDF decryption failed: $e');
      return null;
    }
  }

  Future<File> cachePdfBytes(
      Uint8List bytes, String uid, String pid, String docId) async {
    final path = await pdfPath(uid, pid, docId);
    final file = File(path);
    final encryptedBytes = SecurityService.instance.encryptBytes(bytes);
    await file.writeAsBytes(encryptedBytes, flush: true);
    debugPrint('[Cache] PDF saved (encrypted): $path');
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
    if (!file.existsSync()) return null;

    try {
      final encryptedBytes = await file.readAsBytes();
      final decryptedBytes = SecurityService.instance.decryptBytes(encryptedBytes);
      final tempDir = await getTemporaryDirectory();
      final tempFile = File(p.join(tempDir.path, 'decrypted_$assetId.png'));
      await tempFile.writeAsBytes(decryptedBytes, flush: true);
      return tempFile;
    } catch (e) {
      debugPrint('[Cache] Image decryption failed: $e');
      return null;
    }
  }

  Future<File> cacheImageBytes(
      Uint8List bytes, String uid, String pid, String assetId) async {
    final path = await imagePath(uid, pid, assetId);
    final file = File(path);
    final encryptedBytes = SecurityService.instance.encryptBytes(bytes);
    await file.writeAsBytes(encryptedBytes, flush: true);
    debugPrint('[Cache] Image saved (encrypted): $path');
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
    final encrypted = SecurityService.instance.encryptString(html);
    await file.writeAsString(encrypted, flush: true);
    return file;
  }

  Future<String?> readCachedHtml(String uid, String pid, String docId) async {
    final path = await htmlPath(uid, pid, docId);
    final file = File(path);
    if (!file.existsSync()) return null;
    try {
      final encrypted = await file.readAsString();
      return SecurityService.instance.decryptString(encrypted);
    } catch (e) {
      debugPrint('[Cache] HTML decryption failed: $e');
      return null;
    }
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