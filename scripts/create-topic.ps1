$ErrorActionPreference = 'Stop'
$projectRoot = Split-Path -Parent $PSScriptRoot
Set-Location $projectRoot

# Kafka safely skips creation when this topic already exists.
docker compose exec -T broker /opt/kafka/bin/kafka-topics.sh --bootstrap-server localhost:9092 --create --if-not-exists --topic ventas-demo --partitions 1 --replication-factor 1
if ($LASTEXITCODE -ne 0) { throw 'Could not create ventas-demo. Start Kafka first.' }
docker compose exec -T broker /opt/kafka/bin/kafka-topics.sh --bootstrap-server localhost:9092 --describe --topic ventas-demo
if ($LASTEXITCODE -ne 0) { throw 'Could not check ventas-demo.' }

