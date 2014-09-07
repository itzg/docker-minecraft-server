This docker image provides a Minecraft Server that will automatically download the latest stable, latest snapshot, or any specific server version.

To simply use the latest stable version, run

    docker run -d -p 25565:25565 itzg/minecraft-server

where the default server port, 25565, will be exposed on your host machine.

Mojang now requires accepting the [Minecraft EULA](https://account.mojang.com/documents/minecraft_eula). To accept add

	-e EULA=TRUE

such as

	docker run -e EULA=TRUE -d -p 25565:25565 itzg/minecraft-server                                                                                                                                                                      
                                                                                                                             
                                                                                                                                                                                
In order to persist the Minecraft data, which you *probably want to do for a real server setup*, use the `-v` argument to map a local path to the `/data' path in the container,
                                                                                                       
    docker run -d -v /path/on/host:/data -p 25565:25565 itzg/minecraft-server                               
                                                                                                       
To use a different Minecraft version, pass the `VERSION` environment variable, which can have the value
* LATEST                                  
* SNAPSHOT                                
* (or a specific version, such as "1.7.9")                           
                                                                     
For example, to use the latest snapshot:                             
                                                                     
    docker run -d -e VERSION=SNAPSHOT -p 25565:25565 itzg/minecraft-server
                                                                  
or a specific version:                                                                                                       
                                                                                                                             
    docker run -d -e VERSION=1.7.9 -p 25565:25565 itzg/minecraft-server                                                           
                                                                                                                             
The message of the day, shown below each server entry in the UI, can be changed with the `MOTD` environment variable, such as
                                                                     
    docker run -d -e 'MOTD=My Server' -p 25565:25565 itzg/minecraft-server
