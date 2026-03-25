import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('zh'),
    Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hant'),
  ];

  /// No description provided for @appName.
  ///
  /// In zh, this message translates to:
  /// **'SafeKey'**
  String get appName;

  /// No description provided for @welcomeSlide1Title.
  ///
  /// In zh, this message translates to:
  /// **'全离线加密存储'**
  String get welcomeSlide1Title;

  /// No description provided for @welcomeSlide1Subtitle.
  ///
  /// In zh, this message translates to:
  /// **'所有数据使用 AES-256-GCM 加密，\n仅存储于您的设备本地，绝不联网'**
  String get welcomeSlide1Subtitle;

  /// No description provided for @welcomeSlide2Title.
  ///
  /// In zh, this message translates to:
  /// **'Face ID / Touch ID'**
  String get welcomeSlide2Title;

  /// No description provided for @welcomeSlide2Subtitle.
  ///
  /// In zh, this message translates to:
  /// **'支持生物识别快速解锁，\n无需每次输入主密码'**
  String get welcomeSlide2Subtitle;

  /// No description provided for @welcomeSlide3Title.
  ///
  /// In zh, this message translates to:
  /// **'无需注册，无需联网'**
  String get welcomeSlide3Title;

  /// No description provided for @welcomeSlide3Subtitle.
  ///
  /// In zh, this message translates to:
  /// **'您的数据只属于您自己，\nApp 不申请任何网络权限'**
  String get welcomeSlide3Subtitle;

  /// No description provided for @getStarted.
  ///
  /// In zh, this message translates to:
  /// **'开始使用'**
  String get getStarted;

  /// No description provided for @nextStep.
  ///
  /// In zh, this message translates to:
  /// **'下一步'**
  String get nextStep;

  /// No description provided for @setupMasterPasswordTitle.
  ///
  /// In zh, this message translates to:
  /// **'设置主密码'**
  String get setupMasterPasswordTitle;

  /// No description provided for @setupFailed.
  ///
  /// In zh, this message translates to:
  /// **'设置失败，请重试'**
  String get setupFailed;

  /// No description provided for @masterPasswordIsYourOnly.
  ///
  /// In zh, this message translates to:
  /// **'主密码是您数据的唯一保障'**
  String get masterPasswordIsYourOnly;

  /// No description provided for @masterPasswordWarning.
  ///
  /// In zh, this message translates to:
  /// **'主密码无法找回，请务必牢记。建议使用包含大小写字母、数字和符号的组合。'**
  String get masterPasswordWarning;

  /// No description provided for @masterPassword.
  ///
  /// In zh, this message translates to:
  /// **'主密码'**
  String get masterPassword;

  /// No description provided for @atLeast6CharsHint.
  ///
  /// In zh, this message translates to:
  /// **'至少 6 位字符'**
  String get atLeast6CharsHint;

  /// No description provided for @enterMasterPasswordError.
  ///
  /// In zh, this message translates to:
  /// **'请输入主密码'**
  String get enterMasterPasswordError;

  /// No description provided for @masterPasswordTooShortError.
  ///
  /// In zh, this message translates to:
  /// **'主密码至少需要 6 位字符'**
  String get masterPasswordTooShortError;

  /// No description provided for @confirmMasterPassword.
  ///
  /// In zh, this message translates to:
  /// **'确认主密码'**
  String get confirmMasterPassword;

  /// No description provided for @reEnterMasterPasswordHint.
  ///
  /// In zh, this message translates to:
  /// **'再次输入主密码'**
  String get reEnterMasterPasswordHint;

  /// No description provided for @confirmMasterPasswordError.
  ///
  /// In zh, this message translates to:
  /// **'请确认主密码'**
  String get confirmMasterPasswordError;

  /// No description provided for @passwordMismatchError.
  ///
  /// In zh, this message translates to:
  /// **'两次输入的密码不一致'**
  String get passwordMismatchError;

  /// No description provided for @completeSetup.
  ///
  /// In zh, this message translates to:
  /// **'完成设置'**
  String get completeSetup;

  /// No description provided for @lockedOutMessage.
  ///
  /// In zh, this message translates to:
  /// **'连续错误 {count} 次，已锁定 {minutes} 分钟'**
  String lockedOutMessage(int count, int minutes);

  /// No description provided for @passwordWrongRemaining.
  ///
  /// In zh, this message translates to:
  /// **'密码错误，还剩 {remaining} 次机会'**
  String passwordWrongRemaining(int remaining);

  /// No description provided for @durationMinSec.
  ///
  /// In zh, this message translates to:
  /// **'{m} 分 {s} 秒'**
  String durationMinSec(int m, int s);

  /// No description provided for @durationSec.
  ///
  /// In zh, this message translates to:
  /// **'{s} 秒'**
  String durationSec(int s);

  /// No description provided for @enterMasterPasswordToUnlock.
  ///
  /// In zh, this message translates to:
  /// **'输入主密码解锁'**
  String get enterMasterPasswordToUnlock;

  /// No description provided for @failedAttemptsWarning.
  ///
  /// In zh, this message translates to:
  /// **'已输错 {failed} 次，再错 {remaining} 次将锁定 30 分钟'**
  String failedAttemptsWarning(int failed, int remaining);

  /// No description provided for @unlock.
  ///
  /// In zh, this message translates to:
  /// **'解锁'**
  String get unlock;

  /// No description provided for @useFaceIdTouchId.
  ///
  /// In zh, this message translates to:
  /// **'使用 Face ID / Touch ID'**
  String get useFaceIdTouchId;

  /// No description provided for @appLockedHint.
  ///
  /// In zh, this message translates to:
  /// **'您的密码本已锁定'**
  String get appLockedHint;

  /// No description provided for @tapToUnlockBiometric.
  ///
  /// In zh, this message translates to:
  /// **'轻触图标以解锁'**
  String get tapToUnlockBiometric;

  /// No description provided for @verifying.
  ///
  /// In zh, this message translates to:
  /// **'验证中…'**
  String get verifying;

  /// No description provided for @usePasswordInstead.
  ///
  /// In zh, this message translates to:
  /// **'使用密码登录'**
  String get usePasswordInstead;

  /// No description provided for @switchToFaceId.
  ///
  /// In zh, this message translates to:
  /// **'改用 Face ID'**
  String get switchToFaceId;

  /// No description provided for @biometricFailedHint.
  ///
  /// In zh, this message translates to:
  /// **'已失败 {count} 次，再失败 {left} 次将切换到密码解锁'**
  String biometricFailedHint(int count, int left);

  /// No description provided for @biometricFailedAutoSwitched.
  ///
  /// In zh, this message translates to:
  /// **'Face ID 验证失败，已切换到密码解锁'**
  String get biometricFailedAutoSwitched;

  /// No description provided for @accountLocked.
  ///
  /// In zh, this message translates to:
  /// **'账户已锁定'**
  String get accountLocked;

  /// No description provided for @accountLockedDesc.
  ///
  /// In zh, this message translates to:
  /// **'连续输错密码超过 5 次，账户已临时锁定'**
  String get accountLockedDesc;

  /// No description provided for @remainingTime.
  ///
  /// In zh, this message translates to:
  /// **'剩余 {time}'**
  String remainingTime(String time);

  /// No description provided for @addPasswordTooltip.
  ///
  /// In zh, this message translates to:
  /// **'添加密码'**
  String get addPasswordTooltip;

  /// No description provided for @searchHint.
  ///
  /// In zh, this message translates to:
  /// **'搜索名称、账号、备注...'**
  String get searchHint;

  /// No description provided for @allCategories.
  ///
  /// In zh, this message translates to:
  /// **'全部'**
  String get allCategories;

  /// No description provided for @copyUsername.
  ///
  /// In zh, this message translates to:
  /// **'复制账号'**
  String get copyUsername;

  /// No description provided for @copyPassword.
  ///
  /// In zh, this message translates to:
  /// **'复制密码'**
  String get copyPassword;

  /// No description provided for @edit.
  ///
  /// In zh, this message translates to:
  /// **'编辑'**
  String get edit;

  /// No description provided for @delete.
  ///
  /// In zh, this message translates to:
  /// **'删除'**
  String get delete;

  /// No description provided for @deleteConfirmTitle.
  ///
  /// In zh, this message translates to:
  /// **'删除确认'**
  String get deleteConfirmTitle;

  /// No description provided for @deleteConfirmContent.
  ///
  /// In zh, this message translates to:
  /// **'确定要删除「{name}」的密码记录吗？此操作无法撤销。'**
  String deleteConfirmContent(String name);

  /// No description provided for @deleteConfirmContentShort.
  ///
  /// In zh, this message translates to:
  /// **'确定删除「{name}」吗？此操作无法撤销。'**
  String deleteConfirmContentShort(String name);

  /// No description provided for @cancel.
  ///
  /// In zh, this message translates to:
  /// **'取消'**
  String get cancel;

  /// No description provided for @deletedEntry.
  ///
  /// In zh, this message translates to:
  /// **'已删除「{name}」'**
  String deletedEntry(String name);

  /// No description provided for @noMatchingPasswords.
  ///
  /// In zh, this message translates to:
  /// **'未找到匹配的密码'**
  String get noMatchingPasswords;

  /// No description provided for @noPasswordsYet.
  ///
  /// In zh, this message translates to:
  /// **'还没有密码记录'**
  String get noPasswordsYet;

  /// No description provided for @tryOtherKeywords.
  ///
  /// In zh, this message translates to:
  /// **'尝试其他关键词'**
  String get tryOtherKeywords;

  /// No description provided for @tapPlusToAdd.
  ///
  /// In zh, this message translates to:
  /// **'点击右下角 + 添加第一条密码'**
  String get tapPlusToAdd;

  /// No description provided for @addPassword.
  ///
  /// In zh, this message translates to:
  /// **'添加密码'**
  String get addPassword;

  /// No description provided for @editPassword.
  ///
  /// In zh, this message translates to:
  /// **'编辑密码'**
  String get editPassword;

  /// No description provided for @save.
  ///
  /// In zh, this message translates to:
  /// **'保存'**
  String get save;

  /// No description provided for @savedEntry.
  ///
  /// In zh, this message translates to:
  /// **'已保存「{name}」'**
  String savedEntry(String name);

  /// No description provided for @updatedEntry.
  ///
  /// In zh, this message translates to:
  /// **'已更新「{name}」'**
  String updatedEntry(String name);

  /// No description provided for @saveFailed.
  ///
  /// In zh, this message translates to:
  /// **'保存失败，请重试'**
  String get saveFailed;

  /// No description provided for @nameLabel.
  ///
  /// In zh, this message translates to:
  /// **'名称 *'**
  String get nameLabel;

  /// No description provided for @nameHint.
  ///
  /// In zh, this message translates to:
  /// **'如：微信、Gmail'**
  String get nameHint;

  /// No description provided for @nameRequired.
  ///
  /// In zh, this message translates to:
  /// **'请输入名称'**
  String get nameRequired;

  /// No description provided for @usernameLabel.
  ///
  /// In zh, this message translates to:
  /// **'账号 / 用户名 *'**
  String get usernameLabel;

  /// No description provided for @usernameHint.
  ///
  /// In zh, this message translates to:
  /// **'手机号、邮箱或用户名'**
  String get usernameHint;

  /// No description provided for @usernameRequired.
  ///
  /// In zh, this message translates to:
  /// **'请输入账号'**
  String get usernameRequired;

  /// No description provided for @passwordLabel.
  ///
  /// In zh, this message translates to:
  /// **'密码 *'**
  String get passwordLabel;

  /// No description provided for @passwordHint.
  ///
  /// In zh, this message translates to:
  /// **'输入或生成密码'**
  String get passwordHint;

  /// No description provided for @generatorTooltip.
  ///
  /// In zh, this message translates to:
  /// **'密码生成器'**
  String get generatorTooltip;

  /// No description provided for @passwordRequired.
  ///
  /// In zh, this message translates to:
  /// **'请输入密码'**
  String get passwordRequired;

  /// No description provided for @urlLabel.
  ///
  /// In zh, this message translates to:
  /// **'网址（选填）'**
  String get urlLabel;

  /// No description provided for @noteLabel.
  ///
  /// In zh, this message translates to:
  /// **'备注（选填）'**
  String get noteLabel;

  /// No description provided for @noteHint.
  ///
  /// In zh, this message translates to:
  /// **'其他信息...'**
  String get noteHint;

  /// No description provided for @categoryLabel.
  ///
  /// In zh, this message translates to:
  /// **'分类'**
  String get categoryLabel;

  /// No description provided for @editTooltip.
  ///
  /// In zh, this message translates to:
  /// **'编辑'**
  String get editTooltip;

  /// No description provided for @deleteTooltip.
  ///
  /// In zh, this message translates to:
  /// **'删除'**
  String get deleteTooltip;

  /// No description provided for @usernameFieldLabel.
  ///
  /// In zh, this message translates to:
  /// **'账号'**
  String get usernameFieldLabel;

  /// No description provided for @passwordFieldLabel.
  ///
  /// In zh, this message translates to:
  /// **'密码'**
  String get passwordFieldLabel;

  /// No description provided for @urlFieldLabel.
  ///
  /// In zh, this message translates to:
  /// **'网址'**
  String get urlFieldLabel;

  /// No description provided for @noteFieldLabel.
  ///
  /// In zh, this message translates to:
  /// **'备注'**
  String get noteFieldLabel;

  /// No description provided for @createdAt.
  ///
  /// In zh, this message translates to:
  /// **'创建时间'**
  String get createdAt;

  /// No description provided for @updatedAt.
  ///
  /// In zh, this message translates to:
  /// **'更新时间'**
  String get updatedAt;

  /// No description provided for @passwordGenerator.
  ///
  /// In zh, this message translates to:
  /// **'密码生成器'**
  String get passwordGenerator;

  /// No description provided for @length.
  ///
  /// In zh, this message translates to:
  /// **'长度'**
  String get length;

  /// No description provided for @uppercase.
  ///
  /// In zh, this message translates to:
  /// **'大写字母'**
  String get uppercase;

  /// No description provided for @lowercase.
  ///
  /// In zh, this message translates to:
  /// **'小写字母'**
  String get lowercase;

  /// No description provided for @digits.
  ///
  /// In zh, this message translates to:
  /// **'数字'**
  String get digits;

  /// No description provided for @specialChars.
  ///
  /// In zh, this message translates to:
  /// **'特殊字符'**
  String get specialChars;

  /// No description provided for @regenerate.
  ///
  /// In zh, this message translates to:
  /// **'重新生成'**
  String get regenerate;

  /// No description provided for @useThisPassword.
  ///
  /// In zh, this message translates to:
  /// **'使用此密码'**
  String get useThisPassword;

  /// No description provided for @copy.
  ///
  /// In zh, this message translates to:
  /// **'复制'**
  String get copy;

  /// No description provided for @passwordCopied.
  ///
  /// In zh, this message translates to:
  /// **'密码已复制'**
  String get passwordCopied;

  /// No description provided for @copied.
  ///
  /// In zh, this message translates to:
  /// **'已复制'**
  String get copied;

  /// No description provided for @copiedLabel.
  ///
  /// In zh, this message translates to:
  /// **'{label} 已复制'**
  String copiedLabel(String label);

  /// No description provided for @strengthWeak.
  ///
  /// In zh, this message translates to:
  /// **'弱'**
  String get strengthWeak;

  /// No description provided for @strengthMedium.
  ///
  /// In zh, this message translates to:
  /// **'中等'**
  String get strengthMedium;

  /// No description provided for @strengthStrong.
  ///
  /// In zh, this message translates to:
  /// **'强'**
  String get strengthStrong;

  /// No description provided for @strengthVeryStrong.
  ///
  /// In zh, this message translates to:
  /// **'非常强'**
  String get strengthVeryStrong;

  /// No description provided for @settings.
  ///
  /// In zh, this message translates to:
  /// **'设置'**
  String get settings;

  /// No description provided for @sectionSecurity.
  ///
  /// In zh, this message translates to:
  /// **'安全'**
  String get sectionSecurity;

  /// No description provided for @sectionPreferences.
  ///
  /// In zh, this message translates to:
  /// **'偏好设置'**
  String get sectionPreferences;

  /// No description provided for @sectionDataManagement.
  ///
  /// In zh, this message translates to:
  /// **'数据管理'**
  String get sectionDataManagement;

  /// No description provided for @sectionTools.
  ///
  /// In zh, this message translates to:
  /// **'工具'**
  String get sectionTools;

  /// No description provided for @sectionAbout.
  ///
  /// In zh, this message translates to:
  /// **'关于'**
  String get sectionAbout;

  /// No description provided for @biometricSubtitleEnabled.
  ///
  /// In zh, this message translates to:
  /// **'快速解锁，无需输入密码'**
  String get biometricSubtitleEnabled;

  /// No description provided for @biometricSubtitleDisabled.
  ///
  /// In zh, this message translates to:
  /// **'当前设备不支持生物识别'**
  String get biometricSubtitleDisabled;

  /// No description provided for @biometricEnabledMsg.
  ///
  /// In zh, this message translates to:
  /// **'Face ID / Touch ID 已开启'**
  String get biometricEnabledMsg;

  /// No description provided for @biometricDisabledMsg.
  ///
  /// In zh, this message translates to:
  /// **'生物识别已关闭'**
  String get biometricDisabledMsg;

  /// No description provided for @biometricNotAvailable.
  ///
  /// In zh, this message translates to:
  /// **'当前设备不支持或未录入生物特征\n（模拟器请先执行 Features → Face ID → Enrolled）'**
  String get biometricNotAvailable;

  /// No description provided for @autoLock.
  ///
  /// In zh, this message translates to:
  /// **'自动锁定'**
  String get autoLock;

  /// No description provided for @autoLockSeconds.
  ///
  /// In zh, this message translates to:
  /// **'{s} 秒'**
  String autoLockSeconds(int s);

  /// No description provided for @changeMasterPassword.
  ///
  /// In zh, this message translates to:
  /// **'修改主密码'**
  String get changeMasterPassword;

  /// No description provided for @autoLockTimePicker.
  ///
  /// In zh, this message translates to:
  /// **'自动锁定时间'**
  String get autoLockTimePicker;

  /// No description provided for @currentMasterPasswordHint.
  ///
  /// In zh, this message translates to:
  /// **'当前主密码'**
  String get currentMasterPasswordHint;

  /// No description provided for @newMasterPasswordHint.
  ///
  /// In zh, this message translates to:
  /// **'新主密码（至少 6 位）'**
  String get newMasterPasswordHint;

  /// No description provided for @enterCurrentMasterPasswordError.
  ///
  /// In zh, this message translates to:
  /// **'请输入当前主密码'**
  String get enterCurrentMasterPasswordError;

  /// No description provided for @enterNewPasswordError.
  ///
  /// In zh, this message translates to:
  /// **'请输入新密码'**
  String get enterNewPasswordError;

  /// No description provided for @atLeast6CharsError.
  ///
  /// In zh, this message translates to:
  /// **'至少 6 位字符'**
  String get atLeast6CharsError;

  /// No description provided for @passwordsNotMatchError.
  ///
  /// In zh, this message translates to:
  /// **'两次密码不一致'**
  String get passwordsNotMatchError;

  /// No description provided for @confirmNewMasterPasswordHint.
  ///
  /// In zh, this message translates to:
  /// **'确认新主密码'**
  String get confirmNewMasterPasswordHint;

  /// No description provided for @masterPasswordUpdated.
  ///
  /// In zh, this message translates to:
  /// **'主密码已更新'**
  String get masterPasswordUpdated;

  /// No description provided for @wrongCurrentPassword.
  ///
  /// In zh, this message translates to:
  /// **'原密码错误，请重试'**
  String get wrongCurrentPassword;

  /// No description provided for @clipboardAutoClear.
  ///
  /// In zh, this message translates to:
  /// **'剪贴板自动清除'**
  String get clipboardAutoClear;

  /// No description provided for @clipboardClearAfter.
  ///
  /// In zh, this message translates to:
  /// **'复制密码后 {label} 清除'**
  String clipboardClearAfter(String label);

  /// No description provided for @clipboardClearTimePicker.
  ///
  /// In zh, this message translates to:
  /// **'剪贴板清除时间'**
  String get clipboardClearTimePicker;

  /// No description provided for @backupExportSubject.
  ///
  /// In zh, this message translates to:
  /// **'SafeKey 备份文件'**
  String get backupExportSubject;

  /// No description provided for @exportFailed.
  ///
  /// In zh, this message translates to:
  /// **'导出失败：{error}'**
  String exportFailed(String error);

  /// No description provided for @importSuccess.
  ///
  /// In zh, this message translates to:
  /// **'成功恢复 {count} 条密码记录'**
  String importSuccess(int count);

  /// No description provided for @importFailed.
  ///
  /// In zh, this message translates to:
  /// **'导入失败，请确认文件格式正确且主密码匹配'**
  String get importFailed;

  /// No description provided for @importModeTitle.
  ///
  /// In zh, this message translates to:
  /// **'选择导入方式'**
  String get importModeTitle;

  /// No description provided for @importModeMessage.
  ///
  /// In zh, this message translates to:
  /// **'合并导入：保留现有数据，备份中重复条目将被跳过。\n\n清空恢复：删除所有现有数据，完全以备份文件恢复。'**
  String get importModeMessage;

  /// No description provided for @importModeMerge.
  ///
  /// In zh, this message translates to:
  /// **'合并导入'**
  String get importModeMerge;

  /// No description provided for @importModeReplace.
  ///
  /// In zh, this message translates to:
  /// **'清空恢复'**
  String get importModeReplace;

  /// No description provided for @importReplaceWarning.
  ///
  /// In zh, this message translates to:
  /// **'此操作将删除所有现有密码，无法撤销，确定继续？'**
  String get importReplaceWarning;

  /// No description provided for @exportBackup.
  ///
  /// In zh, this message translates to:
  /// **'导出备份'**
  String get exportBackup;

  /// No description provided for @exportBackupSubtitle.
  ///
  /// In zh, this message translates to:
  /// **'导出加密备份文件（.skbak）'**
  String get exportBackupSubtitle;

  /// No description provided for @importRestore.
  ///
  /// In zh, this message translates to:
  /// **'导入恢复'**
  String get importRestore;

  /// No description provided for @importRestoreSubtitle.
  ///
  /// In zh, this message translates to:
  /// **'从备份文件恢复数据'**
  String get importRestoreSubtitle;

  /// No description provided for @passwordGeneratorSubtitle.
  ///
  /// In zh, this message translates to:
  /// **'生成高强度随机密码'**
  String get passwordGeneratorSubtitle;

  /// No description provided for @aboutSafeKey.
  ///
  /// In zh, this message translates to:
  /// **'关于 SafeKey'**
  String get aboutSafeKey;

  /// No description provided for @appVersionLine.
  ///
  /// In zh, this message translates to:
  /// **'版本 {version}（构建 {buildNumber}）'**
  String appVersionLine(String version, String buildNumber);

  /// No description provided for @privacyPolicy.
  ///
  /// In zh, this message translates to:
  /// **'隐私政策'**
  String get privacyPolicy;

  /// No description provided for @privacyPolicySubtitle.
  ///
  /// In zh, this message translates to:
  /// **'我们不收集任何用户数据'**
  String get privacyPolicySubtitle;

  /// No description provided for @aboutContent.
  ///
  /// In zh, this message translates to:
  /// **'SafeKey 是一款完全本地化的密码管理工具，采用 AES-256-GCM 加密，不联网，不收集任何数据。您的隐私和安全是我们的唯一承诺。'**
  String get aboutContent;

  /// No description provided for @close.
  ///
  /// In zh, this message translates to:
  /// **'关闭'**
  String get close;

  /// No description provided for @privacyContent.
  ///
  /// In zh, this message translates to:
  /// **'SafeKey 不收集、不传输、不分析任何用户数据。\n\n• 所有密码数据仅存储在您的设备本地\n• App 不申请网络访问权限\n• 数据使用 AES-256-GCM 加密存储\n• 主密码不以任何形式存储，仅用于派生加密密钥\n• 我们无法也不会访问您的数据\n\n您的数据属于您自己，仅此而已。'**
  String get privacyContent;

  /// No description provided for @categorySocial.
  ///
  /// In zh, this message translates to:
  /// **'社交'**
  String get categorySocial;

  /// No description provided for @categoryFinance.
  ///
  /// In zh, this message translates to:
  /// **'金融'**
  String get categoryFinance;

  /// No description provided for @categoryShopping.
  ///
  /// In zh, this message translates to:
  /// **'购物'**
  String get categoryShopping;

  /// No description provided for @categoryGame.
  ///
  /// In zh, this message translates to:
  /// **'游戏'**
  String get categoryGame;

  /// No description provided for @categoryOther.
  ///
  /// In zh, this message translates to:
  /// **'其他'**
  String get categoryOther;

  /// No description provided for @language.
  ///
  /// In zh, this message translates to:
  /// **'语言'**
  String get language;

  /// No description provided for @followSystem.
  ///
  /// In zh, this message translates to:
  /// **'跟随系统'**
  String get followSystem;

  /// No description provided for @autoLockImmediate.
  ///
  /// In zh, this message translates to:
  /// **'立即'**
  String get autoLockImmediate;

  /// No description provided for @autoLock1Min.
  ///
  /// In zh, this message translates to:
  /// **'1 分钟'**
  String get autoLock1Min;

  /// No description provided for @autoLock5Min.
  ///
  /// In zh, this message translates to:
  /// **'5 分钟'**
  String get autoLock5Min;

  /// No description provided for @autoLock15Min.
  ///
  /// In zh, this message translates to:
  /// **'15 分钟'**
  String get autoLock15Min;

  /// No description provided for @clipboard15Sec.
  ///
  /// In zh, this message translates to:
  /// **'15 秒'**
  String get clipboard15Sec;

  /// No description provided for @clipboard30Sec.
  ///
  /// In zh, this message translates to:
  /// **'30 秒'**
  String get clipboard30Sec;

  /// No description provided for @clipboard1Min.
  ///
  /// In zh, this message translates to:
  /// **'1 分钟'**
  String get clipboard1Min;

  /// No description provided for @clipboardNever.
  ///
  /// In zh, this message translates to:
  /// **'永不'**
  String get clipboardNever;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'zh'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when language+script codes are specified.
  switch (locale.languageCode) {
    case 'zh':
      {
        switch (locale.scriptCode) {
          case 'Hant':
            return AppLocalizationsZhHant();
        }
        break;
      }
  }

  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
