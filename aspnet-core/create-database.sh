#!/bin/bash

# 清除屏幕
clear

# 执行迁移命令
./migrate-db-cmd.sh LY.MicroService.Platform.EntityFrameworkCore platform --ef-u
./migrate-db-cmd.sh LY.MicroService.BackendAdmin.EntityFrameworkCore admin --ef-u
./migrate-db-cmd.sh LY.MicroService.AuthServer.EntityFrameworkCore auth-server --ef-u
./migrate-db-cmd.sh LY.MicroService.IdentityServer.EntityFrameworkCore identityserver4-admin --ef-u
./migrate-db-cmd.sh LY.MicroService.LocalizationManagement.EntityFrameworkCore localization --ef-u
./migrate-db-cmd.sh LY.MicroService.RealtimeMessage.EntityFrameworkCore messages --ef-u
./migrate-db-cmd.sh LY.MicroService.TaskManagement.EntityFrameworkCore task-management --ef-u
./migrate-db-cmd.sh LY.MicroService.WebhooksManagement.EntityFrameworkCore webhooks-management --ef-u

# 强制终止所有dotnet进程
pkill -f dotnet.exe