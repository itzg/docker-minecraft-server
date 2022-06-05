# testing dependencies don't get downloaded when download dependencies is set to false.
mc-image-helper assert fileExists "/data/mods/voicechat-fabric*"
mc-image-helper assert fileExists "/data/mods/flan*"
# Dependent of flan, but dependencies are set to false:
! mc-image-helper assert fileExists "/data/mods/fabric-api*"
