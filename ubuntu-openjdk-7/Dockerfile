FROM ubuntu:trusty

MAINTAINER itzg

ENV APT_GET_UPDATE 2015-02-15
RUN apt-get update
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y openjdk-7-jre-headless && apt-get clean

ENV JAVA_HOME /usr/lib/jvm/java-7-openjdk-amd64
