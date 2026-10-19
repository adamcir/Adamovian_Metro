#!/usr/bin/env bash
set -euo pipefail

script_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
source_dir="$(cd -- "$script_dir/../addon/adamovian_metro" && pwd -P)"
gmod_dir="${1:-$HOME/.local/share/Steam/steamapps/common/GarrysMod/garrysmod}"
if [[ ! -d "$source_dir/lua" ]]; then echo "Addon source not found: $source_dir" >&2; exit 1; fi
if [[ ! -d "$gmod_dir/addons" ]]; then echo "Invalid Garrys Mod folder: $gmod_dir" >&2; exit 1; fi
gmod_dir="$(cd -- "$gmod_dir" && pwd -P)"
if [[ "${gmod_dir##*/}" != "garrysmod" ]]; then echo "Expected the garrysmod directory" >&2; exit 1; fi
dest="$gmod_dir/addons/adamovian_metro"
if [[ "$source_dir" == "$dest" ]]; then echo "Source and destination must be different" >&2; exit 1; fi

if [[ -e "$dest" || -L "$dest" ]]; then
    echo "Removing old Adamovian Metro..."
    rm -rf -- "$dest"
fi
mkdir -p -- "$dest"
cp -a -- "$source_dir/." "$dest/"
echo "Adamovian Metro installed to: $dest"
