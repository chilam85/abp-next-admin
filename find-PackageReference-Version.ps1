# PowerShell
Get-ChildItem -Recurse -Filter "*.csproj" | ForEach-Object {
    $content = Get-Content $_.FullName
    if ($content -match 'PackageReference.*Version=') {
        Write-Host "⚠️ 发现违规: $($_.FullName)"
    }
}