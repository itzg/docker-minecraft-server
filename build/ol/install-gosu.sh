#!/bin/bash

if [[ $(uname -m) == "aarch64" ]]; then 
    curl -sL -o /bin/gosu https://github.com/tianon/gosu/releases/download/1.16/gosu-arm64
    chmod +x /bin/gosu
elif [[ $(uname -m) == "x86_64" ]]; then 
    curl -sL -o /bin/gosu https://github.com/tianon/gosu/releases/download/1.16/gosu-amd64
    chmod +x /bin/gosu
else
    echo "Not supported!"
    exit 1
fi  
