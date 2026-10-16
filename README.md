# Apache Kafka order demo

This beginner-friendly project runs one Apache Kafka broker in **KRaft mode**. KRaft is Kafka's built-in way to manage the cluster, so this demo does not need ZooKeeper. The official `apache/kafka:4.3.1` image is pinned in `docker-compose.yml`.

## What the demo shows

An online store sends each customer order as an event to the `ventas-demo` topic. Kafka stores those events so a consumer can read them later, or receive new events as they arrive.

## Requirements

- Windows 10 with Docker Desktop using the WSL 2 engine.
- Docker Compose v2 (`docker compose`).
- Enough free space for the Kafka image and messages.

No Java, Python, or Kafka installation is needed on Windows. The sample was designed to keep the project and Kafka message data in `D:\Copia c\Oswaldo Rivera\Riwi\ruta_avanzada\data_analyzis\semana_12\apache-kafka-demo`. Docker Desktop still stores its own downloaded image layers in its configured disk image, which on Windows with WSL 2 is commonly under `C:\Users\<you>\AppData\Local\Docker\wsl`. Moving that existing disk image is a separate Docker Desktop setting; this project does not change it.

## Project files

```text
docker-compose.yml       Kafka settings and D: data mount
.env.example             Optional port and version settings
scripts/                  PowerShell demo commands
data/                     Kafka messages (created on first start)
docs/presentation-guide.md 3–5 minute class script
```

The `data` folder is created automatically. It is where Kafka keeps messages between starts. `docker compose down` does not remove it.

## Start and check Kafka

Open PowerShell and run:

```powershell
Set-Location 'D:\Copia c\Oswaldo Rivera\Riwi\ruta_avanzada\data_analyzis\semana_12\apache-kafka-demo'
.\scripts\start.ps1
```

The first start downloads the pinned Kafka image. The script waits for the broker to answer and prints its container status. You can also check it with:

```powershell
docker compose ps
docker compose logs --tail 30 broker
```

If you want to change defaults, copy `.env.example` to `.env` and edit the values before starting. The default host port is `9094`.

## Create the topic and send orders

```powershell
.\scripts\create-topic.ps1
.\scripts\produce.ps1
```

The producer sends these fictional orders:

```json
{"order_id": 1001, "product": "Laptop", "amount": 2500}
{"order_id": 1002, "product": "Mouse", "amount": 80}
{"order_id": 1003, "product": "Keyboard", "amount": 150}
```

## Read orders

Open a **second PowerShell window** in the project folder and run:

```powershell
Set-Location 'D:\Copia c\Oswaldo Rivera\Riwi\ruta_avanzada\data_analyzis\semana_12\apache-kafka-demo'
.\scripts\consume.ps1
```

The consumer starts at the beginning of the topic, so it can show orders sent earlier. It then waits for new orders. Run `produce.ps1` again in the first window to show live delivery. Press **Ctrl+C** in the consumer window to stop listening.

The scripts run Kafka's command-line tools inside the broker container, so no extra software is installed on Windows. A separate application running on Windows would connect to `localhost:9094`; another container on the Compose network would use `broker:9092`. Kafka advertises both addresses so clients can use the address that works from where they run.

## Type your own messages

Open two PowerShell windows. Start the producer first so it creates the separate topic and waits for input. Do not type until the consumer is ready:

```powershell
# Producer window; leave it open and wait before typing
.\scripts\write-message.ps1
```

In the second window, start the consumer:

```powershell
.\scripts\consume.ps1 -Topic mensajes-libres
```

Now type a line in the producer window and press Enter. It appears in the consumer window. Type more lines to send more messages. Press **Ctrl+C** in the producer window when finished, then press **Ctrl+C** in the consumer window.
## Stop Kafka safely

```powershell
.\scripts\stop.ps1
```

This stops and removes the container but does not delete `data`. Start it again with `start.ps1` to read the saved messages. Do not run `docker compose down --volumes` if you want to keep the data.

## Common problems

- **Cannot connect to Docker:** Open Docker Desktop and wait until it says it is running, then try `docker info` and `docker compose ps` again.
- **The broker is not ready:** Check `docker compose logs broker`; wait a little longer on the first start. If port `9094` is already in use, change `KAFKA_HOST_PORT` in `.env`.
- **The scripts are blocked by PowerShell policy:** Run a script for this window only with `powershell -ExecutionPolicy Bypass -File .\scripts\start.ps1`. This does not change the computer's policy.
- **The consumer shows nothing:** Create the topic and send orders first. The script uses `--from-beginning` so a new consumer reads saved orders too.
- **D: has room but C: is filling up:** Kafka's message folder is on D:, but Docker Desktop may keep downloaded images and its WSL 2 disk on C:. Check Docker Desktop **Settings → Resources → Advanced → Disk image location**. Do not move that disk manually; moving existing Docker data is outside this project setup.

