#!/bin/bash

#umask 002
export HOME=/data

if [ ! -e /data/eula.txt ]; then
  if [ "$EULA" != "" ]; then
    echo "# Generated via Docker on $(date)" > eula.txt
    echo "eula=$EULA" >> eula.txt
  else
    echo ""
    echo "Please accept the Minecraft EULA at"
    echo "  https://account.mojang.com/documents/minecraft_eula"
    echo "by adding the following immediately after 'docker run':"
    echo "  -e EULA=TRUE"
    echo ""
    exit 1
  fi
fi

echo "Checking version information."
case "X$VERSION" in
  X|XLATEST|Xlatest)
    VANILLA_VERSION=`wget -O - https://s3.amazonaws.com/Minecraft.Download/versions/versions.json | jsawk -n 'out(this.latest.release)'`
  ;;
  XSNAPSHOT|Xsnapshot)
    VANILLA_VERSION=`wget -O - https://s3.amazonaws.com/Minecraft.Download/versions/versions.json | jsawk -n 'out(this.latest.snapshot)'`
  ;;
  X[1-9]*)
    VANILLA_VERSION=$VERSION
  ;;
  *)
    VANILLA_VERSION=`wget -O - https://s3.amazonaws.com/Minecraft.Download/versions/versions.json | jsawk -n 'out(this.latest.release)'`
  ;;
esac

cd /data

echo "Checking type information."
case "$TYPE" in
  *BUKKIT|*bukkit|SPIGOT|spigot)
    TYPE=SPIGOT
    if [ -z "$BUILD_SPIGOT_FROM_SOURCE" ]; then
        case "$TYPE" in
          *BUKKIT|*bukkit)
            echo "Downloading latest CraftBukkit $VANILLA_VERSION server ..."
            SERVER=craftbukkit_server.jar
            ;;
          *)
            echo "Downloading latest Spigot $VANILLA_VERSION server ..."
            SERVER=spigot_server.jar
            ;;
        esac
        case $VANILLA_VERSION in
          1.8*)
            URL=/spigot18/$SERVER
            ;;
          1.9*)
            URL=/spigot19/$SERVER
            ;;
          *)
            echo "That version of $SERVER is not available."
            exit 1
          ;;
        esac
        
        #attempt https, and if it fails, fallback to http and download that way. Display error if neither works.
        wget -q -N $SERVER https://getspigot.org$URL || \
        	(echo "Falling back to http, unable to contact server using https..." && \
        	wget -q -N $SERVER http://getspigot.org$URL) || \
        	echo "Unable to download new copy of spigot server"
    fi
    if [ "$BUILD_SPIGOT_FROM_SOURCE" = true ]; then
        echo "Building spigot from source, might take a while, get some coffee"
        if [ ! -f /data/spigot_server.jar ]; then
            echo "Downloading and building buildtools for version $VANILLA_VERSION"
            mkdir /data/temp
            cd /data/temp
            wget -P /data/temp https://hub.spigotmc.org/jenkins/job/BuildTools/lastSuccessfulBuild/artifact/target/BuildTools.jar && \
            java -jar /data/temp/BuildTools.jar --rev $VANILLA_VERSION && \
            find * -maxdepth 0 ! -name '*.jar' -exec rm -rf {} \; && \
            chown minecraft:minecraft spigot-*.jar && \
            chown minecraft:minecraft craftbukkit-*.jar && \
            mv spigot-*.jar /data/spigot_server.jar && \
            mv craftbukkit-*.jar /data/craftbukkit_server.jar
            echo "Cleaning up"
            rm -rf /data/temp
            cd /data    
        fi
        case "$TYPE" in
          *BUKKIT|*bukkit)
            SERVER=craftbukkit_server.jar
            ;;
          *)
            SERVER=spigot_server.jar
            ;;
        esac
    fi  
    ;;

  FORGE|forge)
    TYPE=FORGE
    norm=$VANILLA_VERSION

    echo "Checking Forge version information."
    case $FORGEVERSION in
        RECOMMENDED)
  		FORGE_VERSION=`wget -O - http://files.minecraftforge.net/maven/net/minecraftforge/forge/promotions_slim.json | jsawk -n "out(this.promos['$norm-recommended'])"`
        ;;

        *)
  		FORGE_VERSION=$FORGEVERSION
        ;;
    esac

    # URL format changed for 1.7.10 from 10.13.2.1300
    sorted=$((echo $FORGE_VERSION; echo 10.13.2.1300) | sort -V | head -1)
    if [[ $norm == '1.7.10' && $sorted == '10.13.2.1300' ]]; then
        # if $FORGEVERSION >= 10.13.2.1300
        normForgeVersion="$norm-$FORGE_VERSION-$norm"
    else
        normForgeVersion="$norm-$FORGE_VERSION"
    fi

    FORGE_INSTALLER="forge-$normForgeVersion-installer.jar"
    SERVER="forge-$normForgeVersion-universal.jar"

    if [ ! -e "$SERVER" ]; then
      echo "Downloading $FORGE_INSTALLER ..."
      wget -q http://files.minecraftforge.net/maven/net/minecraftforge/forge/$normForgeVersion/$FORGE_INSTALLER
      echo "Installing $SERVER"
      java -jar $FORGE_INSTALLER --installServer
    fi
  ;;

  VANILLA|vanilla)
    SERVER="minecraft_server.$VANILLA_VERSION.jar"

    if [ ! -e $SERVER ]; then
      echo "Downloading $SERVER ..."
      wget -q https://s3.amazonaws.com/Minecraft.Download/versions/$VANILLA_VERSION/$SERVER
    fi
  ;;

  *)
      echo "Invalid type: '$TYPE'"
      echo "Must be: VANILLA, FORGE, SPIGOT"
      exit 1
  ;;

