#!/bin/bash

set -e
if [ "${ENABLE_MC_HELPER_AOT_WARMUP}" = "1" ]; then
  echo "Warming mc-image-helper AOT cache at ${MC_IMAGE_HELPER_AOT_CACHE}"
  mkdir -p "$(dirname "${MC_IMAGE_HELPER_AOT_CACHE}")"

  aot_config=/tmp/mc-image-helper.aotconf
  # record config
  if ! MC_IMAGE_HELPER_OPTS="-XX:AOTMode=record -XX:AOTConfiguration=${aot_config}" mc-image-helper java-release > /dev/null; then
    echo "Failed to record AOT configuration"
    exit 1
  fi

  # create cache
  if ! MC_IMAGE_HELPER_OPTS="-XX:AOTMode=create -XX:AOTConfiguration=${aot_config} -XX:AOTCache=${MC_IMAGE_HELPER_AOT_CACHE}" mc-image-helper java-release > /dev/null; then
    echo "Failed to create AOT cache"
    exit 1
  fi
else
  echo "Skipping mc-image-helper AOT warmup"
fi
