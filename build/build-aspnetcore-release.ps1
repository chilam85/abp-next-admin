. "./build-aspnetcore-common.ps1"

# Build all solutions
foreach ($service in $serviceArray) {    
    Set-Location $service.Path
    $publishPath = $rootFolder + "/../aspnet-core/services/Publish/" + $service.Service
    if (Test-Path $publishPath) {
        Remove-Item $publishPath -Recurse -Force
    }
    dotnet build -c Release -o $publishPath --no-cache --no-restore
    Remove-Item (Join-Path $publishPath "appsettings.Development.json")  -Recurse
    Copy-Item (Join-Path $service.Path "Dockerfile") -Destination $publishPath -Recurse
}

Set-Location $rootFolder
