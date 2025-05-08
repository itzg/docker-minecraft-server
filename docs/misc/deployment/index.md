# More Deployment Info 

## On Kubernetes

### Using Helm

- itzg Helm Chart:
    - [GitHub repo](https://github.com/itzg/minecraft-server-charts)
      - [Helm Chart repo](https://itzg.github.io/minecraft-server-charts/)
- [mcsh/server-deployment](https://github.com/mcserverhosting-net/charts)

### Using Shulker

[Shulker](https://github.com/jeremylvln/Shulker) is a Kubernetes operator for managing complex and dynamic Minecraft infrastructures, including game servers and proxies. It uses the docker-minecraft-server and docker-bungeecord images under-the-hood.

## With Ansible

[Ansible](https://docs.ansible.com/ansible/latest/getting_started/introduction.html) is an open-source task automation tool built in [Python](https://www.python.org/). Ansible playbooks can be used to automate all kinds of tasks, including deploying remote Minecraft servers.

### Using the MASH playbook

[The MASH Playbook](https://github.com/mother-of-all-self-hosting/mash-playbook) is a premade playbook with the option to deploy a [wide variety of open-source services](https://github.com/mother-of-all-self-hosting/mash-playbook/blob/main/docs/supported-services.md) to your server(s), including [docker-minecraft-server](https://github.com/XHawk87/ansible-role-minecraft), making it a good option if you want all the bells and whistles alongside your Minecraft server.
- Check out the [Installation Guide](https://github.com/mother-of-all-self-hosting/mash-playbook/blob/main/docs/README.md) for the MASH playbook to get started.
- You can then enable [Minecraft](https://github.com/mother-of-all-self-hosting/mash-playbook/blob/main/docs/services/minecraft.md) in your vars.yml.
- Enable any supporting services that you might find useful, such as [user authentication](https://github.com/mother-of-all-self-hosting/mash-playbook/blob/main/docs/services/authelia.md), [remote backups](https://github.com/mother-of-all-self-hosting/mash-playbook/blob/main/docs/services/backup-borg.md), [email relay](https://github.com/mother-of-all-self-hosting/mash-playbook/blob/main/docs/services/exim-relay.md), [cron monitoring](https://github.com/mother-of-all-self-hosting/mash-playbook/blob/main/docs/services/healthchecks.md), [audio and video conferencing](https://github.com/mother-of-all-self-hosting/mash-playbook/blob/main/docs/services/jitsi.md), databases ([MariaDB](https://github.com/mother-of-all-self-hosting/mash-playbook/blob/main/docs/services/mariadb.md), [PostgresSQL](https://github.com/mother-of-all-self-hosting/mash-playbook/blob/main/docs/services/postgres.md)), [push notifications](https://github.com/mother-of-all-self-hosting/mash-playbook/blob/main/docs/services/ntfy.md), [uptime monitoring](https://github.com/mother-of-all-self-hosting/mash-playbook/blob/main/docs/services/uptime-kuma.md), [a website](https://github.com/mother-of-all-self-hosting/mash-playbook/blob/main/docs/services/wordpress.md), as well as installing any [extra files, folders, applications, services and running commands](https://github.com/mother-of-all-self-hosting/mash-playbook/blob/main/docs/services/auxiliary.md) automatically on deployment.

## On CloudFormation (AWS)

If you're looking for a simple way to deploy this to the Amazon Web Services Cloud, check out the [Minecraft Server Deployment (CloudFormation) repository](https://github.com/vatertime/minecraft-spot-pricing). This repository contains a CloudFormation template that will get you up and running in AWS in a matter of minutes. Optionally it uses Spot Pricing so the server is very cheap, and you can easily turn it off when not in use.

## Supporting Articles

Below are supporting articles for server deployment.

- "Zero to Minecraft Server with Docker Desktop and Compose"

    https://dev.to/rela-v/zero-to-minecraft-server-with-docker-desktop-and-compose-500a

    - This is a reference guide/tutorial on how to set up a vanilla Minecraft server using this project, including step-by-step instructions, and information on topics such as port-forwarding.
