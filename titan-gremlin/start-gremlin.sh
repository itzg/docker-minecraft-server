#!/bin/bash

args=

if [ $(ls /conf|wc -l) = 0 ]; then
  cp -r $TITAN_HOME/conf/* /conf
fi

rm -f /tmp/titan.properties

if [ -n "$CASS_PORT_9160_TCP_ADDR" ]; then
  shortcut=/tmp/titan.properties
  cat >> /tmp/titan.properties <<END
storage.backend=cassandra
storage.hostname=$CASS_PORT_9160_TCP_ADDR
END
fi

if [ -n "$ES_CLUSTER" -o -n "$ES_PORT_9300_TCP_PORT" ]; then
  shortcut=/tmp/titan.properties
  cat >> /tmp/titan.properties <<END
index.search.backend=elasticsearch
index.search.elasticsearch.client-only=true
END

  if [ -n "$ES_CLUSTER" ]; then
    cat >> /tmp/titan.properties <<END
index.search.elasticsearch.ext.cluster.name=$ES_CLUSTER
END
  fi
  if [ -n "$ES_PORT_9300_TCP_PORT" ]; then
    cat >> /tmp/titan.properties <<END
index.search.hostname=$ES_PORT_9300_TCP_ADDR
END
  fi
  
fi

if [ -n "$shortcut" ]; then
  cat > /tmp/init.groovy <<END
g = TitanFactory.open('$shortcut')
println 'The graph \'g\' was opened using $shortcut'
END
  args="$args /tmp/init.groovy"
fi

exec $TITAN_HOME/bin/gremlin.sh $args
