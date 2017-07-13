FROM openjdk:8u121-jre-alpine

LABEL maintainer "itzg"

RUN apk -U add bash

ARG ES_VERSION=5.5.0

ADD https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-$ES_VERSION.tar.gz /tmp
# need to adapt to both Docker's new remote-unpack-ADD behavior and the old behavior
RUN cd /usr/share && \
  if [ -f /tmp/elasticsearch-$ES_VERSION.tar.gz ]; then tar xf /tmp/es.tgz; else mv /tmp/elasticsearch-${ES_VERSION} /usr/share; fi && \
  rm -f /tmp/elasticsearch-$ES_VERSION.tar.gz

EXPOSE 9200 9300

HEALTHCHECK --timeout=5s CMD wget -q -O - http://$HOSTNAME:9200/_cat/health

ENV ES_HOME=/usr/share/elasticsearch-$ES_VERSION \
    DEFAULT_ES_USER=elasticsearch \
    ES_JAVA_OPTS="-Xms1g -Xmx1g"

RUN adduser -S -s /bin/sh $DEFAULT_ES_USER

VOLUME ["/data","/conf"]

WORKDIR $ES_HOME

COPY java.policy /usr/lib/jvm/java-1.8-openjdk/jre/lib/security/
COPY start /start
COPY log4j2.properties $ES_HOME/config/

CMD ["/start"]
