FROM java:8u92-jre-alpine

MAINTAINER itzg

ENV ES_VERSION=2.3.4

ADD https://download.elasticsearch.org/elasticsearch/release/org/elasticsearch/distribution/tar/elasticsearch/$ES_VERSION/elasticsearch-$ES_VERSION.tar.gz /tmp/es.tgz
RUN cd /usr/share && \
  tar xf /tmp/es.tgz && \
  rm /tmp/es.tgz

ADD start /start

EXPOSE 9200 9300

ENV ES_HOME=/usr/share/elasticsearch-$ES_VERSION \
    OPTS=-Dnetwork.host=_non_loopback_ \
    DEFAULT_ES_USER=elasticsearch

RUN adduser -S -s /bin/sh $DEFAULT_ES_USER

VOLUME ["/data","/conf"]

WORKDIR $ES_HOME

CMD ["/start"]
