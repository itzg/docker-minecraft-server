FROM eclipse-temurin:16-jdk

LABEL org.opencontainers.image.authors="Geoff Bourne <itzgeoff@gmail.com>"

RUN apt-get update \
  && DEBIAN_FRONTEND=noninteractive \
  apt-get install -y \
    imagemagick \
    gosu \
    sudo \
    net-tools \
    iputils-ping \
    curl wget \
    git \
    jq \
    dos2unix \
    mysql-client \
    tzdata \
    rsync \
    nano \
    unzip \
    knockd \
    ttf-dejavu \
    && apt-get clean

RUN addgroup --gid 1000 minecraft \
  && adduser --system --shell /bin/false --uid 1000 --ingroup minecraft --home /data minecraft

COPY files/sudoers* /etc/sudoers.d

EXPOSE 25565 25575

# hook into docker BuildKit --platform support
# see https://docs.docker.com/engine/reference/builder/#automatic-platform-args-in-the-global-scope
ARG TARGETOS
ARG TARGETARCH
ARG TARGETVARIANT

ARG EASY_ADD_VER=0.7.1
ADD https://github.com/itzg/easy-add/releases/download/${EASY_ADD_VER}/easy-add_${TARGETOS}_${TARGETARCH}${TARGETVARIANT} /usr/bin/easy-add
RUN chmod +x /usr/bin/easy-add

RUN easy-add --var os=${TARGETOS} --var arch=${TARGETARCH}${TARGETVARIANT} \
  --var version=1.2.0 --var app=restify --file {{.app}} \
  --from https://github.com/itzg/{{.app}}/releases/download/{{.version}}/{{.app}}_{{.version}}_{{.os}}_{{.arch}}.tar.gz

RUN easy-add --var os=${TARGETOS} --var arch=${TARGETARCH}${TARGETVARIANT} \
 --var version=1.5.1 --var app=rcon-cli --file {{.app}} \
 --from https://github.com/itzg/{{.app}}/releases/download/{{.version}}/{{.app}}_{{.version}}_{{.os}}_{{.arch}}.tar.gz

RUN easy-add --var os=${TARGETOS} --var arch=${TARGETARCH}${TARGETVARIANT} \
 --var version=0.10.1 --var app=mc-monitor --file {{.app}} \
 --from https://github.com/itzg/{{.app}}/releases/download/{{.version}}/{{.app}}_{{.version}}_{{.os}}_{{.arch}}.tar.gz

RUN easy-add --var os=${TARGETOS} --var arch=${TARGETARCH}${TARGETVARIANT} \
 --var version=1.8.0 --var app=mc-server-runner --file {{.app}} \
 --from https://github.com/itzg/{{.app}}/releases/download/{{.version}}/{{.app}}_{{.version}}_{{.os}}_{{.arch}}.tar.gz

RUN easy-add --var os=${TARGETOS} --var arch=${TARGETARCH}${TARGETVARIANT} \
 --var version=0.1.1 --var app=maven-metadata-release --file {{.app}} \
 --from https://github.com/itzg/{{.app}}/releases/download/{{.version}}/{{.app}}_{{.version}}_{{.os}}_{{.arch}}.tar.gz

ARG MC_HELPER_VERSION=1.9.6
ARG MC_HELPER_BASE_URL=https://github.com/itzg/mc-image-helper/releases/download/v${MC_HELPER_VERSION}
RUN curl -fsSL ${MC_HELPER_BASE_URL}/mc-image-helper-${MC_HELPER_VERSION}.tgz \
    | tar -C /usr/share -zxf - \
    && ln -s /usr/share/mc-image-helper-${MC_HELPER_VERSION}/bin/mc-image-helper /usr/bin

VOLUME ["/data"]
WORKDIR /data

STOPSIGNAL SIGTERM

ENV UID=1000 GID=1000 \
  MEMORY="1G" \
  TYPE=VANILLA VERSION=LATEST \
  ENABLE_RCON=true RCON_PORT=25575 RCON_PASSWORD=minecraft \
  SERVER_PORT=25565 ONLINE_MODE=TRUE SERVER_NAME="Dedicated Server" \
  ENABLE_AUTOPAUSE=false AUTOPAUSE_TIMEOUT_EST=3600 AUTOPAUSE_TIMEOUT_KN=120 AUTOPAUSE_TIMEOUT_INIT=600 \
  AUTOPAUSE_PERIOD=10 AUTOPAUSE_KNOCK_INTERFACE=eth0

COPY scripts/start* /
COPY bin/ /usr/local/bin/
COPY bin/mc-health /health.sh
COPY files/server.properties /tmp/server.properties
COPY files/log4j2.xml /tmp/log4j2.xml
COPY files/autopause /autopause

RUN dos2unix /start* && chmod +x /start* \
    && dos2unix /autopause/* && chmod +x /autopause/*.sh

ENTRYPOINT [ "/start" ]
HEALTHCHECK --start-period=1m CMD mc-health
