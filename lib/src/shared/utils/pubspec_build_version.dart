import 'package:flutter/services.dart';

/// 从随应用打包的 [pubspec.yaml] 资源读取 `version:`（与顶层 pubspec 构建时一致，无原生插件）。
class PubspecBuildVersion {
  PubspecBuildVersion._();

  static const String assetPath = 'pubspec.yaml';

  static Future<({String version, String buildNumber})?> load() async {
    try {
      final raw = await rootBundle.loadString(assetPath);
      return parse(raw);
    } catch (_) {
      return null;
    }
  }

  static ({String version, String buildNumber})? parse(String raw) {
    for (final line in raw.split('\n')) {
      var t = line.trim();
      if (!t.startsWith('version:')) continue;
      var rest = t.substring('version:'.length).trim();
      final hash = rest.indexOf('#');
      if (hash >= 0) rest = rest.substring(0, hash).trim();
      final plus = rest.indexOf('+');
      if (plus >= 0) {
        return (
          version: rest.substring(0, plus).trim(),
          buildNumber: rest.substring(plus + 1).trim(),
        );
      }
      if (rest.isNotEmpty) {
        return (version: rest, buildNumber: '0');
      }
    }
    return null;
  }
}
