import 'dart:convert';
// ignore: library_prefixes
import 'package:encrypt/encrypt.dart' as Encrypt;

class Encryption {
  static final key = Encrypt.Key.fromLength(32);
  static final iv = Encrypt.IV.fromLength(16);

  static String encrypt(String plaintext) {
    final encrypter = Encrypt.Encrypter(Encrypt.AES(key));
    final encrypted = encrypter.encrypt(plaintext, iv: iv);
    return base64.encode(encrypted.bytes);
  }

  static String decrypt(String ciphertext) {
    final encrypter = Encrypt.Encrypter(Encrypt.AES(key));
    final decrypted =
        encrypter.decrypt(Encrypt.Encrypted.fromBase64(ciphertext), iv: iv);
    return decrypted;
  }
}
