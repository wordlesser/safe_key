import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../shared/constants/app_constants.dart';
import '../../../shared/constants/app_theme.dart';
import '../../../shared/utils/pubspec_build_version.dart';
import '../../../shared/controllers/locale_controller.dart';
import '../../../shared/widgets/app_snackbar.dart';
import '../../auth/controller/auth_controller.dart';
import '../../generator/pages/generator_page.dart';
import '../../passwords/controller/passwords_controller.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.settings)),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _SectionHeader(title: l10n.sectionSecurity),
              const _SecuritySection(),
              const SizedBox(height: 8),
              _SectionHeader(title: l10n.sectionPreferences),
              const _PreferenceSection(),
              const SizedBox(height: 8),
              _SectionHeader(title: l10n.sectionDataManagement),
              const _DataSection(),
              const SizedBox(height: 8),
              _SectionHeader(title: l10n.sectionTools),
              const _ToolsSection(),
              const SizedBox(height: 8),
              _SectionHeader(title: l10n.sectionAbout),
              const _AboutSection(),
              if (kDebugMode) ...[
                const SizedBox(height: 8),
                const _SectionHeader(title: 'DEV'),
                const _DevSection(),
              ],
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}

// ── 分区标题 ────────────────────────────────────────────────────────

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
      child: Text(
        title,
        style: const TextStyle(
          color: AppColors.primary,
          fontSize: 13,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}

// ── 安全 ────────────────────────────────────────────────────────────

class _SecuritySection extends StatelessWidget {
  const _SecuritySection();

  String _autoLockLabel(AppLocalizations l10n, int seconds) {
    switch (seconds) {
      case 0:
        return l10n.autoLockImmediate;
      case 60:
        return l10n.autoLock1Min;
      case 300:
        return l10n.autoLock5Min;
      case 900:
        return l10n.autoLock15Min;
      default:
        return l10n.autoLockSeconds(seconds);
    }
  }

  void _showAutoLockPicker(BuildContext context, AuthController auth) {
    final l10n = AppLocalizations.of(context);
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surfaceVariant,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Text(
                l10n.autoLockTimePicker,
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            ...AppConstants.autoLockOptions.map((secs) {
              final label = _autoLockLabel(l10n, secs);
              return ListTile(
                title: Text(
                  label,
                  style: const TextStyle(color: AppColors.textPrimary),
                ),
                trailing: auth.autoLockSeconds == secs
                    ? const Icon(Icons.check_rounded, color: AppColors.primary)
                    : null,
                onTap: () {
                  auth.setAutoLockSeconds(secs);
                  Navigator.pop(ctx);
                },
              );
            }),
          ],
        ),
      ),
    );
  }

  void _showChangeMasterPassword(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final currentCtrl = TextEditingController();
    final newCtrl = TextEditingController();
    final confirmCtrl = TextEditingController();
    bool obs1 = true, obs2 = true, obs3 = true;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setS) => AlertDialog(
          backgroundColor: AppColors.surface,
          title: Text(
            l10n.changeMasterPassword,
            style: const TextStyle(color: AppColors.textPrimary),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: currentCtrl,
                  obscureText: obs1,
                  autocorrect: false,
                  textCapitalization: TextCapitalization.none,
                  style: const TextStyle(color: AppColors.textPrimary),
                  decoration: InputDecoration(
                    hintText: l10n.currentMasterPasswordHint,
                    suffixIcon: IconButton(
                      icon: Icon(
                        obs1
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                        color: AppColors.textHint,
                        size: 20,
                      ),
                      onPressed: () => setS(() => obs1 = !obs1),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: newCtrl,
                  obscureText: obs2,
                  autocorrect: false,
                  textCapitalization: TextCapitalization.none,
                  style: const TextStyle(color: AppColors.textPrimary),
                  decoration: InputDecoration(
                    hintText: l10n.newMasterPasswordHint,
                    suffixIcon: IconButton(
                      icon: Icon(
                        obs2
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                        color: AppColors.textHint,
                        size: 20,
                      ),
                      onPressed: () => setS(() => obs2 = !obs2),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: confirmCtrl,
                  obscureText: obs3,
                  autocorrect: false,
                  textCapitalization: TextCapitalization.none,
                  style: const TextStyle(color: AppColors.textPrimary),
                  decoration: InputDecoration(
                    hintText: l10n.confirmNewMasterPasswordHint,
                    suffixIcon: IconButton(
                      icon: Icon(
                        obs3
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                        color: AppColors.textHint,
                        size: 20,
                      ),
                      onPressed: () => setS(() => obs3 = !obs3),
                    ),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text(l10n.cancel),
            ),
            TextButton(
              onPressed: () async {
                final current = currentCtrl.text.trim();
                final newPwd = newCtrl.text.trim();
                final confirm = confirmCtrl.text.trim();

                if (current.isEmpty) {
                  AppSnackbar.show(
                    ctx,
                    l10n.enterCurrentMasterPasswordError,
                    isError: true,
                  );
                  return;
                }
                if (newPwd.length < 6) {
                  AppSnackbar.show(
                    ctx,
                    l10n.atLeast6CharsError,
                    isError: true,
                  );
                  return;
                }
                if (newPwd != confirm) {
                  AppSnackbar.show(
                    ctx,
                    l10n.passwordsNotMatchError,
                    isError: true,
                  );
                  return;
                }

                Navigator.pop(ctx);

                if (!context.mounted) return;
                final auth = context.read<AuthController>();
                final pwd = context.read<PasswordsController>();
                final ok = await auth.changeMasterPassword(
                  current,
                  newPwd,
                  (oldKey, newKey) => pwd.reEncryptAll(oldKey, newKey),
                );

                if (context.mounted) {
                  AppSnackbar.show(
                    context,
                    ok ? l10n.masterPasswordUpdated : l10n.wrongCurrentPassword,
                    isSuccess: ok,
                    isError: !ok,
                  );
                }
              },
              child: Text(
                l10n.save,
                style: const TextStyle(color: AppColors.primary),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Consumer<AuthController>(
      builder: (context, auth, _) {
        return _SettingsCard(
          children: [
            _SettingsTile(
              icon: Icons.fingerprint_rounded,
              iconColor: AppColors.secondary,
              title: 'Face ID / Touch ID',
              subtitle: auth.biometricAvailable
                  ? (auth.biometricEnabled
                      ? l10n.biometricSubtitleEnabled
                      : l10n.biometricSubtitleDisabled)
                  : l10n.biometricSubtitleDisabled,
              trailing: auth.biometricAvailable
                  ? Switch(
                      value: auth.biometricEnabled,
                      onChanged: (v) async {
                        final errMsg = await auth.setBiometricEnabled(v);
                        if (errMsg != null && context.mounted) {
                          AppSnackbar.show(context, errMsg, isError: true);
                        } else if (errMsg == null && context.mounted) {
                          AppSnackbar.show(
                            context,
                            v
                                ? l10n.biometricEnabledMsg
                                : l10n.biometricDisabledMsg,
                            isSuccess: v,
                          );
                        }
                      },
                    )
                  : GestureDetector(
                      onTap: () => AppSnackbar.show(
                        context,
                        l10n.biometricNotAvailable,
                        isError: true,
                      ),
                      child: const Icon(
                        Icons.block_rounded,
                        color: AppColors.textHint,
                      ),
                    ),
            ),
            const Divider(height: 1, indent: 56),
            _SettingsTile(
              icon: Icons.lock_clock_outlined,
              iconColor: AppColors.warning,
              title: l10n.autoLock,
              subtitle: _autoLockLabel(l10n, auth.autoLockSeconds),
              onTap: () => _showAutoLockPicker(context, auth),
            ),
            const Divider(height: 1, indent: 56),
            _SettingsTile(
              icon: Icons.password_rounded,
              iconColor: AppColors.primary,
              title: l10n.changeMasterPassword,
              onTap: () => _showChangeMasterPassword(context),
            ),
          ],
        );
      },
    );
  }
}

// ── 偏好设置 ────────────────────────────────────────────────────────

class _PreferenceSection extends StatelessWidget {
  const _PreferenceSection();

  String _clipboardLabel(AppLocalizations l10n, int seconds) {
    switch (seconds) {
      case 15:
        return l10n.clipboard15Sec;
      case 30:
        return l10n.clipboard30Sec;
      case 60:
        return l10n.clipboard1Min;
      case 0:
        return l10n.clipboardNever;
      default:
        return '$seconds s';
    }
  }

  void _showClipboardPicker(
    BuildContext context,
    PasswordsController pwd,
  ) {
    final l10n = AppLocalizations.of(context);
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surfaceVariant,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Text(
                l10n.clipboardClearTimePicker,
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            ...AppConstants.clipboardClearOptions.map((secs) {
              final label = _clipboardLabel(l10n, secs);
              return ListTile(
                title: Text(
                  label,
                  style: const TextStyle(color: AppColors.textPrimary),
                ),
                trailing: pwd.clipboardClearSeconds == secs
                    ? const Icon(Icons.check_rounded, color: AppColors.primary)
                    : null,
                onTap: () {
                  pwd.setClipboardClearSeconds(secs);
                  Navigator.pop(ctx);
                },
              );
            }),
          ],
        ),
      ),
    );
  }

  void _showLanguagePicker(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final localeCtrl = context.read<LocaleController>();
    final options = [
      (null, l10n.followSystem),
      (const Locale('zh', 'Hans'), '简体中文'),
      (const Locale('zh', 'Hant'), '繁體中文'),
      (const Locale('en'), 'English'),
    ];

    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surfaceVariant,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Text(
                l10n.language,
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            ...options.map((opt) {
              final (locale, label) = opt;
              final isSelected = localeCtrl.locale == locale;
              return ListTile(
                title: Text(
                  label,
                  style: const TextStyle(color: AppColors.textPrimary),
                ),
                trailing: isSelected
                    ? const Icon(Icons.check_rounded, color: AppColors.primary)
                    : null,
                onTap: () {
                  localeCtrl.setLocale(locale);
                  Navigator.pop(ctx);
                },
              );
            }),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Consumer<PasswordsController>(
      builder: (context, pwd, _) {
        final clipLabel =
            _clipboardLabel(l10n, pwd.clipboardClearSeconds);
        return _SettingsCard(
          children: [
            _SettingsTile(
              icon: Icons.content_paste_rounded,
              iconColor: AppColors.categorySocial,
              title: l10n.clipboardAutoClear,
              subtitle: l10n.clipboardClearAfter(clipLabel),
              onTap: () => _showClipboardPicker(context, pwd),
            ),
            const Divider(height: 1, indent: 56),
            _SettingsTile(
              icon: Icons.language_rounded,
              iconColor: AppColors.categoryGame,
              title: l10n.language,
              onTap: () => _showLanguagePicker(context),
            ),
          ],
        );
      },
    );
  }
}

// ── 数据管理 ────────────────────────────────────────────────────────

class _DataSection extends StatelessWidget {
  const _DataSection();

  static Rect _shareOrigin(BuildContext context) {
    final box = context.findRenderObject() as RenderBox?;
    if (box == null || !box.hasSize) {
      return const Rect.fromLTWH(100, 400, 200, 50);
    }
    return box.localToGlobal(Offset.zero) & box.size;
  }

  Future<void> _export(BuildContext context) async {
    final l10n = AppLocalizations.of(context);
    final auth = context.read<AuthController>();
    final pwd = context.read<PasswordsController>();
    if (auth.masterKey == null) return;

    // 在进入异步流程前先捕获位置，避免 context 跨帧失效
    final origin = _shareOrigin(context);

    try {
      final encrypted = await pwd.exportBackup(auth.masterKey!);
      final backup = {
        'version': 1,
        'created_at': DateTime.now().millisecondsSinceEpoch,
        'data': encrypted,
      };
      final jsonStr = jsonEncode(backup);
      final dir = await getTemporaryDirectory();
      final file = File(
        '${dir.path}/${AppConstants.backupFileName}_'
        '${DateTime.now().millisecondsSinceEpoch}'
        '${AppConstants.backupFileExtension}',
      );
      await file.writeAsString(jsonStr);

      await SharePlus.instance.share(
        ShareParams(
          files: [XFile(file.path)],
          text: l10n.backupExportSubject,
          subject: l10n.backupExportSubject,
          sharePositionOrigin: origin,
        ),
      );
    } catch (e) {
      debugPrint(e.toString());
      if (context.mounted) {
        AppSnackbar.show(
          context,
          AppLocalizations.of(context).exportFailed(e.toString()),
          isError: true,
        );
      }
    }
  }

  Future<void> _import(BuildContext context) async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.any,
      allowMultiple: false,
    );
    if (result == null || result.files.isEmpty) return;

    final path = result.files.first.path;
    if (path == null) return;

    if (!context.mounted) return;
    final l10n = AppLocalizations.of(context);

    // 让用户选择导入模式
    final mode = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.importModeTitle),
        content: Text(l10n.importModeMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(l10n.importModeMerge),
          ),
          TextButton(
            onPressed: () async {
              final confirm = await showDialog<bool>(
                context: ctx,
                builder: (ctx2) => AlertDialog(
                  title: Text(l10n.importModeReplace),
                  content: Text(l10n.importReplaceWarning),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(ctx2, false),
                      child: Text(l10n.cancel),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(ctx2, true),
                      child: Text(
                        l10n.importModeReplace,
                        style: const TextStyle(color: AppColors.error),
                      ),
                    ),
                  ],
                ),
              );
              if (ctx.mounted) Navigator.pop(ctx, confirm == true ? true : null);
            },
            child: Text(
              l10n.importModeReplace,
              style: const TextStyle(color: AppColors.error),
            ),
          ),
        ],
      ),
    );

    // null = 取消，false = 合并，true = 清空恢复
    if (mode == null) return;

    try {
      final file = File(path);
      final jsonStr = await file.readAsString();
      final backup = jsonDecode(jsonStr) as Map<String, dynamic>;
      final encrypted = backup['data'] as String;

      if (!context.mounted) return;
      final auth = context.read<AuthController>();
      final pwd = context.read<PasswordsController>();
      if (auth.masterKey == null) return;

      final count = await pwd.importBackup(
        encrypted,
        auth.masterKey!,
        replaceAll: mode,
      );
      if (context.mounted) {
        AppSnackbar.show(
          context,
          AppLocalizations.of(context).importSuccess(count),
          isSuccess: true,
        );
      }
    } catch (e) {
      if (context.mounted) {
        AppSnackbar.show(
          context,
          AppLocalizations.of(context).importFailed,
          isError: true,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return _SettingsCard(
      children: [
        Builder(
          builder: (tileCtx) => _SettingsTile(
            icon: Icons.upload_file_rounded,
            iconColor: AppColors.success,
            title: l10n.exportBackup,
            subtitle: l10n.exportBackupSubtitle,
            onTap: () => _export(tileCtx),
          ),
        ),
        const Divider(height: 1, indent: 56),
        _SettingsTile(
          icon: Icons.download_rounded,
          iconColor: AppColors.categoryOther,
          title: l10n.importRestore,
          subtitle: l10n.importRestoreSubtitle,
          onTap: () => _import(context),
        ),
      ],
    );
  }
}

// ── 工具 ────────────────────────────────────────────────────────────

class _ToolsSection extends StatelessWidget {
  const _ToolsSection();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return _SettingsCard(
      children: [
        _SettingsTile(
          icon: Icons.casino_rounded,
          iconColor: AppColors.categoryShopping,
          title: l10n.generatorTooltip,
          subtitle: l10n.passwordGeneratorSubtitle,
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const GeneratorPage()),
            );
          },
        ),
      ],
    );
  }
}

