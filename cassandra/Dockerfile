FROM java:openjdk-8u72-jdk

MAINTAINER itzg

ENV CASSANDRA_VERSION 2.2.6

RUN wget -qO /tmp/apache-cassandra.tgz http://mirrors.ibiblio.org/apache/cassandra/$CASSANDRA_VERSION/apache-cassandra-$CASSANDRA_VERSION-bin.tar.gz
RUN tar -C /opt -zxf /tmp/apache-cassandra.tgz && \
  rm /tmp/apache-cassandra.tgz


RUN mv /opt/apache-cassandra-$CASSANDRA_VERSION /opt/cassandra
ENV CASSANDRA_HOME /opt/cassandra
ENV CASSANDRA_CONF /conf
ENV CASSANDRA_DATA /data
WORKDIR $CASSANDRA_HOME

RUN ln -s $CASSANDRA_HOME/bin/* /usr/local/bin
VOLUME ["/data","/conf"]

EXPOSE 9042 9160 7000 7001

ADD cassandra.in.sh $CASSANDRA_HOME/cassandra.in.sh
RUN mv $CASSANDRA_HOME/bin/cassandra.in.sh $CASSANDRA_HOME/bin/orig.cassandra.in.sh

CMD ["/opt/cassandra/bin/cassandra", "-f"]
