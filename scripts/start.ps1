$ErrorActionPreference = 'Stop'
$projectRoot = Split-Path -Parent $PSScriptRoot
Set-Location $projectRoot

# Keep Kafka's message files in this project on D:.
New-Item -ItemType Directory -Force -Path (Join-Path $projectRoot 'data') | Out-Null

docker compose up -d
if ($LASTEXITCODE -ne 0) { throw 'Could not start Kafka. Check that Docker Desktop is running.' }

Write-Host 'Waiting for Kafka to answer...'
for ($attempt = 1; $attempt -le 45; $attempt++) {
    # Docker runs an API check inside Kafka and reports its health here.
    $health = docker inspect kafka-demo-broker --format '{{.State.Health.Status}}' 2>$null
    if ($LASTEXITCODE -eq 0 -and $health -eq 'healthy') {
        Write-Host 'Kafka is ready.' -ForegroundColor Green
        docker compose ps
        exit 0
    }
    if ($LASTEXITCODE -eq 0 -and $health -eq 'unhealthy') { break }
    Start-Sleep -Seconds 2
}

docker compose ps
throw 'Kafka did not become ready in 60 seconds. Check: docker compose logs broker'

