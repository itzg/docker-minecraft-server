# syntax = docker/dockerfile:1.3

ARG BASE_IMAGE=eclipse-temurin:17-jre-focal
FROM ${BASE_IMAGE}

# CI system should set this to a hash or git revision of the build directory and it's contents to
# ensure consistent cache updates.
ARG BUILD_FILES_REV=1
RUN --mount=target=/build,source=build \
    REV=${BUILD_FILES_REV} /build/run.sh install-packages

RUN --mount=target=/build,source=build \
    REV=${BUILD_FILES_REV} /build/run.sh setup-user

COPY --chmod=644 files/sudoers* /etc/sudoers.d

EXPOSE 25565

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
  --var version=1.6.1 --var app=rcon-cli --file {{.app}} \
  --from https://github.com/itzg/{{.app}}/releases/download/{{.version}}/{{.app}}_{{.version}}_{{.os}}_{{.arch}}.tar.gz

RUN easy-add --var os=${TARGETOS} --var arch=${TARGETARCH}${TARGETVARIANT} \
  --var version=0.11.0 --var app=mc-monitor --file {{.app}} \
  --from https://github.com/itzg/{{.app}}/releases/download/{{.version}}/{{.app}}_{{.version}}_{{.os}}_{{.arch}}.tar.gz

RUN easy-add --var os=${TARGETOS} --var arch=${TARGETARCH}${TARGETVARIANT} \
  --var version=1.8.3 --var app=mc-server-runner --file {{.app}} \
  --from https://github.com/itzg/{{.app}}/releases/download/{{.version}}/{{.app}}_{{.version}}_{{.os}}_{{.arch}}.tar.gz

RUN easy-add --var os=${TARGETOS} --var arch=${TARGETARCH}${TARGETVARIANT} \
  --var version=0.1.1 --var app=maven-metadata-release --file {{.app}} \
  --from https://github.com/itzg/{{.app}}/releases/download/{{.version}}/{{.app}}_{{.version}}_{{.os}}_{{.arch}}.tar.gz

ARG MC_HELPER_VERSION=1.25.12
ARG MC_HELPER_BASE_URL=https://github.com/itzg/mc-image-helper/releases/download/${MC_HELPER_VERSION}
RUN curl -fsSL ${MC_HELPER_BASE_URL}/mc-image-helper-${MC_HELPER_VERSION}.tgz \
  | tar -C /usr/share -zxf - \
  && ln -s /usr/share/mc-image-helper-${MC_HELPER_VERSION}/bin/mc-image-helper /usr/bin

# Install modified knockd
ADD https://github.com/Metalcape/knock/releases/download/0.8.1/knock-0.8.1-${TARGETARCH}${TARGETVARIANT}.tar.gz /tmp/knock.tar.gz
RUN tar -xf /tmp/knock.tar.gz -C /usr/local/ && rm /tmp/knock.tar.gz
RUN find /usr/lib -name 'libpcap.so.0.8' -execdir cp '{}' libpcap.so.1 \;

VOLUME ["/data"]
WORKDIR /data

STOPSIGNAL SIGTERM

# End user MUST set EULA and change RCON_PASSWORD
ENV TYPE=VANILLA VERSION=LATEST EULA="" UID=1000 GID=1000 RCON_PASSWORD=minecraft

COPY --chmod=755 scripts/start* /
COPY --chmod=755 bin/ /usr/local/bin/
COPY --chmod=755 bin/mc-health /health.sh
COPY --chmod=644 files/log4j2.xml /image/log4j2.xml
# By default this file gets retrieved from repo, but bundle in image as potential fallback
COPY --chmod=644 files/cf-exclude-include.json /image/cf-exclude-include.json
COPY --chmod=755 files/auto /auto

RUN dos2unix /start* /auto/*

ENTRYPOINT [ "/start" ]
HEALTHCHECK --start-period=1m --interval=5s --retries=24 CMD mc-health
