FROM itzg/ubuntu-openjdk-7

MAINTAINER itzg

ENV KIBANA_VERSION 4.1.1

RUN wget -q -O /tmp/kibana.tgz https://download.elasticsearch.org/kibana/kibana/kibana-${KIBANA_VERSION}-linux-x64.tar.gz

RUN tar -C /opt -xzf /tmp/kibana.tgz && rm /tmp/kibana.tgz
ENV KIBANA_HOME /opt/kibana-$KIBANA_VERSION-linux-x64

# Simplify for cross-container
ENV ES_URL http://es:9200

WORKDIR $KIBANA_HOME

ADD start.sh /start

EXPOSE 5601

CMD ["/start"]
