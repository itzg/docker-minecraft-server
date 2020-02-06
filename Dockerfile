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

# hook into docker buildx --platform support
# see https://github.com/docker/buildx/#---platformvaluevalue
ARG TARGETPLATFORM=linux/amd64

ARG EASY_ADD_VER=0.5.1
ADD "https://easy-add-downloader.now.sh/api/download?version=${EASY_ADD_VER}&platform=${TARGETPLATFORM}" /usr/bin/easy-add
RUN chmod +x /usr/bin/easy-add

RUN easy-add --var version=1.2.0 --var app=restify --file restify --from https://github.com/itzg/{{.app}}/releases/download/{{.version}}/{{.app}}_{{.version}}_{{.os}}_{{.arch}}.tar.gz

RUN easy-add --var version=1.4.7 --var app=rcon-cli --file rcon-cli --from https://github.com/itzg/{{.app}}/releases/download/{{.version}}/{{.app}}_{{.version}}_{{.os}}_{{.arch}}.tar.gz

RUN easy-add --var version=0.1.6 --var app=mc-monitor --file mc-monitor --from https://github.com/itzg/{{.app}}/releases/download/v{{.version}}/{{.app}}_{{.version}}_Linux_{{.arch}}.tar.gz

RUN easy-add --var version=1.3.3 --var app=mc-server-runner --file mc-server-runner --from https://github.com/itzg/{{.app}}/releases/download/{{.version}}/{{.app}}_{{.version}}_{{.os}}_{{.arch}}.tar.gz

RUN easy-add --var version=0.1.0 --var app=maven-metadata-release --file maven-metadata-release --from https://github.com/itzg/{{.app}}/releases/download/v{{.version}}/{{.app}}_{{.version}}_{{.os}}_{{.arch}}.tar.gz

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
