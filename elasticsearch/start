#!/bin/sh

pre_checks() {
  mmc=$(sysctl vm.max_map_count|sed 's/.*= //')
  if [[ $mmc -lt 262144 ]]; then
    echo "
ERROR: As of 5.0.0 Elasticsearch requires increasing mmap counts.
Refer to https://www.elastic.co/guide/en/elasticsearch/reference/current/vm-max-map-count.html
"
    exit 1
  fi
}

discoverIpFromLink() {
  dev=$1
  mode=$2
  ip=`ipaddr show dev $dev scope global|awk '$1 == "inet" { if (!match($2,"/32")) { gsub("/.*","",$2) ; print $2 } }'`
  echo "Discovered $mode address $ip for $dev"
  OPTS="$OPTS -E $mode.host=$ip"
}

discoverAllGlobalIps() {
  if [ ${#IGNORE_NETWORK} -eq 0 ]
  then
    IGNORE_NETWORK='999.999.999.999'
  fi
  printf "Finding IPs"
  while [ ${#ips} -eq 0 ]
  do
    printf "."
    ips=`ipaddr show scope global| grep -v "inet ${IGNORE_NETWORK}" | awk '$1 == "inet" { if (!match($2,"/32")) { gsub("/.*","",$2) ; addrs[length(addrs)] = $2 } } END { for (i in addrs) { if (i>0) printf "," ; printf addrs[i] } }'`
    sleep 1
  done
  echo " found! $ips"
  OPTS="$OPTS -E network.host=$ips"
}

setup_clustering() {

  if [ -n "$CLUSTER" ]; then
    OPTS="$OPTS -E cluster.name=$CLUSTER"
    if [ -n "$CLUSTER_FROM" ]; then
      if [ -d /data/$CLUSTER_FROM -a ! -d /data/$CLUSTER ]; then
        echo "Performing cluster data migration from $CLUSTER_FROM to $CLUSTER"
        mv /data/$CLUSTER_FROM /data/$CLUSTER
      fi
    fi
  fi

  if [ -n "$NODE_NAME" ]; then
    OPTS="$OPTS -E node.name=$NODE_NAME"
  fi

  if [ -n "$MULTICAST" ]; then
    OPTS="$OPTS -E discovery.zen.ping.multicast.enabled=$MULTICAST"
  fi

  if [ -n "$UNICAST_HOSTS" ]; then
    OPTS="$OPTS -E discovery.zen.ping.unicast.hosts=$UNICAST_HOSTS"
  fi

  if [ -n "$PUBLISH_AS" ]; then
    OPTS="$OPTS -E transport.publish_host=$(echo $PUBLISH_AS | awk -F: '{print $1}')"
    OPTS="$OPTS -E transport.publish_port=$(echo $PUBLISH_AS | awk -F: '{if ($2) print $2; else print 9300}')"
  fi

  if [ -n "$MIN_MASTERS" ]; then
    OPTS="$OPTS -E discovery.zen.minimum_master_nodes=$MIN_MASTERS"
  fi

}

install_plugins() {

  if [ -n "$PLUGINS" ]; then
    for p in $(echo $PLUGINS | awk -v RS=, '{print}')
    do
      echo "Installing the plugin $p"
      $ES_HOME/bin/elasticsearch-plugin install $p
    done
  else
    mkdir -p $ES_HOME/plugins
  fi
}

setup_personality() {

  if [ -n "$TYPE" ]; then
    case $TYPE in
      MASTER)
        OPTS="$OPTS -E node.master=true -E node.data=false -E node.ingest=false"
        ;;

      GATEWAY|COORDINATING)
        OPTS="$OPTS -E node.master=false -E node.data=false -E node.ingest=false"
        ;;

      INGEST)
        OPTS="$OPTS -E node.master=false -E node.data=false -E node.ingest=true"
        ;;

      DATA|NON_MASTER)
        OPTS="$OPTS -E node.master=false -E node.data=true -E node.ingest=false"
        ;;

      *)
        echo "Unknown node type. Please use MASTER|GATEWAY|DATA|NON_MASTER"
        exit 1
    esac
  fi

}

pre_checks

if [ -f /conf/env ]; then
  . /conf/env
fi

if [ ! -e /conf/elasticsearch.* ]; then
  cp $ES_HOME/config/elasticsearch.yml /conf
fi

if [ ! -e /conf/log4j2.properties ]; then
  cp $ES_HOME/config/log4j2.properties /conf
fi

OPTS="$OPTS \
  -E path.conf=/conf \
  -E path.data=/data \
  -E path.logs=/data \
  -E transport.tcp.port=9300 \
  -E http.port=9200"

discoverAllGlobalIps
if [ "${DISCOVER_TRANSPORT_IP}" != "" ]; then
  discoverIpFromLink $DISCOVER_TRANSPORT_IP transport
fi
if [ "${DISCOVER_HTTP_IP}" != "" ]; then
  discoverIpFromLink $DISCOVER_HTTP_IP http
fi

setup_personality
setup_clustering
install_plugins

mkdir -p /conf/scripts

echo "Starting Elasticsearch with the options $OPTS"
CMD="$ES_HOME/bin/elasticsearch $OPTS"
if [ `id -u` = 0 ]; then
  echo "Running as non-root..."
  chown -R $DEFAULT_ES_USER /data /conf
  su -c "$CMD" $DEFAULT_ES_USER
else
  $CMD
fi
