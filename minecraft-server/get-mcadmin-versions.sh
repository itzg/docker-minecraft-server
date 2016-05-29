#!/bin/bash

if [ $# -lt 1 ]; then
  echo Missing arg: URL
  exit 1
fi

cd /tmp
wget -qO mcadmin-versions.jar https://bintray.com/itzgeoff/artifacts/download_file?file_path=me%2Fitzg%2Fmcadmin-versions%2F1.1.0%2Fmcadmin-versions-1.1.0.jar
wget -q http://central.maven.org/maven2/org/jsoup/jsoup/1.9.1/jsoup-1.9.1.jar

java -jar mcadmin-versions.jar $1 > /tmp/mcadmin-versions.db
rm *.jar
