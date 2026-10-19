#!/usr/bin/env bash
set -euo pipefail
script_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
source_dir="$script_dir/../addon/adamovian_metro"
gmod_dir="${1:-$HOME/.local/share/Steam/steamapps/common/GarrysMod/garrysmod}"
if [[ ! -d "$source_dir/lua" ]]; then echo "Addon source not found: $source_dir" >&2; exit 1; fi
if [[ ! -d "$gmod_dir" ]]; then echo "Garrys Mod folder not found: $gmod_dir" >&2; exit 1; fi
dest="$gmod_dir/addons/adamovian_metro"
mkdir -p "$dest"
cp -a "$source_dir/." "$dest/"
echo "Adamovian Metro installed to: $dest"
