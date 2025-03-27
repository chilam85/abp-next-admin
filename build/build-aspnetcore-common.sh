#!/bin/bash

# COMMON PATHS
rootFolder=$(cd "$(dirname "$0")" && pwd)
echo $rootFolder

# List of solutions used only in development mode
declare -A serviceArray
serviceArray[admin]="$rootFolder/../aspnet-core/services/LY.MicroService.BackendAdmin.HttpApi.Host/"
serviceArray[authserver]="$rootFolder/../aspnet-core/services/LY.MicroService.AuthServer/"
serviceArray[authserver_api]="$rootFolder/../aspnet-core/services/LY.MicroService.AuthServer.HttpApi.Host/"
serviceArray[identityserver]="$rootFolder/../aspnet-core/services/LY.MicroService.IdentityServer/"
serviceArray[identityserver4_admin]="$rootFolder/../aspnet-core/services/LY.MicroService.IdentityServer.HttpApi.Host/"
serviceArray[localization]="$rootFolder/../aspnet-core/services/LY.MicroService.LocalizationManagement.HttpApi.Host/"
serviceArray[platform]="$rootFolder/../aspnet-core/services/LY.MicroService.PlatformManagement.HttpApi.Host/"
serviceArray[messages]="$rootFolder/../aspnet-core/services/LY.MicroService.RealtimeMessage.HttpApi.Host/"
serviceArray[task_management]="$rootFolder/../aspnet-core/services/LY.MicroService.TaskManagement.HttpApi.Host/"
serviceArray[webhooks]="$rootFolder/../aspnet-core/services/LY.MicroService.WebhooksManagement.HttpApi.Host/"
serviceArray[workflow]="$rootFolder/../aspnet-core/services/LY.MicroService.WorkflowManagement.HttpApi.Host/"
serviceArray[wechat]="$rootFolder/../aspnet-core/services/LY.MicroService.WechatManagement.HttpApi.Host/"
serviceArray[internal_apigateway]="$rootFolder/../gateways/internal/LINGYUN.MicroService.Internal.ApiGateway/src/LINGYUN.MicroService.Internal.Gateway/"

declare -A solutionArray
solutionArray[All]="$rootFolder/../aspnet-core/LINGYUN.MicroService.All.sln"
solutionArray[Common]="$rootFolder/../aspnet-core/LINGYUN.MicroService.Common.sln"
solutionArray[TaskManagement]="$rootFolder/../aspnet-core/LINGYUN.MicroService.TaskManagement.sln"
solutionArray[WebhooksManagement]="$rootFolder/../aspnet-core/LINGYUN.MicroService.WebhooksManagement.sln"
solutionArray[Workflow]="$rootFolder/../aspnet-core/LINGYUN.MicroService.Workflow.sln"
solutionArray[SingleProject]="$rootFolder/../aspnet-core/LINGYUN.MicroService.SingleProject.sln"
solutionArray[WechatManagement]="$rootFolder/../aspnet-core/LINGYUN.MicroService.WechatManagement.sln"
solutionArray[InternalApiGateway]="$rootFolder/../gateways/internal/LINGYUN.MicroService.Internal.ApiGateway/LINGYUN.MicroService.Internal.ApiGateway.sln"

declare -A migrationArray
migrationArray[Platform]="$rootFolder/../aspnet-core/migrations/LY.MicroService.Platform.DbMigrator"
migrationArray[LocalizationManagement]="$rootFolder/../aspnet-core/migrations/LY.MicroService.LocalizationManagement.DbMigrator"
migrationArray[RealtimeMessage]="$rootFolder/../aspnet-core/migrations/LY.MicroService.RealtimeMessage.DbMigrator"
migrationArray[IdentityServer]="$rootFolder/../aspnet-core/migrations/LY.MicroService.IdentityServer.DbMigrator"
migrationArray[TaskManagement]="$rootFolder/../aspnet-core/migrations/LY.MicroService.TaskManagement.DbMigrator"
migrationArray[AuthServer]="$rootFolder/../aspnet-core/migrations/LY.MicroService.AuthServer.DbMigrator"
migrationArray[WebhooksManagement]="$rootFolder/../aspnet-core/migrations/LY.MicroService.WebhooksManagement.DbMigrator"
migrationArray[BackendAdmin]="$rootFolder/../aspnet-core/migrations/LY.MicroService.BackendAdmin.DbMigrator"
# migrationArray[ApplicationsSingle]="$rootFolder/../aspnet-core/migrations/LY.MicroService.Applications.Single.DbMigrator"

echo ""
echo -e "\033[1m\033[31m\033[43m:::::::::::::: !!! You are in development mode !!! ::::::::::::::\033[0m"
echo ""

# for key in "${!serviceArray[@]}"; do
#   echo "Service: $key, Path: ${serviceArray[$key]}"
# done