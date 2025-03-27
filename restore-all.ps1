# 查找当前目录及其子目录中的所有 .csproj 文件
Get-ChildItem -Recurse -Filter "*.csproj" | ForEach-Object {
    # 在每个找到的 .csproj 文件的目录中运行 dotnet restore
    $directory = $_.DirectoryName
    Set-Location $directory
    dotnet restore
    #Set-Location ".."  # 可选：返回之前的目录，但在这个脚本中不是必需的，因为每次循环都会设置新的位置
}