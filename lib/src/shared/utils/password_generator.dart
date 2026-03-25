import 'dart:math';

import '../../../l10n/app_localizations.dart';

class PasswordGenerator {
  static const String _lowercase = 'abcdefghijklmnopqrstuvwxyz';
  static const String _uppercase = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
  static const String _digits = '0123456789';
  static const String _symbols = '!@#\$%^&*()_+-=[]{}|;:,.<>?';

  static String generate({
    required int length,
    required bool includeLowercase,
    required bool includeUppercase,
    required bool includeDigits,
    required bool includeSymbols,
  }) {
    final buffer = StringBuffer();

    if (!includeLowercase && !includeUppercase && !includeDigits && !includeSymbols) {
      return generate(
        length: length,
        includeLowercase: true,
        includeUppercase: true,
        includeDigits: true,
        includeSymbols: false,
      );
    }

    // 必选字符池
    final required = <String>[];
    if (includeLowercase) required.add(_lowercase);
    if (includeUppercase) required.add(_uppercase);
    if (includeDigits) required.add(_digits);
    if (includeSymbols) required.add(_symbols);

    // 合并字符池
    final pool = required.join();
    final random = Random.secure();

    // 确保每个启用的字符集至少包含一个字符
    for (final charset in required) {
      buffer.write(charset[random.nextInt(charset.length)]);
    }

    // 用随机字符填满剩余长度
    final remaining = length - required.length;
    for (int i = 0; i < remaining; i++) {
      buffer.write(pool[random.nextInt(pool.length)]);
    }

    // 打乱字符顺序
    final chars = buffer.toString().split('');
    chars.shuffle(random);
    return chars.join();
  }

  /// 评估密码强度，返回 0.0 - 1.0
  static double evaluateStrength(String password) {
    if (password.isEmpty) return 0.0;

    double score = 0.0;
    final len = password.length;

    // 长度得分
    if (len >= 8) score += 0.2;
    if (len >= 12) score += 0.1;
    if (len >= 16) score += 0.1;

    // 字符种类得分
    final hasLower = password.contains(RegExp(r'[a-z]'));
    final hasUpper = password.contains(RegExp(r'[A-Z]'));
    final hasDigit = password.contains(RegExp(r'[0-9]'));
    final hasSymbol = password.contains(RegExp(r'[^a-zA-Z0-9]'));

    if (hasLower) score += 0.15;
    if (hasUpper) score += 0.15;
    if (hasDigit) score += 0.15;
    if (hasSymbol) score += 0.15;

    return score.clamp(0.0, 1.0);
  }

  static String strengthLabel(double strength, AppLocalizations l10n) {
    if (strength < 0.3) return l10n.strengthWeak;
    if (strength < 0.6) return l10n.strengthMedium;
    if (strength < 0.8) return l10n.strengthStrong;
    return l10n.strengthVeryStrong;
  }
}
