FROM ubuntu:trusty

MAINTAINER itzg

RUN apt-get update
RUN apt-get -y upgrade

RUN apt-get -y install ruby ruby-dev make patch
RUN gem install bundler

ADD Gemfile /tmp/Gemfile
WORKDIR /tmp
RUN bundle install

ADD template /site-template

VOLUME ["/site"]
EXPOSE 4000

ADD start.sh /start
CMD ["/start"]

