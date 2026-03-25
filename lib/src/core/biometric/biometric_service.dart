import 'package:flutter/foundation.dart';
import 'package:local_auth/local_auth.dart';

class BiometricService {
  BiometricService._();
  static final BiometricService instance = BiometricService._();

  final LocalAuthentication _auth = LocalAuthentication();

  /// 设备是否支持生物识别（硬件层面）
  Future<bool> isDeviceSupported() async {
    try {
      final supported = await _auth.isDeviceSupported();
      debugPrint('[Biometric] isDeviceSupported: $supported');
      return supported;
    } catch (e) {
      debugPrint('[Biometric] isDeviceSupported error: $e');
      return false;
    }
  }

  /// 设备是否已录入生物特征（Face ID 是否已在设备/模拟器中 enrolled）
  Future<bool> canCheckBiometrics() async {
    try {
      final canCheck = await _auth.canCheckBiometrics;
      debugPrint('[Biometric] canCheckBiometrics: $canCheck');
      return canCheck;
    } catch (e) {
      debugPrint('[Biometric] canCheckBiometrics error: $e');
      return false;
    }
  }

  /// 获取可用的生物识别类型列表
  Future<List<BiometricType>> getAvailableBiometrics() async {
    try {
      final types = await _auth.getAvailableBiometrics();
      debugPrint('[Biometric] availableBiometrics: $types');
      return types;
    } catch (e) {
      debugPrint('[Biometric] getAvailableBiometrics error: $e');
      return [];
    }
  }

  /// 综合判断：设备支持 AND 已录入生物特征，才算"可用"
  Future<bool> isAvailable() async {
    final supported = await isDeviceSupported();
    if (!supported) {
      debugPrint('[Biometric] isAvailable: false (device not supported)');
      return false;
    }
    final canCheck = await canCheckBiometrics();
    if (!canCheck) {
      debugPrint(
        '[Biometric] isAvailable: false — 设备支持生物识别但未录入。\n'
        '  iOS 模拟器请先执行：Features → Face ID → Enrolled，\n'
        '  然后重启 App 或重新检测。',
      );
      return false;
    }
    debugPrint('[Biometric] isAvailable: true');
    return true;
  }

  /// 执行生物识别认证
  Future<(bool success, String? errorMessage)> authenticate({
    String reason = '请验证身份以访问密码本',
  }) async {
    try {
      final result = await _auth.authenticate(
        localizedReason: reason,
        options: const AuthenticationOptions(
          biometricOnly: false,
          stickyAuth: true,
          sensitiveTransaction: true,
        ),
      );
      debugPrint('[Biometric] authenticate result: $result');
      return (result, null);
    } catch (e) {
      debugPrint('[Biometric] authenticate error: $e');
      return (false, e.toString());
    }
  }
}
