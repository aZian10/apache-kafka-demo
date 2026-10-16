param(
    [string]$Topic = 'ventas-demo'
)

$ErrorActionPreference = 'Stop'
$projectRoot = Split-Path -Parent $PSScriptRoot
Set-Location $projectRoot

Write-Host "Reading saved messages from '$Topic', then waiting for new ones. Press Ctrl+C to stop."
# A fresh consumer starts at the first saved message.
docker compose exec broker /opt/kafka/bin/kafka-console-consumer.sh --bootstrap-server localhost:9092 --topic $Topic --from-beginning --command-property auto.offset.reset=earliest
if ($LASTEXITCODE -ne 0) { throw 'Could not read messages. Start Kafka and create the topic first.' }

