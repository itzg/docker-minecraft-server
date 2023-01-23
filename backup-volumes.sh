#!/bin/bash

docker-compose pause

dirname=${PWD##*/}
for nv in `docker volume ls -q`
do
  if [[ $nv = ${dirname}* ]]; then
    f=${nv//${dirname}_/}
    echo -n "Backing up $f ..."
    docker run -it --rm \
      -v $nv:/data -v $PWD:/backup alpine \
      tar -cjf /backup/$f.tar.bz2 -C /data ./
    echo "done"
  fi
done

docker-compose unpause

