$rootFolder = (Get-Item -Path "./" -Verbose).FullName
Write-host "当前工作目录: $rootFolder"

$vuePath = Join-Path $rootFolder "../apps/vben5"
$antdPath = Join-Path $vuePath "/apps/app-antd"
$publishPath = Join-Path $rootFolder "../aspnet-core/services/Publish/client"
$distPath = Join-Path $rootFolder "../aspnet-core/services/Publish/client/dist"
$dockerPath = Join-Path $rootFolder "../aspnet-core/services/Publish/client/docker"

if (Test-Path (Join-Path $antdPath "dist")) {
    Remove-Item (Join-Path $antdPath "dist")  -Recurse
}   
if (Test-Path $publishPath) {   
    Remove-Item $publishPath  -Recurse
}

Set-Location $vuePath
Write-host "转到目录: $vuePath"
Write-host "开始构建前端UI应用界面"

# CMD /c yarn
# CMD /c yarn build
pnpm install
pnpm build

Write-host "前端UI应用界面构建完成,拷贝到输出目录"
Copy-Item -Path (Join-Path $antdPath "dist") -Destination $distPath -Recurse
Copy-Item -Path (Join-Path $antdPath "docker") -Destination $dockerPath -Recurse
Copy-Item (Join-Path $antdPath "Dockerfile") -Destination $publishPath

Set-Location $rootFolder