// ── 关于 ────────────────────────────────────────────────────────────

class _AboutSection extends StatefulWidget {
  const _AboutSection();

  @override
  State<_AboutSection> createState() => _AboutSectionState();
}

class _AboutSectionState extends State<_AboutSection> {
  ({String version, String buildNumber})? _version;

  @override
  void initState() {
    super.initState();
    PubspecBuildVersion.load().then((v) {
      if (mounted) setState(() => _version = v);
    });
  }

  String _versionLine(AppLocalizations l10n) {
    final v = _version;
    if (v == null) return '…';
    return l10n.appVersionLine(v.version, v.buildNumber);
  }

  void _showAbout(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: Text(
          l10n.aboutSafeKey,
          style: const TextStyle(color: AppColors.textPrimary),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _versionLine(l10n),
              style: const TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              l10n.aboutContent,
              style: const TextStyle(
                color: AppColors.textSecondary,
                height: 1.6,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(l10n.close),
          ),
        ],
      ),
    );
  }

  void _showPrivacy(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: Text(
          l10n.privacyPolicy,
          style: const TextStyle(color: AppColors.textPrimary),
        ),
        content: SingleChildScrollView(
          child: Text(
            l10n.privacyContent,
            style: const TextStyle(
              color: AppColors.textSecondary,
              height: 1.6,
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(l10n.close),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return _SettingsCard(
      children: [
        _SettingsTile(
          icon: Icons.info_outline_rounded,
          iconColor: AppColors.textSecondary,
          title: l10n.aboutSafeKey,
          subtitle: _versionLine(l10n),
          onTap: () => _showAbout(context),
        ),
        const Divider(height: 1, indent: 56),
        _SettingsTile(
          icon: Icons.shield_outlined,
          iconColor: AppColors.success,
          title: l10n.privacyPolicy,
          subtitle: l10n.privacyPolicySubtitle,
          onTap: () => _showPrivacy(context),
        ),
      ],
    );
  }
}

// ── 开发测试 ─────────────────────────────────────────────────────────

class _DevSection extends StatelessWidget {
  const _DevSection();

  Future<void> _seedData(BuildContext context) async {
    final auth = context.read<AuthController>();
    final pwd = context.read<PasswordsController>();
    if (auth.masterKey == null) return;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('插入测试数据'),
        content: const Text('将插入 20 条示例密码记录，已有数据不受影响，确定继续？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('确定'),
          ),
        ],
      ),
    );
    if (confirmed != true) return;

    await pwd.seedTestData(auth.masterKey!);

    if (context.mounted) {
      AppSnackbar.show(context, '已插入 20 条测试数据', isSuccess: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return _SettingsCard(
      children: [
        _SettingsTile(
          icon: Icons.science_rounded,
          iconColor: AppColors.primary,
          title: '插入测试数据',
          subtitle: '生成 20 条示例密码（覆盖所有分类）',
          onTap: () => _seedData(context),
        ),
      ],
    );
  }
}

// ── 通用组件 ────────────────────────────────────────────────────────

class _SettingsCard extends StatelessWidget {
  const _SettingsCard({required this.children});
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(children: children),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  const _SettingsTile({
    required this.icon,
    required this.iconColor,
    required this.title,
    this.subtitle,
    this.trailing,
    this.onTap,
  });

  final IconData icon;
  final Color iconColor;
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      leading: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: iconColor.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: iconColor, size: 18),
      ),
      title: Text(
        title,
        style: const TextStyle(
          color: AppColors.textPrimary,
          fontSize: 15,
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: subtitle != null
          ? Text(
              subtitle!,
              style: const TextStyle(
                color: AppColors.textHint,
                fontSize: 12,
              ),
            )
          : null,
      trailing: trailing ??
          (onTap != null
              ? const Icon(
                  Icons.chevron_right_rounded,
                  color: AppColors.textHint,
                  size: 18,
                )
              : null),
    );
  }
}
