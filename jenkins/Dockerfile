FROM java:openjdk-8u72-jdk

MAINTAINER itzg

ADD download-and-start.sh /download-and-start

ENV JENKINS_HOME /data
VOLUME ["/data"]
EXPOSE 8080 38252

CMD ["/download-and-start"]
