#!/usr/bin/env zsh
# 与 deploy_appstore.sh 一致：把 Homebrew Ruby / bundler 放在 PATH 前，
# 避免 macOS 默认的 /usr/bin/bundle（Ruby 2.6）与 Gemfile.lock 的 BUNDLED WITH 2.6.x 不匹配。
# 用法：./scripts/fastlane.sh upload_only
# 上传类 lane 会自动加载项目根 .env.appstore（若存在）。

set -euo pipefail

ROOT="${0:A:h}/.."
cd "$ROOT"

export LANG="${LANG:-en_US.UTF-8}"
export LC_ALL="${LC_ALL:-en_US.UTF-8}"

if [[ -d /opt/homebrew/bin ]]; then
  PATH="/opt/homebrew/bin:$PATH"
elif [[ -d /usr/local/bin ]]; then
  PATH="/usr/local/bin:$PATH"
fi
for _brew_ruby_bin in /opt/homebrew/opt/ruby/bin /usr/local/opt/ruby/bin; do
  if [[ -d "$_brew_ruby_bin" ]]; then
    PATH="$_brew_ruby_bin:$PATH"
    break
  fi
done
export PATH

_needs_asc=0
for _a in "$@"; do
  case "$_a" in
    beta|upload|release|beta_only|upload_only|release_only)
      _needs_asc=1
      ;;
  esac
done

_ENV_FILE="$ROOT/.env.appstore"
if [[ "$_needs_asc" -eq 1 ]]; then
  if [[ ! -f "$_ENV_FILE" ]]; then
    echo "[✗] 上传类 lane 需要配置 $_ENV_FILE（可先复制 .env.appstore.example）" >&2
    exit 1
  fi
  set -a
  # shellcheck source=/dev/null
  source "$_ENV_FILE"
  set +a
fi

exec bundle exec fastlane "$@"
