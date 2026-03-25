class AppConstants {
  static const String appName = 'SafeKey';
  static const String appVersion = '1.0.0';

  // 安全存储 key
  static const String kSalt = 'sk_salt';
  static const String kVerifier = 'sk_verifier';
  static const String kMasterKeyB64 = 'sk_master_key'; // 供生物识别解锁恢复 key
  static const String kBiometricEnabled = 'sk_biometric';
  static const String kAutoLockDuration = 'sk_auto_lock';
  static const String kClipboardClearDuration = 'sk_clipboard_clear';
  static const String kIsFirstLaunch = 'sk_first_launch';
  static const String kFailedAttempts = 'sk_failed_attempts';
  static const String kLockoutUntil = 'sk_lockout_until';

  // 安全设置
  static const int maxFailedAttempts = 5;
  static const int lockoutMinutes = 30;
  static const int defaultClipboardClearSeconds = 30;

  // 密码生成器默认值
  static const int defaultPasswordLength = 16;

  // 备份文件后缀
  static const String backupFileExtension = '.skbak';
  static const String backupFileName = 'safekey_backup';

  // 自动锁定选项（秒）
  static const List<int> autoLockOptions = [0, 60, 300, 900];

  // 剪贴板清除时间选项（秒）
  static const List<int> clipboardClearOptions = [15, 30, 60, 0];
}
