[English](README.md) | [简体中文](README.zh-CN.md)

# SafeKey

A **local-first** password manager: data stays on your device, protected by a master password and **AES-256-GCM**. There is **no cloud sync**. The app supports **Face ID / Touch ID**, Simplified Chinese / Traditional Chinese / English UI, backup import & export, and a password generator.

The shipped app version is defined in `pubspec.yaml` as `version` (e.g. `1.0.1+2` means marketing version **1.0.1** and build number **2**).

## Stack

- Flutter / Dart (see `environment.sdk` in `pubspec.yaml`)
- SQLite (`sqflite`) for encrypted credential records
- Secure storage (`flutter_secure_storage` — Keychain / Keystore)
- Crypto & KDF: `encrypt`, `pointycastle` (PBKDF2, etc.)
- State: `provider`

## Requirements

- [Flutter](https://docs.flutter.dev/get-started/install) installed locally
- **Xcode** for iOS development and App Store builds
- **Android Studio / SDK** for Android work

## Run locally

```bash
cd safe_key
flutter pub get
flutter gen-l10n   # if you changed ARB files; builds often regenerate this
flutter run
```

## iOS release & App Store (optional)

This repo includes **fastlane** and shell automation. Lane details are in [`fastlane/README.md`](fastlane/README.md).

Typical flow:

1. Copy the env template: `cp .env.appstore.example .env.appstore`, then edit with your App Store Connect API key and paths (**do not commit** `.env.appstore`; it is listed in `.gitignore`).
2. From the repo root: `./scripts/deploy_appstore.sh -h` for supported lanes (`build`, `upload_only`, `release`, etc.).
3. If you run fastlane directly in the terminal on macOS, prefer **Homebrew Ruby / Bundler**, or the wrapper [`scripts/fastlane.sh`](scripts/fastlane.sh), so you do not pick up the old system `/usr/bin/bundle`.

## Debug flags

In `lib/src/shared/constants/app_debug_flags.dart`, **`kAlwaysShowOnboardingOnLaunch`** is only for capturing onboarding screenshots. Set it back to **`false`** before shipping.

## Privacy

The product focus is local encryption and privacy; exact wording follows the in-app privacy policy and App Store materials.

## Links

- [Flutter documentation](https://docs.flutter.dev/)
- [fastlane](https://fastlane.tools/)
