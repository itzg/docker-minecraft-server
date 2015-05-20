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

elif [ -n "$CASS_ADDR" ]; then

  shortcut=/tmp/titan.properties
  cat >> /tmp/titan.properties <<END
storage.backend=cassandra
storage.hostname=$CASS_ADDR
END

fi


esAddr=${ES_ENV_PUBLISH_AS:-${ES_PORT_9300_TCP_ADDR}}

if [ -n "$ES_CLUSTER" -o -n "$esAddr" ]; then
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
  if [ -n "$esAddr" ]; then
    # strip off the port spec, if present
    esAddr=$(echo $esAddr | cut -d: -f1)
    cat >> /tmp/titan.properties <<END
index.search.hostname=$esAddr
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
