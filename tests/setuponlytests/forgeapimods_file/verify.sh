# Validates specific beta call out for specific mod:
mc-image-helper assert fileExists "/data/mods/voicechat-fabric*"
mc-image-helper assert fileExists "/data/mods/flan*"
# Dependent of flan:
mc-image-helper assert fileExists "/data/mods/fabric-api*"
