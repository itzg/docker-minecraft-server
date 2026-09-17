# verify that the old config was removed and the new one from the pack was installed
mc-image-helper assert fileNotExists config/stale.txt
mc-image-helper assert fileExists config/opt.yml
