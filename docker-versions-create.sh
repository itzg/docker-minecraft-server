#!/bin/bash
#set -x
# Use this array to build different versions of the docker container
version_array=('openjdk:8u212-jre-alpine' \
  'adoptopenjdk/openjdk8-openj9:alpine' \
  'adoptopenjdk/openjdk8:alpine-jre' \
  'adoptopenjdk/openjdk8:alpine-jre-nightly')
# This variable will determine what build would be the default one (without version)
defailt_version='openjdk:8u212-jre-alpine'

function ShowHelp {
  cat <<EOF
This script will create and push new docker images to docker hub.
It will also create a new git branch on github. Please consider merging new brunch with master if you are satisfied with changes.
To add or remove different version from the build - edit this file and add\remove version from 'version_array'
By default, it will skip recreation of image if Dockerfile for this image was found in ./versions dir

Usage:
  docker-versions-create.sh [--help, --ask]
  --help: shows this massage
  --ask:  don't skip image recreation and ask if recreation is required for each version.
EOF
  exit 0
}

function DockerBuild {
  local container_version docker_file tag_version
  container_version="$1"
  docker_file="$2"
  tag_version=$(echo "$container_version" | tr '/:' '-')
  cp ./Dockerfile ./versions/"$docker_file"
  sed -e "s|^FROM.*\$|FROM $container_version|" -i ./versions/"$docker_file"
  if [[ "$container_version" == "$defailt_version" ]]; then
    # skipping version tag creation
    docker build -f ./versions/"$docker_file" -t itzg/minecraft-server .
  else
    docker build -f ./versions/"$docker_file" -t itzg/minecraft-server:"$tag_version" .
  fi
}

function GitBranch {
  local container_version docker_file tag_version
  container_version="$1"
  docker_file="$2"
  tag_version=$(echo "$container_version" | tr '/:' '-')
  # Recreating git branch if exists
  if [[ $(git branch -l) == *"$tag_version"* ]]; then
    git checkout master
    git branch -D "$tag_version"
    git push -d origin "$tag_version"
  fi
  git checkout -b "$tag_version" || exit 1
  git add ./versions/*
  git commit -m "Version $container_version added"
  git push --set-upstream origin "$tag_version"
}

function DockerPush {
  local container_version docker_file tag_version
  container_version="$1"
  docker_file="$2"
  tag_version=$(echo "$container_version" | tr '/:' '-')
  if [[ "$container_version" == "$defailt_version" ]]; then
    docker push itzg/minecraft-server
  else
    docker push itzg/minecraft-server:"$tag_version"
  fi
}

#Some checks
if [[ $# -gt 2 ]]; then
  echo "This script recieves only one argument"
  ShowHelp
elif [[ $# -eq 1 ]]; then
  case "$1" in
    '--help' )
      ShowHelp;;
    '--ask' )
      REBUILD_ASK='True';;
  esac
fi
test -e ./Dockerfile || \
  { echo "Can't find Dockerfile."; \
  exit 1; }
test -d ./versions || \
  mkdir ./versions || \
  { echo "Can't create directory to store different versions. Please check directory permissions!"; \
  exit 1; }
touch ./versions/.test || \
  { echo "Can't create files inside versions. Please check directory permissions!"; \
  exit 1; }
rm -f ./versions/.test

# Working with versions
for version in "${version_array[@]}"; do
  echo "Working with $version"
  version_file_name=$(echo "$version" | tr '/:' '-')
  version_file_name="Dockerfile-$version_file_name"
  if [[ -e ./versions/"$version_file_name" ]] && [[ "$REBUILD_ASK" != 'True' ]]; then
    echo "Version '$version' was found. Skipping"
    continue
  elif [[ -e ./versions/"$version_file_name" ]] && [[ "$REBUILD_ASK" == 'True' ]]; then
    echo "Version '$version' was found. Should we recreate it? [y]"
    read answer
    if [[ "$answer" == 'y' ]]; then
      rm -f ./versions/"$version_file_name"
      DockerBuild "$version" "$version_file_name" || exit 1
      GitBranch "$version" "$version_file_name"  || exit 1
      DockerPush "$version" "$version_file_name" || exit 1
    else
      continue
    fi
  elif [[ ! -e ./versions/"$version_file_name" ]]; then
    echo "Version '$version' was not found. Creating"
    DockerBuild "$version" "$version_file_name" || exit 1
    GitBranch "$version" "$version_file_name" || exit 1
    DockerPush "$version" "$version_file_name" || exit 1
  fi
done
