# No family filter applied, DO NOT use Fabric or Forge specific name validation as it may cause random breakage.
mc-image-helper assert fileExists "/data/mods/voicechat-fabric-1*"
# Should be pull v4 and higher for 1.18.2:
mc-image-helper assert fileExists "/data/mods/architectury-4*"
mc-image-helper assert fileExists "/data/mods/fabric-api*"

