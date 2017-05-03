FROM ubuntu:trusty

LABEL maintainer "itzg"

ENV APT_GET_UPDATE 2014-09-18

RUN apt-get update
RUN apt-get -y upgrade

RUN apt-get -y install ruby ruby-dev make patch nodejs
RUN gem install bundler

ADD Gemfile /tmp/Gemfile
WORKDIR /tmp
RUN bundle install

ADD template /site-template

VOLUME ["/site"]
EXPOSE 4000

ADD start.sh /start
CMD ["/start"]
