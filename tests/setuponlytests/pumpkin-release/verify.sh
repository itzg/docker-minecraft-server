mc-image-helper assert fileExists "/data/pumpkin-*-Linux*"

actual=$(<"/data/.pumpkin-release")
if [[ ${actual} != "0.2.0+26.3-26.51" ]]; then
  echo "Expected /data/.pumpkin-release to be '0.2.0+26.3-26.51', but was '${actual}'"
  exit 1
fi
