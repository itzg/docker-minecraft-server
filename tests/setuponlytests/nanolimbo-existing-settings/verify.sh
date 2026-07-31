set -e
# SERVER_PORT must have been applied to the settings.yml that was already there
port=$(mc-image-helper yaml-path --file /data/settings.yml .bind.port)
[ "$port" = 25599 ] || { echo "expected bind.port 25599 but was '$port'"; exit 1; }
