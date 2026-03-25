import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../shared/constants/app_theme.dart';
import '../../../shared/widgets/app_snackbar.dart';
import '../controller/auth_controller.dart';

/// Face ID 连续失败几次后自动切换到密码输入
const _kMaxBiometricFailures = 3;

class UnlockPage extends StatefulWidget {
  const UnlockPage({super.key});

  @override
  State<UnlockPage> createState() => _UnlockPageState();
}

class _UnlockPageState extends State<UnlockPage>
    with SingleTickerProviderStateMixin {
  final _controller = TextEditingController();
  bool _obscure = true;
  bool _loading = false;
  Timer? _lockoutTimer;

  // ── 生物识别流程状态 ─────────────────────────────────────────
  /// false = 显示 Face ID 界面；true = 显示密码表单
  bool _showPasswordForm = false;
  int _biometricFailedCount = 0;
  bool _biometricInProgress = false;

  // ── Face ID 图标脉冲动画 ──────────────────────────────────────
  late final AnimationController _pulseController;
  late final Animation<double> _pulseAnim;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    );
    _pulseAnim = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final auth = context.read<AuthController>();
      if (!auth.biometricEnabled || !auth.biometricAvailable) {
        // 未设置生物识别，直接显示密码输入框
        setState(() => _showPasswordForm = true);
      } else {
        // 有 Face ID，显示生物识别界面并立即触发
        _pulseController.repeat(reverse: true);
        _tryBiometric();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _pulseController.dispose();
    _lockoutTimer?.cancel();
    super.dispose();
  }

  // ── 生物识别 ──────────────────────────────────────────────────

  Future<void> _tryBiometric() async {
    if (_showPasswordForm || _biometricInProgress) return;
    final auth = context.read<AuthController>();
    if (!auth.biometricEnabled || !auth.biometricAvailable) {
      setState(() => _showPasswordForm = true);
      return;
    }
    if (auth.isLockedOut) return;

    setState(() => _biometricInProgress = true);
    final success = await auth.unlockWithBiometric();
    if (!mounted) return;
    setState(() => _biometricInProgress = false);

    if (!success) {
      _biometricFailedCount++;
      if (_biometricFailedCount >= _kMaxBiometricFailures) {
        _switchToPasswordForm(showHint: true);
      } else {
        setState(() {});
      }
    }
  }

  void _switchToPasswordForm({bool showHint = false}) {
    setState(() => _showPasswordForm = true);
    _pulseController.stop();
    if (showHint && mounted) {
      AppSnackbar.show(
        context,
        AppLocalizations.of(context).biometricFailedAutoSwitched,
      );
    }
  }

  void _switchToBiometricView() {
    setState(() {
      _showPasswordForm = false;
      _biometricFailedCount = 0;
    });
    _pulseController.repeat(reverse: true);
    _tryBiometric();
  }

  // ── 密码解锁 ──────────────────────────────────────────────────

  Future<void> _unlock() async {
    final pwd = _controller.text.trim();
    if (pwd.isEmpty) return;

    setState(() => _loading = true);
    final auth = context.read<AuthController>();
    final success = await auth.unlockWithPassword(pwd);

    if (!mounted) return;
    setState(() => _loading = false);

    if (!success) {
      _controller.clear();
      final l10n = AppLocalizations.of(context);
      if (auth.isLockedOut) {
        AppSnackbar.show(
          context,
          l10n.lockedOutMessage(
            auth.failedAttempts,
            auth.lockoutRemaining?.inMinutes ?? 30,
          ),
          isError: true,
        );
      } else {
        AppSnackbar.show(
          context,
          l10n.passwordWrongRemaining(5 - auth.failedAttempts),
          isError: true,
        );
      }
    }
  }

  String _formatDuration(Duration d) {
    final l10n = AppLocalizations.of(context);
    final m = d.inMinutes;
    final s = d.inSeconds % 60;
    if (m > 0) return l10n.durationMinSec(m, s);
    return l10n.durationSec(s);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Consumer<AuthController>(
          builder: (context, auth, _) {
            if (auth.isLockedOut) {
              return _LockedOutView(
                lockoutUntil: auth.lockoutUntil,
                formatDuration: _formatDuration,
              );
            }

            // 生物识别可用且未切换到密码表单 → 显示 Face ID 界面
            if (!_showPasswordForm &&
                auth.biometricEnabled &&
                auth.biometricAvailable) {
              return _BiometricUnlockView(
                failedCount: _biometricFailedCount,
                inProgress: _biometricInProgress,
                pulseAnim: _pulseAnim,
                onTap: _tryBiometric,
                onUsePassword: _switchToPasswordForm,
              );
            }

            // 密码表单
            return _UnlockForm(
              controller: _controller,
              obscure: _obscure,
              loading: _loading,
              biometricAvailable:
                  auth.biometricEnabled && auth.biometricAvailable,
              failedAttempts: auth.failedAttempts,
              onToggleObscure: () => setState(() => _obscure = !_obscure),
              onUnlock: _unlock,
              onSwitchToFaceId: _switchToBiometricView,
            );
          },
        ),
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════════
//  Face ID 解锁界面
// ══════════════════════════════════════════════════════════════════

class _BiometricUnlockView extends StatelessWidget {
  const _BiometricUnlockView({
    required this.failedCount,
    required this.inProgress,
    required this.pulseAnim,
    required this.onTap,
    required this.onUsePassword,
  });

  final int failedCount;
  final bool inProgress;
  final Animation<double> pulseAnim;
  final VoidCallback onTap;
  final VoidCallback onUsePassword;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Column(
      children: [
        Expanded(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // App 图标
                  Container(
                    width: 72,
                    height: 72,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: AppColors.primary.withValues(alpha: 0.25),
                      ),
                    ),
                    child: const Icon(
                      Icons.key_rounded,
                      color: AppColors.primary,
                      size: 36,
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'SafeKey',
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    l10n.appLockedHint,
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 56),

                  // Face ID 图标按钮（脉冲动画）
                  ScaleTransition(
                    scale: pulseAnim,
                    child: GestureDetector(
                      onTap: inProgress ? null : onTap,
                      child: inProgress
                          ? const SizedBox(
                              width: 72,
                              height: 72,
                              child: CircularProgressIndicator(
                                strokeWidth: 2.5,
                                color: AppColors.primary,
                              ),
                            )
                          : const Icon(
                              Icons.fingerprint,
                              color: AppColors.primary,
                              size: 72,
                            ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    inProgress ? l10n.verifying : l10n.tapToUnlockBiometric,
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        // 底部：切换到密码
        Padding(
          padding: const EdgeInsets.fromLTRB(32, 0, 32, 40),
          child: TextButton(
            onPressed: onUsePassword,
            style: TextButton.styleFrom(
              foregroundColor: AppColors.textSecondary,
            ),
            child: Text(
              l10n.usePasswordInstead,
              style: const TextStyle(fontSize: 15),
            ),
          ),
        ),
      ],
    );
  }
}

// ══════════════════════════════════════════════════════════════════
//  密码解锁表单
// ══════════════════════════════════════════════════════════════════

class _UnlockForm extends StatelessWidget {
  const _UnlockForm({
    required this.controller,
    required this.obscure,
    required this.loading,
    required this.biometricAvailable,
    required this.failedAttempts,
    required this.onToggleObscure,
    required this.onUnlock,
    required this.onSwitchToFaceId,
  });

  final TextEditingController controller;
  final bool obscure;
  final bool loading;
  final bool biometricAvailable;
  final int failedAttempts;
  final VoidCallback onToggleObscure;
  final VoidCallback onUnlock;
  final VoidCallback onSwitchToFaceId;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return SingleChildScrollView(
      padding: const EdgeInsets.all(32),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minHeight: MediaQuery.sizeOf(context).height -
              MediaQuery.paddingOf(context).vertical -
              64,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(),
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: AppColors.primary.withValues(alpha: 0.3),
                ),
              ),
              child: const Icon(
                Icons.key_rounded,
                color: AppColors.primary,
                size: 40,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'SafeKey',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 28,
                fontWeight: FontWeight.w700,
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              l10n.enterMasterPasswordToUnlock,
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 15,
              ),
            ),
            const SizedBox(height: 40),
            TextField(
              controller: controller,
              obscureText: obscure,
              autofocus: true,
              autocorrect: false,
              textCapitalization: TextCapitalization.none,
              textInputAction: TextInputAction.done,
              onSubmitted: (_) => onUnlock(),
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 16,
              ),
              decoration: InputDecoration(
                hintText: l10n.masterPassword,
                prefixIcon: const Icon(
                  Icons.lock_outline_rounded,
                  color: AppColors.textHint,
                  size: 20,
                ),
                suffixIcon: IconButton(
                  icon: Icon(
                    obscure
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                    color: AppColors.textHint,
                    size: 20,
                  ),
                  onPressed: onToggleObscure,
                ),
              ),
            ),
            if (failedAttempts > 0) ...[
              const SizedBox(height: 8),
              Text(
                l10n.failedAttemptsWarning(
                  failedAttempts,
                  5 - failedAttempts,
                ),
                style: const TextStyle(
                  color: AppColors.warning,
                  fontSize: 12,
                ),
                textAlign: TextAlign.center,
              ),
            ],
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: loading ? null : onUnlock,
              child: loading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : Text(l10n.unlock),
            ),

            // 有 Face ID 时显示切换按钮（从密码切回 Face ID 视图）
            if (biometricAvailable) ...[
              const SizedBox(height: 16),
              TextButton.icon(
                onPressed: onSwitchToFaceId,
                icon: const Icon(Icons.fingerprint, size: 20),
                label: Text(l10n.switchToFaceId),
              ),
            ],
            const SizedBox(),
          ],
        ),
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════════
//  锁定倒计时界面（不变）
// ══════════════════════════════════════════════════════════════════

