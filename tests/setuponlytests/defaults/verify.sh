# EXPECT_RCON_PASSWORD is passed in to the test environment from the action generated output
echo "EXPECT_RCON_PASSWORD=$EXPECT_RCON_PASSWORD"
echo "RCON_PASSWORD=$RCON_PASSWORD"
mc-image-helper assert propertyEquals --file=server.properties --property=rcon.password --expect="${EXPECT_RCON_PASSWORD}"
mc-image-helper assert propertyEquals --file=server.properties --property=rcon.port --expect=25575
mc-image-helper assert propertyEquals --file=server.properties --property=enable-rcon --expect=true
