// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get appName => 'SafeKey';

  @override
  String get welcomeSlide1Title => '全离线加密存储';

  @override
  String get welcomeSlide1Subtitle => '所有数据使用 AES-256-GCM 加密，\n仅存储于您的设备本地，绝不联网';

  @override
  String get welcomeSlide2Title => 'Face ID / Touch ID';

  @override
  String get welcomeSlide2Subtitle => '支持生物识别快速解锁，\n无需每次输入主密码';

  @override
  String get welcomeSlide3Title => '无需注册，无需联网';

  @override
  String get welcomeSlide3Subtitle => '您的数据只属于您自己，\nApp 不申请任何网络权限';

  @override
  String get getStarted => '开始使用';

  @override
  String get nextStep => '下一步';

  @override
  String get setupMasterPasswordTitle => '设置主密码';

  @override
  String get setupFailed => '设置失败，请重试';

  @override
  String get masterPasswordIsYourOnly => '主密码是您数据的唯一保障';

  @override
  String get masterPasswordWarning => '主密码无法找回，请务必牢记。建议使用包含大小写字母、数字和符号的组合。';

  @override
  String get masterPassword => '主密码';

  @override
  String get atLeast6CharsHint => '至少 6 位字符';

  @override
  String get enterMasterPasswordError => '请输入主密码';

  @override
  String get masterPasswordTooShortError => '主密码至少需要 6 位字符';

  @override
  String get confirmMasterPassword => '确认主密码';

  @override
  String get reEnterMasterPasswordHint => '再次输入主密码';

  @override
  String get confirmMasterPasswordError => '请确认主密码';

  @override
  String get passwordMismatchError => '两次输入的密码不一致';

  @override
  String get completeSetup => '完成设置';

  @override
  String lockedOutMessage(int count, int minutes) {
    return '连续错误 $count 次，已锁定 $minutes 分钟';
  }

  @override
  String passwordWrongRemaining(int remaining) {
    return '密码错误，还剩 $remaining 次机会';
  }

  @override
  String durationMinSec(int m, int s) {
    return '$m 分 $s 秒';
  }

  @override
  String durationSec(int s) {
    return '$s 秒';
  }

  @override
  String get enterMasterPasswordToUnlock => '输入主密码解锁';

  @override
  String failedAttemptsWarning(int failed, int remaining) {
    return '已输错 $failed 次，再错 $remaining 次将锁定 30 分钟';
  }

  @override
  String get unlock => '解锁';

  @override
  String get useFaceIdTouchId => '使用 Face ID / Touch ID';

  @override
  String get appLockedHint => '您的密码本已锁定';

  @override
  String get tapToUnlockBiometric => '轻触图标以解锁';

  @override
  String get verifying => '验证中…';

  @override
  String get usePasswordInstead => '使用密码登录';

  @override
  String get switchToFaceId => '改用 Face ID';

  @override
  String biometricFailedHint(int count, int left) {
    return '已失败 $count 次，再失败 $left 次将切换到密码解锁';
  }

  @override
  String get biometricFailedAutoSwitched => 'Face ID 验证失败，已切换到密码解锁';

  @override
  String get accountLocked => '账户已锁定';

  @override
  String get accountLockedDesc => '连续输错密码超过 5 次，账户已临时锁定';

  @override
  String remainingTime(String time) {
    return '剩余 $time';
  }

  @override
  String get addPasswordTooltip => '添加密码';

  @override
  String get searchHint => '搜索名称、账号、备注...';

  @override
  String get allCategories => '全部';

  @override
  String get copyUsername => '复制账号';

  @override
  String get copyPassword => '复制密码';

  @override
  String get edit => '编辑';

  @override
  String get delete => '删除';

  @override
  String get deleteConfirmTitle => '删除确认';

  @override
  String deleteConfirmContent(String name) {
    return '确定要删除「$name」的密码记录吗？此操作无法撤销。';
  }

  @override
  String deleteConfirmContentShort(String name) {
    return '确定删除「$name」吗？此操作无法撤销。';
  }

  @override
  String get cancel => '取消';

  @override
  String deletedEntry(String name) {
    return '已删除「$name」';
  }

  @override
  String get noMatchingPasswords => '未找到匹配的密码';

  @override
  String get noPasswordsYet => '还没有密码记录';

  @override
  String get tryOtherKeywords => '尝试其他关键词';

  @override
  String get tapPlusToAdd => '点击右下角 + 添加第一条密码';

  @override
  String get addPassword => '添加密码';

  @override
  String get editPassword => '编辑密码';

  @override
  String get save => '保存';

  @override
  String savedEntry(String name) {
    return '已保存「$name」';
  }

  @override
  String updatedEntry(String name) {
    return '已更新「$name」';
  }

  @override
  String get saveFailed => '保存失败，请重试';

  @override
  String get nameLabel => '名称 *';

  @override
  String get nameHint => '如：微信、Gmail';

  @override
  String get nameRequired => '请输入名称';

  @override
  String get usernameLabel => '账号 / 用户名 *';

  @override
  String get usernameHint => '手机号、邮箱或用户名';

  @override
  String get usernameRequired => '请输入账号';

  @override
  String get passwordLabel => '密码 *';

  @override
  String get passwordHint => '输入或生成密码';

  @override
  String get generatorTooltip => '密码生成器';

  @override
  String get passwordRequired => '请输入密码';

  @override
  String get urlLabel => '网址（选填）';

  @override
  String get noteLabel => '备注（选填）';

  @override
  String get noteHint => '其他信息...';

  @override
  String get categoryLabel => '分类';

  @override
  String get editTooltip => '编辑';

  @override
  String get deleteTooltip => '删除';

  @override
  String get usernameFieldLabel => '账号';

  @override
  String get passwordFieldLabel => '密码';

  @override
  String get urlFieldLabel => '网址';

  @override
  String get noteFieldLabel => '备注';

  @override
  String get createdAt => '创建时间';

  @override
  String get updatedAt => '更新时间';

  @override
  String get passwordGenerator => '密码生成器';

  @override
  String get length => '长度';

  @override
  String get uppercase => '大写字母';

  @override
  String get lowercase => '小写字母';

  @override
  String get digits => '数字';

  @override
  String get specialChars => '特殊字符';

  @override
  String get regenerate => '重新生成';

  @override
  String get useThisPassword => '使用此密码';

  @override
  String get copy => '复制';

  @override
  String get passwordCopied => '密码已复制';

  @override
  String get copied => '已复制';

  @override
  String copiedLabel(String label) {
    return '$label 已复制';
  }

  @override
  String get strengthWeak => '弱';

  @override
  String get strengthMedium => '中等';

  @override
  String get strengthStrong => '强';

  @override
  String get strengthVeryStrong => '非常强';

  @override
  String get settings => '设置';

  @override
  String get sectionSecurity => '安全';

  @override
  String get sectionPreferences => '偏好设置';

  @override
  String get sectionDataManagement => '数据管理';

  @override
  String get sectionTools => '工具';

  @override
  String get sectionAbout => '关于';

  @override
  String get biometricSubtitleEnabled => '快速解锁，无需输入密码';

  @override
  String get biometricSubtitleDisabled => '当前设备不支持生物识别';

  @override
  String get biometricEnabledMsg => 'Face ID / Touch ID 已开启';

  @override
  String get biometricDisabledMsg => '生物识别已关闭';

  @override
  String get biometricNotAvailable =>
      '当前设备不支持或未录入生物特征\n（模拟器请先执行 Features → Face ID → Enrolled）';

  @override
  String get autoLock => '自动锁定';

  @override
  String autoLockSeconds(int s) {
    return '$s 秒';
  }

  @override
  String get changeMasterPassword => '修改主密码';

  @override
  String get autoLockTimePicker => '自动锁定时间';

  @override
  String get currentMasterPasswordHint => '当前主密码';

  @override
  String get newMasterPasswordHint => '新主密码（至少 6 位）';

  @override
  String get enterCurrentMasterPasswordError => '请输入当前主密码';

  @override
  String get enterNewPasswordError => '请输入新密码';

  @override
  String get atLeast6CharsError => '至少 6 位字符';

  @override
  String get passwordsNotMatchError => '两次密码不一致';

  @override
  String get confirmNewMasterPasswordHint => '确认新主密码';

  @override
  String get masterPasswordUpdated => '主密码已更新';

  @override
  String get wrongCurrentPassword => '原密码错误，请重试';

  @override
  String get clipboardAutoClear => '剪贴板自动清除';

  @override
  String clipboardClearAfter(String label) {
    return '复制密码后 $label 清除';
  }

  @override
  String get clipboardClearTimePicker => '剪贴板清除时间';

  @override
  String get backupExportSubject => 'SafeKey 备份文件';

  @override
  String exportFailed(String error) {
    return '导出失败：$error';
  }

  @override
  String importSuccess(int count) {
    return '成功恢复 $count 条密码记录';
  }

  @override
  String get importFailed => '导入失败，请确认文件格式正确且主密码匹配';

  @override
  String get importModeTitle => '选择导入方式';

  @override
  String get importModeMessage =>
      '合并导入：保留现有数据，备份中重复条目将被跳过。\n\n清空恢复：删除所有现有数据，完全以备份文件恢复。';

  @override
  String get importModeMerge => '合并导入';

  @override
  String get importModeReplace => '清空恢复';

  @override
  String get importReplaceWarning => '此操作将删除所有现有密码，无法撤销，确定继续？';

  @override
  String get exportBackup => '导出备份';

  @override
  String get exportBackupSubtitle => '导出加密备份文件（.skbak）';

  @override
  String get importRestore => '导入恢复';

  @override
  String get importRestoreSubtitle => '从备份文件恢复数据';

  @override
  String get passwordGeneratorSubtitle => '生成高强度随机密码';

  @override
  String get aboutSafeKey => '关于 SafeKey';

  @override
  String appVersionLine(String version, String buildNumber) {
    return '版本 $version（构建 $buildNumber）';
  }

  @override
  String get privacyPolicy => '隐私政策';

  @override
  String get privacyPolicySubtitle => '我们不收集任何用户数据';

  @override
  String get aboutContent =>
      'SafeKey 是一款完全本地化的密码管理工具，采用 AES-256-GCM 加密，不联网，不收集任何数据。您的隐私和安全是我们的唯一承诺。';

  @override
  String get close => '关闭';

  @override
  String get privacyContent =>
      'SafeKey 不收集、不传输、不分析任何用户数据。\n\n• 所有密码数据仅存储在您的设备本地\n• App 不申请网络访问权限\n• 数据使用 AES-256-GCM 加密存储\n• 主密码不以任何形式存储，仅用于派生加密密钥\n• 我们无法也不会访问您的数据\n\n您的数据属于您自己，仅此而已。';

  @override
  String get categorySocial => '社交';

  @override
  String get categoryFinance => '金融';

  @override
  String get categoryShopping => '购物';

  @override
  String get categoryGame => '游戏';

  @override
  String get categoryOther => '其他';

  @override
  String get language => '语言';

  @override
  String get followSystem => '跟随系统';

  @override
  String get autoLockImmediate => '立即';

  @override
  String get autoLock1Min => '1 分钟';

  @override
  String get autoLock5Min => '5 分钟';

  @override
  String get autoLock15Min => '15 分钟';

  @override
  String get clipboard15Sec => '15 秒';

  @override
  String get clipboard30Sec => '30 秒';

  @override
  String get clipboard1Min => '1 分钟';

  @override
  String get clipboardNever => '永不';
}

