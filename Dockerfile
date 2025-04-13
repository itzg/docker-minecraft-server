ARG BASE_IMAGE=eclipse-temurin:21-jre
FROM ${BASE_IMAGE}

# hook into docker BuildKit --platform support
# see https://docs.docker.com/engine/reference/builder/#automatic-platform-args-in-the-global-scope
ARG TARGETOS
ARG TARGETARCH
ARG TARGETVARIANT

# The following three arg/env vars get used by the platform specific "install-packages" script
ARG EXTRA_DEB_PACKAGES=""
ARG EXTRA_DNF_PACKAGES=""
ARG EXTRA_ALPINE_PACKAGES=""
ARG FORCE_INSTALL_PACKAGES=1
RUN --mount=target=/build,source=build \
    TARGET=${TARGETARCH}${TARGETVARIANT} \
    /build/run.sh install-packages

RUN --mount=target=/build,source=build \
    /build/run.sh setup-user

COPY --chmod=644 files/sudoers* /etc/sudoers.d

EXPOSE 25565

ARG APPS_REV=1
ARG GITHUB_BASEURL=https://github.com

ARG EASY_ADD_VERSION=0.8.10
ADD ${GITHUB_BASEURL}/itzg/easy-add/releases/download/${EASY_ADD_VERSION}/easy-add_${TARGETOS}_${TARGETARCH}${TARGETVARIANT} /usr/bin/easy-add
RUN chmod +x /usr/bin/easy-add

ARG RESTIFY_VERSION=1.7.8
RUN easy-add --var os=${TARGETOS} --var arch=${TARGETARCH}${TARGETVARIANT} \
  --var version=${RESTIFY_VERSION} --var app=restify --file {{.app}} \
  --from ${GITHUB_BASEURL}/itzg/{{.app}}/releases/download/{{.version}}/{{.app}}_{{.version}}_{{.os}}_{{.arch}}.tar.gz

ARG RCON_CLI_VERSION=1.7.0
RUN easy-add --var os=${TARGETOS} --var arch=${TARGETARCH}${TARGETVARIANT} \
  --var version=${RCON_CLI_VERSION} --var app=rcon-cli --file {{.app}} \
  --from ${GITHUB_BASEURL}/itzg/{{.app}}/releases/download/{{.version}}/{{.app}}_{{.version}}_{{.os}}_{{.arch}}.tar.gz

ARG MC_MONITOR_VERSION=0.15.5
RUN easy-add --var os=${TARGETOS} --var arch=${TARGETARCH}${TARGETVARIANT} \
  --var version=${MC_MONITOR_VERSION} --var app=mc-monitor --file {{.app}} \
  --from ${GITHUB_BASEURL}/itzg/{{.app}}/releases/download/{{.version}}/{{.app}}_{{.version}}_{{.os}}_{{.arch}}.tar.gz

ARG MC_SERVER_RUNNER_VERSION=1.12.6
RUN easy-add --var os=${TARGETOS} --var arch=${TARGETARCH}${TARGETVARIANT} \
  --var version=${MC_SERVER_RUNNER_VERSION} --var app=mc-server-runner --file {{.app}} \
  --from ${GITHUB_BASEURL}/itzg/{{.app}}/releases/download/{{.version}}/{{.app}}_{{.version}}_{{.os}}_{{.arch}}.tar.gz

ARG MC_HELPER_VERSION=1.41.7
ARG MC_HELPER_BASE_URL=${GITHUB_BASEURL}/itzg/mc-image-helper/releases/download/${MC_HELPER_VERSION}
# used for cache busting local copy of mc-image-helper
ARG MC_HELPER_REV=1
RUN curl -fsSL ${MC_HELPER_BASE_URL}/mc-image-helper-${MC_HELPER_VERSION}.tgz \
  | tar -C /usr/share -zxf - \
  && ln -s /usr/share/mc-image-helper-${MC_HELPER_VERSION}/bin/mc-image-helper /usr/bin

VOLUME ["/data"]
WORKDIR /data

STOPSIGNAL SIGTERM

# End user MUST set EULA and change RCON_PASSWORD
ENV TYPE=VANILLA VERSION=LATEST EULA="" UID=1000 GID=1000 LC_ALL=en_US.UTF-8

COPY --chmod=755 scripts/start* /
COPY --chmod=755 bin/ /usr/local/bin/
COPY --chmod=755 bin/mc-health /health.sh
COPY --chmod=644 files/* /image/
COPY --chmod=755 files/auto /auto

RUN curl -fsSL -o /image/Log4jPatcher.jar https://github.com/CreeperHost/Log4jPatcher/releases/download/v1.0.1/Log4jPatcher-1.0.1.jar

RUN dos2unix /start* /auto/*

ENTRYPOINT [ "/start" ]
HEALTHCHECK --start-period=2m --retries=2 --interval=30s CMD mc-health

ARG BUILDTIME=local
ARG VERSION=local
ARG REVISION=local
RUN echo "buildtime=${BUILDTIME}\nversion=${VERSION}\nrevision=${REVISION}" > /etc/image.properties
