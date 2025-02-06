#!/bin/bash

# 检查是否提供了参数
if [ $# -ne 1 ]; then
    echo "使用方法: $0 <文件名>"
    exit 1
fi

ACC=$1
TARGET_DIR=`cd ~; pwd`  # 请替换为实际存放 .a 和 .b 文件的目录

echo "ACC=$ACC, TARGET_DIR=$TARGET_DIR"

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

# 创建软链接
ln -s "$TARGET_DIR/.gitconfig.$ACC" "$TARGET_DIR/.gitconfig"
echo "软链接 $TARGET_DIR/.gitconfig.$ACC -> $TARGET_DIR/.gitconfig 创建成功"

echo "================ git config --list ==============>>>"
git config --list
