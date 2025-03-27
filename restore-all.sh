#!/bin/bash

# 查找当前目录及其子目录中的所有 .csproj 文件
find . -type f -name "*.csproj" -exec dirname {} \; | sort -u | while read -r dir; do
    # 在每个找到的 .csproj 文件的目录中运行 dotnet restore
    (cd "$dir" && dotnet restore)
done