esac


#Switch to minecraft user
echo "...switching to user 'minecraft'"
su - minecraft

# If supplied with a URL for a world, download it and unpack
if [[ "$WORLD" ]]; then
case "X$WORLD" in
  X[Hh][Tt][Tt][Pp]*)
    echo "Downloading world via HTTP"
    echo "$WORLD"
    wget -q -O - "$WORLD" > /data/world.zip
    echo "Unzipping word"
    unzip -q /data/world.zip
    rm -f /data/world.zip
    if [ ! -d /data/world ]; then
      echo World directory not found
      for i in /data/*/level.dat; do
        if [ -f "$i" ]; then
          d=`dirname "$i"`
          echo Renaming world directory from $d
          mv -f "$d" /data/world
        fi
      done
    fi
    if [ "$TYPE" = "SPIGOT" ]; then
      # Reorganise if a Spigot server
      echo "Moving End and Nether maps to Spigot location"
      [ -d "/data/world/DIM1" ] && mv -f "/data/world/DIM1" "/data/world_the_end"
      [ -d "/data/world/DIM-1" ] && mv -f "/data/world/DIM-1" "/data/world_nether"
    fi
    ;;
  *)
    echo "Invalid URL given for world: Must be HTTP or HTTPS and a ZIP file"
    ;;
esac
fi

# If supplied with a URL for a modpack (simple zip of jars), download it and unpack
if [[ "$MODPACK" ]]; then
case "X$MODPACK" in
  X[Hh][Tt][Tt][Pp]*[Zz][iI][pP])
    echo "Downloading mod/plugin pack via HTTP"
    echo "$MODPACK"
    wget -q -O /tmp/modpack.zip "$MODPACK"
    if [ "$TYPE" = "SPIGOT" ]; then
      mkdir -p /data/plugins
      unzip -d /data/plugins /tmp/modpack.zip
    else
      mkdir -p /data/mods
      unzip -d /data/mods /tmp/modpack.zip
    fi
    rm -f /tmp/modpack.zip
    ;;
  *)
    echo "Invalid URL given for modpack: Must be HTTP or HTTPS and a ZIP file"
    ;;
esac
fi

if [ ! -e server.properties ]; then
  echo "Creating server.properties"
  cp /tmp/server.properties .

  if [ -n "$WHITELIST" ]; then
    echo "Creating whitelist"
    sed -i "/whitelist\s*=/ c whitelist=true" /data/server.properties
    sed -i "/white-list\s*=/ c white-list=true" /data/server.properties
  fi

  if [ -n "$MOTD" ]; then
    echo "Setting motd"
    sed -i "/motd\s*=/ c motd=$MOTD" /data/server.properties
  fi  

  if [ -n "$ALLOW_NETHER" ]; then
    echo "Setting allow-nether"
    sed -i "/allow-nether\s*=/ c allow-nether=$ALLOW_NETHER" /data/server.properties
  fi  

  if [ -n "$ANNOUNCE_PLAYER_ACHIEVEMENTS" ]; then
    echo "Setting announce-player-achievements"
    sed -i "/announce-player-achievements\s*=/ c announce-player-achievements=$ANNOUNCE_PLAYER_ACHIEVEMENTS" /data/server.properties
  fi  

  if [ -n "$ENABLE_COMMAND_BLOCK" ]; then
    echo "Setting enable-command-block"
    sed -i "/enable-command-block\s*=/ c enable-command-block=$ENABLE_COMMAND_BLOCK" /data/server.properties
  fi

  if [ -n "$SPAWN_ANIMAILS" ]; then
    echo "Setting spawn-animals"
    sed -i "/spawn-animals\s*=/ c spawn-animals=$SPAWN_ANIMAILS" /data/server.properties
  fi


  if [ -n "$SPAWN_MONSTERS" ]; then
    echo "Setting spawn-monsters"
    sed -i "/spawn-monsters\s*=/ c spawn-monsters=$SPAWN_MONSTERS" /data/server.properties
  fi

  if [ -n "$SPAWN_NPCS" ]; then
    echo "Setting spawn-npcs"
    sed -i "/spawn-npcs\s*=/ c spawn-npcs=$SPAWN_NPCS" /data/server.properties
  fi


  if [ -n "$GENERATE_STRUCTURES" ]; then
    echo "Setting generate-structures"
    sed -i "/generate-structures\s*=/ c generate-structures=$GENERATE_STRUCTURES" /data/server.properties
  fi
  
  if [ -n "$VIEW_DISTANCE" ]; then
    echo "Setting view-distance"
    sed -i "/view-distance\s*=/ c view-distance=$VIEW_DISTANCE" /data/server.properties
  fi

  if [ -n "$HARDCORE" ]; then
    echo "Setting hardcore"
    sed -i "/hardcore\s*=/ c hardcore=$HARDCORE" /data/server.properties
  fi
  
  if [ -n "$MAX_BUILD_HEIGHT" ]; then
    echo "Setting max-build-height"
    sed -i "/max-build-height\s*=/ c max-build-height=$MAX_BUILD_HEIGHT" /data/server.properties
  fi

  if [ -n "$FORCE_GAMEMODE" ]; then
    echo "Setting force-gamemode"
    sed -i "/force-gamemode\s*=/ c force-gamemode=$FORCE_GAMEMODE" /data/server.properties
  fi
 
  if [ -n "$MAX_TICK_TIME" ]; then
    echo "Setting max-tick-time"
    sed -i "/max-tick-time\s*=/ c max-tick-time=$MAX_TICK_TIME" /data/server.properties
  fi

  if [ -n "$ENABLE_QUERY" ]; then
    echo "Enabling query"
    sed -i "/enable-query\s*=/ c enable-query=$ENABLE_QUERY" /data/server.properties
  fi

  if [ -n "$QUERY_PORT" ]; then
    echo "Setting query port"    
    sed -i "/query.port\s*=/ c query.port=$QUERY_PORT" /data/server.properties
  fi

  if [ -n "$ENABLE_RCON" ]; then
    echo "Enabling rcon"
    sed -i "/enable-rcon\s*=/ c enable-rcon=$ENABLE_RCON" /data/server.properties
  fi

  if [ -n "$RCON_PASSWORD" ]; then
    echo "Setting rcon password to $RCON_PASSWORD"    
    sed -i "/rcon.password\s*=/ c rcon.password=$RCON_PASSWORD" /data/server.properties
  fi

  if [ -n "$RCON_PORT" ]; then
    echo "Setting rcon port"
    sed -i "/rcon.port\s*=/ c rcon.port=$RCON_PORT" /data/server.properties
  fi
   
  if [ -n "$MAX_PLAYERS" ]; then
    echo "Setting max players"
    sed -i "/max-players\s*=/ c max-players=$MAX_PLAYERS" /data/server.properties
  fi 

  if [ -n "$MAX_WORLD_SIZE" ]; then
    echo "Setting max world size"
    sed -i "/max-world-size\s*=/ c max-world-size=$MAX_WORLD_SIZE" /data/server.properties
  fi 
    
  if [ -n "$LEVEL" ]; then
    echo "Setting level name"
    sed -i "/level-name\s*=/ c level-name=$LEVEL" /data/server.properties
  fi

  if [ -n "$SEED" ]; then
    echo "Setting seed"
    sed -i "/level-seed\s*=/ c level-seed=$SEED" /data/server.properties
  fi

  if [ -n "$PVP" ]; then
    echo "Setting PVP"
    sed -i "/pvp\s*=/ c pvp=$PVP" /data/server.properties
  fi

  if [ -n "$LEVEL_TYPE" ]; then
    # normalize to uppercase
    echo "Setting level type"
    LEVEL_TYPE=${LEVEL_TYPE^^}
    # check for valid values and only then set
    case $LEVEL_TYPE in
      DEFAULT|FLAT|LARGEBIOMES|AMPLIFIED|CUSTOMIZED)
        sed -i "/level-type\s*=/ c level-type=$LEVEL_TYPE" /data/server.properties
        ;;
      *)
        echo "Invalid LEVEL_TYPE: $LEVEL_TYPE"
	exit 1
	;;
    esac
  fi

  if [ -n "$GENERATOR_SETTINGS" ]; then
    echo "Setting generator settings"
    sed -i "/generator-settings\s*=/ c generator-settings=$GENERATOR_SETTINGS" /data/server.properties
  fi

  if [ -n "$DIFFICULTY" ]; then
    echo "Setting difficulty"
    case $DIFFICULTY in
      peaceful|0)
        DIFFICULTY=0
        ;;
      easy|1)
        DIFFICULTY=1
        ;;
      normal|2)
        DIFFICULTY=2
        ;;
      hard|3)
        DIFFICULTY=3
        ;;
      *)
        echo "DIFFICULTY must be peaceful, easy, normal, or hard."
        exit 1
        ;;
    esac
    sed -i "/difficulty\s*=/ c difficulty=$DIFFICULTY" /data/server.properties
  fi

  if [ -n "$MODE" ]; then
    echo "Setting mode"
    case ${MODE,,?} in
      0|1|2|3)
        ;;
      s*)
        MODE=0
        ;;
      c*)
        MODE=1
        ;;
      a*)
        MODE=2
        ;;
      s*)
        MODE=3
        ;;
      *)
        echo "ERROR: Invalid game mode: $MODE"
        exit 1
        ;;
    esac

    sed -i "/gamemode\s*=/ c gamemode=$MODE" /data/server.properties
  fi
fi


if [ -n "$OPS" -a ! -e ops.txt.converted ]; then
  echo "Setting ops"
  echo $OPS | awk -v RS=, '{print}' >> ops.txt
fi

if [ -n "$WHITELIST" -a ! -e white-list.txt.converted ]; then
  echo "Setting whitelist"
  echo $WHITELIST | awk -v RS=, '{print}' >> white-list.txt
fi

if [ -n "$ICON" -a ! -e server-icon.png ]; then
  echo "Using server icon from $ICON..."
  # Not sure what it is yet...call it "img"
  wget -q -O /tmp/icon.img $ICON
  specs=$(identify /tmp/icon.img | awk '{print $2,$3}')
  if [ "$specs" = "PNG 64x64" ]; then
    mv /tmp/icon.img /data/server-icon.png
  else
    echo "Converting image to 64x64 PNG..."
    convert /tmp/icon.img -resize 64x64! /data/server-icon.png
  fi
fi

# Make sure files exist to avoid errors
if [ ! -e banned-players.json ]; then
	echo '' > banned-players.json
fi
if [ ! -e banned-ips.json ]; then
	echo '' > banned-ips.json
fi

# If any modules have been provided, copy them over
[ -d /data/mods ] || mkdir /data/mods
for m in /mods/*.jar
do
  if [ -f "$m" ]; then
    echo Copying mod `basename "$m"`
    cp -f "$m" /data/mods
  fi
done
[ -d /data/config ] || mkdir /data/config
for c in /config/*
do
  if [ -f "$c" ]; then
    echo Copying configuration `basename "$c"`
    cp -rf "$c" /data/config
  fi
done

if [ "$TYPE" = "SPIGOT" ]; then
  echo Copying any Bukkit plugins over
  if [ -d /plugins ]; then
    cp -r /plugins /data
  fi
fi

# If we have a bootstrap.txt file... feed that in to the server stdin
if [ -f /data/bootstrap.txt ];
then
    exec java $JVM_OPTS -jar $SERVER < /data/bootstrap.txt
else
    exec java $JVM_OPTS -jar $SERVER
fi

exec java $JVM_OPTS -jar $SERVER
