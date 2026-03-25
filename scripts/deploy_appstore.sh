#!/usr/bin/env zsh
# ═══════════════════════════════════════════════════════════════════════════════
#  SafeKey — 自动打包 & 提交 App Store 脚本
#
#  用法：
#    ./scripts/deploy_appstore.sh [lane] [选项]
#
#  lane（可选，默认 release）:
#    build        — 仅构建 IPA
#    beta         — 构建并上传 TestFlight
#    upload       — 构建并上传 App Store Connect（不提交审核）
#    release      — 构建、上传并提交审核（默认）
#    beta_only    — 仅上传已有 IPA 到 TestFlight（需先 build，产物在 build/ios/ipa/）
#    upload_only  — 仅上传已有 IPA 到 App Store Connect（不提交审核）
#    release_only — 仅上传已有 IPA 并提交审核
#
#  选项（对齐常见 iOS 脚本习惯，与 pubspec 的 version: x.y.z+build 一致）:
#    -v, --version  营销版本号（CFBundleShortVersionString），不传则用 pubspec 前半段
#    -n, --number   构建号（CFBundleVersion），不传则用 pubspec 的 + 后半段
#    -h, --help     帮助
#
#  示例：
#    ./scripts/deploy_appstore.sh release -v 1.0.2 -n 42
#    ./scripts/deploy_appstore.sh upload --version 1.0.2 --number 42
#    ./scripts/deploy_appstore.sh beta    # 版本号与构建号取自 pubspec.yaml
#
# 关于 fastlane：https://fastlane.tools ，Ruby 发布自动化工具；本仓库逻辑在 fastlane/Fastfile。
# 脚本通过 bundle exec fastlane 按 Gemfile 锁定版本执行，不是 PATH 里任意一个 fastlane。
# ═══════════════════════════════════════════════════════════════════════════════

set -euo pipefail

# Flutter 构建时会跑 pod --version；需 UTF-8，且 PATH 须优先命中可用的 pod（常见：/usr/local 下旧 gem
# 包装脚本与系统 Ruby 不一致 → Flutter 报「CocoaPods 损坏」；Homebrew 的 /opt/homebrew/bin/pod 通常正常）
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
if [[ -d /opt/homebrew/bin ]]; then
  PATH="/opt/homebrew/bin:$PATH"
elif [[ -d /usr/local/bin ]]; then
  PATH="/usr/local/bin:$PATH"
fi
# Homebrew 的 ruby 常为 keg-only，不在 /opt/homebrew/bin；须把其 bin 提前，
# 否则 `bundle` 会落到系统 Ruby，`bundle exec fastlane` 失败并退回 /usr/local/bin/fastlane（旧 gem）。
for _brew_ruby_bin in /opt/homebrew/opt/ruby/bin /usr/local/opt/ruby/bin; do
  if [[ -d "$_brew_ruby_bin" ]]; then
    PATH="$_brew_ruby_bin:$PATH"
    break
  fi
done
export PATH

# ─── 颜色输出 ──────────────────────────────────────────────────────────────────
RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'; BLUE='\033[0;34m'; NC='\033[0m'
info()    { echo "${BLUE}[INFO]${NC} $*"; }
success() { echo "${GREEN}[✓]${NC} $*"; }
warn()    { echo "${YELLOW}[!]${NC} $*"; }
error()   { echo "${RED}[✗]${NC} $*"; exit 1; }

# Ctrl+C：向当前进程组发 SIGINT，避免 fastlane / flutter / xcodebuild 子进程占住前端后「按了没反应」
trap 'trap - INT; printf "\n%b\n" "${YELLOW}[!]${NC} 已中断 (Ctrl+C)" >&2; kill -INT 0 2>/dev/null; exit 130' INT

show_usage() {
  cat <<'EOF'
用法: ./scripts/deploy_appstore.sh [lane] [选项]

lane（可选，默认 release）:
  build | beta | upload | release | beta_only | upload_only | release_only

选项:
  -v, --version   营销版本号（如 1.0.2），默认读 pubspec 的 version: 前半段
  -n, --number    构建号（如 42），默认读 pubspec 的 + 后半段
  -h, --help      显示本帮助

示例:
  ./scripts/deploy_appstore.sh release -v 1.0.2 -n 42
  ./scripts/deploy_appstore.sh upload --version 1.0.2 --number 42
  ./scripts/deploy_appstore.sh beta
  ./scripts/deploy_appstore.sh build && ./scripts/deploy_appstore.sh upload_only
EOF
  exit 0
}

# ─── 路径定位 ──────────────────────────────────────────────────────────────────
SCRIPT_DIR="${0:A:h}"
PROJECT_ROOT="${SCRIPT_DIR}/.."
cd "$PROJECT_ROOT"

# ─── 解析参数 ─────────────────────────────────────────────────────────────────
LANE="release"
BUILD_VERSION_CLI=""
BUILD_NUMBER_CLI=""

while [[ $# -gt 0 ]]; do
  case "$1" in
    -h|--help)
      show_usage
      ;;
    -v|--version)
      [[ -n "${2:-}" ]] || error "选项 $1 需要参数（营销版本号，如 1.0.2）"
      BUILD_VERSION_CLI="$2"
      shift 2
      ;;
    -n|--number)
      [[ -n "${2:-}" ]] || error "选项 $1 需要参数（构建号，如 42）"
      BUILD_NUMBER_CLI="$2"
      shift 2
      ;;
    build|beta|upload|release|beta_only|upload_only|release_only)
      LANE="$1"
      shift
      ;;
    *)
      error "未知参数：$1\n（lane 见 -h：build|beta|upload|release|beta_only|upload_only|release_only）"
      ;;
  esac