/// The translations for Chinese, using the Han script (`zh_Hant`).
class AppLocalizationsZhHant extends AppLocalizationsZh {
  AppLocalizationsZhHant() : super('zh_Hant');

  @override
  String get appName => 'SafeKey';

  @override
  String get welcomeSlide1Title => '全離線加密儲存';

  @override
  String get welcomeSlide1Subtitle => '所有資料使用 AES-256-GCM 加密，\n僅儲存於您的裝置本地，絕不聯網';

  @override
  String get welcomeSlide2Title => 'Face ID / Touch ID';

  @override
  String get welcomeSlide2Subtitle => '支援生物識別快速解鎖，\n無需每次輸入主密碼';

  @override
  String get welcomeSlide3Title => '無需註冊，無需聯網';

  @override
  String get welcomeSlide3Subtitle => '您的資料只屬於您自己，\nApp 不申請任何網路權限';

  @override
  String get getStarted => '開始使用';

  @override
  String get nextStep => '下一步';

  @override
  String get setupMasterPasswordTitle => '設定主密碼';

  @override
  String get setupFailed => '設定失敗，請重試';

  @override
  String get masterPasswordIsYourOnly => '主密碼是您資料的唯一保障';

  @override
  String get masterPasswordWarning => '主密碼無法找回，請務必牢記。建議使用包含大小寫字母、數字和符號的組合。';

