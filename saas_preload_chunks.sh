#!/bin/bash

RADIUS=$1
WORLD_NAME=$2

function isFcpPending() {
	RCON_OUTPUT=$(./exec_rcon.sh fcp pending | grep -is "no pending tasks")
	# RCON_OUTPUT=$(echo "g" | grep -is "no pending tasks")

	if [[ -z "$RCON_OUTPUT" ]]; then
		# RCON_OUTPUT empty -> There is a pending task
		echo "pending"
	else
		# RCON_OUTPUT not empty -> There are NO pending tasks
		echo "free"
	fi
}

if [ $(isFcpPending) = "pending" ]; then
	echo "FCP is already running, Aborting process."
	exit 1
fi 


# Kick off the preloaded tasks
./exec_rcon.sh fcp start ${RADIUS} ${WORLD_NAME} 0 0

i=0
while [ $(isFcpPending) = "pending" ]
do
	echo "Slept for: $(($i*10)) seconds"
	((i++))
	sleep 10
done





