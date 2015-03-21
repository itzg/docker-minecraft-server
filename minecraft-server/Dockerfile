FROM itzg/ubuntu-openjdk-7

MAINTAINER itzg

RUN apt-get update
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y libmozjs-24-bin imagemagick && apt-get clean
RUN update-alternatives --install /usr/bin/js js /usr/bin/js24 100

RUN wget -O /usr/bin/jsawk https://github.com/micha/jsawk/raw/master/jsawk
RUN chmod +x /usr/bin/jsawk
RUN useradd -M -s /bin/false --uid 1000 minecraft \
  && mkdir /data \
  && chown minecraft:minecraft /data

EXPOSE 25565

COPY start.sh /start
COPY start-minecraft.sh /start-minecraft

VOLUME ["/data"]
COPY server.properties /tmp/server.properties
WORKDIR /data

CMD [ "/start" ]

ENV UID 1000
ENV MOTD A Minecraft Server Powered by Docker
ENV LEVEL world
ENV JVM_OPTS -Xmx1024M -Xms1024M
ENV TYPE VANILLA
ENV VERSION LATEST
