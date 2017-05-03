FROM java:8

LABEL maintainer "itzg"

ENV GITBLIT_VERSION 1.7.1

RUN wget -qO /tmp/gitblit.tgz http://dl.bintray.com/gitblit/releases/gitblit-$GITBLIT_VERSION.tar.gz

RUN tar -C /opt -xvf /tmp/gitblit.tgz && \
    rm /tmp/gitblit.tgz

VOLUME ["/data"]

ADD start.sh /start

ENV GITBLIT_PATH=/opt/gitblit-${GITBLIT_VERSION} \
    GITBLIT_HTTPS_PORT=443 \
    GITBLIT_HTTP_PORT=80 \
    GITBLIT_BASE_FOLDER=/data \
    GITBLIT_ADMIN_USER=admin \
    GITBLIT_INITIAL_REPO=
WORKDIR $GITBLIT_PATH

EXPOSE 80 443

ENTRYPOINT ["/start"]
