FROM ubuntu:trusty

LABEL maintainer "itzg"

ENV APT_GET_UPDATE 2015-10-29
RUN apt-get update
RUN DEBIAN_FRONTEND=noninteractive \
  apt-get -q -y install openjdk-7-jre-headless wget unzip \
  && apt-get clean

ENV JAVA_HOME /usr/lib/jvm/java-7-openjdk-amd64
