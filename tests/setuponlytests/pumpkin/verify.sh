mc-image-helper assert fileExists "/data/pumpkin-*-Linux*"

pumpkinToml=/data/pumpkin.toml

assertPathEquals() {
  local path=$1
  local expected=$2
  local actual
  actual=$(mc-image-helper toml-path --file "${pumpkinToml}" "${path}")
  if [[ ${actual} != "${expected}" ]]; then
    echo "Expected ${path} to be '${expected}', but was '${actual}'"
    exit 1
  fi
}

assertPathEquals '$.networking.java.motd' "Pumpkin test MOTD"
assertPathEquals '$.networking.bedrock.motd' "Pumpkin test MOTD"
assertPathEquals '$.networking.java.max_players' "25"
assertPathEquals '$.networking.bedrock.max_players' "25"
assertPathEquals '$.networking.java.online_mode' "false"
assertPathEquals '$.networking.bedrock.online_mode' "false"
assertPathEquals '$.networking.java.view_distance' "8"
assertPathEquals '$.default_gamemode' "Creative"
assertPathEquals '$.default_difficulty' "Hard"
assertPathEquals '$.default_level_name' "myworld"
assertPathEquals '$.pvp.enabled' "false"
assertPathEquals '$.networking.query.enabled' "true"
assertPathEquals '$.networking.query.address' "0.0.0.0:25566"
assertPathEquals '$.networking.rcon.address' "0.0.0.0:25576"
