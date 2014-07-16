FROM itzg/ubuntu-openjdk-7

MAINTAINER itzg

ENV APT_GET_UPDATE 2014-07-19

RUN apt-get update
RUN apt-get install -y wget unzip

ENV TITAN_VER 0.4.4
ENV TITAN_STORAGE all
ENV REXSTER_VER 2.4.0

RUN wget -O /tmp/titan.zip http://s3.thinkaurelius.com/downloads/titan/titan-$TITAN_STORAGE-$TITAN_VER.zip
RUN wget -O /tmp/rexster.zip http://tinkerpop.com/downloads/rexster/rexster-server-$REXSTER_VER.zip

WORKDIR /opt

RUN unzip /tmp/titan.zip
RUN rm /tmp/titan.zip

RUN unzip /tmp/rexster.zip
RUN rm /tmp/rexster.zip

RUN ln -s titan-$TITAN_STORAGE-$TITAN_VER titan
RUN ln -s rexster-server-$REXSTER_VER rexster-server

RUN mkdir /opt/rexster-server/ext/titan
RUN ln -s /opt/titan-$TITAN_STORAGE-$TITAN_VER/lib/* /opt/rexster-server/ext/titan
RUN wget -O /opt/rexster-server/ext/titan/titan-rexter-$TITAN_VER.jar \
   http://central.maven.org/maven2/com/thinkaurelius/titan/titan-rexster/$TITAN_VER/titan-rexster-$TITAN_VER.jar

# Clean up distro area
RUN rm /opt/rexster-server/ext/titan/log4j* /opt/rexster-server/ext/titan/slf4j*
RUN rm /opt/rexster-server/lib/lucene-core*

ADD gremlin /usr/local/bin/gremlin
ADD rexster /usr/local/bin/rexster

WORKDIR titan

ADD titan.properties /opt/titan/conf/titan.properties
ADD init-graph-storage.groovy /tmp/init-graph-storage.groovy

VOLUME ["/data", "/config", "/scripts"]
RUN ln -s /data /opt/titan/db

RUN gremlin -e /tmp/init-graph-storage.groovy && rm /tmp/init-graph-storage.groovy

EXPOSE 8182 8184

ADD rexster.xml /config/rexster.xml

CMD ["/usr/local/bin/rexster", "-s", "-c", "/config/rexster.xml"]