class _LockedOutView extends StatefulWidget {
  const _LockedOutView({
    required this.lockoutUntil,
    required this.formatDuration,
  });

  final DateTime? lockoutUntil;
  final String Function(Duration) formatDuration;

  @override
  State<_LockedOutView> createState() => _LockedOutViewState();
}

class _LockedOutViewState extends State<_LockedOutView> {
  Timer? _timer;
  Duration? _remaining;

  @override
  void initState() {
    super.initState();
    _updateRemaining();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      _updateRemaining();
    });
  }

  void _updateRemaining() {
    if (widget.lockoutUntil == null) return;
    final r = widget.lockoutUntil!.difference(DateTime.now());
    setState(() => _remaining = r.isNegative ? Duration.zero : r);
    if (_remaining == Duration.zero) {
      _timer?.cancel();
      if (mounted) {
        context.read<AuthController>().initialize();
      }
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.lock_person_rounded,
              color: AppColors.error,
              size: 64,
            ),
            const SizedBox(height: 24),
            Text(
              l10n.accountLocked,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 22,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              l10n.accountLockedDesc,
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 15,
              ),
              textAlign: TextAlign.center,
            ),
            if (_remaining != null && _remaining! > Duration.zero) ...[
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: AppColors.error.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppColors.error.withValues(alpha: 0.3),
                  ),
                ),
                child: Text(
                  l10n.remainingTime(widget.formatDuration(_remaining!)),
                  style: const TextStyle(
                    color: AppColors.error,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    fontFeatures: [FontFeature.tabularFigures()],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
