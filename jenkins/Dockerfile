FROM java:openjdk-8u102-jdk

MAINTAINER itzg

RUN apt-get update && \
  DEBIAN_FRONTEND=noninteractive apt-get install -y \
  graphviz \
  && apt-get clean

ENV JENKINS_HOME=/data

VOLUME ["/data", "/root", "/opt/jenkins"]
EXPOSE 8080 38252

COPY download-and-start.sh /download-and-start

CMD ["/download-and-start"]
