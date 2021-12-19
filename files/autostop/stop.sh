#!/bin/bash

. /start-utils

logAutostopAction "Stopping Java process"

rcon-cli stop >/dev/null
