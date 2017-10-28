#!/bin/bash

function buildSpigotFromSource {
  echo "Building Spigot $VANILLA_VERSION from source, might take a while, get some coffee"
  mkdir /data/temp
  cd /data/temp
  wget -q -P /data/temp https://hub.spigotmc.org/jenkins/job/BuildTools/lastSuccessfulBuild/artifact/target/BuildTools.jar && \
    java -jar /data/temp/BuildTools.jar --rev $VANILLA_VERSION 2>&1 |tee /data/spigot_build.log| while read l; do echo -n .; done; echo "done"
  mv spigot-*.jar /data/spigot_server.jar
  mv craftbukkit-*.jar /data/craftbukkit_server.jar
  echo "Cleaning up"
  rm -rf /data/temp
  cd /data
}

function downloadSpigot {
  local match
  case "$TYPE" in
    *BUKKIT|*bukkit)
      match="Craftbukkit"
      downloadUrl=${BUKKIT_DOWNLOAD_URL}
      ;;
    *)
      match="Spigot"
      downloadUrl=${SPIGOT_DOWNLOAD_URL}
      ;;
  esac

  if [[ -z $downloadUrl ]]; then
    downloadUrl=$(restify --class=jar-div https://mcadmin.net/ | \
      jq --arg version "$match $VANILLA_VERSION" -r -f /usr/share/mcadmin.jq)
    if [[ -z $downloadUrl ]]; then
      echo "ERROR: Version $VANILLA_VERSION is not supported for $TYPE"
      echo "       Refer to https://mcadmin.net/ for supported versions"
      exit 2
    fi
  fi

  echo "Downloading $match"
  curl -kfsSL -o $SERVER "$downloadUrl"
  status=$?
  if [ ! -f $SERVER ]; then
    echo "ERROR: failed to download from $downloadUrl (status=$status)"
    exit 3
  fi

}


case "$TYPE" in
  *BUKKIT|*bukkit)
    export SERVER=craftbukkit_server.jar
    ;;
  *)
    export SERVER=spigot_server.jar
    ;;
esac

if [ ! -f $SERVER ]; then
   if [[ "$BUILD_SPIGOT_FROM_SOURCE" = TRUE || "$BUILD_SPIGOT_FROM_SOURCE" = true || "$BUILD_FROM_SOURCE" = TRUE || "$BUILD_FROM_SOURCE" = true ]]; then
     buildSpigotFromSource
   else
     downloadSpigot
   fi
fi

# Normalize on Spigot for operations below
export TYPE=SPIGOT

# Continue to Final Setup
su-exec minecraft /start-finalSetup01World $@
