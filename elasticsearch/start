#!/bin/sh

if [ ! -e /conf/elasticsearch.* ]; then
  cp $ES_HOME/config/elasticsearch.yml /conf
fi

if [ ! -e /conf/logging.* ]; then
  cp $ES_HOME/config/logging.yml /conf
fi

OPTS="-Des.path.conf=/conf \
  -Des.path.data=/data \
  -Des.path.logs=/data \
  -Des.transport.tcp.port=9300 \
  -Des.http.port=9200"

if [ -n "$CLUSTER" ]; then
  OPTS="$OPTS -Des.cluster.name=$CLUSTER"
fi

if [ -n "$NODE_NAME" ]; then
  OPTS="$OPTS -Des.node.name=$NODE_NAME"
fi

if [ -n "$UNICAST_HOSTS" ]; then
  OPTS="$OPTS -Des.discovery.zen.ping.unicast.hosts=$UNICAST_HOSTS"
fi

if [ -n "$PUBLISH_AS" ]; then
  OPTS="$OPTS -Des.transport.publish_host=$(echo $PUBLISH_AS | awk -F: '{print $1}')"
  OPTS="$OPTS -Des.transport.publish_port=$(echo $PUBLISH_AS | awk -F: '{if ($2) print $2; else print 9300}')"
fi

if [ -n "$PLUGINS" ]; then
  for p in $(echo $PLUGINS | awk -v RS=, '{print}')
  do
    echo "Installing the plugin $p"
    $ES_HOME/bin/plugin --install $p
  done
fi

echo "Starting Elasticsearch with the options $OPTS"
$ES_HOME/bin/elasticsearch $OPTS
