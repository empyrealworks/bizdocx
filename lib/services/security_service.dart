import 'dart:convert';
import 'dart:typed_data';
import 'package:encrypt/encrypt.dart' as enc;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecurityService {
  SecurityService._();
  static final SecurityService instance = SecurityService._();

  static const _storage = FlutterSecureStorage();
  static const _masterKeyAlias = 'bizdocx_master_key';
  
  enc.Key? _key;
  final _iv = enc.IV.fromLength(16);

  Future<void> init() async {
    String? base64Key = await _storage.read(key: _masterKeyAlias);
    if (base64Key == null) {
      final newKey = enc.Key.fromSecureRandom(32);
      base64Key = newKey.base64;
      await _storage.write(key: _masterKeyAlias, value: base64Key);
    }
    _key = enc.Key.fromBase64(base64Key);
  }

  Uint8List encryptBytes(Uint8List bytes) {
    if (_key == null) throw Exception('SecurityService not initialized');
    final encrypter = enc.Encrypter(enc.AES(_key!, mode: enc.AESMode.sic));
    return Uint8List.fromList(encrypter.encryptBytes(bytes, iv: _iv).bytes);
  }

  Uint8List decryptBytes(Uint8List bytes) {
    if (_key == null) throw Exception('SecurityService not initialized');
    final encrypter = enc.Encrypter(enc.AES(_key!, mode: enc.AESMode.sic));
    return Uint8List.fromList(encrypter.decryptBytes(enc.Encrypted(bytes), iv: _iv));
  }

  String encryptString(String text) {
    final bytes = utf8.encode(text);
    final encrypted = encryptBytes(Uint8List.fromList(bytes));
    return base64.encode(encrypted);
  }

  String decryptString(String encryptedBase64) {
    final bytes = base64.decode(encryptedBase64);
    final decrypted = decryptBytes(bytes);
    return utf8.decode(decrypted);
  }
}
