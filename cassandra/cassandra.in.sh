#!/bin/bash

sed -i -e 's/log4j.rootLogger=.*/log4j.rootLogger=INFO,stdout/' $CASSANDRA_HOME/conf/log4j-server.properties

cassYml=$CASSANDRA_HOME/conf/cassandra.yaml

privateAddr=$(hostname -i)

seeds=${SEEDS:-${PUBLISH_AS:-$privateAddr}}

sed -i -e "s/- seeds:.*/- seeds: \"$seeds\"/" $cassYml

sed -i -e "s/listen_address:.*/listen_address: $privateAddr/" $cassYml
sed -i -e "s/rpc_address:.*/rpc_address: $privateAddr/" $cassYml

sed -i -e "s#- /var/lib/cassandra/data#- $CASSANDRA_DATA#" $cassYml

if [ -n "$PUBLISH_AS" ]; then
  sed -i -e "s/\(\s*#\)\?\s*broadcast_address:.*/broadcast_address: $PUBLISH_AS/" $cassYml
fi

# Copy over our tweaked files, but non-clobbering to let user have ultimate control
cp -rn $CASSANDRA_HOME/conf/* $CASSANDRA_CONF

# source the original
. $CASSANDRA_HOME/bin/orig.cassandra.in.sh

