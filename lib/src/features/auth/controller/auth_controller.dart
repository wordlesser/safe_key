import 'dart:async';
import 'dart:convert';
import 'dart:isolate';

import 'package:flutter/foundation.dart';

import '../../../core/biometric/biometric_service.dart';
import '../../../core/crypto/encryption_service.dart';
import '../../../core/storage/database_service.dart';
import '../../../core/storage/secure_storage_service.dart';
import '../../../shared/constants/app_constants.dart';
import '../../../shared/constants/app_debug_flags.dart';

enum AuthState {
  initializing,
  firstRun,   // 欢迎引导页
  settingUp,  // 设置主密码页
  locked,
  unlocked,
  lockedOut,
}

class AuthController extends ChangeNotifier {
  AuthState _state = AuthState.initializing;
  Uint8List? _masterKey;
  int _failedAttempts = 0;
  DateTime? _lockoutUntil;
  bool _biometricEnabled = false;
  bool _biometricAvailable = false;
  int _autoLockSeconds = 0;
  Timer? _autoLockTimer;
  DateTime? _backgroundedAt;
  // 正在执行生物识别认证时为 true，防止系统弹窗触发误锁
  bool _isAuthenticating = false;
  // 最近一次解锁时间，2 秒内不允许自动锁定（防止 resumed 事件与 unlock 竞态）
  DateTime? _lastUnlockTime;
  /// 截引导页素材：临时把界面切成 [AuthState.firstRun]，点在引导页「开始使用」时恢复
  bool _onboardingScreenshotOverride = false;
  AuthState? _stateBeforeOnboardingOverride;

  // ── Getters ────────────────────────────────────────────────────

  AuthState get state => _state;
  Uint8List? get masterKey => _masterKey;
  bool get isUnlocked => _state == AuthState.unlocked;
  bool get isFirstRun => _state == AuthState.firstRun;
  bool get isSettingUp => _state == AuthState.settingUp;
  bool get isLocked => _state == AuthState.locked;
  bool get isLockedOut => _state == AuthState.lockedOut;
  int get failedAttempts => _failedAttempts;
  DateTime? get lockoutUntil => _lockoutUntil;
  bool get biometricEnabled => _biometricEnabled;
  bool get biometricAvailable => _biometricAvailable;
  int get autoLockSeconds => _autoLockSeconds;

  Duration? get lockoutRemaining {
    if (_lockoutUntil == null) return null;
    final remaining = _lockoutUntil!.difference(DateTime.now());
    return remaining.isNegative ? null : remaining;
  }

  // ── 初始化 ─────────────────────────────────────────────────────

  Future<void> initialize() async {
    debugPrint('[Auth] initialize start');
    _biometricAvailable = await BiometricService.instance.isAvailable();
    debugPrint('[Auth] biometricAvailable=$_biometricAvailable');

    final storage = SecureStorageService.instance;
    final salt = await storage.read(AppConstants.kSalt);

    // 卸载重装后：Keychain 残留但数据库文件已消失，自动清理并回到首次启动状态
    if (salt != null && !await DatabaseService.instance.databaseFileExists()) {
      debugPrint('[Auth] database missing but Keychain exists → clean up and firstRun');
      await storage.deleteAll();
      _state = AuthState.firstRun;
      notifyListeners();
      return;
    }

    if (salt == null) {
      _state = AuthState.firstRun;
    } else {
      _state = AuthState.locked;
      // 读取失败次数和锁定时间
      final attempts = await storage.read(AppConstants.kFailedAttempts);
      _failedAttempts = int.tryParse(attempts ?? '0') ?? 0;

      final lockoutStr = await storage.read(AppConstants.kLockoutUntil);
      if (lockoutStr != null) {
        final lockoutMs = int.tryParse(lockoutStr);
        if (lockoutMs != null) {
          _lockoutUntil = DateTime.fromMillisecondsSinceEpoch(lockoutMs);
          if (_lockoutUntil!.isAfter(DateTime.now())) {
            _state = AuthState.lockedOut;
          } else {
            // 锁定时间已过，重置
            _lockoutUntil = null;
            _failedAttempts = 0;
            await _saveFailedAttempts();
          }
        }
      }
    }

    // 读取设置
    final bioStr = await storage.read(AppConstants.kBiometricEnabled);
    _biometricEnabled = bioStr == 'true';

    final lockStr = await storage.read(AppConstants.kAutoLockDuration);
    _autoLockSeconds = int.tryParse(lockStr ?? '0') ?? 0;

    notifyListeners();
    _applyOnboardingScreenshotIfNeeded();
  }

