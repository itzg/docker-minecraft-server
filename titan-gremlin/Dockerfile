FROM itzg/ubuntu-openjdk-7

MAINTAINER itzg

RUN apt-get install -y wget unzip

RUN wget -q -O /tmp/titan.zip http://s3.thinkaurelius.com/downloads/titan/titan-0.5.0-hadoop2.zip
RUN unzip /tmp/titan.zip -d /opt && rm /tmp/titan.zip

ENV TITAN_HOME /opt/titan-0.5.0-hadoop2
WORKDIR $TITAN_HOME

VOLUME ["/conf","/data"]
ADD start-gremlin.sh /opt/start-gremlin.sh

CMD ["/bin/bash", "-e", "/opt/start-gremlin.sh"]

