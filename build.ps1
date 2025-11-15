param(
    [string]$TemplatePath = ".\NuGet.config.template",
    [string]$OutputPath = ".\NuGet.config"
)

if (-Not (Test-Path $TemplatePath)) {
    Write-Host "Template file not found: $TemplatePath" -ForegroundColor Red
    exit 1
}

$content = Get-Content $TemplatePath -Raw
Set-Content -Path $OutputPath -Value $content

Write-Host "NuGet.config created: $OutputPath" -ForegroundColor Green
