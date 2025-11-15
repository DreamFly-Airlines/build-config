param(
    [string]$NugetConfigTemplatePath = ".\NuGet.config.template",
    [string]$NuGetConfigOutputPath = ".\NuGet.config",
    [string]$EnvTemplatePath = ".\.env.template",
    [string]$EnvOutputPath = ".\.env"
)

if (-Not (Test-Path $NugetConfigTemplatePath)) {
    Write-Host "NuGet.config.template not found: $NugetConfigTemplatePath" -ForegroundColor Red
    exit 1
}

if (-Not (Test-Path $EnvTemplatePath)) {
    Write-Host ".env.template not found: $EnvTemplatePath" -ForegroundColor Red
    exit 1
}

if (-Not (Test-Path $EnvOutputPath)) {
    Copy-Item $EnvTemplatePath $EnvOutputPath
    Write-Host ".env created from template: $EnvOutputPath" -ForegroundColor Yellow
    Write-Host "Please fill in the required environment variables in the .env file and rerun script" -ForegroundColor Yellow
    exit 1
}

$envVars = @{}
Get-Content $EnvOutputPath | ForEach-Object {
    if ($_ -match "^\s*([^#=]+)\s*=\s*(.+)\s*$") {
        $key = $matches[1].Trim()
        $value = $matches[2].Trim()
        $envVars[$key] = $value
    }
}

$content = Get-Content $NugetConfigTemplatePath -Raw

$content = $content -replace "%YOUR_GITHUB_USERNAME%", $envVars["GITHUB_USERNAME"]
$content = $content -replace "%YOUR_GITHUB_PERSONAL_ACCESS_TOKEN%", $envVars["GITHUB_PERSONAL_ACCESS_TOKEN"]

Set-Content -Path $NuGetConfigOutputPath -Value $content
Write-Host "NuGet.config created and filled with .env: $NuGetConfigOutputPath" -ForegroundColor Green
