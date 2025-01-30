# Ollama 🤖🧠

Ollama provides a **local LLM service**, enabling AI-driven tasks without relying on cloud-based models. This repository contains a **Docker Compose** configuration for deploying **Ollama** and its **WebUI** on **Synology NAS** and **macOS**.

---

## Overview 📝

This repository adapts the guides from [**Lixandru Marius Bogdan**](https://github.com/mariushosting) to create a **complete all-in-one deployment** for **Ollama**. It simplifies the deployment process using **Docker Compose**, making it easy to set up and manage on a **Synology NAS** (via DSM Container Manager or Portainer) or **macOS**.

### **Features:**

- 🧠 **Local AI Model Serving** – Run LLM models locally without cloud dependencies.
- 🌐 **Web Interface for Easy Interaction** – Use **Ollama WebUI** to interact with models.
- 🏠 **Synology & macOS Compatible** – Works seamlessly across platforms.
- ⚡ **Lightweight & Efficient** – Minimal resource usage with optimized performance.

For setup instructions, visit:

- 📖 **[Ollama Setup Guide](https://mariushosting.com/how-to-install-ollama-on-your-synology-nas/)**

---

## Configuring IPAM and Network Firewall 🌍

This project uses **Docker IPAM (IP Address Management)** to manage container networking. To ensure smooth communication, you may need to configure your **firewall** to allow access based on the defined subnet.

### **IPAM Configuration**

You can configure the following settings in your [`.env`](example.env) file:

```bash
# Define the subnet range for the network
COMPOSE_NETWORK_SUBNET="${COMPOSE_NETWORK_SUBNET:-172.24.0.0/16}"

# Define the IP range for containers
COMPOSE_NETWORK_IP_RANGE="${COMPOSE_NETWORK_IP_RANGE:-172.24.5.0/24}"

# Define the network gateway
COMPOSE_NETWORK_GATEWAY="${COMPOSE_NETWORK_GATEWAY:-172.24.5.254}"
```

### **Updating Firewall Settings on Synology NAS** 🔥

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

This guide walks you through deploying **Ollama** using **Docker Compose**. You can deploy it on:

- 🏠 **Synology NAS** (DSM Container Manager or Portainer)
- 💻 **macOS** (Docker Desktop)

### **Using the Makefile** 🛠️

To simplify deployment and management, this project includes a **Makefile** with the following commands:

| Command              | Description |
|----------------------|-------------|
| `make up`           | Starts the Ollama service stack. |
| `make down`         | Stops and removes containers and volumes. |
| `make logs`         | Shows real-time logs of the running containers. |
| `make open`         | Opens the Ollama WebUI in your default web browser. |
| `make run`          | Starts the stack, opens the WebUI, and shows logs. |
| `make clean`        | Alias for `make down`. |
| `make help`         | Displays available commands. |

### **1. Copy and Edit the Environment File** 📜

A sample `.env` file is included. Copy it and adjust any necessary settings:

```sh
cp example.env .env
vim .env  # Edit as needed
```

### **2. Deploy Using Makefile**

Run the following command to bring up the service stack:

```sh
make up
```

### **3. Access the Web Interface** 🌍

Once deployed, open the **Ollama WebUI** using:

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

### **Ollama WebUI not connecting to Ollama?** 🤖

- Ensure the **OLLAMA_BASE_URL** in your `.env` is set correctly.
- Check if the **Ollama container is running**:

  ```sh
  docker ps | grep ollama
  ```

- Restart the Ollama service:

  ```sh
  docker restart ollama
  ```

### **Can't access the web interface?** 🔥

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

📄 **[View docker-compose.yml](./docker-compose.yml)**

---

## Conclusion 🎉

You've successfully set up **Ollama** for local AI model deployment! 🚀 Now you can leverage local AI capabilities without cloud dependencies.

For advanced configurations, visit the **[Ollama documentation](https://ollama.com/docs)**.
