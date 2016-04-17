#!/bin/bash

cassYml=$CASSANDRA_HOME/conf/cassandra.yaml

privateAddr=$(hostname -i)

seeds=${SEEDS:-${PUBLISH_AS:-$privateAddr}}

sed -i -e "s/- seeds:.*/- seeds: \"$seeds\"/" \
  -e "s/listen_address:.*/listen_address: $privateAddr/" \
  -e "s/rpc_address:.*/rpc_address: $privateAddr/" \
  -e "s/start_rpc:.*/start_rpc: true/" \
  -e "s#- /var/lib/cassandra/data#- $CASSANDRA_DATA#" \
  $cassYml

if [ -n "$PUBLISH_AS" ]; then
  sed -i -e "s/\(\s*#\)\?\s*broadcast_address:.*/broadcast_address: $PUBLISH_AS/" $cassYml
fi

# Copy over our tweaked files, but non-clobbering to let user have ultimate control
cp -rn $CASSANDRA_HOME/conf/* $CASSANDRA_CONF

# source the original
. $CASSANDRA_HOME/bin/orig.cassandra.in.sh
