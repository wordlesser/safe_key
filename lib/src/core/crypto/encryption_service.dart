import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:encrypt/encrypt.dart' as enc;
import 'package:pointycastle/export.dart';

class EncryptionService {
  static const int _pbkdf2Iterations = 100000;
  static const int _keyLength = 32; // 256 bit
  static const int _saltLength = 16;
  static const int _ivLength = 12; // 96 bit for GCM
  static const String _verificationPlaintext = 'SafeKey-V1-OK';

  // ── 盐值 ───────────────────────────────────────────────────────

  static Uint8List generateSalt() {
    final rng = Random.secure();
    return Uint8List.fromList(
      List.generate(_saltLength, (_) => rng.nextInt(256)),
    );
  }

  // ── PBKDF2 密钥派生 ────────────────────────────────────────────

  static Uint8List deriveKey(String password, Uint8List salt) {
    final pbkdf2 = PBKDF2KeyDerivator(HMac(SHA256Digest(), 64));
    pbkdf2.init(Pbkdf2Parameters(salt, _pbkdf2Iterations, _keyLength));
    return pbkdf2.process(Uint8List.fromList(utf8.encode(password)));
  }

  // ── AES-256-GCM 加解密 ─────────────────────────────────────────

  /// 加密，返回 base64(IV[12] + Ciphertext+Tag)
  static String encryptData(String plaintext, Uint8List keyBytes) {
    final key = enc.Key(keyBytes);
    final iv = enc.IV.fromSecureRandom(_ivLength);
    final encrypter = enc.Encrypter(enc.AES(key, mode: enc.AESMode.gcm));
    final encrypted = encrypter.encrypt(plaintext, iv: iv);

    final combined = Uint8List(_ivLength + encrypted.bytes.length);
    combined.setRange(0, _ivLength, iv.bytes);
    combined.setRange(_ivLength, combined.length, encrypted.bytes);
    return base64Url.encode(combined);
  }

  /// 解密 base64(IV[12] + Ciphertext+Tag)
  static String decryptData(String ciphertext, Uint8List keyBytes) {
    final data = base64Url.decode(ciphertext);
    final iv = enc.IV(Uint8List.fromList(data.sublist(0, _ivLength)));
    final encryptedBytes = Uint8List.fromList(data.sublist(_ivLength));
    final key = enc.Key(keyBytes);
    final encrypter = enc.Encrypter(enc.AES(key, mode: enc.AESMode.gcm));
    return encrypter.decrypt(enc.Encrypted(encryptedBytes), iv: iv);
  }

  // ── 主密码验证令牌 ─────────────────────────────────────────────

  static String createVerificationToken(Uint8List keyBytes) {
    return encryptData(_verificationPlaintext, keyBytes);
  }

  /// 返回 (isValid, derivedKey)
  /// [precomputedKey] 可传入已在 isolate 中派生好的 key，避免在主线程二次计算
  static (bool, Uint8List?) verifyMasterPassword(
    String password,
    Uint8List salt,
    String verificationToken, {
    Uint8List? precomputedKey,
  }) {
    try {
      final keyBytes = precomputedKey ?? deriveKey(password, salt);
      final decrypted = decryptData(verificationToken, keyBytes);
      if (decrypted == _verificationPlaintext) {
        return (true, keyBytes);
      }
      return (false, null);
    } catch (_) {
      return (false, null);
    }
  }
}
