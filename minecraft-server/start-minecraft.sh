#!/bin/bash

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
case $VERSION in
  LATEST)
    VANILLA_VERSION=`wget -O - https://s3.amazonaws.com/Minecraft.Download/versions/versions.json | jsawk -n 'out(this.latest.release)'`
  ;;
  SNAPSHOT)
    VANILLA_VERSION=`wget -O - https://s3.amazonaws.com/Minecraft.Download/versions/versions.json | jsawk -n 'out(this.latest.snapshot)'`
  ;;
  *)
    VANILLA_VERSION=$VERSION
  ;;
esac

cd /data

echo "Checking minecraft / forge type information."
case $TYPE in
  VANILLA)
    SERVER="minecraft_server.$VANILLA_VERSION.jar"

    if [ ! -e $SERVER ]; then
      echo "Downloading $SERVER ..."
      wget -q https://s3.amazonaws.com/Minecraft.Download/versions/$VANILLA_VERSION/$SERVER
    fi
  ;;

  FORGE)
    # norm := the official Minecraft version as Forge is tracking it. dropped the third part starting with 1.8
    case $VANILLA_VERSION in
      1.7.*)
        norm=$VANILLA_VERSION
      ;;

      *)
        norm=`echo $VANILLA_VERSION | sed 's/^\([0-9]\+\.[0-9]\+\).*/\1/'`
      ;;
    esac

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

    if [ ! -e $SERVER ]; then
      echo "Downloading $FORGE_INSTALLER ..."
      wget -q http://files.minecraftforge.net/maven/net/minecraftforge/forge/$normForgeVersion/$FORGE_INSTALLER
      echo "Installing $SERVER"
      java -jar $FORGE_INSTALLER --installServer
    fi
  ;;

esac

# If supplied with a URL for a world, download it and unpack
case "X$WORLD" in
  Xhttp*)
    echo "Downloading world via HTTP"
    wget -q -O - "$WORLD" > /data/world.zip
    echo "Unzipping word"
    unzip -q /data/world.zip
    rm -f /data/world.zip
    if [ ! -d /data/world ]; then
      echo Renaming world directory...
      for i in /data/*/level.dat; do
        if [ -f "$i" ]; then	
          d=`dirname "$i"`
          mv -f "$d" /data/world
        fi
      done
    fi
    ;;
esac

if [ ! -e server.properties ]; then
  cp /tmp/server.properties .

  if [ -n "$WHITELIST" ]; then
    sed -i "/whitelist\s*=/ c whitelist=true" /data/server.properties
    sed -i "/white-list\s*=/ c white-list=true" /data/server.properties
  fi

  if [ -n "$MOTD" ]; then
    sed -i "/motd\s*=/ c motd=$MOTD" /data/server.properties
  fi

  if [ -n "$LEVEL" ]; then
    sed -i "/level-name\s*=/ c level-name=$LEVEL" /data/server.properties
  fi

  if [ -n "$SEED" ]; then
    sed -i "/level-seed\s*=/ c level-seed=$SEED" /data/server.properties
  fi

  if [ -n "$PVP" ]; then
    sed -i "/pvp\s*=/ c pvp=$PVP" /data/server.properties
  fi

  if [ -n "$LEVEL_TYPE" ]; then
    # normalize to uppercase
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
    sed -i "/generator-settings\s*=/ c generator-settings=$GENERATOR_SETTINGS" /data/server.properties
  fi

  if [ -n "$DIFFICULTY" ]; then
    case $DIFFICULTY in
      peaceful)
        DIFFICULTY=0
        ;;
      easy)
        DIFFICULTY=1
        ;;
      normal)
        DIFFICULTY=2
        ;;
      hard)
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
    case ${MODE,,?} in
      0|1|2|3)
        ;;
      s*)
        MODE=0
        ;;
      c*)
        MODE=1
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
  echo $OPS | awk -v RS=, '{print}' >> ops.txt
fi

if [ -n "$WHITELIST" -a ! -e white-list.txt.converted ]; then
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
if [ ! -e banned-ip.json ]; then
	echo '' > banned-ip.json
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


exec java $JVM_OPTS -jar $SERVER
