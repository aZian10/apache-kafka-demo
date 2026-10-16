$ErrorActionPreference = 'Stop'
$projectRoot = Split-Path -Parent $PSScriptRoot
Set-Location $projectRoot

# This stops the container and keeps the data folder.
docker compose down
if ($LASTEXITCODE -ne 0) { throw 'Could not stop the Kafka environment.' }
Write-Host 'Kafka stopped. Saved messages remain in .\data.'

