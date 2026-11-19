# world1 directory of the zip was extracted, without overwriting the existing level.dat
mc-image-helper assert fileExists world1/region/r.0.0.mca
mc-image-helper assert fileNotExists world1/world1 world1/other world1/readme.txt
grep -qx existing world1/level.dat
# both selected directories were extracted into the same destination
mc-image-helper assert fileExists merged/level.dat merged/region/r.0.0.mca merged/readme.txt
# whole tar.gz was extracted and the plain entry was still copied
mc-image-helper assert fileExists extracted/config/a.toml plain/plain.txt
