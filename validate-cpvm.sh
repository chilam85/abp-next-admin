#!/bin/bash
# validate-and-fix-cpvm.sh

set -euo pipefail

SOLUTION_ROOT="${1:-.}"
PACKAGES_PROPS="$SOLUTION_ROOT/Directory.Packages.props"

# 默认排除目录（小写）
EXCLUDE_DIRS=("tests" "test" "templates" "template" "examples" "samples" "benchmarks" "tools")

echo "🔍 开始验证 CPVM 完整性（排除: ${EXCLUDE_DIRS[*]}）..."

# Step 1: 检查 Directory.Packages.props 是否存在
if [ ! -f "$PACKAGES_PROPS" ]; then
    echo "❌ 未找到 Directory.Packages.props: $PACKAGES_PROPS"
    exit 1
fi

# Step 2: 提取已声明的包 ID（忽略大小写差异，但保留原始）
declare -A DECLARED_PACKAGES
while IFS= read -r line; do
    if [[ $line =~ \<PackageVersion[[:space:]]+Include=[\"\']([^\"\'\>]+)[\"\'] ]]; then
        pkg="${BASH_REMATCH[1]}"
        DECLARED_PACKAGES["$pkg"]=1
    fi
done < <(grep -h '<PackageVersion\s\+Include=' "$PACKAGES_PROPS" || true)

echo "📦 已在 Directory.Packages.props 中声明 ${#DECLARED_PACKAGES[@]} 个包"

# Step 3: 构建排除正则（用于 find）
exclude_pattern=""
for dir in "${EXCLUDE_DIRS[@]}"; do
    if [ -z "$exclude_pattern" ]; then
        exclude_pattern="-name $dir"
    else
        exclude_pattern="$exclude_pattern -o -name $dir"
    fi
done

# Step 4: 查找所有 .csproj，跳过排除目录
mapfile -d '' csproj_files < <(
    find "$SOLUTION_ROOT" -type f -name "*.csproj" \
        $([ -n "$exclude_pattern" ] && echo "-not ( $exclude_pattern )" ) \
        -print0
)

VIOLATIONS=()
MISSING_PACKAGES=()
VERSION_ATTR_FOUND=false

for proj in "${csproj_files[@]}"; do
    # 获取相对于 SOLUTION_ROOT 的路径（用于判断是否在排除目录中）
    rel_path="${proj#$SOLUTION_ROOT/}"
    
    # 再次确保不在排除目录（find 可能不够精确）
    skip=false
    for excl in "${EXCLUDE_DIRS[@]}"; do
        if [[ "$rel_path" == "$excl"/* ]] || [[ "$rel_path" == "$excl" ]]; then
            skip=true
            break
        fi
    done
    if [ "$skip" = true ]; then
        continue
    fi

    # 检查是否包含 Version= （NU1008 违规）
    if grep -qP '<PackageReference[^>]*Version\s*=\s*["'\''][^"'\'']' "$proj"; then
        VIOLATIONS+=("❌ [$proj] 包含禁止的 Version 属性")
        VERSION_ATTR_FOUND=true
    fi

    # 提取所有 Include="..."
    while IFS= read -r pkg; do
        if [[ -n "$pkg" ]]; then
            if [[ -z "${DECLARED_PACKAGES[$pkg]+x}" ]]; then
                MISSING_PACKAGES["$pkg"]=1
                VIOLATIONS+=("⚠️ [$proj] 引用了未声明的包: $pkg")
            fi
        fi
    done < <(grep -oP '<PackageReference\s+Include=["'\'']\K[^"'\'']+(?=["'\'']/>)' "$proj" 2>/dev/null || true)
done

# Step 5: 输出结果
if [ ${#VIOLATIONS[@]} -gt 0 ]; then
    echo
    echo "🚨 发现 ${#VIOLATIONS[@]} 个 CPVM 问题："
    for v in "${VIOLATIONS[@]}"; do
        echo "$v"
    done

    if [ ${#MISSING_PACKAGES[@]} -gt 0 ]; then
        echo
        echo "✨ 请将以下内容添加到 Directory.Packages.props 的 <ItemGroup> 中："
        echo ""
        for pkg in $(printf '%s\n' "${!MISSING_PACKAGES[@]}" | sort); do
            echo "    <PackageVersion Include=\"$pkg\" Version=\"\$(PackageVersion)\" />"
        done
        echo ""
    fi

    if [ "$VERSION_ATTR_FOUND" = true ]; then
        echo "🔧 提示：请删除所有 .csproj 中 PackageReference 的 Version 属性！"
    fi

    exit 1
else
    echo "✅ CPVM 验证通过！所有引用均符合规范。"
    exit 0
fi