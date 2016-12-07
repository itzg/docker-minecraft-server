FROM alpine
#FROM container4armhf/armhf-alpine

MAINTAINER itzg

RUN echo "http://dl-3.alpinelinux.org/alpine/v3.5/community/" >> /etc/apk/repositories &&\
        apk update && \
        apk add \
          openjdk8-jre-base \
          openssl \
          imagemagick \
          lsof \
          su-exec \
          bash \
          git \
          jq &&\
        rm -rf /var/cache/apk/*

          #nano \
          #sudo \
          #vim \

RUN addgroup -g 1000 minecraft \
  && adduser -Ss /bin/false -u 1000 -G minecraft -h /home/minecraft minecraft \
  && mkdir /data \
  && mkdir /config \
  && mkdir /mods \
  && mkdir /plugins \
  && chown minecraft:minecraft /data /config /mods /plugins /home/minecraft

EXPOSE 25565 25575

#ADD https://github.com/itzg/restify/releases/download/1.0.3/restify_linux_arm /usr/local/bin/restify
ADD https://github.com/itzg/restify/releases/download/1.0.3/restify_linux_amd64 /usr/local/bin/restify
COPY start.sh /start
COPY start-minecraft.sh /start-minecraft
COPY mcadmin.jq /usr/share
RUN chmod +x /usr/local/bin/*

VOLUME ["/data","/mods","/config","/plugins","/home/minecraft"]
COPY server.properties /tmp/server.properties
WORKDIR /data

ENTRYPOINT [ "/start" ]

ENV UID=1000 GID=1000 \
    MOTD="A Minecraft Server Powered by Docker" \
    JVM_OPTS="-Xmx1024M -Xms1024M" \
    TYPE=VANILLA VERSION=LATEST FORGEVERSION=RECOMMENDED LEVEL=world PVP=true DIFFICULTY=easy \
    LEVEL_TYPE=DEFAULT GENERATOR_SETTINGS= WORLD= MODPACK= ONLINE_MODE=TRUE CONSOLE=true