  @override
  String get masterPassword => '主密碼';

  @override
  String get atLeast6CharsHint => '至少 6 位字元';

  @override
  String get enterMasterPasswordError => '請輸入主密碼';

  @override
  String get masterPasswordTooShortError => '主密碼至少需要 6 位字元';

  @override
  String get confirmMasterPassword => '確認主密碼';

  @override
  String get reEnterMasterPasswordHint => '再次輸入主密碼';

  @override
  String get confirmMasterPasswordError => '請確認主密碼';

  @override
  String get passwordMismatchError => '兩次輸入的密碼不一致';

  @override
  String get completeSetup => '完成設定';

  @override
  String lockedOutMessage(int count, int minutes) {
    return '連續錯誤 $count 次，已鎖定 $minutes 分鐘';
  }

  @override
  String passwordWrongRemaining(int remaining) {
    return '密碼錯誤，還剩 $remaining 次機會';
  }

  @override
  String durationMinSec(int m, int s) {
    return '$m 分 $s 秒';
  }

  @override
  String durationSec(int s) {
    return '$s 秒';
  }

  @override
  String get enterMasterPasswordToUnlock => '輸入主密碼解鎖';

  @override
  String failedAttemptsWarning(int failed, int remaining) {
    return '已輸錯 $failed 次，再錯 $remaining 次將鎖定 30 分鐘';
  }