  /// 已存在保险库时，为截 [WelcomePage] 强制显示引导；真・首次安装仍为 firstRun 时不重复处理。
  void _applyOnboardingScreenshotIfNeeded() {
    if (!kAlwaysShowOnboardingOnLaunch) return;
    if (_state == AuthState.firstRun || _state == AuthState.settingUp) {
      return;
    }
    _onboardingScreenshotOverride = true;
    _stateBeforeOnboardingOverride = _state;
    _state = AuthState.firstRun;
    notifyListeners();
  }

  void _exitOnboardingScreenshotPreview() {
    if (!_onboardingScreenshotOverride) return;
    _onboardingScreenshotOverride = false;
    final previous = _stateBeforeOnboardingOverride;
    _stateBeforeOnboardingOverride = null;
    if (previous != null) {
      _state = previous;
    }
    notifyListeners();
  }

  // ── 欢迎页 → 设置密码页（不走 Navigator）──────────────────────

  void proceedToSetup() {
    if (_onboardingScreenshotOverride) {
      _exitOnboardingScreenshotPreview();
      return;
    }
    _state = AuthState.settingUp;
    notifyListeners();
  }

  void backToWelcome() {
    if (_onboardingScreenshotOverride) {
      _exitOnboardingScreenshotPreview();
      return;
    }
    _state = AuthState.firstRun;
    notifyListeners();
  }

  // ── 设置主密码（首次使用）──────────────────────────────────────

  Future<void> setupMasterPassword(String password) async {
    final storage = SecureStorageService.instance;
    final salt = EncryptionService.generateSalt();
    // PBKDF2 是 CPU 密集型操作，放到后台 isolate 避免阻塞主线程
    final keyBytes = await Isolate.run(
      () => EncryptionService.deriveKey(password, salt),
    );
    final verifier = EncryptionService.createVerificationToken(keyBytes);

    await storage.write(
      AppConstants.kSalt,
      String.fromCharCodes(salt),
    );
    await storage.write(AppConstants.kVerifier, verifier);
    await storage.write(AppConstants.kIsFirstLaunch, 'false');

    _masterKey = keyBytes;
    _failedAttempts = 0;
    _state = AuthState.unlocked;
    // 将 masterKey 存入安全存储，供后续生物识别解锁恢复
    await _saveMasterKeyForBiometric(keyBytes);
    notifyListeners();
  }

  // ── 密码解锁 ───────────────────────────────────────────────────

  Future<bool> unlockWithPassword(String password) async {
    if (_state == AuthState.lockedOut) {
      final remaining = lockoutRemaining;
      if (remaining != null && remaining.inSeconds > 0) return false;
      // 锁定已到期，重置
      _state = AuthState.locked;
      _lockoutUntil = null;
      _failedAttempts = 0;
      await _saveFailedAttempts();
    }

    final storage = SecureStorageService.instance;
    final saltStr = await storage.read(AppConstants.kSalt);
    final verifier = await storage.read(AppConstants.kVerifier);
    if (saltStr == null || verifier == null) return false;

    final salt = Uint8List.fromList(saltStr.codeUnits);
    // PBKDF2 放到后台 isolate
    final derivedKey = await Isolate.run(
      () => EncryptionService.deriveKey(password, salt),
    );
    final (isValid, keyBytes) = EncryptionService.verifyMasterPassword(
      password,
      salt,
      verifier,
      precomputedKey: derivedKey,
    );

    if (isValid && keyBytes != null) {
      _masterKey = keyBytes;
      _failedAttempts = 0;
      _state = AuthState.unlocked;
      _lastUnlockTime = DateTime.now();
      await _saveFailedAttempts();
      // 密码解锁成功后同步 masterKey 到安全存储，供生物识别解锁使用
      await _saveMasterKeyForBiometric(keyBytes);
      _startAutoLockTimer();
      notifyListeners();
      return true;
    } else {
      _failedAttempts++;
      if (_failedAttempts >= AppConstants.maxFailedAttempts) {
        _lockoutUntil = DateTime.now().add(
          Duration(minutes: AppConstants.lockoutMinutes),
        );
        _state = AuthState.lockedOut;
        await SecureStorageService.instance.write(
          AppConstants.kLockoutUntil,
          _lockoutUntil!.millisecondsSinceEpoch.toString(),
        );
      }
      await _saveFailedAttempts();
      notifyListeners();
      return false;
    }
  }

