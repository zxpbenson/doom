#!/bin/bash

# 检查是否提供了参数
if [ $# -ne 1 ]; then
    echo "使用方法: $0 <jdk-version> (只有 8，11，17，21，23，24 可选)"
    exit 1
fi

VER=$1
TARGET_DIR=`cd ~/software/; pwd`  # 这里换成你自己的目录

echo "LTS Version List : 8，11，17，21，25(未发布)"
echo "VER=$VER, TARGET_DIR=$TARGET_DIR"

function delOldJdkLink() {
# 如果软链接已存在，先删除
  if [ -L "$TARGET_DIR/jdk" ]; then
    unlink "$TARGET_DIR/jdk"
    echo "已删除现有的软链接 $TARGET_DIR/jdk"
  fi
}

case "$1" in
    8)
        delOldJdkLink
        echo "switch to jdk8"
        ln -s $TARGET_DIR/jdk1.8.0_261.jdk $TARGET_DIR/jdk
        ;;
    11)
        delOldJdkLink
        echo "switch to jdk11"
        ln -s $TARGET_DIR/jdk-11.0.26.jdk $TARGET_DIR/jdk
        ;;
    17)
        delOldJdkLink
        echo "switch to jdk17"
        ln -s $TARGET_DIR/jdk-17.0.14.jdk $TARGET_DIR/jdk
        ;;
    21)
        delOldJdkLink
        echo "switch to jdk21"
        ln -s $TARGET_DIR/jdk-21.0.6.jdk $TARGET_DIR/jdk
        ;;
    23)
        delOldJdkLink
        echo "switch to jdk23"
        ln -s $TARGET_DIR/jdk-23.0.2.jdk $TARGET_DIR/jdk
        ;;
    24)
        delOldJdkLink
        echo "switch to jdk23"
        ln -s $TARGET_DIR/jdk-24.jdk $TARGET_DIR/jdk
        ;;
    *)
        echo "无效参数，请使用 8 | 11 | 17 | 21 | 23 | 24"
        exit 1
        ;;
esac

echo "================ java -version ==============>>>"
java -version

