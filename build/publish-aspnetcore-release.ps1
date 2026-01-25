. "./build-aspnetcore-common.ps1"

# $rootFolder = (Get-Item -Path "../" -Verbose).FullName

# Build all services
foreach ($service in $serviceArray) {  
    $publishPath = $rootFolder + "/../aspnet-core/services/Publish/" + $service.Service
    if (Test-Path $publishPath) {
        Remove-Item $publishPath -Recurse -Force
    }
    dotnet publish -c Release -o $publishPath $service.Path --no-cache
    $dockerFile = Join-Path $service.Path "Dockerfile";
    Write-host "copy dockerFile: $dockerFile"
    if ((Test-Path $dockerFile)) {
        Copy-Item $dockerFile -Destination $publishPath
    }
}

Set-Location $rootFolder