  @override
  String get unlock => '解鎖';

  @override
  String get useFaceIdTouchId => '使用 Face ID / Touch ID';

  @override
  String get appLockedHint => '您的密碼本已鎖定';

  @override
  String get tapToUnlockBiometric => '輕觸圖示以解鎖';

  @override
  String get verifying => '驗證中…';

  @override
  String get usePasswordInstead => '使用密碼登入';

  @override
  String get switchToFaceId => '改用 Face ID';

  @override
  String biometricFailedHint(int count, int left) {
    return '已失敗 $count 次，再失敗 $left 次將切換到密碼解鎖';
  }

  @override
  String get biometricFailedAutoSwitched => 'Face ID 驗證失敗，已切換到密碼解鎖';

  @override
  String get accountLocked => '帳戶已鎖定';

  @override
  String get accountLockedDesc => '連續輸錯密碼超過 5 次，帳戶已暫時鎖定';

  @override
  String remainingTime(String time) {
    return '剩餘 $time';
  }

  @override
  String get addPasswordTooltip => '新增密碼';

  @override
  String get searchHint => '搜尋名稱、帳號、備註...';

  @override
  String get allCategories => '全部';

  @override
  String get copyUsername => '複製帳號';

  @override
  String get copyPassword => '複製密碼';

  @override
  String get edit => '編輯';

  @override
  String get delete => '刪除';

  @override
  String get deleteConfirmTitle => '刪除確認';

  @override
  String deleteConfirmContent(String name) {
    return '確定要刪除「$name」的密碼記錄嗎？此操作無法撤銷。';
  }