done

info "项目根目录: $(pwd)"
info "目标 Lane: $LANE"

# ─── 从 pubspec 读取默认版本（version: x.y.z+build）──────────────────────────
read_version_from_pubspec() {
  local raw
  # 不用 grep|head 管道，避免 set -o pipefail 下 SIGPIPE（退出码 141）
  raw=$(awk '/^version:/{sub(/^version:[[:space:]]+/,""); sub(/[[:space:]]+$/,""); print; exit}' "$PROJECT_ROOT/pubspec.yaml")
  [[ -n "$raw" ]] || error "pubspec.yaml 中未找到 version:"
  if [[ "$raw" == *+* ]]; then
    PUBSPEC_VERSION="${raw%%+*}"
    PUBSPEC_BUILD="${raw#*+}"
  else
    PUBSPEC_VERSION="$raw"
    PUBSPEC_BUILD=""
  fi
}

read_version_from_pubspec
FLUTTER_BUILD_NAME="${BUILD_VERSION_CLI:-$PUBSPEC_VERSION}"
FLUTTER_BUILD_NUMBER="${BUILD_NUMBER_CLI:-$PUBSPEC_BUILD}"

# 仅上传已有 IPA 时，版本以包内为准，不强制要求 pubspec / -v -n
case "$LANE" in
  beta_only|upload_only|release_only)
    ;;
  *)
    [[ -n "$FLUTTER_BUILD_NAME" ]] || error "营销版本号为空（请设置 pubspec 的 version 或使用 -v）"
    [[ -n "$FLUTTER_BUILD_NUMBER" ]] || error "构建号为空：请在 pubspec 使用 version: x.y.z+构建号，或使用 -n 指定"
    export FLUTTER_BUILD_NAME
    export FLUTTER_BUILD_NUMBER
    info "构建版本: $FLUTTER_BUILD_NAME（营销版本） / $FLUTTER_BUILD_NUMBER（构建号）"
    ;;
esac
if [[ "$LANE" == beta_only || "$LANE" == upload_only || "$LANE" == release_only ]]; then
  info "Lane $LANE：使用 build/ios/ipa/*.ipa，跳过重新构建"
fi

# ─── 检查并加载环境变量 ────────────────────────────────────────────────────────
# 密钥与路径只在项目根目录 .env.appstore 中维护（不写进本脚本，避免误提交）。
# ASC_KEY_ID / ASC_ISSUER_ID / ASC_KEY_PATH / APPLE_* 等会 source 进当前 shell；
# 使用 set -a 保证随后赋值的变量会 export，Fastlane 子进程才能读到 ENV[...]。
ENV_FILE="$PROJECT_ROOT/.env.appstore"
if [[ ! -f "$ENV_FILE" ]]; then
  warn "未找到 .env.appstore，请先配置："
  echo ""
  echo "  cp .env.appstore.example .env.appstore"
  echo "  # 编辑 .env.appstore 填入你的 API Key 信息"
  echo ""
  error "缺少 .env.appstore 配置文件"
