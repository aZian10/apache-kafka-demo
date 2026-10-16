$ErrorActionPreference = 'Stop'
$projectRoot = Split-Path -Parent $PSScriptRoot
Set-Location $projectRoot

$topic = 'mensajes-libres'

# Create the chat topic the first time this script runs.
docker compose exec -T broker /opt/kafka/bin/kafka-topics.sh --bootstrap-server localhost:9092 --create --if-not-exists --topic $topic --partitions 1 --replication-factor 1
if ($LASTEXITCODE -ne 0) { throw 'Could not create mensajes-libres. Start Kafka first.' }

Write-Host "Type any message for the consumer. Press Ctrl+C when you are done."
docker compose exec -T broker /opt/kafka/bin/kafka-console-producer.sh --bootstrap-server localhost:9092 --topic $topic