  @override
  String deleteConfirmContentShort(String name) {
    return '確定刪除「$name」嗎？此操作無法撤銷。';
  }

  @override
  String get cancel => '取消';

  @override
  String deletedEntry(String name) {
    return '已刪除「$name」';
  }

  @override
  String get noMatchingPasswords => '未找到符合的密碼';

  @override
  String get noPasswordsYet => '還沒有密碼記錄';

  @override
  String get tryOtherKeywords => '嘗試其他關鍵字';

  @override
  String get tapPlusToAdd => '點擊右下角 + 新增第一條密碼';

  @override
  String get addPassword => '新增密碼';

  @override
  String get editPassword => '編輯密碼';

  @override
  String get save => '儲存';

  @override
  String savedEntry(String name) {
    return '已儲存「$name」';
  }

  @override
  String updatedEntry(String name) {
    return '已更新「$name」';
  }

  @override
  String get saveFailed => '儲存失敗，請重試';

  @override
  String get nameLabel => '名稱 *';

  @override
  String get nameHint => '如：Line、Gmail';

  @override
  String get nameRequired => '請輸入名稱';

  @override
  String get usernameLabel => '帳號 / 使用者名稱 *';

  @override
  String get usernameHint => '手機號、電子郵件或使用者名稱';

  @override
  String get usernameRequired => '請輸入帳號';

  @override
  String get passwordLabel => '密碼 *';

  @override
  String get passwordHint => '輸入或產生密碼';

  @override
  String get generatorTooltip => '密碼產生器';

  @override
  String get passwordRequired => '請輸入密碼';

  @override
  String get urlLabel => '網址（選填）';

  @override
  String get noteLabel => '備註（選填）';

  @override
  String get noteHint => '其他資訊...';

  @override
  String get categoryLabel => '分類';

  @override
  String get editTooltip => '編輯';

  @override
  String get deleteTooltip => '刪除';

  @override
  String get usernameFieldLabel => '帳號';

  @override
  String get passwordFieldLabel => '密碼';

  @override
  String get urlFieldLabel => '網址';

  @override
  String get noteFieldLabel => '備註';

  @override
  String get createdAt => '建立時間';

  @override
  String get updatedAt => '更新時間';

  @override
  String get passwordGenerator => '密碼產生器';

  @override
  String get length => '長度';

  @override
  String get uppercase => '大寫字母';

  @override
  String get lowercase => '小寫字母';

  @override
  String get digits => '數字';

  @override
  String get specialChars => '特殊字元';

  @override
  String get regenerate => '重新產生';

  @override
  String get useThisPassword => '使用此密碼';

  @override
  String get copy => '複製';

  @override
  String get passwordCopied => '密碼已複製';

  @override
  String get copied => '已複製';

  @override
  String copiedLabel(String label) {
    return '$label 已複製';
  }

  @override
  String get strengthWeak => '弱';

  @override
  String get strengthMedium => '中等';

  @override
  String get strengthStrong => '強';

  @override
  String get strengthVeryStrong => '非常強';

  @override
  String get settings => '設定';

  @override
  String get sectionSecurity => '安全';

  @override
  String get sectionPreferences => '偏好設定';

  @override
  String get sectionDataManagement => '資料管理';

  @override
  String get sectionTools => '工具';

  @override
  String get sectionAbout => '關於';

  @override
  String get biometricSubtitleEnabled => '快速解鎖，無需輸入密碼';

  @override
  String get biometricSubtitleDisabled => '目前裝置不支援生物識別';

  @override
  String get biometricEnabledMsg => 'Face ID / Touch ID 已開啟';

  @override
  String get biometricDisabledMsg => '生物識別已關閉';

  @override
  String get biometricNotAvailable =>
      '目前裝置不支援或未登錄生物特徵\n（模擬器請先執行 Features → Face ID → Enrolled）';

  @override
  String get autoLock => '自動鎖定';

  @override
  String autoLockSeconds(int s) {
    return '$s 秒';
  }

  @override
  String get changeMasterPassword => '修改主密碼';

  @override
  String get autoLockTimePicker => '自動鎖定時間';

