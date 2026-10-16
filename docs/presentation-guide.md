# 3–5 minute presentation guide

## Before class

Start Docker Desktop and wait until it reports that it is running. The first Kafka start needs an internet connection to download the image. Keep two PowerShell windows open in `D:\Copia c\Oswaldo Rivera\Riwi\ruta_avanzada\data_analyzis\semana_12\apache-kafka-demo`.

## Commands and what the class sees

### 1. Start Kafka (about 30 seconds)

In the first window:

```powershell
Set-Location 'D:\Copia c\Oswaldo Rivera\Riwi\ruta_avanzada\data_analyzis\semana_12\apache-kafka-demo'
.\scripts\start.ps1
```

Say: “Kafka is the message broker for our store. It is starting without ZooKeeper.” The script waits for Kafka to answer and shows the running container.

### 2. Create the order topic (about 10 seconds)

```powershell
.\scripts\create-topic.ps1
```

Say: “A topic is a named place where Kafka keeps related messages.” The output shows `ventas-demo` and its one partition.

### 3. Send orders (about 10 seconds)

```powershell
.\scripts\produce.ps1
```

Say: “The store is the producer. Each new order is one event.” The script confirms it sent three sample orders.

### 4. Read saved and new orders (about 30 seconds)

In the second window:

```powershell
Set-Location 'D:\Copia c\Oswaldo Rivera\Riwi\ruta_avanzada\data_analyzis\semana_12\apache-kafka-demo'
.\scripts\consume.ps1
```

The three orders appear even though they were sent before this consumer started. Say: “Kafka kept the messages. This new consumer starts at the beginning, then stays ready for more.”

Back in the first window, send them again:

```powershell
.\scripts\produce.ps1
```

The new copies appear in the consumer window. Press **Ctrl+C** in the second window to finish listening.

## Optional: type a message and watch it arrive

Open the producer in one window first. This creates the topic and waits for input; do not type yet:

```powershell
.\scripts\write-message.ps1
```

In the second window, start the consumer:

```powershell
.\scripts\consume.ps1 -Topic mensajes-libres
```

Now type any line in the producer window and press Enter. Each line should appear in the consumer window. Press **Ctrl+C** in the producer window, then in the consumer window. This uses a separate `mensajes-libres` topic so it does not mix with the sample orders.
### 5. Stop cleanly (about 5 seconds)

In the first window:

```powershell
.\scripts\stop.ps1
```

Say: “The broker is stopped, but the messages are still saved under this project's `data` folder on D:.”

## Simple definitions

- **Producer:** An application that sends messages, like the online store recording an order.
- **Broker:** The Kafka server that receives, stores, and shares messages.
- **Topic:** A named stream of related messages; here it is `ventas-demo`.
- **Consumer:** An application that reads messages, like a shipping or reporting service.
- **Partition:** A piece of a topic that stores messages in order. This small demo uses one partition to keep the example easy to follow.
- **Offset:** A message's position number inside a partition. A consumer uses offsets to remember where to continue reading.

Kafka can keep messages after a consumer has read them. Each consumer tracks its own reading position, so another consumer can read the same messages too.

## Why are there two addresses?

Kafka has an internal address, `broker:9092`, for containers on the Docker network. Programs running directly on Windows use `localhost:9094`. Kafka advertises both so clients receive an address they can reach. The demo scripts run Kafka's sample tools inside the broker container and use its internal address; a Windows app would use `localhost:9094`.

## Questions the teacher may ask

**Does Kafka need ZooKeeper here?** No. This version runs in KRaft mode, where Kafka manages its metadata itself.

**Why can a new consumer see old orders?** The broker stores them, and the script asks the consumer to start from the beginning with `--from-beginning`.

**Can several applications read the same topic?** Yes. Each application can be its own consumer and keep its own reading position.

**What does an offset tell Kafka?** It is the position of a message in a partition. A consumer can use it to continue from where it stopped.

**Will stopping Kafka erase the orders?** No. This setup saves them in the project's `data` folder. The normal stop script does not delete it.

