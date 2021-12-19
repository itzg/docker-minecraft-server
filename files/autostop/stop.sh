#!/bin/bash

. /start-utils

logAutostopAction "Stopping Java process"
kill -SIGTERM 1
