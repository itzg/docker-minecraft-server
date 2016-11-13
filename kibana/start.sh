#!/bin/sh

OPTS="-e $ES_URL -H $HOSTNAME"

exec bin/kibana $OPTS

