. "./build-aspnetcore-common.ps1"

# Build all solutions
foreach ($service in $serviceArray) {  
    Set-Location $service.Path
    dotnet build --no-cache
}

Set-Location $rootFolder

#build生成到aspnet-core\services\Publish目录