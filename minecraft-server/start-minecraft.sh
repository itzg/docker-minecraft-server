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

case $VERSION in
  LATEST)
    VANILLA_VERSION=`wget -O - https://s3.amazonaws.com/Minecraft.Download/versions/versions.json | jsawk -n 'out(this.latest.release)'`
    FORGE_VERSION=`wget -O - http://files.minecraftforge.net/maven/net/minecraftforge/forge/promotions_slim.json \
                    | jsawk -n 'out(this.promos.recommended)'`
  ;;
  SNAPSHOT)
    VANILLA_VERSION=`wget -O - https://s3.amazonaws.com/Minecraft.Download/versions/versions.json | jsawk -n 'out(this.latest.snapshot)'`
    FORGE_VERSION=`wget -O - http://files.minecraftforge.net/maven/net/minecraftforge/forge/promotions_slim.json \
                    | jsawk -n 'out(this.promos.latest)'`
  ;;
esac

cd /data

case $TYPE in
  VANILLA)
    SERVER="minecraft_server.$VANILLA_VERSION.jar"

    if [ ! -e $SERVER ]; then
      echo "Downloading $SERVER ..."
      wget -q https://s3.amazonaws.com/Minecraft.Download/versions/$VANILLA_VERSION/$SERVER
    fi
  ;;

  FORGE)
    FORGE_INSTALLER="forge-$VERSION-$FORGE_VERSION-installer.jar"
    SERVER="forge-$VERSION-$FORGE_VERSION-universal.jar"

    if [ ! -e $SERVER ]; then
      echo "Downloading $SERVER ..."
      wget -q http://files.minecraftforge.net/maven/net/minecraftforge/forge/$VERSION-$FORGE_VERSION/$FORGE_INSTALLER
    fi

    echo "Installing $SERVER"
    exec java -jar $FORGE_INSTALLER --installServer
  ;;
esac

if [ ! -e server.properties ]; then
  cp /tmp/server.properties .

  if [ -n "$MOTD" ]; then
    sed -i "/motd\s*=/ c motd=$MOTD" /data/server.properties
  fi

  if [ -n "$LEVEL" ]; then
    sed -i "/level-name\s*=/ c level-name=$LEVEL" /data/server.properties
  fi

  if [ -n "$SEED" ]; then
    sed -i "/level-seed\s*=/ c level-seed=$SEED" /data/server.properties
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

exec java $JVM_OPTS -jar $SERVER
