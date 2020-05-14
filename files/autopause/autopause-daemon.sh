#!/bin/bash

exec 1>/tmp/terminal-mc

sudo /usr/sbin/knockd -c /autopause/knockd-config.cfg -d

while :
do
  sleep $AUTOPAUSE_CHECK_INTERVAL
done
