# Requires -Encoding UTF8
# $OutputEncoding = [Console]::OutputEncoding = [System.Text.Encoding]::UTF8
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

# 切换到UTF-8代码页（65001）
#chcp 65001 | Out-Null

# 或切换到中文区代码页（936）
# chcp 936 | Out-Null

. "./build-aspnetcore-common.ps1"

# Build all solutions
foreach ($migration in $migrationArray) {    
    Set-Location $migration.Path
    dotnet run
}

Set-Location $rootFolder