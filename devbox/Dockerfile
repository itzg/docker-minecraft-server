FROM itzg/ubuntu-openjdk-7

RUN apt-get update
RUN DEBIAN_FRONTEND=noninteractive \
  apt-get install -yq git curl wget unzip openjdk-7-jdk && \
  apt-get clean

ENV MAVEN_VER 3.3.3
ENV NODEJS_VER 0.12.7

RUN wget -O /tmp/maven.tgz http://apache.mirrors.pair.com/maven/maven-3/$MAVEN_VER/binaries/apache-maven-$MAVEN_VER-bin.tar.gz
RUN tar xvf /tmp/maven.tgz && rm /tmp/maven.tgz
ENV M2_HOME /opt/apache-maven-$MAVEN_VER
ENV PATH $PATH:$M2_HOME/bin

RUN curl -s https://raw.githubusercontent.com/isaacs/nave/master/nave.sh > /usr/local/bin/nave
RUN chmod +x /usr/local/bin/nave
RUN nave usemain latest

RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

VOLUME ["/shared"]

RUN useradd -m -d /home/developer developer

USER developer
RUN curl -s get.gvmtool.net | bash

WORKDIR /home/developer
CMD bash
