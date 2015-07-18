FROM itzg/ubuntu-openjdk-7

MAINTAINER itzg

ENV TITAN_VERSION 0.5.4

RUN wget -q -O /tmp/titan.zip http://s3.thinkaurelius.com/downloads/titan/titan-$TITAN_VERSION-hadoop2.zip
RUN unzip -q /tmp/titan.zip -d /opt && rm /tmp/titan.zip

ENV TITAN_HOME /opt/titan-$TITAN_VERSION-hadoop2
WORKDIR $TITAN_HOME

VOLUME ["/conf","/data"]
ADD start-gremlin.sh /opt/start-gremlin.sh

CMD ["/opt/start-gremlin.sh"]
