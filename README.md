# Ollama 🤖🧠

Ollama provides a local LLM service, enabling AI-driven tasks without relying on cloud-based models. This repository contains a Docker Compose configuration for deploying Ollama and its WebUI on Synology NAS and macOS.

---

## Overview 📝

This repository adapts the guides from [Lixandru Marius Bogdan](https://github.com/mariushosting) to create a complete all-in-one deployment for Ollama. It simplifies the deployment process using Docker Compose, making it easy to set up and manage on a Synology NAS (via DSM Container Manager or Portainer) or macOS.

### Performance Notice ⚠️

While Ollama can run in Docker on Synology NAS and macOS, performance is significantly limited. On Synology NAS, it's generally too slow to be practical. On macOS, running Ollama in Docker will heavily tax your CPU and will not properly leverage your system's GPU. For optimal performance on macOS, it's recommended to install Ollama natively and only use this Docker Compose setup to run the Ollama WebUI. See [Tips for Running Ollama Natively on macOS](#tips-for-running-ollama-natively-on-macos-) to set up the native Ollama service using a macOS Launch Agent. For details on how to connect the WebUI to a native Ollama service, see [Connecting WebUI to Native Ollama](#connecting-webui-to-native-ollama-on-macos-).

### Features

- 🧠 **Local AI Model Serving** - Run LLM models locally without cloud dependencies.
- 🌐 **Web Interface for Easy Interaction** - Use Ollama WebUI to interact with models.
- 🏠 **Synology & macOS Compatible** - Works seamlessly across platforms.
- ⚡ **Lightweight & Efficient** - Minimal resource usage with optimized performance.

For setup instructions, visit:

- 📖 [Ollama Setup Guide](https://mariushosting.com/how-to-install-ollama-on-your-synology-nas/)

---

## Configuring IPAM and Network Firewall 🌍

This project uses Docker IPAM (IP Address Management) to manage container networking. To ensure smooth communication, you may need to configure your firewall to allow access based on the defined subnet.

### IPAM Configuration

You can configure the following settings in your [`.env`](example.env) file:

```bash
# Define the subnet range for the network
COMPOSE_NETWORK_SUBNET="${COMPOSE_NETWORK_SUBNET:-172.24.0.0/16}"

# Define the IP range for containers
COMPOSE_NETWORK_IP_RANGE="${COMPOSE_NETWORK_IP_RANGE:-172.24.5.0/24}"

# Define the network gateway
COMPOSE_NETWORK_GATEWAY="${COMPOSE_NETWORK_GATEWAY:-172.24.5.254}"
```

### Updating Firewall Settings on Synology NAS 🔥

To allow communication for this Docker network, update the **Synology Firewall** settings:

1. Open **Control Panel** → **Security** (under Connectivity).
2. Navigate to the **Firewall** tab → Click **Edit Rules**.
3. Click **Create** to add a new rule:
   - **Ports**: Select `All`
   - **Source IP**: Select `Specific IP`
   - Click `Select` → Choose `Subnet`
   - Enter `172.24.0.0` for **IP Address** and `255.255.0.0` for **Subnet mask/Prefix length**
   - **Action**: Select `Allow`
4. Click **OK** to apply the changes.

This ensures that containers using this Docker network can communicate without restrictions.

For more details, check the **[Docker Compose IPAM documentation](https://docs.docker.com/compose/compose-file/06-networks/#ipam)**.

---

## Deployment 🚀

This guide walks you through deploying Ollama using Docker Compose. You can deploy it on:

- 🏠 Synology NAS (DSM Container Manager or Portainer)
- 💻 macOS (Docker Desktop)

### Using the Makefile 🛠️

To simplify deployment and management, this project includes a Makefile with the following commands:

| Command              | Description |
|----------------------|-------------|
| `make up`           | Starts the Ollama service stack. |
| `make down`         | Stops and removes containers and volumes. |
| `make logs`         | Shows real-time logs of the running containers. |
| `make open`         | Opens the Ollama WebUI in your default web browser. |
| `make run`          | Starts the stack, opens the WebUI, and shows logs. |
| `make clean`        | Alias for `make down`. |
| `make help`         | Displays available commands. |

### 1. Copy and Edit the Environment File 📜

A sample `.env` file is included. Copy it and adjust any necessary settings:

```sh
cp example.env .env
vim .env  # Edit as needed
```

### 2. Deploy Using Makefile

Run the following command to bring up the service stack:

```sh
make up
```

### 3. Access the Web Interface 🌍

Once deployed, open the Ollama WebUI using:

```sh
make open
```

Alternatively, you can manually access it from your browser:

- 🌐 **Ollama WebUI**: `http://localhost:8271` *(on macOS)*
- 📡 **Ollama WebUI**: `http://<synology-ip>:8271` *(on Synology NAS)*

To view real-time logs:

```sh
make logs
```

To stop and remove the stack:

```sh
make down
```

---

## Troubleshooting 🛠️

### Ollama WebUI not connecting to Ollama? 🤖

- Ensure the OLLAMA_BASE_URL in your `.env` is set correctly.
- Check if the Ollama container is running:

  ```sh
  docker ps | grep ollama
  ```

- Restart the Ollama service:

  ```sh
  docker restart ollama
  ```

### Can't access the web interface? 🔥

- Ensure the correct NAS IP and port (`8271`) are used.
- Check running containers:

  ```sh
  docker ps
  ```

- Restart the stack:

  ```sh
  make down
  make up
  ```

---

## Docker Compose Configuration 📄

The **docker-compose.yml** file defines the deployment. Check it out if you need to tweak settings.

📄 [View docker-compose.yml](./docker-compose.yml)

---

## Tips for Running Ollama Natively on macOS 💡

A `plist` file is included to manage the native Ollama service as a macOS Launch Agent: [com.ollama.serve.plist](config/plist/com.ollama.serve.plist).

### How it works

Launch Agents are macOS-specific services managed by `launchd`. The provided `plist` file configures macOS to run Ollama as a background service on user login or on demand.

### Installation

Copy the plist file to your LaunchAgents directory:

```bash
cp config/plist/com.ollama.serve.plist ~/Library/LaunchAgents/
```

### Commands to start/stop the service

```bash
# Start the ollama service
launchctl load ~/Library/LaunchAgents/com.ollama.serve.plist

# Stop the ollama service
launchctl unload ~/Library/LaunchAgents/com.ollama.serve.plist
```

### Optional Aliases

Add these to your `.bashrc`, `.zshrc`, or preferred aliases file:

```bash
alias ollamaStart="launchctl load ~/Library/LaunchAgents/com.ollama.serve.plist"
alias ollamaStop="launchctl unload ~/Library/LaunchAgents/com.ollama.serve.plist"
```

### Monitoring Logs

After starting the service, monitor logs with:

```bash
tail -F /tmp/ollama.log /tmp/ollama.err
```

---

## Connecting WebUI to Native Ollama on macOS 🔗

To connect the Ollama WebUI to a natively running Ollama service on macOS:

1. Open `docker-compose.yml`.
2. Comment out the entire `ollama` service block.
3. Comment out the `depends_on` section under the `ollama-webui` service block.
4. In your `.env` file, set:

   ```bash
   OLLAMA_HOSTNAME="${OLLAMA_HOSTNAME:-localhost}"
   LLAMA_WEBUI_BASE_URL="${OLLAMA_WEBUI_BASE_URL:-http://ollama:11434}"
   ```

This will configure the WebUI to connect to your native Ollama service running on macOS.

### Running the WebUI from the command line

After configuring your `.env` file and updating `docker-compose.yml`:

```bash
docker-compose up -d ollama-webui
```

To view logs for the WebUI service:

```bash
docker-compose logs -f ollama-webui
```

To stop the WebUI service:

```bash
docker-compose stop ollama-webui
```

## Conclusion 🎉

You've successfully set up Ollama for local AI model deployment! 🚀 Now you can leverage local AI capabilities without cloud dependencies.

For advanced configurations, visit the **[Ollama documentation](https://ollama.com/docs)**.
