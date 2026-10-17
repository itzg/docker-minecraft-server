mc-image-helper assert fileExists "/data/Crucible-1.7.10-5.3.jar"

if [ ! -d /data/libraries ]; then
  echo "Expected /data/libraries to have been extracted from libraries.zip"
  exit 1
fi
