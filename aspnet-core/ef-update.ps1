Set-Location ".\migrations\LY.MicroService.BackendAdmin.EntityFrameworkCore"
dotnet ef database update

Set-Location ".\migrations\LY.MicroService.Platform.EntityFrameworkCore"
dotnet ef database update

Set-Location ".\migrations\LY.MicroService.LocalizationManagement.EntityFrameworkCore"
dotnet ef database update

Set-Location ".\migrations\LY.MicroService.RealtimeMessage.EntityFrameworkCore"
dotnet ef database update

Set-Location ".\migrations\LY.MicroService.IdentityServer.EntityFrameworkCore"
dotnet ef database update

Set-Location ".\migrations\LY.MicroService.TaskManagement.EntityFrameworkCore"
dotnet ef database update

Set-Location ".\migrations\LY.MicroService.AuthServer.EntityFrameworkCore"
dotnet ef database update

Set-Location ".\migrations\LY.MicroService.WebhooksManagement.EntityFrameworkCore"
dotnet ef database update

#单数据库时用这一个就够了
Set-Location ".\migrations\LY.MicroService.Applications.Single.EntityFrameworkCore.PostgreSql"
dotnet ef database update