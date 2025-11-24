# validate-and-fix-cpvm.ps1
param(
    [string]$SolutionRoot = ".",
    [string]$PackagesPropsPath = "$SolutionRoot/Directory.Packages.props",
    [string[]]$ExcludeDirs = @("tests", "test", "templates", "template", "examples", "samples", "benchmarks", "tools")
)

Write-Host "🔍 开始验证 CPVM 完整性（排除: $($ExcludeDirs -join ', ')）..." -ForegroundColor Cyan

# 标准化路径
$SolutionRoot = Resolve-Path $SolutionRoot
$PackagesPropsPath = Resolve-Path $PackagesPropsPath -ErrorAction SilentlyContinue

if (-not $?) {
    Write-Error "❌ 未找到 Directory.Packages.props 文件: $PackagesPropsPath"
    exit 1
}

# Step 1: 提取已声明的包
$packagesPropsContent = Get-Content $PackagesPropsPath -Raw
# 提取所有 ItemGroup 块中的 PackageVersion 条目
$declaredPackages = @{}
$allItemGroups = [regex]::Matches($packagesPropsContent, '(?s)<ItemGroup>(.*?)</ItemGroup>')
Write-Host "Found $($allItemGroups.Count) ItemGroup(s)"
foreach ($itemGroupMatch in $allItemGroups) {
    $itemGroupContent = $itemGroupMatch.Groups[1].Value
    $packageVersionMatches = [regex]::Matches($itemGroupContent, '<PackageVersion\s+Include=["'']([^"''>]+)["'']')
    foreach ($match in $packageVersionMatches) {
        $pkgId = $match.Groups[1].Value
        $declaredPackages[$pkgId] = $true
    }
}

Write-Host "📦 已在 Directory.Packages.props 中声明 $($declaredPackages.Count) 个包"

# Step 2: 构建排除正则（匹配路径中包含这些目录）
$excludePattern = ($ExcludeDirs | ForEach-Object { [regex]::Escape($_) }) -join '|'
$excludeRegex = "(^|\\)($excludePattern)(\\|$)"

# Step 3: 扫描 .csproj（跳过排除目录）
$violations = @()
$missingPackages = @{}
$versionAttributeFound = $false

Get-ChildItem -Path $SolutionRoot -Recurse -Filter "*.csproj" | ForEach-Object {
    $projPath = $_.FullName

    # 检查是否在排除目录中
    $relativePath = $projPath.Substring($SolutionRoot.Path.Length).TrimStart('\', '/')
    if ($relativePath -match $excludeRegex) {
        return  # 跳过
    }

    $content = Get-Content $projPath -Raw

    # 检查 Version= 违规
    if ($content -match '<PackageReference[^>]*Version\s*=\s*["''][^"''>]*["''][^>]*/>') {
        $violations += "❌ [$projPath] 包含禁止的 Version 属性"
        $versionAttributeFound = $true
    }

    # 提取 PackageReference Include
    $refMatches = [regex]::Matches($content, '<PackageReference\s+Include=["'']([^"''>]+)["''][^>]*/>')
    foreach ($match in $refMatches) {
        $pkgId = $match.Groups[1].Value
        if (-not $declaredPackages.ContainsKey($pkgId)) {
            $missingPackages[$pkgId] = $true
            $violations += "⚠️ [$projPath] 引用了未声明的包: $pkgId"
        }
    }
}

# Step 4: 输出结果
if ($violations.Count -gt 0) {
    Write-Host "`n🚨 发现 $($violations.Count) 个 CPVM 问题：" -ForegroundColor Red
    $violations | ForEach-Object { Write-Host $_ }

    if ($missingPackages.Count -gt 0) {
        Write-Host "`n✨ 请将以下内容添加到 Directory.Packages.props 的 <ItemGroup> 中：" -ForegroundColor Magenta
        Write-Host ""
        $sortedMissing = $missingPackages.Keys | Sort-Object
        foreach ($pkg in $sortedMissing) {
            Write-Host "    <PackageVersion Include=`"$pkg`" Version=`"`$(PackageVersion)`" />"
        }
        Write-Host ""
    }

    if ($versionAttributeFound) {
        Write-Host "🔧 提示：请删除所有 .csproj 中 PackageReference 的 Version 属性！" -ForegroundColor Yellow
    }

    exit 1
} else {
    Write-Host "✅ CPVM 验证通过！所有引用均符合规范。" -ForegroundColor Green
    exit 0
}