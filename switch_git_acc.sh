#!/usr/bin/env bash

show_help() {
  cat <<EOF
Usage:
  $0 -a <account_type> [options]

Options:
  -a, --account              Account type (github, corp)
  -h, --help                 显示帮助

Example:
  $0 -a github
  $0 -a corp
EOF
}

ACCOUNT=""
TARGET_DIR="$HOME"

while [[ $# -gt 0 ]]; do
  case "$1" in
    -a|--account) ACCOUNT="$2"; shift 2 ;;
    -h|--help) show_help; exit 0 ;;
    *) echo "Unknown option: $1"; show_help; exit 1 ;;
  esac
done

if [[ -z "$ACCOUNT" ]]; then
  echo "Error: account type is required"
  show_help
  exit 1
fi

echo "ACC=$ACCOUNT, TARGET_DIR=$TARGET_DIR"

delOldGitCfgLink() {
  # 检查文件是否存在
  if [ ! -f "$TARGET_DIR/.gitconfig.$ACCOUNT" ]; then
    echo "错误: $TARGET_DIR/.gitconfig.$ACCOUNT 不存在"
    exit 1
  fi

  # 如果软链接已存在，先删除
  if [ -L "$TARGET_DIR/.gitconfig" ]; then
    rm "$TARGET_DIR/.gitconfig"
    echo "已删除现有的软链接 $TARGET_DIR/.gitconfig"
  fi
}

case "$ACCOUNT" in
    github)
        delOldGitCfgLink
        echo "switch to github config"
        ln -s "$TARGET_DIR/.gitconfig.$ACCOUNT" "$TARGET_DIR/.gitconfig"
        ;;
    corp)
        delOldGitCfgLink
        echo "switch to corp git config"
        ln -s "$TARGET_DIR/.gitconfig.$ACCOUNT" "$TARGET_DIR/.gitconfig"
        ;;
    *)
        echo "无效参数: $ACCOUNT，请使用 github | corp"
        exit 1
        ;;
esac

echo "================ git config --list ==============>>>"
git config --list
