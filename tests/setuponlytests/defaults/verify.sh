mc-image-helper assert propertyEquals --file=server.properties --property=rcon.password --expect=minecraft
mc-image-helper assert propertyEquals --file=server.properties --property=rcon.port --expect=25575
mc-image-helper assert propertyEquals --file=server.properties --property=enable-rcon --expect=true
