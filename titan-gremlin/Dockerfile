FROM openjdk:8-jre

LABEL maintainer "itzg"

ENV TITAN_VERSION 0.5.4

ADD http://s3.thinkaurelius.com/downloads/titan/titan-$TITAN_VERSION-hadoop2.zip /tmp/titan.zip
RUN unzip -q /tmp/titan.zip -d /opt && \
    rm /tmp/titan.zip

ENV TITAN_HOME /opt/titan-$TITAN_VERSION-hadoop2
WORKDIR $TITAN_HOME

VOLUME ["/conf","/data"]
ADD start-gremlin.sh /opt/start-gremlin.sh

CMD ["/opt/start-gremlin.sh"]
