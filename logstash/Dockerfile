FROM itzg/ubuntu-openjdk-7

LABEL maintainer "itzg"

ENV LOGSTASH_VERSION 1.5.0-1

RUN wget -qO /tmp/logstash.deb http://download.elastic.co/logstash/logstash/packages/debian/logstash_${LOGSTASH_VERSION}_all.deb

RUN dpkg -i /tmp/logstash.deb && rm /tmp/logstash.deb

WORKDIR /opt/logstash

# For collectd reception
EXPOSE 25826

# /conf is the default directory where our logstash will read pipeline config files
# /logs is an optional attach point to reference something like /var/log on the host
VOLUME ["/conf","/logs"]

ENV PLUGIN_UPDATES 2015-06-10

RUN bin/plugin install logstash-input-heartbeat
RUN bin/plugin install logstash-output-elasticsearch_groom

CMD ["bin/logstash","agent","-f","/conf"]
