#!/bin/bash
set -euo pipefail

rm -rf data
mkdir -p data/plugins
printf 'managed-plugin\n' > data/plugins/tabtps-spigot-1.3.26.jar
cat > data/.modrinth-manifest.json <<'EOF'
{"@type":"me.itzg.helpers.modrinth.ModrinthManifest","timestamp":"2026-01-01T00:00:00Z","files":["plugins/tabtps-spigot-1.3.26.jar"],"projects":["tabtps"]}
EOF
