#!/bin/bash

# git-switch-clean.sh - 支持 Vue/Vite/React/Angular/.NET/Unity
# 用法: ./git-switch-clean.sh <branch-name>

set -e

if [ $# -eq 0 ]; then
    echo "❌ 请指定要切换的分支名"
    echo "用法: $0 <branch-name>"
    exit 1
fi

BRANCH="$1"

echo "🔄 当前分支: $(git rev-parse --abbrev-ref HEAD)"
echo "➡️  正在切换到分支: $BRANCH"

# 检查未提交更改
if ! git diff-index --quiet HEAD --; then
    echo "⚠️  警告：当前有未提交的更改"
    read -p "是否继续？(y/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        exit 1
    fi
fi

git checkout "$BRANCH" || { echo "❌ 切换失败"; exit 1; }

echo "🧹 清理被 .gitignore 忽略的文件..."
git clean -fdX

# ========== 自动检测项目类型 ==========
CLEANED=false

# --- Unity ---
if [ -f "ProjectSettings/ProjectVersion.txt" ]; then
    echo "🎮 检测到 Unity 项目"
    # Unity 常见生成目录（通常已在 .gitignore，但保险起见）
    for dir in Library Logs Temp Build obj; do
        if [ -d "$dir" ]; then
            echo "  删除 $dir/"
            rm -rf "$dir"
        fi
    done
    CLEANED=true
fi

# --- .NET (包括 MAUI) ---
if [ "$CLEANED" = false ] && (find . -name "*.csproj" -o -name "*.sln" | grep -q .); then
    echo "🔧 检测到 .NET 项目（含 MAUI）"
    dotnet clean 2>/dev/null || true
    dotnet restore
    CLEANED=true
fi

# 清理 .vs（仅当存在时）
if [ -d ".vs" ]; then
    echo "  删除 .vs/（VS 用户缓存）"
    rm -rf .vs
fi

# --- Node.js 生态（Vue/Vite/React/Angular）---
if [ "$CLEANED" = false ] && [ -f "package.json" ]; then
    echo "📦 检测到 Node.js 项目"

    # 读取 package.json 判断框架（可选）
    if command -v jq &> /dev/null; then
        scripts=$(jq -r '.scripts // {} | keys[]' package.json 2>/dev/null || echo "")
        if [[ "$scripts" == *"build"* ]]; then
            echo "  找到 build 脚本，准备重建"
        fi
    fi

    # 清理常见输出目录（即使 git clean 没删干净）
    for dir in dist build out .next cache; do
        if [ -d "$dir" ]; then
            echo "  删除 $dir/"
            rm -rf "$dir"
        fi
    done

    npm install
    CLEANED=true
fi

# --- Angular CLI 特殊处理（可选）---
if [ -f "angular.json" ]; then
    echo "⚛️  检测到 Angular 项目"
    # Angular 默认输出到 dist/project-name，已由上面覆盖
fi

# --- React/Vite/Vue 无需额外操作，依赖 npm install 即可 ---

if [ "$CLEANED" = false ]; then
    echo "ℹ️  未识别项目类型，仅完成基础清理"
fi

echo "✅ 已切换到 '$BRANCH' 并完成环境清理！"
