#!/bin/sh

cat /etc/os-release | grep -E "^ID=" | cut -d= -f2 | sed -e 's/"//g'