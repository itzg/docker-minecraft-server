mc-image-helper assert fileExists \
  world/level.dat \
  world_nether/DIM-1/some_spigot_nether_file \
  world_the_end/DIM1/some_spigot_end_file
mc-image-helper assert fileNotExists \
  world_nether/DIM-1/some_vanilla_nether_file \
  world_the_end/DIM1/some_vanilla_end_file
