#!/usr/bin/env bash
set -euo pipefail

repo_root=$(cd "$(dirname "$0")/../.." && pwd)
fixture=$(cd "$(dirname "$0")" && pwd)/versions.json

# Load only getGTNHdownloadPath from the production script. The rest of the
# startup script intentionally does not run during this focused unit test.
tmp_function=$(mktemp)
trap 'rm -f "$tmp_function"' EXIT
awk '
  /^function getGTNHdownloadPath\(\)\{/ { in_function=1 }
  /^function deleteGTNHbackup\(\)\{/ { in_function=0 }
  in_function { print }
' "$repo_root/scripts/start-deployGTNH" > "$tmp_function"

log() { :; }
debug() { :; }
logError() { printf 'error: %s\n' "$*" >&2; }
curl() { cat "$GTNH_VERSIONS_FIXTURE"; }
mc-image-helper() {
  if [[ "$1" == java-release ]]; then
    printf '%s\n' "$GTNH_TEST_JAVA"
  else
    return 1
  fi
}

# shellcheck source=/dev/null
source "$tmp_function"

assert_url() {
  local version=$1 java=$2 expected=$3 fixture_path=${4:-$fixture}
  local gtnh_download_path=""
  export GTNH_PACK_VERSION=$version
  export GTNH_TEST_JAVA=$java
  export GTNH_VERSIONS_FIXTURE=$fixture_path
  getGTNHdownloadPath
  [[ "$gtnh_download_path" == "$expected" ]] || {
    printf 'expected %s, got %s\n' "$expected" "$gtnh_download_path" >&2
    return 1
  }
}

assert_url latest 21 'https://example.invalid/2.8.4-java17.zip'
assert_url latest-dev 21 'https://example.invalid/2.9.0-rc-1-java17.zip'
assert_url latest-dev 21 'https://example.invalid/2.9.0-rc-1-java17.zip' "$(cd "$(dirname "$0")" && pwd)/versions-wrapper.json"
assert_url 2.9.0-beta-2 21 'https://example.invalid/2.9.0-beta-2-java17.zip'
assert_url 2.9.0-beta-2 8 'https://example.invalid/2.9.0-beta-2-java8.zip'

if (
  GTNH_PACK_VERSION=2.9.0-beta-2
  GTNH_TEST_JAVA=26
  GTNH_VERSIONS_FIXTURE=$fixture
  getGTNHdownloadPath
); then
  echo 'expected unsupported Java version to fail' >&2
  exit 1
fi

echo 'GTNH versions.json selection tests passed'
