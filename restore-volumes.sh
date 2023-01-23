#!/bin/bash

dirname=${PWD##*/}
for f in `ls *.tar.bz2`
do
  nv="${dirname}_${f%.tar.bz2}"
  echo -n "Restoring $nv ..."
  docker run -it --rm \
    -v $nv:/data -v $PWD:/backup alpine \
    sh -c "rm -rf /data/* /data/..?* /data/.[!.]* ; tar -C /data/ -xjf /backup/$f"
  echo "done"
done

