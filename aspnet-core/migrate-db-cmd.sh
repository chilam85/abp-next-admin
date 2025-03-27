#!/bin/bash

# 设置字符编码（如果需要，可以根据具体情况调整）
# export LC_ALL=en_US.UTF-8
# export LANG=en_US.UTF-8

# 标题参数
TITLE=$2

# 显示迁移信息
echo "$TITLE migrating"

# 切换到目标目录
MIGRATION_DIR="./migrations/$1"
cd "$MIGRATION_DIR" || { echo "Failed to change directory to $MIGRATION_DIR"; exit 1; }

# 获取第三个参数
ACTION=$3

# 根据参数执行不同的操作
case "$ACTION" in
    "--run")
        dotnet run --no-build
        ;;
    "--restore")
        dotnet restore
        ;;
    "--ef-u")
        dotnet ef database update
        ;;
    "")
        dotnet run --no-build
        ;;
    *)
        echo "Unknown action: $ACTION"
        exit 1
        ;;
esac

# 返回到原始目录
cd ../../

# 显示迁移完成信息
echo "$TITLE migrated"
echo "--------"