fi
set -a
# shellcheck source=/dev/null
source "$ENV_FILE"
set +a
success "已加载 .env.appstore（已 export 供 fastlane 使用）"

# ─── 检查必要环境变量 ──────────────────────────────────────────────────────────
check_env() {
  local var="$1"
  local desc="$2"
  if [[ -z "${(P)var:-}" ]]; then
    error "缺少环境变量 $var（$desc）\n请编辑 .env.appstore"
  fi
}

if [[ "$LANE" != "build" ]]; then
  check_env "ASC_KEY_ID"    "App Store Connect API Key ID"
  check_env "ASC_ISSUER_ID" "App Store Connect Issuer ID"
  check_env "ASC_KEY_PATH"  ".p8 密钥文件路径"
  [[ -f "$ASC_KEY_PATH" ]] || error ".p8 文件不存在：$ASC_KEY_PATH"
fi
success "环境变量检查通过"

# ─── 检查依赖工具 ──────────────────────────────────────────────────────────────
info "检查依赖工具..."

case "$LANE" in
  beta_only|upload_only|release_only)
    info "仅上传 lane：跳过 Flutter / Xcode / CocoaPods 检查"
    ;;
  *)
    # Flutter
    if ! command -v flutter &>/dev/null; then
      error "未找到 flutter 命令，请先安装 Flutter SDK\nhttps://docs.flutter.dev/get-started/install/macos"
    fi
    _FLUTTER_VER_OUT=$(flutter --version 2>&1)
    FLUTTER_VERSION="${_FLUTTER_VER_OUT%%$'\n'*}"
    [[ -n "$FLUTTER_VERSION" ]] || error "无法获取 flutter --version"
    success "Flutter: $FLUTTER_VERSION"

    # Xcode
    if ! command -v xcodebuild &>/dev/null; then
      error "未找到 xcodebuild，请安装 Xcode"
    fi
    _XCODE_VER_OUT=$(xcodebuild -version 2>&1)
    XCODE_VERSION="${_XCODE_VER_OUT%%$'\n'*}"
    [[ -n "$XCODE_VERSION" ]] || error "无法获取 xcodebuild -version"
    success "Xcode: $XCODE_VERSION"

    # CocoaPods（与 Flutter 一致：会先执行 pod --version，失败则报「损坏」）
    if [[ -f "$PROJECT_ROOT/ios/Podfile" ]]; then
      POD_BIN="$(command -v pod 2>/dev/null)" || POD_BIN=""
      [[ -n "$POD_BIN" ]] || error "未找到 pod。请安装：brew install cocoapods"
      _pod_ver_check="$("$POD_BIN" --version 2>&1)" || {
        error "pod --version 失败（Flutter 会报 CocoaPods 损坏）。\n  pod 路径: $POD_BIN\n  输出:\n${_pod_ver_check}\n  可尝试: brew reinstall cocoapods；确认 PATH 优先 /opt/homebrew/bin。"
      }
      success "CocoaPods: ${_pod_ver_check} ($POD_BIN)"
    fi
    ;;
esac

# Ruby / Bundler / Fastlane
if ! command -v ruby &>/dev/null; then
  error "未找到 ruby"
fi

# RubyGems 源（缺失时 fastlane / gem 会告警）
if ! gem sources --list 2>/dev/null | grep -qE 'https://rubygems\.org/?$'; then
  info "添加 RubyGems 官方源 https://rubygems.org …"
  gem sources --add https://rubygems.org
fi

# 安装/更新 fastlane（通过 bundler；必须在 Gemfile 目录下执行）
USE_BUNDLE_FASTLANE=0
if [[ -f "$PROJECT_ROOT/Gemfile" ]]; then
  if ! command -v bundle &>/dev/null; then
    info "正在安装 bundler..."
    gem install bundler --no-document
  fi
  info "正在安装/更新 fastlane (via bundler)..."
  (cd "$PROJECT_ROOT" && bundle install --quiet)
  _FL_BIN="$(cd "$PROJECT_ROOT" && bundle exec which fastlane 2>/dev/null)" || _FL_BIN=""
  [[ -n "$_FL_BIN" && -x "$_FL_BIN" ]] || error "bundle exec 找不到 fastlane。\n  请在项目根执行: cd $PROJECT_ROOT && bundle install\n  当前 ruby: $(command -v ruby)\n  当前 bundle: $(command -v bundle)"
  success "fastlane（Bundler）: $_FL_BIN"
  USE_BUNDLE_FASTLANE=1
