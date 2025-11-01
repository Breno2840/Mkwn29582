// lib/core/services/encryption_service.dart

import 'package:encrypt/encrypt.dart' as encrypt;

class EncryptionService {
  // ATENÇÃO: Chave e IV fixos são inseguros para produção.
  static final _key = encrypt.Key.fromUtf8('my32lengthsupersecretnooneknows!');
  static final _iv = encrypt.IV.fromLength(16);
  static final _encrypter = encrypt.Encrypter(encrypt.AES(_key, mode: encrypt.AESMode.cbc));

  static String encryptText(String plainText) {
    final encrypted = _encrypter.encrypt(plainText, iv: _iv);
    return encrypted.base64;
  }

  static String decryptText(String encryptedBase64) {
    try {
      final decrypted = _encrypter.decrypt(encrypt.Encrypted.fromBase64(encryptedBase64), iv: _iv);
      return decrypted;
    } catch (e) {
      return "Falha ao descriptografar.";
    }
  }
}
