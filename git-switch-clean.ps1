# Git-SwitchClean.ps1 - 支持 Vue/Vite/React/Angular/.NET/Unity
# 用法: .\Git-SwitchClean.ps1 -Branch "feat/login"

param(
    [Parameter(Mandatory=$true)]
    [string]$Branch
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

Write-Host "🔄 当前分支: $(git rev-parse --abbrev-ref HEAD)" -ForegroundColor Cyan
Write-Host "➡️  正在切换到分支: $Branch" -ForegroundColor Yellow

# 检查未暂存更改
if (git status --porcelain | Where-Object { $_ -notmatch '^??' }) {
    Write-Warning "当前有未提交的更改"
    $confirm = Read-Host "是否继续？(y/N)"
    if ($confirm -notlike "y*") { exit 1 }
}

git checkout $Branch
if ($LASTEXITCODE -ne 0) { Write-Error "❌ 切换失败"; exit 1 }

Write-Host "🧹 清理被 .gitignore 忽略的文件..." -ForegroundColor Magenta
git clean -fdX

$cleaned = $false

# --- Unity ---
if (Test-Path "ProjectSettings/ProjectVersion.txt") {
    Write-Host "🎮 检测到 Unity 项目" -ForegroundColor Green
    @("Library", "Logs", "Temp", "Build", "obj") | ForEach-Object {
        if (Test-Path $_) {
            Write-Host "  删除 $_/" -ForegroundColor Gray
            Remove-Item -Recurse -Force $_
        }
    }
    $cleaned = $true
}

# --- .NET (including MAUI) ---
if (-not $cleaned -and (Get-ChildItem -Recurse -Include "*.csproj","*.sln" | Select-Object -First 1)) {
    Write-Host "🔧 检测到 .NET 项目（含 MAUI）" -ForegroundColor Green
    dotnet clean 2>$null | Out-Null
    dotnet restore
    $cleaned = $true
}

if (Test-Path ".vs") {
    Write-Host "  删除 .vs/（VS 用户缓存）" -ForegroundColor Gray
    Remove-Item -Recurse -Force .vs
}

# --- Node.js (Vue/Vite/React/Angular) ---
if (-not $cleaned -and (Test-Path "package.json")) {
    Write-Host "📦 检测到 Node.js 项目" -ForegroundColor Green

    # 清理常见构建目录
    @("dist", "build", "out", ".next", "cache") | ForEach-Object {
        if (Test-Path $_) {
            Write-Host "  删除 $_/" -ForegroundColor Gray
            Remove-Item -Recurse -Force $_
        }
    }

    npm install
    $cleaned = $true

    # Angular 额外提示
    if (Test-Path "angular.json") {
        Write-Host "⚛️  检测到 Angular 项目" -ForegroundColor Cyan
    }
}

if (-not $cleaned) {
    Write-Host "ℹ️  未识别项目类型，仅完成基础清理" -ForegroundColor DarkGray
}

Write-Host "✅ 已切换到 '$Branch' 并完成环境清理！" -ForegroundColor Green
