[English](README.md) | 简体中文

# SafeKey

本地密码管理应用：**数据保存在本机**，使用主密码与 **AES-256-GCM** 加密，**无云端同步**。支持 **Face ID / Touch ID**、简中 / 繁中 / 英文界面、备份导入导出与密码生成器等。

应用版本以 `pubspec.yaml` 中的 `version` 为准（例如 `1.0.1+2` 表示营销版本 **1.0.1**、构建号 **2**）。

## 技术栈

- Flutter / Dart（SDK 要求见 `pubspec.yaml` 的 `environment.sdk`）
- SQLite（`sqflite`）存储加密后的密码条目
- 安全存储（`flutter_secure_storage`，系统 Keychain / Keystore）
- 加密与密钥派生：`encrypt`、`pointycastle`（PBKDF2 等）
- 状态管理：`provider`

## 环境要求

- 本机已安装 [Flutter](https://docs.flutter.dev/get-started/install)
- **Xcode**（开发与发布 **iOS**）
- **Android Studio / SDK**（**Android** 开发与发布）

## 本地运行

```bash
cd safe_key
flutter pub get
flutter gen-l10n   # 若修改了 ARB；通常构建也会自动生成
flutter run
```

## iOS 发布与 App Store（可选）

仓库内提供 **fastlane** 与脚本化流程，lane 说明见 [`fastlane/README.md`](fastlane/README.md)。

常见步骤：

1. 复制环境模板：`cp .env.appstore.example .env.appstore`，填入 App Store Connect API Key 等（**勿提交** `.env.appstore`，已在 `.gitignore` 中）。
2. 在项目根执行：`./scripts/deploy_appstore.sh -h` 查看 lane（如 `build`、`upload_only`、`release` 等）。
3. 终端直接跑 fastlane 时，在 macOS 上请使用 **Homebrew 的 Ruby / Bundler**，或使用 [`scripts/fastlane.sh`](scripts/fastlane.sh)，避免命中系统自带的旧版 `bundle`。

## 调试开关

`lib/src/shared/constants/app_debug_flags.dart` 中的 **`kAlwaysShowOnboardingOnLaunch`** 仅用于截取引导页等素材，**发布前请设为 `false`**。

## 隐私

产品定位为本地加密与隐私优先；具体表述以应用内隐私政策与 App Store 材料为准。

## 相关链接

- [Flutter 文档](https://docs.flutter.dev/)
- [fastlane](https://fastlane.tools/)
