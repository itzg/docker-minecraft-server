FROM itzg/ubuntu-openjdk-7
 
MAINTAINER itzg

ENV APT_GET_UPDATE 2014-07-19
 
RUN apt-get update
RUN apt-get -y install wget tar
 
ENV GITBLIT_VERSION 1.6.0
 
RUN wget -O /tmp/gitblit.tgz http://dl.bintray.com/gitblit/releases/gitblit-$GITBLIT_VERSION.tar.gz
 
RUN mkdir /opt/gitblit
RUN tar -C /opt/gitblit -xvf /tmp/gitblit.tgz
RUN rm /tmp/gitblit.tgz
 
VOLUME ["/data"]
 
ADD start.sh /start
 
WORKDIR /opt/gitblit
ENV GITBLIT_PATH /opt/gitblit
ENV GITBLIT_HTTPS_PORT 443
ENV GITBLIT_HTTP_PORT 80
ENV GITBLIT_BASE_FOLDER /data
 
EXPOSE 80 443
 
CMD ["/start"]