else
  # 回退到全局 fastlane
  if ! command -v fastlane &>/dev/null; then
    info "正在安装 fastlane..."
    if command -v brew &>/dev/null; then
      brew install fastlane
    else
      gem install fastlane --no-document
    fi
  fi
  success "fastlane（全局）: $(command -v fastlane)"
fi

# ─── 显示构建摘要 ──────────────────────────────────────────────────────────────
echo ""
echo "═══════════════════════════════════════"
echo "  SafeKey 自动发布"
echo "───────────────────────────────────────"
echo "  Lane        : $LANE"
if [[ "$LANE" == beta_only || "$LANE" == upload_only || "$LANE" == release_only ]]; then
  echo "  版本说明     : 以 IPA 内嵌为准（未重新构建）"
else
  echo "  营销版本     : $FLUTTER_BUILD_NAME"
  echo "  构建号      : $FLUTTER_BUILD_NUMBER"
fi
[[ "$LANE" != "build" ]] && echo "  Key ID      : $ASC_KEY_ID"
[[ "$LANE" != "build" ]] && echo "  Team        : ${APPLE_TEAM_ID:-（未设置）}"
echo "  时间        : $(date '+%Y-%m-%d %H:%M:%S')"
echo "═══════════════════════════════════════"
echo ""

# ─── 已有 IPA（仅上传 lane）──────────────────────────────────────────────────
if [[ "$LANE" == beta_only || "$LANE" == upload_only || "$LANE" == release_only ]]; then
  _EXIST_IPA="$(find "$PROJECT_ROOT/build/ios/ipa" -maxdepth 1 -name '*.ipa' 2>/dev/null | head -1)"
  [[ -n "$_EXIST_IPA" ]] || error "未找到 build/ios/ipa/*.ipa。请先执行：./scripts/deploy_appstore.sh build"
  info "将上传已有 IPA: $_EXIST_IPA"
fi

# ─── 确认执行 ─────────────────────────────────────────────────────────────────
# 不用 read '?prompt'（部分环境下对 SIGINT 不友好）；显式 printf + read -r
if [[ "${CI:-0}" != "1" ]]; then
  printf '%b ' "${BLUE}[INFO]${NC} 按 Enter 继续，Ctrl+C 取消... "
  read -r _ || true
  # read 被信号打断时 zsh 可能走这里；trap 会 exit 130
fi

# ─── 记录开始时间 ──────────────────────────────────────────────────────────────
START_TS=$SECONDS

# ─── 执行 Fastlane ─────────────────────────────────────────────────────────────
# 已在项目根 cd，不用子 shell，便于终端 Ctrl+C 与当前进程组一致
info "开始执行 fastlane $LANE ..."
set +e
if [[ "$USE_BUNDLE_FASTLANE" -eq 1 ]]; then
  bundle exec fastlane "$LANE"
else
  fastlane "$LANE"
fi
EXIT_CODE=$?
set -e
# 用户中断：130 = SIGINT，143 = SIGTERM（部分工具）
case "$EXIT_CODE" in
  130|143)
    printf '%b\n' "${YELLOW}[!]${NC} 任务已取消或中断（退出码 $EXIT_CODE）"
    exit 130
    ;;
esac

# ─── 结果报告 ──────────────────────────────────────────────────────────────────
ELAPSED=$(( SECONDS - START_TS ))
MINS=$(( ELAPSED / 60 ))
SECS=$(( ELAPSED % 60 ))

echo ""
if [[ $EXIT_CODE -eq 0 ]]; then
  success "全部完成！耗时 ${MINS}m${SECS}s"
  case "$LANE" in
    build)        info "IPA 位置：$(find build/ios/ipa -name '*.ipa' 2>/dev/null | head -1)" ;;
    beta|beta_only) info "前往 TestFlight 查看：https://appstoreconnect.apple.com" ;;
    upload|upload_only) info "前往 App Store Connect 管理版本：https://appstoreconnect.apple.com" ;;
    release|release_only) info "已提交审核，请在 App Store Connect 跟踪进度：https://appstoreconnect.apple.com" ;;
  esac
else
  error "fastlane $LANE 失败（退出码 $EXIT_CODE），请查看上方日志"
fi
