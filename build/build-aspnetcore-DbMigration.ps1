. "./build-aspnetcore-common.ps1"

# Build all solutions
foreach ($migration in $migrationArray) {    
    Set-Location $migration.Path
    # $env:DOTNET_ENVIRONMENT = "Development"
    dotnet run
}

Set-Location $rootFolder
