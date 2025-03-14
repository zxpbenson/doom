#!/bin/bash

# 检查是否提供了参数
if [ $# -ne 1 ]; then
    echo "使用方法: $0 <jdk-version> (只有 8，23 可选)"
    exit 1
fi

VER=$1
TARGET_DIR=`cd ~/software/; pwd` 

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
    23)
        delOldJdkLink
        echo "switch to jdk23"
        ln -s $TARGET_DIR/jdk-23.0.2.jdk $TARGET_DIR/jdk
        ;;
    *)
        echo "无效参数，请使用 8 | 23"
        exit 1
        ;;
esac

echo "================ java -version ==============>>>"
java -version

