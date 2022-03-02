#!/bin/bash

# shellcheck source=start-utils
. /start-utils

while read -r cmd; do
  logAutopause "RCON: running - $cmd"
  output=$(rcon-cli "$cmd")
  logAutopause "$output"
done < <($1)
