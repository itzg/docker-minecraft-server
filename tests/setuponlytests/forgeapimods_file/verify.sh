# Validates specific beta call out for specific mod:
mc-image-helper assert fileExists "/data/mods/voicechat-fabric*"
mc-image-helper assert fileExists "/data/mods/onastick-fabric*"
# Dependent of on a stick:
mc-image-helper assert fileExists "/data/mods/fabric-api*"
