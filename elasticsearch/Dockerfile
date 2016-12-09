FROM java:8u92-jre-alpine

MAINTAINER itzg

RUN apk -U add bash

ENV ES_VERSION=5.1.1

ADD https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-$ES_VERSION.tar.gz /tmp/es.tgz
RUN cd /usr/share && \
  tar xf /tmp/es.tgz && \
  rm /tmp/es.tgz

EXPOSE 9200 9300

ENV ES_HOME=/usr/share/elasticsearch-$ES_VERSION \
    DEFAULT_ES_USER=elasticsearch \
    DISCOVER_TRANSPORT_IP=eth0 \
    DISCOVER_HTTP_IP=eth0 \
    ES_JAVA_OPTS="-Xms1g -Xmx1g"

RUN adduser -S -s /bin/sh $DEFAULT_ES_USER

VOLUME ["/data","/conf"]

WORKDIR $ES_HOME

COPY start /start
COPY log4j2.properties $ES_HOME/config/

CMD ["/start"]
