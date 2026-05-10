mc-image-helper assert propertyEquals --file=server.properties --property=motd --expect=from-generic-pack
mc-image-helper assert fileExists config/dummy.yml
