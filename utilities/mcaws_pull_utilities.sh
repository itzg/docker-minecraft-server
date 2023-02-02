#!/bin/bash

echo "Username:"
read USERNAME

echo "Password:"
read -s PASSWORD

# Download nbt utility
git clone https://${USERNAME}:${PASSWORD}@github.com/thehenrylam/nbt_utils.git

# Download chunk loader utility
git clone https://${USERNAME}:${PASSWORD}@github.com/thehenrylam/strange_chunk_loader.git

