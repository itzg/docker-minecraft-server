# Zero to Minecraft Server 
## with Docker Desktop and Compose

This is a reference guide/tutorial on how to set up a Minecraft server using this project and docker-compose. Some parts of this tutorial will make mention of operating system-dependent methods and may or may not provide the specific workflow for your OS (e.g. Windows, Mac, Linux, etc.). Please access the many readily available online resources on how to perform these steps.

## 1. Set RCON_PASSWORD passphrase (if you plan to use RCON)

The very first and most important thing to mention is that creating a Minecraft server comes with security risks, and by creating a Minecraft server using any method at all, you accept these risks. *Understanding what these risks are and how to minimize your risk is of the utmost importance.*

RCON is enabled by default to perform accessory functions of this project. Without an RCON password set, it will be set to a randomized value each time you start the server. If you plan to use an RCON password (which might be sensible if you plan to use RCON), then you should set this first before anything else for convenience and because it will improve your server setup workflow. **DO NOT reuse a passphrase that you use for anything else, as this poses a significant security risk.** It is better is to memorize your passphrase rather than putting it anywhere, but if you do, guard it like you would any other passphrase by putting it in a safe place - *don't place it directly in your server folder*.

## 2. Enable Virtualization.

The second step is to enable virtualization (this varies by System). First, check if you already have virtualization enabled - please follow the appropriate steps according to your operating system. Specific steps are out of scope for the purposes of this tutorial, but if you find that you do not have virtualization enabled, you will need to enable it in this step for Docker to work.

## 3. Download Docker Desktop.

You may navigate to [this page to download Docker Desktop](https://www.docker.com/products/docker-desktop/). It is required to run this project.

## 4. Create a New Server Directory

Create a new folder and name it something recognizable (such as "minecraft-server", for example). You may either use the command line, or your system's file manager GUI.

## 5. Create and Populate docker-compose.yml File in the Server Directory

The most important part of the docker-compose.yml creation step is to make sure that your docker-compose.yml file is properly formatted. One potential example docker-compose.yml file is as follows (be sure to delete any irrelevant lines to your application, or add any that you may need before copying and pasting the file contents). Be sure that the indentation is correct for every part of the file. 

!!! note
    One common pitfall may be that during the creation of your docker-compose.yml file, your text editing application (if using TextEdit for example) may add a .txt extension to your file - *this will render it unfindable by docker-compose: your docker-compose.yml file must actually be of the YAML type*.

```yaml
version: "3.8"
# Other docker-compose examples in /examples

services:
  minecraft:
    image: itzg/minecraft-server
    ports:
      - "25565:25565"
    volumes:
      - "mc:/data"
    environment:
      EULA: "TRUE"
```

## 6. Use docker-compose to Start Server

This is this simplest part of the server setup. Simply run the command `docker compose up -d` and docker compose will set up and serve a Minecraft server.

## 7. Find Your Host IP Address

Your server should now be running on your client (and, as of now, won't be accessible to the outside world) - you may view the logs through either the terminal or the terminal tab within Docker. Alternatively, you may issue the command `docker logs <container name>` to view the logs; adding the `-f` flag will allow you to follow the logs in real-time. The server will be running on your computer client on the port specified within your docker-compose.yml file. As such, you will need to expose one of your ports. To do this, you will need to port-forward your server client's (for example, your desktop's or otherwise your server machine's) IP address with the port that your server is using. To do this, first find your IP address: this process varies by operating system - 

- On Windows, open your command line application of choice and type in `ipconfig --all` - find your IPv4 address and use that as your IP address.

- On Mac, open your terminal and type in `ipconfig getifaddr en0` - the output will be your IP address.

- On Linux, use the command `ip r | grep default`: this will give you your relevant IP address, which is the `via` value in the output.

## 8. Port-forward using Router

!!! warning 
    In general, please **DO NOT** expose your RCON port externally (unless you are doing so intentionally with a full understanding of what that means and what it entails). 

First, log into your router settings page. Many routers use an IP address of `192.168.1.1`, but make sure you check what it is: this process may vary by operating system. To log in to your router settings page, simply type your router IP address directly into your preferred internet browser (e.g. Chrome, Firefox, Edge). Then, look for your Port-forwarding setting: this will be router/manufacturer-dependent, so look for specific instructions on how to access this setting. Forward the port that you have specified in your docker-compose.yml. Once you have done this, your server should be working and accessible to anyone with the address.

## 9. Test and Monitor for Errors, Changes, or Unusual Activity

Your Minecraft Server should now be accessible to the outside world on the exact IP Address:Port pair that you forwarded when you port-forwarded in the previous step (e.g. `192.168.1.1:25565`). You may test this by entering Minecraft and directly connecting using the aforementioned address or by adding the server in the Multiplayer tab, and making sure that the server is accessible.

!!! warning
    It is not recommended to share this IP address widely: it is the IP address that corresponds to your home network's access point: sharing indiscriminately may expose your home network to security threats.

