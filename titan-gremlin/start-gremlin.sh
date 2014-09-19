#!/bin/bash

if [ $(ls /conf|wc -l) = 0 ]; then
  cp -r $TITAN_HOME/conf/* /conf
fi

$TITAN_HOME/bin/gremlin.sh
