#!/bin/bash

[[ $(uname -m) == "aarch64" ]] && curl -sL -o /bin/gosu https://github.com/tianon/gosu/releases/download/1.14/gosu-arm64 && chmod +x /bin/gosu
[[ $(uname -m) == "x86_64" ]] && curl -sL -o /bin/gosu https://github.com/tianon/gosu/releases/download/1.14/gosu-amd64 && chmod +x /bin/gosu

