FROM itzg/ubuntu-openjdk-7

RUN apt-get update
RUN apt-get install -yq git curl wget unzip

ENV MAVEN_VER 3.2.2
ENV NODEJS_VER 0.10.29

WORKDIR /opt

RUN wget -O /tmp/maven.tgz http://apache.mirrors.pair.com/maven/maven-3/$MAVEN_VER/binaries/apache-maven-$MAVEN_VER-bin.tar.gz
RUN tar xvf /tmp/maven.tgz && rm /tmp/maven.tgz
ENV M2_HOME /opt/apache-maven-$MAVEN_VER
ENV PATH $PATH:$M2_HOME/bin

RUN curl -s https://raw.githubusercontent.com/isaacs/nave/master/nave.sh > /usr/local/bin/nave
RUN chmod +x /usr/local/bin/nave
RUN nave usemain latest

WORKDIR /root
env HOME /root

VOLUME ["/shared"]

RUN curl -s get.gvmtool.net | bash

CMD bash