  @override
  String get currentMasterPasswordHint => '目前主密碼';

  @override
  String get newMasterPasswordHint => '新主密碼（至少 6 位）';

  @override
  String get enterCurrentMasterPasswordError => '請輸入目前主密碼';

  @override
  String get enterNewPasswordError => '請輸入新密碼';

  @override
  String get atLeast6CharsError => '至少 6 位字元';

  @override
  String get passwordsNotMatchError => '兩次密碼不一致';

  @override
  String get confirmNewMasterPasswordHint => '確認新主密碼';

  @override
  String get masterPasswordUpdated => '主密碼已更新';

  @override
  String get wrongCurrentPassword => '原密碼錯誤，請重試';

  @override
  String get clipboardAutoClear => '剪貼簿自動清除';

  @override
  String clipboardClearAfter(String label) {
    return '複製密碼後 $label 清除';
  }

  @override
  String get clipboardClearTimePicker => '剪貼簿清除時間';

  @override
  String get backupExportSubject => 'SafeKey 備份檔案';

  @override
  String exportFailed(String error) {
    return '匯出失敗：$error';
  }

  @override
  String importSuccess(int count) {
    return '成功還原 $count 筆密碼記錄';
  }

  @override
  String get importFailed => '匯入失敗，請確認檔案格式正確且主密碼相符';

  @override
  String get importModeTitle => '選擇匯入方式';

  @override
  String get importModeMessage =>
      '合併匯入：保留現有資料，備份中重複的條目將被略過。\n\n清空還原：刪除所有現有資料，完全以備份檔案還原。';

  @override
  String get importModeMerge => '合併匯入';

  @override
  String get importModeReplace => '清空還原';

  @override
  String get importReplaceWarning => '此操作將刪除所有現有密碼，無法復原，確定繼續？';

  @override
  String get exportBackup => '匯出備份';

  @override
  String get exportBackupSubtitle => '匯出加密備份檔案（.skbak）';

  @override
  String get importRestore => '匯入還原';

  @override
  String get importRestoreSubtitle => '從備份檔案還原資料';

  @override
  String get passwordGeneratorSubtitle => '產生高強度隨機密碼';

  @override
  String get aboutSafeKey => '關於 SafeKey';

  @override
  String appVersionLine(String version, String buildNumber) {
    return '版本 $version（建置 $buildNumber）';
  }

  @override
  String get privacyPolicy => '隱私權政策';

  @override
  String get privacyPolicySubtitle => '我們不收集任何使用者資料';

  @override
  String get aboutContent =>
      'SafeKey 是一款完全本地化的密碼管理工具，採用 AES-256-GCM 加密，不聯網，不收集任何資料。您的隱私和安全是我們唯一的承諾。';

  @override
  String get close => '關閉';

  @override
  String get privacyContent =>
      'SafeKey 不收集、不傳輸、不分析任何使用者資料。\n\n• 所有密碼資料僅儲存在您的裝置本地\n• App 不申請網路存取權限\n• 資料使用 AES-256-GCM 加密儲存\n• 主密碼不以任何形式儲存，僅用於派生加密金鑰\n• 我們無法也不會存取您的資料\n\n您的資料屬於您自己，僅此而已。';

  @override
  String get categorySocial => '社交';

  @override
  String get categoryFinance => '金融';

  @override
  String get categoryShopping => '購物';

  @override
  String get categoryGame => '遊戲';

  @override
  String get categoryOther => '其他';

  @override
  String get language => '語言';

  @override
  String get followSystem => '跟隨系統';

  @override
  String get autoLockImmediate => '立即';

  @override
  String get autoLock1Min => '1 分鐘';

  @override
  String get autoLock5Min => '5 分鐘';

  @override
  String get autoLock15Min => '15 分鐘';

  @override
  String get clipboard15Sec => '15 秒';

  @override
  String get clipboard30Sec => '30 秒';

  @override
  String get clipboard1Min => '1 分鐘';

  @override
  String get clipboardNever => '永不';
}
