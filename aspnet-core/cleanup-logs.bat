@echo off
cls
chcp 65001

echo. 清理所有服务日志

del .\services\LY.MicroService.Applications.Single\Logs /Q
del .\services\LY.MicroService.BackendAdmin.HttpApi.Host\Logs /Q
del .\services\LY.MicroService.AuthServer\Logs /Q
del .\services\LY.MicroService.AuthServer.HttpApi.Host\Logs /Q
del .\services\LY.MicroService.identityServer\Logs /Q
del .\services\LY.MicroService.identityServer.HttpApi.Host\Logs /Q
del .\services\LY.MicroService.LocalizationManagement.HttpApi.Host\Logs /Q
del .\services\LY.MicroService.PlatformManagement.HttpApi.Host\Logs /Q
del .\services\LY.MicroService.RealtimeMessage.HttpApi.Host\Logs /Q
del .\services\LY.MicroService.TaskManagement.HttpApi.Host\Logs /Q
del .\services\LY.MicroService.WebhooksManagement.HttpApi.Host\Logs /Q
del .\services\LY.MicroService.WechatManagement.HttpApi.Host\Logs /Q
del .\services\LY.MicroService.WorkflowManagement.HttpApi.Host\Logs /Q

del .\aspire\LINGYUN.Abp.MicroService.AdminService\Logs /Q
del .\aspire\LINGYUN.Abp.MicroService.ApiGateway\Logs /Q
del .\aspire\LINGYUN.Abp.MicroService.AppHost\Logs /Q
del .\aspire\LINGYUN.Abp.MicroService.AuthServer\Logs /Q
del .\aspire\LINGYUN.Abp.MicroService.IdentityService\Logs /Q
del .\aspire\LINGYUN.Abp.MicroService.LocalizationService\Logs /Q
del .\aspire\LINGYUN.Abp.MicroService.MessageService\Logs /Q
del .\aspire\LINGYUN.Abp.MicroService.PlatformService\Logs /Q
del .\aspire\LINGYUN.Abp.MicroService.TaskService\Logs /Q
del .\aspire\LINGYUN.Abp.MicroService.WebhookService\Logs /Q
del .\aspire\LINGYUN.Abp.MicroService.WeChatService\Logs /Q
del .\aspire\LINGYUN.Abp.MicroService.WorkflowService\Logs /Q

del .\aspire\LINGYUN.Abp.MicroService.AdminService.DbMigrator\bin\Debug\net10.0\Logs /Q
del .\aspire\LINGYUN.Abp.MicroService.AuthServer.DbMigrator\bin\Debug\net10.0\Logs /Q
del .\aspire\LINGYUN.Abp.MicroService.LocalizationService.DbMigrator\bin\Debug\net10.0\Logs /Q
del .\aspire\LINGYUN.Abp.MicroService.MessageService.DbMigrator\bin\Debug\net10.0\Logs /Q
del .\aspire\LINGYUN.Abp.MicroService.PlatformService.DbMigrator\bin\Debug\net10.0\Logs /Q
del .\aspire\LINGYUN.Abp.MicroService.TaskService.DbMigrator\bin\Debug\net10.0\Logs /Q
del .\aspire\LINGYUN.Abp.MicroService.WebhookService.DbMigrator\bin\Debug\net10.0\Logs /Q

