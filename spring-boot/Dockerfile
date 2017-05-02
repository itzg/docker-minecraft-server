FROM itzg/gvm

LABEL maintainer "itzg"

RUN ["/run", "install", "springboot"]

ADD run /run
ENTRYPOINT ["/run"]

VOLUME ["/home/spring"]
ADD app.groovy /home/spring/app.groovy
EXPOSE 8080

WORKDIR /home/spring

CMD ["run", "app.groovy"]
