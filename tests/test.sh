#!/bin/bash

cd "$(dirname "$0")" || exit 1

failed=false

down() {
  docker-compose down -v
}

docker-compose run monitor || failed=true
echo "
Result: failed=$failed"

if $failed; then
  docker-compose logs mc
  down
  exit 1
else
  down
fi