  // ── 生物识别解锁 ───────────────────────────────────────────────

  Future<bool> unlockWithBiometric() async {
    debugPrint('[Auth] unlockWithBiometric: enabled=$_biometricEnabled available=$_biometricAvailable state=$_state');
    if (!_biometricEnabled || !_biometricAvailable) return false;
    if (_state == AuthState.lockedOut) return false;

    _isAuthenticating = true;
    try {
      final (authenticated, errMsg) = await BiometricService.instance.authenticate();
      debugPrint('[Auth] authenticate result=$authenticated err=$errMsg');
      if (!authenticated) return false;

      // 从安全存储恢复 masterKey（密码解锁/设置密码时已存入）
      final keyB64 = await SecureStorageService.instance.read(AppConstants.kMasterKeyB64);
      if (keyB64 == null) {
        debugPrint('[Auth] unlockWithBiometric: masterKey not found in storage, cannot unlock');
        return false;
      }
      _masterKey = Uint8List.fromList(base64.decode(keyB64));
      _state = AuthState.unlocked;
      _lastUnlockTime = DateTime.now();
      _startAutoLockTimer();
      notifyListeners();
      debugPrint('[Auth] unlockWithBiometric: success, masterKey restored');
      return true;
    } finally {
      _isAuthenticating = false;
    }
  }

  // ── 锁定 ───────────────────────────────────────────────────────

  void lock() {
    debugPrint('[Auth] lock() called, state=$_state');
    _masterKey = null;
    _state = AuthState.locked;
    _backgroundedAt = null; // 锁定时清除，防止下次 onAppResumed 看到过期数据
    _autoLockTimer?.cancel();
    notifyListeners();
  }

  // ── 后台/前台生命周期 ──────────────────────────────────────────

  void onAppBackgrounded() {
    if (_isAuthenticating) {
      // 生物识别系统弹窗导致的后台状态，不计入锁定计时
      debugPrint('[Auth] onAppBackgrounded ignored (isAuthenticating)');
      return;
    }
    debugPrint('[Auth] onAppBackgrounded, state=$_state');
    _backgroundedAt = DateTime.now();
    _autoLockTimer?.cancel();
  }

  void onAppResumed() {
    debugPrint(
      '[Auth] onAppResumed: state=$_state isAuthenticating=$_isAuthenticating '
      'backgroundedAt=$_backgroundedAt lastUnlockTime=$_lastUnlockTime',
    );

    // 生物识别认证期间，系统弹窗会触发 resumed，直接忽略锁定逻辑
    if (_isAuthenticating) {
      _backgroundedAt = null;
      debugPrint('[Auth] onAppResumed: skipped (isAuthenticating)');
      return;
    }

    // 2 秒保护窗口：刚解锁成功，不允许立即被 resumed 事件重新锁定
    // 真机上 native authenticate() 回调可能比 resumed 生命周期事件先到达 Dart
    if (_lastUnlockTime != null &&
        DateTime.now().difference(_lastUnlockTime!).inMilliseconds < 2000) {
      _backgroundedAt = null;
      debugPrint('[Auth] onAppResumed: skipped (just unlocked within 2s)');
      return;
    }

    if (_backgroundedAt != null && _state == AuthState.unlocked) {
      if (_autoLockSeconds == 0) {
        // 立即锁定
        debugPrint('[Auth] onAppResumed: locking (immediate, elapsed=${DateTime.now().difference(_backgroundedAt!).inMilliseconds}ms)');
        lock();
        return;
      }
      final elapsed = DateTime.now().difference(_backgroundedAt!).inSeconds;
      debugPrint('[Auth] onAppResumed: elapsed=${elapsed}s, limit=${_autoLockSeconds}s');
      if (elapsed >= _autoLockSeconds) {
        lock();
        return;
      }
    }
    _backgroundedAt = null;
    if (_state == AuthState.unlocked) _startAutoLockTimer();
  }

