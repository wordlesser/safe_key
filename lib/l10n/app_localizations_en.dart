// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'SafeKey';

  @override
  String get welcomeSlide1Title => 'Offline Encrypted Storage';

  @override
  String get welcomeSlide1Subtitle =>
      'All data is encrypted with AES-256-GCM\nstored locally on your device, never online';

  @override
  String get welcomeSlide2Title => 'Face ID / Touch ID';

  @override
  String get welcomeSlide2Subtitle =>
      'Unlock quickly with biometrics\nno need to enter master password each time';

  @override
  String get welcomeSlide3Title => 'No Registration, No Internet';

  @override
  String get welcomeSlide3Subtitle =>
      'Your data belongs only to you\nthe app requires no network permissions';

  @override
  String get getStarted => 'Get Started';

  @override
  String get nextStep => 'Next';

  @override
  String get setupMasterPasswordTitle => 'Set Master Password';

  @override
  String get setupFailed => 'Setup failed, please try again';

  @override
  String get masterPasswordIsYourOnly =>
      'Master password is your only safeguard';

  @override
  String get masterPasswordWarning =>
      'The master password cannot be recovered. Please remember it. We recommend using a combination of upper/lowercase letters, numbers and symbols.';

  @override
  String get masterPassword => 'Master Password';

  @override
  String get atLeast6CharsHint => 'At least 6 characters';

  @override
  String get enterMasterPasswordError => 'Please enter master password';

  @override
  String get masterPasswordTooShortError =>
      'Master password must be at least 6 characters';

  @override
  String get confirmMasterPassword => 'Confirm Master Password';

  @override
  String get reEnterMasterPasswordHint => 'Re-enter master password';

  @override
  String get confirmMasterPasswordError => 'Please confirm master password';

  @override
  String get passwordMismatchError => 'Passwords do not match';

  @override
  String get completeSetup => 'Complete Setup';

  @override
  String lockedOutMessage(int count, int minutes) {
    return 'Wrong password $count times, locked for $minutes minutes';
  }

  @override
  String passwordWrongRemaining(int remaining) {
    return 'Wrong password, $remaining attempts remaining';
  }

  @override
  String durationMinSec(int m, int s) {
    return '${m}m ${s}s';
  }

  @override
  String durationSec(int s) {
    return '${s}s';
  }

  @override
  String get enterMasterPasswordToUnlock => 'Enter master password to unlock';

  @override
  String failedAttemptsWarning(int failed, int remaining) {
    return 'Failed $failed times, locked after $remaining more wrong attempts (30 min)';
  }

  @override
  String get unlock => 'Unlock';

  @override
  String get useFaceIdTouchId => 'Use Face ID / Touch ID';

  @override
  String get appLockedHint => 'Your vault is locked';

  @override
  String get tapToUnlockBiometric => 'Tap to unlock';

  @override
  String get verifying => 'Verifying…';

  @override
  String get usePasswordInstead => 'Use password instead';

  @override
  String get switchToFaceId => 'Use Face ID';

  @override
  String biometricFailedHint(int count, int left) {
    return 'Failed $count time(s), $left more failure(s) will switch to password';
  }

  @override
  String get biometricFailedAutoSwitched =>
      'Face ID failed, switched to password unlock';

  @override
  String get accountLocked => 'Account Locked';

  @override
  String get accountLockedDesc =>
      'Too many wrong passwords (5 times), account is temporarily locked';

  @override
  String remainingTime(String time) {
    return 'Remaining: $time';
  }

  @override
  String get addPasswordTooltip => 'Add Password';

  @override
  String get searchHint => 'Search name, account, notes...';

  @override
  String get allCategories => 'All';

  @override
  String get copyUsername => 'Copy Username';

  @override
  String get copyPassword => 'Copy Password';

  @override
  String get edit => 'Edit';

  @override
  String get delete => 'Delete';

  @override
  String get deleteConfirmTitle => 'Confirm Delete';

  @override
  String deleteConfirmContent(String name) {
    return 'Delete password record for \"$name\"? This cannot be undone.';
  }

  @override
  String deleteConfirmContentShort(String name) {
    return 'Delete \"$name\"? This cannot be undone.';
  }

  @override
  String get cancel => 'Cancel';

  @override
  String deletedEntry(String name) {
    return 'Deleted \"$name\"';
  }

  @override
  String get noMatchingPasswords => 'No matching passwords found';

  @override
  String get noPasswordsYet => 'No passwords yet';

  @override
  String get tryOtherKeywords => 'Try other keywords';

  @override
  String get tapPlusToAdd => 'Tap + to add your first password';

  @override
  String get addPassword => 'Add Password';

  @override
  String get editPassword => 'Edit Password';

  @override
  String get save => 'Save';

  @override
  String savedEntry(String name) {
    return 'Saved \"$name\"';
  }

  @override
  String updatedEntry(String name) {
    return 'Updated \"$name\"';
  }

  @override
  String get saveFailed => 'Save failed, please try again';

  @override
  String get nameLabel => 'Name *';

  @override
  String get nameHint => 'e.g. Twitter, Gmail';

  @override
  String get nameRequired => 'Please enter a name';

  @override
  String get usernameLabel => 'Account / Username *';

  @override
  String get usernameHint => 'Phone, email or username';

  @override
  String get usernameRequired => 'Please enter account';

  @override
  String get passwordLabel => 'Password *';

  @override
  String get passwordHint => 'Enter or generate password';

  @override
  String get generatorTooltip => 'Password Generator';

  @override
  String get passwordRequired => 'Please enter password';

  @override
  String get urlLabel => 'URL (optional)';

  @override
  String get noteLabel => 'Note (optional)';

  @override
  String get noteHint => 'Other info...';

  @override
  String get categoryLabel => 'Category';

  @override
  String get editTooltip => 'Edit';

  @override
  String get deleteTooltip => 'Delete';

  @override
  String get usernameFieldLabel => 'Account';

  @override
  String get passwordFieldLabel => 'Password';

  @override
  String get urlFieldLabel => 'URL';

  @override
  String get noteFieldLabel => 'Note';

  @override
  String get createdAt => 'Created';

  @override
  String get updatedAt => 'Updated';

  @override
  String get passwordGenerator => 'Password Generator';

  @override
  String get length => 'Length';

  @override
  String get uppercase => 'Uppercase';

  @override
  String get lowercase => 'Lowercase';

  @override
  String get digits => 'Digits';

  @override
  String get specialChars => 'Special Characters';

  @override
  String get regenerate => 'Regenerate';

  @override
  String get useThisPassword => 'Use This Password';

  @override
  String get copy => 'Copy';

  @override
  String get passwordCopied => 'Password copied';

  @override
  String get copied => 'Copied';

  @override
  String copiedLabel(String label) {
    return '$label Copied';
  }

  @override
  String get strengthWeak => 'Weak';

  @override
  String get strengthMedium => 'Medium';

  @override
  String get strengthStrong => 'Strong';

  @override
  String get strengthVeryStrong => 'Very Strong';

  @override
  String get settings => 'Settings';

  @override
  String get sectionSecurity => 'Security';

  @override
  String get sectionPreferences => 'Preferences';

  @override
  String get sectionDataManagement => 'Data Management';

  @override
  String get sectionTools => 'Tools';

  @override
  String get sectionAbout => 'About';

  @override
  String get biometricSubtitleEnabled => 'Quick unlock, no password needed';

  @override
  String get biometricSubtitleDisabled =>
      'Biometrics not supported on this device';

  @override
  String get biometricEnabledMsg => 'Face ID / Touch ID enabled';

  @override
  String get biometricDisabledMsg => 'Biometrics disabled';

  @override
  String get biometricNotAvailable =>
      'Device doesn\'t support biometrics or none enrolled\n(Simulator: Features → Face ID → Enrolled)';

  @override
  String get autoLock => 'Auto Lock';

  @override
  String autoLockSeconds(int s) {
    return '${s}s';
  }

  @override
  String get changeMasterPassword => 'Change Master Password';

  @override
  String get autoLockTimePicker => 'Auto Lock Time';

  @override
  String get currentMasterPasswordHint => 'Current master password';

  @override
  String get newMasterPasswordHint => 'New master password (at least 6 chars)';

  @override
  String get enterCurrentMasterPasswordError =>
      'Please enter current master password';

  @override
  String get enterNewPasswordError => 'Please enter new password';

  @override
  String get atLeast6CharsError => 'At least 6 characters';

  @override
  String get passwordsNotMatchError => 'Passwords do not match';

  @override
  String get confirmNewMasterPasswordHint => 'Confirm new master password';

  @override
  String get masterPasswordUpdated => 'Master password updated';

  @override
  String get wrongCurrentPassword => 'Wrong current password, please try again';

  @override
  String get clipboardAutoClear => 'Clipboard Auto-Clear';

  @override
  String clipboardClearAfter(String label) {
    return 'Clear $label after copying password';
  }

  @override
  String get clipboardClearTimePicker => 'Clipboard Clear Time';

  @override
  String get backupExportSubject => 'SafeKey Backup File';

  @override
  String exportFailed(String error) {
    return 'Export failed: $error';
  }

  @override
  String importSuccess(int count) {
    return 'Successfully restored $count password records';
  }

  @override
  String get importFailed =>
      'Import failed. Please verify the file format and master password';

  @override
  String get importModeTitle => 'Choose Import Mode';

  @override
  String get importModeMessage =>
      'Merge: Keep existing data and skip duplicate entries from the backup.\n\nReplace All: Delete all existing data and fully restore from the backup.';

  @override
  String get importModeMerge => 'Merge';

  @override
  String get importModeReplace => 'Replace All';

  @override
  String get importReplaceWarning =>
      'This will permanently delete all existing passwords and cannot be undone. Continue?';

  @override
  String get exportBackup => 'Export Backup';

  @override
  String get exportBackupSubtitle => 'Export encrypted backup file (.skbak)';

  @override
  String get importRestore => 'Import & Restore';

  @override
  String get importRestoreSubtitle => 'Restore data from backup file';

  @override
  String get passwordGeneratorSubtitle =>
      'Generate high-strength random passwords';

  @override
  String get aboutSafeKey => 'About SafeKey';

  @override
  String appVersionLine(String version, String buildNumber) {
    return 'Version $version (build $buildNumber)';
  }

  @override
  String get privacyPolicy => 'Privacy Policy';

  @override
  String get privacyPolicySubtitle => 'We collect no user data';

  @override
  String get aboutContent =>
      'SafeKey is a fully offline password manager using AES-256-GCM encryption, no internet, no data collection. Your privacy and security are our only commitment.';

  @override
  String get close => 'Close';

  @override
  String get privacyContent =>
      'SafeKey does not collect, transmit or analyze any user data.\n\n• All password data is stored locally on your device\n• The app requires no network access permission\n• Data is encrypted with AES-256-GCM\n• The master password is never stored, only used to derive encryption keys\n• We cannot and will not access your data\n\nYour data belongs to you, and only you.';

  @override
  String get categorySocial => 'Social';

  @override
  String get categoryFinance => 'Finance';

  @override
  String get categoryShopping => 'Shopping';

  @override
  String get categoryGame => 'Gaming';

  @override
  String get categoryOther => 'Other';

  @override
  String get language => 'Language';

  @override
  String get followSystem => 'Follow System';

  @override
  String get autoLockImmediate => 'Immediately';

  @override
  String get autoLock1Min => '1 minute';

  @override
  String get autoLock5Min => '5 minutes';

  @override
  String get autoLock15Min => '15 minutes';

  @override
  String get clipboard15Sec => '15 sec';

  @override
  String get clipboard30Sec => '30 sec';

  @override
  String get clipboard1Min => '1 min';

  @override
  String get clipboardNever => 'Never';
}
