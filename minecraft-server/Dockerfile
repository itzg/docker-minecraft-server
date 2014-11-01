FROM itzg/ubuntu-openjdk-7

MAINTAINER itzg

RUN apt-get install -y wget libmozjs-24-bin
RUN update-alternatives --install /usr/bin/js js /usr/bin/js24 100

RUN wget -O /usr/bin/jsawk https://github.com/micha/jsawk/raw/master/jsawk
RUN chmod +x /usr/bin/jsawk
RUN useradd -M -s /bin/false minecraft

EXPOSE 25565

ADD start.sh /start
ADD start-minecraft.sh /start-minecraft

VOLUME ['/data']
ADD server.properties /tmp/server.properties
WORKDIR /data

CMD /start

ENV MOTD A Minecraft Server Powered by Docker
ENV LEVEL world
ENV JVM_OPTS -Xmx1024M -Xms1024M
ENV VERSION 1.8
