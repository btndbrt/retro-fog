#!/usr/bin/env bash
# Adds the tweaks from a Vanilla Tweaks zip to the vanillatweaks/ overlay.
#
#   tools/update-vanillatweaks.sh ~/Downloads/VanillaTweaks_rXXXXXX_MC26.3.x.zip
#   tools/update-vanillatweaks.sh --replace ~/Downloads/VanillaTweaks_rXXXXXX_MC26.3.x.zip
#
# By default the zip is ADDED to what's already there: new files are added, files that
# exist in both are overwritten with the zip's version, and nothing is removed.
# With --replace, the folder is emptied first, so only the zip's tweaks remain.
#
# Download the zip from https://vanillatweaks.net/picker/resource-packs/.
# The combined list of tweaks is kept in vanillatweaks/Selected Packs.txt.
set -euo pipefail
cd "$(dirname "$0")/.."

replace=0
if [ "${1:-}" = "--replace" ]; then
  replace=1
  shift
fi
zip="${1:?usage: tools/update-vanillatweaks.sh [--replace] <VanillaTweaks zip>}"

tmp=$(mktemp -d)
trap 'rm -rf "$tmp"' EXIT
unzip -q "$zip" -d "$tmp"

list="vanillatweaks/Selected Packs.txt"
old_packs=""
if [ "$replace" = 0 ] && [ -f "$list" ]; then
  old_packs=$(sed -n '/^Packs:/,$p' "$list" | tail -n +2 | sed 's/^[[:space:]]*//' | grep -v '^$' || true)
fi

if [ "$replace" = 1 ]; then
  rm -rf vanillatweaks
fi
mkdir -p vanillatweaks/assets

# Report files that both versions have but with different content, so changes are visible.
changed=0
while IFS= read -r -d '' f; do
  rel=${f#"$tmp"/}
  if [ -f "vanillatweaks/$rel" ] && ! cmp -s "$f" "vanillatweaks/$rel"; then
    echo "overwriting changed file: $rel"
    changed=$((changed + 1))
  fi
done < <(find "$tmp/assets" -type f -print0)

cp -a "$tmp/assets/." vanillatweaks/assets/

# Combined list of selected tweaks: the old ones first, then any new ones.
new_packs=$(sed -n '/^Packs:/,$p' "$tmp/Selected Packs.txt" | tail -n +2 | sed 's/^[[:space:]]*//' | grep -v '^$' || true)
{
  echo "Vanilla Tweaks Resource Pack"
  grep '^Version:' "$tmp/Selected Packs.txt" || true
  echo "Packs:"
  printf '%s\n%s\n' "$old_packs" "$new_packs" | grep -v '^$' | awk '!seen[$0]++' | sed 's/^/\t/'
} > "$list"

# Vanilla Tweaks can ship its own overlay folders. They would need their own
# entries in pack.mcmeta, so warn instead of silently dropping them.
for dir in "$tmp"/*/; do
  name=$(basename "$dir")
  [ "$name" = assets ] && continue
  echo "warning: the zip contains an overlay folder '$name' that was not copied; ask before shipping" >&2
done

echo "Done: vanillatweaks/ has $(find vanillatweaks -type f | wc -l) files, $changed existing file(s) overwritten."
echo "Selected tweaks are listed in $list; update the list in README.md to match."
echo "Check the versions in pack.mcmeta: Vanilla Tweaks says"
grep -o '"m[a-z]*_format": *[0-9.]*' "$tmp/pack.mcmeta" | head -2
