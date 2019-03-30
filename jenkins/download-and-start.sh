#!/bin/bash

mirrorUrl=http://mirrors.jenkins-ci.org/war/latest/jenkins.war
url=$(curl -s --head $mirrorUrl|awk -F': ' '$1 == "Location" { print $2 }' | sed 's/[[:space:]]*$//')
version=$(echo $url | sed 's#.*/war/\(.*\)/jenkins.war#\1#')

mkdir -p /opt/jenkins
trackingFile=/opt/jenkins/INSTALLED

installed=
if [ -f $trackingFile ]; then
  installed=$(cat $trackingFile)
  echo "Version installed is $installed"
fi

if [ $version != "$installed" ]; then
  echo "Downloading $version from '$url'"
  while ! curl -s -o /opt/jenkins/jenkins.war "$url"
  do
    echo "Trying again in 5 seconds"
    sleep 5
  done

  echo $version > $trackingFile
fi


cd /opt/jenkins
exec java $JENKINS_OPTS -jar jenkins.war
