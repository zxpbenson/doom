#!/usr/bin/env bash

show_help() {
  cat <<EOF
Usage:
  $0 -v <jdk_version> [options]

Options:
  -v, --version              JDK version (8, 11, 17, 21, 25)
  -h, --help                 显示帮助

Example:
  $0 -v 8
  $0 -v 17
EOF
}

VERSION=""
# TARGET_DIR=`cd ~/software/; pwd`
TARGET_DIR="$HOME/software"

while [[ $# -gt 0 ]]; do
  case "$1" in
    -v|--version) VERSION="$2"; shift 2 ;;
    -h|--help) show_help; exit 0 ;;
    *) echo "Unknown option: $1"; show_help; exit 1 ;;
  esac
done

if [[ -z "$VERSION" ]]; then
  echo "Error: JDK version is required"
  show_help
  exit 1
fi

echo "LTS Version List : 8，11，17，21，25"
echo "VER=$VERSION, TARGET_DIR=$TARGET_DIR"

delOldJdkLink() {
  # 如果软链接已存在，先删除
  if [ -L "$TARGET_DIR/jdk" ]; then
    rm "$TARGET_DIR/jdk"
    echo "已删除现有的软链接 $TARGET_DIR/jdk"
  fi
}

case "$VERSION" in
    8)
        delOldJdkLink
        echo "switch to jdk8"
        ln -s "$TARGET_DIR/jdk1.8.0_261.jdk" "$TARGET_DIR/jdk"
        ;;
    11)
        delOldJdkLink
        echo "switch to jdk11"
        ln -s "$TARGET_DIR/jdk-11.0.26.jdk" "$TARGET_DIR/jdk"
        ;;
    17)
        delOldJdkLink
        echo "switch to jdk17"
        ln -s "$TARGET_DIR/jdk-17.0.14.jdk" "$TARGET_DIR/jdk"
        ;;
    21)
        delOldJdkLink
        echo "switch to jdk21"
        ln -s "$TARGET_DIR/jdk-21.0.6.jdk" "$TARGET_DIR/jdk"
        ;;
    25)
        delOldJdkLink
        echo "switch to jdk25"
        ln -s "$TARGET_DIR/jdk-25.0.1.jdk" "$TARGET_DIR/jdk"
        ;;
    *)
        echo "无效参数: $VERSION，请使用 8 | 11 | 17 | 21 | 25"
        exit 1
        ;;
esac

echo "================ java -version ==============>>>"
java -version
