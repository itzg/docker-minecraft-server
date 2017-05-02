FROM java:openjdk-8u102-jdk

LABEL maintainer "itzg"

RUN apt-get update && \
  DEBIAN_FRONTEND=noninteractive apt-get install -y \
  graphviz \
  && apt-get clean

ENV JENKINS_HOME=/data

VOLUME ["/data", "/root", "/opt/jenkins"]
EXPOSE 8080 38252

COPY download-and-start.sh /opt/download-and-start

CMD ["/opt/download-and-start"]
