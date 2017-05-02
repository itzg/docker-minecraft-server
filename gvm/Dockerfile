FROM itzg/ubuntu-openjdk-7

LABEL maintainer "itzg"

RUN apt-get install -y curl unzip

RUN curl -s get.gvmtool.net | bash

ADD run /run
ONBUILD RUN ["/run", "selfupdate"]

ENTRYPOINT ["/run"]
