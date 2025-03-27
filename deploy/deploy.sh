#!/bin/bash

# 设置脚本的编码（在Bash脚本中通常不需要显式设置编码）
# chcp 65001 是 PowerShell 中设置控制台编码的命令，Bash 中不需要此命令

# 导入公共构建脚本（假设它是一个Bash脚本）
source "../build/build-aspnetcore-common.sh"

for key in "${!serviceArray[@]}"; do
  echo "Service: $key, Path: ${serviceArray[$key]}"
done

# 输出开始部署容器的消息
echo "开始部署容器."

# 定义变量
rootFolder="$(realpath "../")"
deployPath="$rootFolder/deploy"
buildPath="$rootFolder/build"
aspnetcorePath="$rootFolder/aspnet-core"
vuePath="$rootFolder/apps/vue"

echo "root: $rootFolder"

# 部署中间件
echo "deploy middleware..."
cd "$rootFolder"
docker-compose -f ./docker-compose.middleware.yml up -d
# --build 中间件不是自己写的dockerfile，yml中也没有build指令，不用构建

# # 等待180秒，数据库初始化完成
# echo "initial database..."
# sleep 180

# 创建数据库（跑一次）
# echo "create database..."
# cd "$aspnetcorePath"
# bash create-database.sh

# 执行数据库迁移（这段跑一次就好，不用重复跑）
echo "migrate database..."
cd "$buildPath"
for key in "${!migrationArray[@]}"; do
  echo "Service: $key, Path: ${migrationArray[$key]}"
  cd ${migrationArray[$key]}
  dotnet run
#--no-build第一次运行肯定是要build的，运行过一次后就可以视情况加上了
done

# # 发布程序包
# echo "release .net project..."
# cd "$buildPath"
# for service in "${serviceArray[@]}"; do
#     publishPath="$aspnetcorePath/services/Publish/${service#*/}/"
#     dotnet publish -c Release -o "$publishPath" "${service}" --no-cache
#     if [ -f "${service}/Dockerfile" ]; then
#         cp "${service}/Dockerfile" "$publishPath"
#     fi
# done

# # 构建前端项目
# echo "build front project..."
# cd "$vuePath"
# pnpm install
# pnpm build

# # 运行应用程序
# echo "running application..."
# cd "$rootFolder"
# docker-compose -f ./docker-compose.yml -f ./docker-compose.override.yml -f ./docker-compose.override.configuration.yml up -d --build

# cd "$deployPath"
# echo "application is running..."