# Convert-DockerfilesToUtf8-Fast.ps1
param(
    [string]$RootPath = ".",
    [string[]]$ExcludeDirs = @("xx", "node_modules", "bin", "obj", ".git"),
    [switch]$Backup
)

$RootPath = Resolve-Path $RootPath
Write-Host "🔍 扫描目录: $RootPath"
Write-Host "🚫 排除目录: $($ExcludeDirs -join ', ')"

# 构建排除的绝对路径集合（用于快速判断）
$excludePaths = @{}
foreach ($dir in $ExcludeDirs) {
    $fullPath = Join-Path $RootPath $dir
    if (Test-Path $fullPath -PathType Container) {
        $excludePaths[(Resolve-Path $fullPath).Path] = $true
    }
}

# 高速获取所有 Dockerfile（不读内容，不全扫描）
$dockerfiles = @()
foreach ($pattern in @("Dockerfile*", "dockerfile*")) {
    $dockerfiles += Get-ChildItem -Path $RootPath -Recurse -File -Filter $pattern -ErrorAction SilentlyContinue
}

# 过滤掉位于排除目录中的文件（通过父目录路径判断）
$filteredFiles = @()
foreach ($file in $dockerfiles) {
    $inExcluded = $false
    $parent = $file.Directory.FullName
    while ($parent -and $parent.Length -gt $RootPath.Path.Length) {
        if ($excludePaths.ContainsKey($parent)) {
            $inExcluded = $true
            break
        }
        $parent = Split-Path $parent -Parent
    }
    if (-not $inExcluded) {
        $filteredFiles += $file
    }
}

if ($filteredFiles.Count -eq 0) {
    Write-Host "⚠️ 未找到任何 Dockerfile。" -ForegroundColor Yellow
    exit 0
}

Write-Host "✅ 找到 $($filteredFiles.Count) 个 Dockerfile:"
$filteredFiles | ForEach-Object { Write-Host "  - $($_.FullName)" }

$choice = Read-Host "`n是否继续转换为 UTF-8 编码? (y/n)"
if ($choice -ne 'y') { exit 0 }

foreach ($file in $filteredFiles) {
    try {
        if ($Backup) {
            Copy-Item $file.FullName "$($file.FullName).bak" -Force
        }
        $content = Get-Content $file.FullName -Raw
        [System.IO.File]::WriteAllText($file.FullName, $content, [System.Text.UTF8Encoding]::new($false))
        Write-Host "✅ 转换成功: $($file.FullName)"
    }
    catch {
        Write-Host "❌ 失败: $($file.FullName) - $_" -ForegroundColor Red
    }
}

Write-Host "`n🎉 完成！" -ForegroundColor Green