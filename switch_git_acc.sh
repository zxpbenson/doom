#!/bin/bash

# 检查是否提供了参数
if [ $# -ne 1 ]; then
    echo "使用方法: $0 <文件名 可选项 github,corp>"
    exit 1
fi

ACC=$1
TARGET_DIR=`cd ~; pwd`

echo "ACC=$ACC, TARGET_DIR=$TARGET_DIR"

function delOldGitCfgLink() {
  # 检查文件是否存在
  if [ ! -f "$TARGET_DIR/.gitconfig.$ACC" ]; then
    echo "错误: $TARGET_DIR/.gitconfig.$ACC 不存在"
    exit 1
  fi

  # 如果软链接已存在，先删除
  if [ -L "$TARGET_DIR/.gitconfig" ]; then
    rm "$TARGET_DIR/.gitconfig"
    echo "已删除现有的软链接 $TARGET_DIR/.gitconfig"
  fi
}

case "$1" in
    github)
        delOldGitCfgLink
        echo "switch to github config"
        ln -s "$TARGET_DIR/.gitconfig.$ACC" "$TARGET_DIR/.gitconfig"
        ;;
    corp)
        delOldGitCfgLink
        echo "switch to corp git config"
        ln -s "$TARGET_DIR/.gitconfig.$ACC" "$TARGET_DIR/.gitconfig"
        ;;
    *)
        echo "无效参数，请使用 github | corp"
        exit 1
        ;;
esac


# 创建软链接


echo "================ git config --list ==============>>>"
git config --list