  // ── 修改主密码 ─────────────────────────────────────────────────

  Future<bool> changeMasterPassword(
    String oldPassword,
    String newPassword,
    Future<void> Function(Uint8List oldKey, Uint8List newKey) reEncryptCallback,
  ) async {
    final storage = SecureStorageService.instance;
    final saltStr = await storage.read(AppConstants.kSalt);
    final verifier = await storage.read(AppConstants.kVerifier);
    if (saltStr == null || verifier == null) return false;

    final salt = Uint8List.fromList(saltStr.codeUnits);
    final (isValid, oldKeyBytes) = EncryptionService.verifyMasterPassword(
      oldPassword,
      salt,
      verifier,
    );
    if (!isValid || oldKeyBytes == null) return false;

    final newSalt = EncryptionService.generateSalt();
    final newKey = await Isolate.run(
      () => EncryptionService.deriveKey(newPassword, newSalt),
    );
    final newVerifier = EncryptionService.createVerificationToken(newKey);

    // 重加密所有数据库中的密码
    await reEncryptCallback(oldKeyBytes, newKey);

    await storage.write(AppConstants.kSalt, String.fromCharCodes(newSalt));
    await storage.write(AppConstants.kVerifier, newVerifier);

    _masterKey = newKey;
    await _saveMasterKeyForBiometric(newKey);
    notifyListeners();
    return true;
  }

  // ── 生物识别开关 ───────────────────────────────────────────────

  /// 返回值：null = 成功；String = 失败原因
  Future<String?> setBiometricEnabled(bool enabled) async {
    debugPrint('[Auth] setBiometricEnabled: $enabled');

    if (enabled) {
      // 开启前先做一次认证，验证设备能正常使用生物识别
      if (!_biometricAvailable) {
        const msg = '当前设备不支持或未录入生物特征\n'
            '（模拟器请先执行 Features → Face ID → Enrolled）';
        debugPrint('[Auth] setBiometricEnabled: $msg');
        return msg;
      }

      _isAuthenticating = true;
      late final bool ok;
      late final String? errMsg;
      try {
        (ok, errMsg) = await BiometricService.instance.authenticate(
          reason: '请验证以开启生物识别解锁',
        );
      } finally {
        _isAuthenticating = false;
      }
      debugPrint('[Auth] setBiometricEnabled auth result: ok=$ok err=$errMsg');

      if (!ok) {
        return errMsg ?? '生物识别验证失败，未开启';
      }

      // 确保 masterKey 已存入安全存储（此时 app 应处于 unlocked 状态）
      if (_masterKey != null) {
        await _saveMasterKeyForBiometric(_masterKey!);
      }
    }

    _biometricEnabled = enabled;
    await SecureStorageService.instance.write(
      AppConstants.kBiometricEnabled,
      enabled.toString(),
    );
    notifyListeners();
    debugPrint('[Auth] setBiometricEnabled: saved, biometricEnabled=$_biometricEnabled');
    return null;
  }

  // ── 自动锁定设置 ───────────────────────────────────────────────

  Future<void> setAutoLockSeconds(int seconds) async {
    _autoLockSeconds = seconds;
    await SecureStorageService.instance.write(
      AppConstants.kAutoLockDuration,
      seconds.toString(),
    );
    notifyListeners();
  }

  // ── 私有方法 ───────────────────────────────────────────────────

  Future<void> _saveMasterKeyForBiometric(Uint8List keyBytes) async {
    final b64 = base64.encode(keyBytes);
    await SecureStorageService.instance.write(AppConstants.kMasterKeyB64, b64);
    debugPrint('[Auth] masterKey saved to secure storage for biometric unlock');
  }

  void _startAutoLockTimer() {
    _autoLockTimer?.cancel();
    if (_autoLockSeconds <= 0) return;
    _autoLockTimer = Timer(Duration(seconds: _autoLockSeconds), lock);
  }

  Future<void> _saveFailedAttempts() async {
    await SecureStorageService.instance.write(
      AppConstants.kFailedAttempts,
      _failedAttempts.toString(),
    );
  }

  @override
  void dispose() {
    _autoLockTimer?.cancel();
    super.dispose();
  }
}
