FROM itzg/ubuntu-openjdk-7

MAINTAINER itzg

ENV APT_GET_UPDATE 2015-10-03
RUN apt-get update

RUN DEBIAN_FRONTEND=noninteractive apt-get install -y libmozjs-24-bin imagemagick lsof && apt-get clean
RUN update-alternatives --install /usr/bin/js js /usr/bin/js24 100

RUN wget -O /usr/bin/jsawk https://github.com/micha/jsawk/raw/master/jsawk
RUN chmod +x /usr/bin/jsawk
RUN useradd -M -s /bin/false --uid 1000 minecraft \
  && mkdir /data \
  && mkdir /config \
  && mkdir /mods \
  && mkdir /plugins \
  && chown minecraft:minecraft /data /config /mods /plugins

EXPOSE 25565

COPY start.sh /start
COPY start-minecraft.sh /start-minecraft

VOLUME ["/data"]
VOLUME ["/mods"]
VOLUME ["/config"]
VOLUME ["/plugins"]
COPY server.properties /tmp/server.properties
WORKDIR /data

CMD [ "/start" ]

# Special marker ENV used by MCCY management tool
ENV MC_IMAGE=YES

ENV UID=1000 GID=1000
ENV MOTD A Minecraft Server Powered by Docker
ENV JVM_OPTS -Xmx1024M -Xms1024M
ENV TYPE=VANILLA VERSION=LATEST FORGEVERSION=RECOMMENDED LEVEL=world PVP=true DIFFICULTY=easy \
  LEVEL_TYPE=DEFAULT GENERATOR_SETTINGS= WORLD= MODPACK=
