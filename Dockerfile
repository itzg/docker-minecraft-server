FROM openjdk:7-jre

LABEL org.opencontainers.image.authors="Geoff Bourne <itzgeoff@gmail.com>"

RUN apt-get update \
  && DEBIAN_FRONTEND=noninteractive \
  apt-get install -y \
    imagemagick \
    sudo \
    net-tools \
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

# Procedure from https://github.com/tianon/gosu/blob/master/INSTALL.md#from-debian
ENV GOSU_VERSION 1.14
RUN set -eux; \
# save list of currently installed packages for later so we can clean up
	savedAptMark="$(apt-mark showmanual)"; \
	apt-get update; \
	apt-get install -y --no-install-recommends ca-certificates wget; \
	if ! command -v gpg; then \
		apt-get install -y --no-install-recommends gnupg2 dirmngr; \
	elif gpg --version | grep -q '^gpg (GnuPG) 1\.'; then \
# "This package provides support for HKPS keyservers." (GnuPG 1.x only)
		apt-get install -y --no-install-recommends gnupg-curl; \
	fi; \
	rm -rf /var/lib/apt/lists/*; \
	\
	dpkgArch="$(dpkg --print-architecture | awk -F- '{ print $NF }')"; \
	wget -O /usr/local/bin/gosu "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$dpkgArch"; \
	wget -O /usr/local/bin/gosu.asc "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$dpkgArch.asc"; \
	\
# verify the signature
	export GNUPGHOME="$(mktemp -d)"; \
	gpg --batch --keyserver hkps://keys.openpgp.org --recv-keys B42F6819007F00F88E364FD4036A9C25BF357DD4; \
	gpg --batch --verify /usr/local/bin/gosu.asc /usr/local/bin/gosu; \
	command -v gpgconf && gpgconf --kill all || :; \
	rm -rf "$GNUPGHOME" /usr/local/bin/gosu.asc; \
	\
# clean up fetch dependencies
	apt-mark auto '.*' > /dev/null; \
	[ -z "$savedAptMark" ] || apt-mark manual $savedAptMark; \
	apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false; \
	\
	chmod +x /usr/local/bin/gosu; \
# verify that the binary works
	gosu --version; \
	gosu nobody true

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
 --var version=1.4.7 --var app=rcon-cli --file {{.app}} \
 --from https://github.com/itzg/{{.app}}/releases/download/{{.version}}/{{.app}}_{{.version}}_{{.os}}_{{.arch}}.tar.gz

RUN easy-add --var os=${TARGETOS} --var arch=${TARGETARCH}${TARGETVARIANT} \
 --var version=0.7.1 --var app=mc-monitor --file {{.app}} \
 --from https://github.com/itzg/{{.app}}/releases/download/{{.version}}/{{.app}}_{{.version}}_{{.os}}_{{.arch}}.tar.gz

RUN easy-add --var os=${TARGETOS} --var arch=${TARGETARCH}${TARGETVARIANT} \
 --var version=1.6.0 --var app=mc-server-runner --file {{.app}} \
 --from https://github.com/itzg/{{.app}}/releases/download/{{.version}}/{{.app}}_{{.version}}_{{.os}}_{{.arch}}.tar.gz

RUN easy-add --var os=${TARGETOS} --var arch=${TARGETARCH}${TARGETVARIANT} \
 --var version=0.1.1 --var app=maven-metadata-release --file {{.app}} \
 --from https://github.com/itzg/{{.app}}/releases/download/{{.version}}/{{.app}}_{{.version}}_{{.os}}_{{.arch}}.tar.gz

COPY mcstatus /usr/local/bin

VOLUME ["/data"]
COPY server.properties /tmp/server.properties
COPY log4j2.xml /tmp/log4j2.xml
WORKDIR /data

STOPSIGNAL SIGTERM

ENV UID=1000 GID=1000 \
  MEMORY="1G" \
  TYPE=VANILLA VERSION=LATEST \
  ENABLE_RCON=true RCON_PORT=25575 RCON_PASSWORD=minecraft \
  SERVER_PORT=25565 ONLINE_MODE=TRUE SERVER_NAME="Dedicated Server" \
  ENABLE_AUTOPAUSE=false AUTOPAUSE_TIMEOUT_EST=3600 AUTOPAUSE_TIMEOUT_KN=120 AUTOPAUSE_TIMEOUT_INIT=600 \
  AUTOPAUSE_PERIOD=10 AUTOPAUSE_KNOCK_INTERFACE=eth0

COPY start* /
COPY health.sh /
ADD files/autopause /autopause

RUN dos2unix /start* && chmod +x /start*
RUN dos2unix /health.sh && chmod +x /health.sh
RUN dos2unix /autopause/* && chmod +x /autopause/*.sh


ENTRYPOINT [ "/start" ]
HEALTHCHECK --start-period=1m CMD /health.sh
