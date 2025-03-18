# Ollama 🤖🧠

Welcome to Ollama, your friendly neighborhood local LLM service! Say goodbye to cloud dependency and hello to AI-driven tasks right at home. This repository is your trusty guide for deploying Ollama and its WebUI on Synology NAS and macOS using Docker Compose. Let's dive in!

---

## Overview 📝

This repository is inspired by the genius of [Lixandru Marius Bogdan](https://github.com/mariushosting). We've crafted a one-stop-shop for deploying Ollama, making your setup as easy as pie (or should we say, as easy as a well-trained AI?). Whether you're on Synology NAS (via DSM Container Manager or Portainer) or macOS, we've got you covered!

### Performance Notice ⚠️

Heads up! While Ollama plays nice in Docker on Synology NAS and macOS, performance can be a bit sluggish. Synology NAS might feel like it's running on a treadmill, and macOS might give your CPU a workout without tapping into that sweet GPU power. For the best experience on macOS, install Ollama natively and use this Docker Compose setup just for the WebUI. Check out [Tips for Running Ollama Natively on macOS](#tips-for-running-ollama-natively-on-macos-) for the scoop on setting up a native Ollama service. And if you want to connect the WebUI to your native Ollama, see [Connecting WebUI to Native Ollama](#connecting-webui-to-macos-native-ollama-).

### Features

- 🧠 **Local AI Model Serving** - Run LLM models locally, no cloud strings attached.
- 🌐 **Web UI for Easy Interaction** - Chat with your models through the Ollama WebUI.
- 🏠 **Synology & macOS Compatible** - Seamless operation across platforms.
- ⚡ **Lightweight & Efficient** - Minimal resource hogging with optimized performance.

For setup instructions, hop on over to:

- 📖 [Ollama Setup Guide](https://mariushosting.com/how-to-install-ollama-on-your-synology-nas/)

---

## Configuring IPAM and Network Firewall 🌍

Let's talk Docker IPAM (IP Address Management). It's the superhero of container networking! To keep your containers chatting smoothly, you might need to tweak your firewall settings.

### IPAM Configuration

Time to get your hands dirty! Configure the following in your [`.env`](example.env) file:

```bash
# Define the subnet range for the network
COMPOSE_NETWORK_SUBNET="${COMPOSE_NETWORK_SUBNET:-172.24.0.0/16}"

# Define the IP range for containers
COMPOSE_NETWORK_IP_RANGE="${COMPOSE_NETWORK_IP_RANGE:-172.24.5.0/24}"

# Define the network gateway
COMPOSE_NETWORK_GATEWAY="${COMPOSE_NETWORK_GATEWAY:-172.24.5.254}"
```

### Updating Firewall Settings on Synology NAS 🔥

Ready to unleash the power of communication for your Docker network? Update your **Synology Firewall** settings:

1. Open **Control Panel** → **Security** (under Connectivity).
2. Navigate to the **Firewall** tab → Click **Edit Rules**.
3. Click **Create** to add a new rule:
   - **Ports**: Select `All`
   - **Source IP**: Select `Specific IP`
   - Click `Select` → Choose `Subnet`
   - Enter `172.24.0.0` for **IP Address** and `255.255.0.0` for **Subnet mask/Prefix length**
   - **Action**: Select `Allow`
4. Click **OK** to apply the changes.

Now your containers can chat freely! 🎉

For more details, check out the **[Docker Compose IPAM documentation](https://docs.docker.com/compose/compose-file/06-networks/#ipam)**.

---

## Deployment 🚀

Let's get Ollama up and running! This guide is your roadmap to deploying Ollama with Docker Compose. You can do it on:

- 🏠 Synology NAS (DSM Container Manager or Portainer)
- 💻 macOS (Docker Desktop)

### Using the Makefile 🛠️

We've included a Makefile to make your life easier. Here's what you can do:

| Command              | Description |
|----------------------|-------------|
| `make up`           | Fire up the Ollama service stack. |
| `make down`         | Stop and remove containers and volumes. |
| `make logs`         | Peek at real-time logs of the running containers. |
| `make open`         | Launch the Ollama WebUI in your favorite web browser. |
| `make run`          | Start the stack, open the WebUI, and show logs. |
| `make clean`        | Just like `make down`, but with flair. |
| `make help`         | Get a rundown of available commands. |

### 1. Copy and Edit the Environment File 📜

We've got a sample [`example.env`](example.env) file for you! Copy it and tweak it to your liking:

```sh
cp example.env .env
vim .env  # Edit as needed
```

### 2. Deploy Using Makefile

Ready, set, deploy! Run this command to bring up the service stack:

```sh
make up
```

### 3. Access the Web Interface 🌍

Once deployed, open the Ollama WebUI with:

```sh
make open
```

Or go the manual route:

- 🌐 **Ollama WebUI**: `http://localhost:8271` *(on macOS)*
- 📡 **Ollama WebUI**: `http://<synology-ip>:8271` *(on Synology NAS)*

To see real-time logs, just run:

```sh
make logs
```

To stop and remove the stack, do this:

```sh
make down
```

---

## Troubleshooting 🛠️

### Ollama WebUI not connecting to Ollama? 🤖

- Double-check the OLLAMA_BASE_URL in your `.env` file.
- Is the Ollama container running? Check with:

  ```sh
  docker ps | grep ollama
  ```

- Need a restart? Just run:

  ```sh
  docker restart ollama
  ```

### Can't access the web interface? 🔥

- Verify the NAS IP and port (`8271`) are correct.
- Check running containers:

  ```sh
  docker ps
  ```

- Restart the stack like a pro:

  ```sh
  make down
  make up
  ```

---

## Docker Compose Configuration 📄

The **docker-compose.yml** file is where the magic happens. Tweak it as needed!

- 📄 [View `docker-compose.yml`](./docker-compose.yml)

---

## Tips for Running Ollama Natively on macOS 💡

We've included a `plist` file to manage the native Ollama service as a macOS Launch Agent:

- 📄 [View `com.ollama.serve.plist`](config/plist/com.ollama.serve.plist)

### How it works

Launch Agents are macOS-specific services managed by `launchd`. The provided `plist` file configures macOS to run Ollama as a background service on user login or on demand.

### Installation

Copy the plist file to your LaunchAgents directory:

```bash
cp config/plist/com.ollama.serve.plist ~/Library/LaunchAgents/
```

### Commands to start/stop the service

Time to control your Ollama service:

```bash
# Start the ollama service
launchctl load ~/Library/LaunchAgents/com.ollama.serve.plist

# Stop the ollama service
launchctl unload ~/Library/LaunchAgents/com.ollama.serve.plist
```

### Optional Aliases

Want to make your life even easier? Add these to your `.bashrc`, `.zshrc`, or preferred aliases file:

```bash
alias ollamaStart="launchctl load ~/Library/LaunchAgents/com.ollama.serve.plist"
alias ollamaStop="launchctl unload ~/Library/LaunchAgents/com.ollama.serve.plist"
```

### Monitoring Logs

Keep an eye on the action with:

```bash
tail -F /tmp/ollama.log /tmp/ollama.err
```

---

## Connecting WebUI to macOS Native Ollama 🔗

Want to connect the Ollama WebUI to a natively running Ollama service on macOS? Here's how:

1. Open `docker-compose.yml`.
2. Comment out the entire `ollama` service block.
3. Comment out the `depends_on` section under the `ollama-webui` service block.
4. In your `.env` file, set:

   ```bash
   OLLAMA_HOSTNAME="${OLLAMA_HOSTNAME:-localhost}"
   LLAMA_WEBUI_BASE_URL="${OLLAMA_WEBUI_BASE_URL:-http://ollama:11434}"
   ```

Now your WebUI is ready to connect to your native Ollama service!

### Running the WebUI from the command line

After configuring your `.env` file and updating `docker-compose.yml`, run:

```bash
docker-compose up -d ollama-webui
```

To check logs for the WebUI service:

```bash
docker-compose logs -f ollama-webui
```

To stop the WebUI service:

```bash
docker-compose stop ollama-webui
```

## Conclusion 🎉

You've successfully set up Ollama for local AI model deployment! 🚀 Now you're ready to unleash the power of local AI without the cloud's shackles.

For advanced configurations, don't forget to visit the **[Ollama documentation](https://ollama.com/docs)**. Happy AI-ing!
