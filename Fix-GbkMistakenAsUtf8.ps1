# Fix-GbkMistakenAsUtf8.ps1
param(
    [string]$Path = "."
)

Get-ChildItem -Path $Path -Recurse -File |
    Where-Object { $_.Name -like "*Dockerfile*" } |
    ForEach-Object {
        $file = $_.FullName
        
        # 读取当前乱码内容（作为 UTF-8 字符串）
        $garbledText = Get-Content $file -Raw -Encoding UTF8
        
        if (-not $garbledText) { return }
        
        try {
            # 步骤1: 将乱码字符串按 UTF-8 编码成字节
            $bytes = [System.Text.Encoding]::UTF8.GetBytes($garbledText)
            
            # 步骤2: 将这些字节用 GBK (CodePage 936) 解码 → 应得原文
            $originalText = [System.Text.Encoding]::GetEncoding(936).GetString($bytes)
            
            # 写回文件（这次用正确方式：自动检测 + 转 UTF-8 无 BOM）
            [System.IO.File]::WriteAllText($file, $originalText, [System.Text.UTF8Encoding]::new($false))
            
            Write-Host "✅ 修复成功: $file"
        }
        catch {
            Write-Host "⚠️ 无法修复（可能不是 GBK 乱码）: $file" -ForegroundColor Yellow
        }
    }