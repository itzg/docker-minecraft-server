FROM openjdk:8u212-jre-alpine

LABEL maintainer "itzg"

RUN apk add --no-cache -U \
  openssl \
  imagemagick \
  lsof \
  su-exec \
  shadow \
  bash \
  curl iputils wget \
  git \
  jq \
  mysql-client \
  tzdata \
  rsync \
  nano

HEALTHCHECK --start-period=1m CMD mc-monitor status --host localhost --port $SERVER_PORT

RUN addgroup -g 1000 minecraft \
  && adduser -Ss /bin/false -u 1000 -G minecraft -h /home/minecraft minecraft \
  && mkdir -m 777 /data /mods /config /plugins \
  && chown minecraft:minecraft /data /config /mods /plugins /home/minecraft

EXPOSE 25565 25575

ARG ARCH=amd64

ARG EASY_ADD_VER=0.3.0
ADD https://github.com/itzg/easy-add/releases/download/${EASY_ADD_VER}/easy-add_${EASY_ADD_VER}_linux_${ARCH} /usr/bin/easy-add
RUN chmod +x /usr/bin/easy-add

ARG RESTIFY_VER=1.2.1
RUN easy-add --file restify --from https://github.com/itzg/restify/releases/download/${RESTIFY_VER}/restify_${RESTIFY_VER}_linux_${ARCH}.tar.gz

ARG RCON_CLI_VER=1.4.7
RUN easy-add --file rcon-cli --from https://github.com/itzg/rcon-cli/releases/download/${RCON_CLI_VER}/rcon-cli_${RCON_CLI_VER}_linux_${ARCH}.tar.gz

ARG MC_MONITOR_VER=0.1.6
RUN easy-add --file mc-monitor --from https://github.com/itzg/mc-monitor/releases/download/v${MC_MONITOR_VER}/mc-monitor_${MC_MONITOR_VER}_Linux_${ARCH}.tar.gz

ARG MC_RUN_VER=1.3.3
RUN easy-add --file mc-server-runner --from https://github.com/itzg/mc-server-runner/releases/download/${MC_RUN_VER}/mc-server-runner_${MC_RUN_VER}_linux_${ARCH}.tar.gz

ARG MVN_META_REL_VER=0.1.0
RUN easy-add --file maven-metadata-release --from https://github.com/itzg/maven-metadata-release/releases/download/v${MVN_META_REL_VER}/maven-metadata-release_${MVN_META_REL_VER}_linux_${ARCH}.tar.gz

COPY mcadmin.jq /usr/share
COPY mcstatus /usr/local/bin

VOLUME ["/data","/mods","/config"]
COPY server.properties /tmp/server.properties
WORKDIR /data

ENTRYPOINT [ "/start" ]

ENV UID=1000 GID=1000 \
  JVM_XX_OPTS="-XX:+UseG1GC" MEMORY="1G" \
  TYPE=VANILLA VERSION=LATEST FORGEVERSION=RECOMMENDED SPONGEBRANCH=STABLE SPONGEVERSION= FABRICVERSION=LATEST LEVEL=world \
  PVP=true DIFFICULTY=easy ENABLE_RCON=true RCON_PORT=25575 RCON_PASSWORD=minecraft \
  RESOURCE_PACK= RESOURCE_PACK_SHA1= \
  LEVEL_TYPE=DEFAULT GENERATOR_SETTINGS= WORLD= MODPACK= MODS= SERVER_PORT=25565 ONLINE_MODE=TRUE CONSOLE=true SERVER_NAME="Dedicated Server" \
  REPLACE_ENV_VARIABLES="FALSE" ENV_VARIABLE_PREFIX="CFG_"

COPY start* /
RUN dos2unix /start* && chmod +x /start*
