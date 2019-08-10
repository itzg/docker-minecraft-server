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
  nano \
  python python-dev py2-pip

RUN pip install mcstatus yq

HEALTHCHECK CMD mcstatus localhost:$SERVER_PORT ping

RUN addgroup -g 1000 minecraft \
  && adduser -Ss /bin/false -u 1000 -G minecraft -h /home/minecraft minecraft \
  && mkdir -m 777 /data /mods /config /plugins \
  && chown minecraft:minecraft /data /config /mods /plugins /home/minecraft

EXPOSE 25565 25575

RUN echo 'hosts: files dns' > /etc/nsswitch.conf

ARG RESTIFY_VER=1.1.6
ARG RCON_CLI_VER=1.4.6
ARG MC_SERVER_RUNNER_VER=1.3.2
ARG ARCH=amd64

ADD https://github.com/itzg/restify/releases/download/${RESTIFY_VER}/restify_${RESTIFY_VER}_linux_${ARCH}.tar.gz /tmp/restify.tgz
RUN tar -x -C /usr/local/bin -f /tmp/restify.tgz restify && \
  rm /tmp/restify.tgz

ADD https://github.com/itzg/rcon-cli/releases/download/${RCON_CLI_VER}/rcon-cli_${RCON_CLI_VER}_linux_${ARCH}.tar.gz /tmp/rcon-cli.tgz
RUN tar -x -C /usr/local/bin -f /tmp/rcon-cli.tgz rcon-cli && \
  rm /tmp/rcon-cli.tgz

ADD https://github.com/itzg/mc-server-runner/releases/download/${MC_SERVER_RUNNER_VER}/mc-server-runner_${MC_SERVER_RUNNER_VER}_linux_${ARCH}.tar.gz /tmp/mc-server-runner.tgz
RUN tar -x -C /usr/local/bin -f /tmp/mc-server-runner.tgz mc-server-runner && \
  rm /tmp/mc-server-runner.tgz

COPY mcadmin.jq /usr/share
RUN chmod +x /usr/local/bin/*

VOLUME ["/data","/mods","/config"]
COPY server.properties /tmp/server.properties
WORKDIR /data

ENTRYPOINT [ "/start" ]

ENV UID=1000 GID=1000 \
  JVM_XX_OPTS="-XX:+UseG1GC" MEMORY="1G" \
  TYPE=VANILLA VERSION=LATEST FORGEVERSION=RECOMMENDED SPONGEBRANCH=STABLE SPONGEVERSION= FABRICVERSION=LATEST LEVEL=world \
  PVP=true DIFFICULTY=easy ENABLE_RCON=true RCON_PORT=25575 RCON_PASSWORD=minecraft \
  LEVEL_TYPE=DEFAULT GENERATOR_SETTINGS= WORLD= MODPACK= MODS= SERVER_PORT=25565 ONLINE_MODE=TRUE CONSOLE=true SERVER_NAME="Dedicated Server" \
  REPLACE_ENV_VARIABLES="FALSE" ENV_VARIABLE_PREFIX="CFG_"

COPY start* /
RUN dos2unix /start* && chmod +x /start*
