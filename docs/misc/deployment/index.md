# More Deployment Info 

## On Kubernetes

### Using Helm

- itzg Helm Chart:
    - [GitHub repo](https://github.com/itzg/minecraft-server-charts)
      - [Helm Chart repo](https://itzg.github.io/minecraft-server-charts/)
- [mcsh/server-deployment](https://github.com/mcserverhosting-net/charts)

### Using Shulker

[Shulker](https://github.com/jeremylvln/Shulker) is a Kubernetes operator for managing complex and dynamic Minecraft infrastructures, including game servers and proxies. It uses the docker-minecraft-server and docker-bungeecord images under-the-hood.

## On CloudFormation (AWS)

If you're looking for a simple way to deploy this to the Amazon Web Services Cloud, check out the [Minecraft Server Deployment (CloudFormation) repository](https://github.com/vatertime/minecraft-spot-pricing). This repository contains a CloudFormation template that will get you up and running in AWS in a matter of minutes. Optionally it uses Spot Pricing so the server is very cheap, and you can easily turn it off when not in use.

## Supporting Articles

Below are supporting articles for server deployment.

- "Zero to Minecraft Server with Docker Desktop and Compose"

    https://dev.to/rela-v/zero-to-minecraft-server-with-docker-desktop-and-compose-500a

    - This is a reference guide/tutorial on how to set up a vanilla Minecraft server using this project, including step-by-step instructions, and information on topics such as port-forwarding.
