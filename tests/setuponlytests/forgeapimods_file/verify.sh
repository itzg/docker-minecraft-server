mc-image-helper assert fileExists "/data/mods/BiomesOPlenty*"
# testing dependencies don't get downloaded when download dependencies is set to false.
! mc-image-helper assert fileExists "/data/mods/TerraBlender*"
mc-image-helper assert fileExists "/data/mods/voicechat-fabric*"
mc-image-helper assert fileExists "/data/mods/fabric-api*"
