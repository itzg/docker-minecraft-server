#!/bin/bash

export SERVER="minecraft_server.$VANILLA_VERSION.jar"

if [ ! -e $SERVER ]; then
  echo "Downloading $SERVER ..."
  wget -q https://s3.amazonaws.com/Minecraft.Download/versions/$VANILLA_VERSION/$SERVER
fi

# Continue to Final Setup
su-exec minecraft /start-finalSetup01World $@
