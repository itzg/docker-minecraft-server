FROM java:openjdk-8u72-jdk

MAINTAINER itzg

ENV ES_VERSION 2.3.2

RUN wget -qO /tmp/es.tgz https://download.elasticsearch.org/elasticsearch/release/org/elasticsearch/distribution/tar/elasticsearch/$ES_VERSION/elasticsearch-$ES_VERSION.tar.gz && \
  cd /usr/share && \
  tar xf /tmp/es.tgz && \
  rm /tmp/es.tgz

ENV ES_HOME /usr/share/elasticsearch-$ES_VERSION
RUN useradd -d $ES_HOME -M -r elasticsearch && \
  chown -R elasticsearch: $ES_HOME

RUN mkdir /data /conf && touch /data/.CREATED /conf/.CREATED && chown -R elasticsearch: /data /conf
VOLUME ["/data","/conf"]

ADD start /start

WORKDIR $ES_HOME
USER elasticsearch

EXPOSE 9200 9300

ENV OPTS=-Dnetwork.host=_non_loopback_

CMD ["/start"]
