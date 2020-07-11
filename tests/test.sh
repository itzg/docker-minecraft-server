#!/bin/bash

cd $(dirname $0)

failed=false
args="-f docker-compose.test.yml"
docker-compose $args run sut || failed=true
echo "
Result: failed=$failed"

$failed && docker-compose $args logs mc
docker-compose $args down -v

if $failed; then
  exit 1
fi

