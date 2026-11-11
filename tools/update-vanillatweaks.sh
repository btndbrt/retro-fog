#!/usr/bin/env bash
# Replaces the vanillatweaks/ overlay with the contents of a new Vanilla Tweaks zip.
#
#   tools/update-vanillatweaks.sh ~/Downloads/VanillaTweaks_rXXXXXX_MC26.3.x.zip
#
# Download the zip from https://vanillatweaks.net/picker/resource-packs/ with the
# tweaks you want. The list of selected tweaks is saved to vanillatweaks/Selected Packs.txt.
set -euo pipefail
cd "$(dirname "$0")/.."

zip="${1:?usage: tools/update-vanillatweaks.sh <VanillaTweaks zip>}"
tmp=$(mktemp -d)
trap 'rm -rf "$tmp"' EXIT

unzip -q "$zip" -d "$tmp"

rm -rf vanillatweaks
mkdir vanillatweaks
cp -a "$tmp/assets" vanillatweaks/
[ -f "$tmp/Selected Packs.txt" ] && cp "$tmp/Selected Packs.txt" vanillatweaks/

# Vanilla Tweaks can ship its own overlay folders. They would need their own
# entries in pack.mcmeta, so warn instead of silently dropping them.
for dir in "$tmp"/*/; do
  name=$(basename "$dir")
  [ "$name" = assets ] && continue
  echo "warning: the zip contains an overlay folder '$name' that was not copied; ask before shipping" >&2
done

echo "Updated vanillatweaks/ ($(find vanillatweaks -type f | wc -l) files)."
echo "Check the versions in pack.mcmeta: Vanilla Tweaks says"
grep -o '"m[a-z]*_format": *[0-9.]*' "$tmp/pack.mcmeta" | head -2
