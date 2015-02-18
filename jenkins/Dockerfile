FROM itzg/ubuntu-openjdk-7

MAINTAINER itzg

RUN DEBIAN_FRONTEND=noninteractive apt-get -y install curl && apt-get clean

ADD download-and-start.sh /download-and-start

ENV JENKINS_HOME /data
VOLUME ["/data"]
EXPOSE 8080 38252

CMD ["/download-and-start"]
