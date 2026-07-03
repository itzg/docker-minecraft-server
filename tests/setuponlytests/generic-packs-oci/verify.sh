set -e
# OCI layers were cached
[ -d /data/packs/oci ]
compgen -G "/data/packs/oci/sha256:*" > /dev/null
# pack content was extracted and applied to /data
[ -d /data/mods ]
compgen -G "/data/mods/*" > /dev/null
