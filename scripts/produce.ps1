$ErrorActionPreference = 'Stop'
$projectRoot = Split-Path -Parent $PSScriptRoot
Set-Location $projectRoot

# Each line becomes one order message.
$orders = @(
    '{"order_id": 1001, "product": "Laptop", "amount": 2500}'
    '{"order_id": 1002, "product": "Mouse", "amount": 80}'
    '{"order_id": 1003, "product": "Keyboard", "amount": 150}'
)
$orders | docker compose exec -T broker /opt/kafka/bin/kafka-console-producer.sh --bootstrap-server localhost:9092 --topic ventas-demo
if ($LASTEXITCODE -ne 0) { throw 'Could not send messages. Create the topic first.' }
Write-Host 'Sent 3 sample orders to ventas-demo.'

