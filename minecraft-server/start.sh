#!/bin/sh

case $VERSION in
  LATEST)
    export VERSION=`wget -O - https://s3.amazonaws.com/Minecraft.Download/versions/versions.json | jsawk -n 'out(this.latest.release)'`
    ;;

  SNAPSHOT)
    export VERSION=`wget -O - https://s3.amazonaws.com/Minecraft.Download/versions/versions.json | jsawk -n 'out(this.latest.snapshot)'`
    ;;
esac

cd /data

if [ ! -e minecraft_server.$VERSION.jar ]; then
  wget https://s3.amazonaws.com/Minecraft.Download/versions/$VERSION/minecraft_server.$VERSION.jar
fi

if [ ! -e server.properties ]; then
  cp /tmp/server.properties .
fi

sed -i "/motd\s*=/ c motd=$MOTD" /data/server.properties
sed -i "/level-name\s*=/ c level-name=$LEVEL" /data/server.properties

java $JVM_OPTS -jar minecraft_server.$VERSION.jar
