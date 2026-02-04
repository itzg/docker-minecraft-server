#!/bin/bash

mc-image-helper assert fileExists "/data/paper-*.jar"

mc-image-helper assert fileExists "/data/config/paper-global.yml"
mc-image-helper assert fileExists "/data/config/paper-world-defaults.yml"
mc-image-helper assert fileExists "/data/spigot.yml"

mc-image-helper assert propertyEquals --file=server.properties --property=pause-when-empty-seconds --expect=60

# Test some keys that should be patched for a vanilla-like experiences
# TODO: Implement and use mc-image-helper assert yamlPathEquals
grep -q "time-command-affects-all-worlds: true" config/paper-global.yml
grep -q "allow-piston-duplication: true" config/paper-global.yml
grep -q "delay-chunk-unloads-by: 0s" config/paper-world-defaults.yml
grep -q "per-player-mob-spawns: false" config/paper-world-defaults.yml
grep -q "cooldown-when-full: false" config/paper-world-defaults.yml
grep -q "animals: 0" spigot.yml
grep -q "max-tnt-per-tick: -1" spigot.yml
