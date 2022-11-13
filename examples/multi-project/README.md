This project demonstrates the use of two compose projects, `dbs` and `servers`, where the following capabilities are demonstrated:

- Managing databases, such as MariaDB, in its own compose project: `dbs`
- Using an `.env` file to avoid including user details within the compose file 
- Accessing the database from a separate project, `servers`, via an external network declaration
  - LuckPerms is configured to access the MariaDB instance
- Isolating the Minecraft server container by purposely **not** declaring port mappings
- Running Waterfall as a proxy
- Using configuration mount points to pre-configure Waterfall and the Minecraft server
- Using Spiget to download plugins, in this case LuckPerms