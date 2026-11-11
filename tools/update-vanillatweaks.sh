#!/usr/bin/env bash
# Adds the tweaks from a Vanilla Tweaks zip to the pack.
#
#   tools/update-vanillatweaks.sh ~/Downloads/VanillaTweaks_rXXXXXX_MC26.3.x.zip
#   tools/update-vanillatweaks.sh --replace ~/Downloads/VanillaTweaks_rXXXXXX_MC1.21.x.zip
#
# The zip's Minecraft version decides where it goes:
#   Version 26.x -> vanillatweaks/       (loads on 26.1 - 26.3)
#   Version 1.21 -> vanillatweaks_1_21/  (loads on 1.21.6 - 1.21.11)
#
# By default the zip is ADDED to what's already in that folder: new files are added,
# files that exist in both are overwritten with the zip's version, nothing is removed.
# With --replace, the folder is emptied first, so only the zip's tweaks remain.
#
# Vanilla Tweaks zips can contain their own overlay folders. Overlays that apply to
# every version the target folder loads on are merged into it; any other overlay
# folder is reported, because it would need its own entry in pack.mcmeta.
#
# Download zips from https://vanillatweaks.net/picker/resource-packs/.
# The combined list of tweaks is kept in <folder>/Selected Packs.txt.
set -euo pipefail
cd "$(dirname "$0")/.."

command -v jq >/dev/null || { echo "error: 'jq' is not installed (sudo apt install jq)" >&2; exit 1; }

replace=0
if [ "${1:-}" = "--replace" ]; then
  replace=1
  shift
fi
zip="${1:?usage: tools/update-vanillatweaks.sh [--replace] <VanillaTweaks zip>}"

tmp=$(mktemp -d)
trap 'rm -rf "$tmp"' EXIT
unzip -q "$zip" -d "$tmp"

version=$(sed -n 's/^Version: *//p' "$tmp/Selected Packs.txt" | tr -d '\r')
case "$version" in
  26.*) target=vanillatweaks ;;
  1.21*) target=vanillatweaks_1_21 ;;
  *) echo "error: Vanilla Tweaks version '$version' is not supported by this pack" >&2; exit 1 ;;
esac

# The format range the target folder loads on, from our own pack.mcmeta.
read -r tmin tmax < <(jq -r --arg d "$target" '.overlays.entries[] | select(.directory == $d) | "\(.min_format) \(.max_format)"' pack.mcmeta)
if [ -z "${tmin:-}" ]; then
  echo "error: pack.mcmeta has no overlay entry for '$target'" >&2
  exit 1
fi
echo "Vanilla Tweaks $version -> $target/ (pack formats $tmin - $tmax)"

list="$target/Selected Packs.txt"
old_packs=""
if [ "$replace" = 0 ] && [ -f "$list" ]; then
  old_packs=$(sed -n '/^Packs:/,$p' "$list" | tail -n +2 | sed 's/^[[:space:]]*//' | grep -v '^$' || true)
fi
if [ "$replace" = 1 ]; then
  rm -rf "$target"
fi
mkdir -p "$target/assets"

# Copies one folder of the zip into the target, reporting files it changes.
merged=$(mktemp -d)
copy_in() {
  local src="$1" changed=0
  while IFS= read -r -d '' f; do
    rel=${f#"$src"/}
    if [ -f "$merged/$rel" ]; then
      echo "warning: $rel is in more than one Vanilla Tweaks folder; the later one wins" >&2
    fi
    if [ -f "$target/$rel" ] && ! cmp -s "$f" "$target/$rel"; then
      changed=$((changed + 1))
    fi
  done < <(find "$src/assets" -type f -print0)
  mkdir -p "$merged/assets"
  cp -a "$src/assets/." "$merged/assets/"
  echo "  $(basename "$src"): $(find "$src/assets" -type f | wc -l) files, $changed would change an existing file"
}

copy_in "$tmp"

# Overlay folders of the zip, in the order pack.mcmeta lists them.
while IFS=' ' read -r dir omin omax; do
  [ -d "$tmp/$dir" ] || continue
  if [ "$omin" -le "$tmin" ] && [ "$omax" -ge "$tmax" ]; then
    copy_in "$tmp/$dir"
  elif [ "$omax" -lt "$tmin" ] || [ "$omin" -gt "$tmax" ]; then
    echo "  $dir: skipped, only for versions this pack doesn't load it on"
  else
    echo "warning: overlay '$dir' (formats $omin - $omax) only covers part of $tmin - $tmax and was NOT copied; ask before shipping" >&2
  fi
done < <(jq -r '.overlays.entries[]? | "\(.directory) \(.min_format) \(.max_format)"' "$tmp/pack.mcmeta" | awk '!seen[$1]++')

cp -a "$merged/assets/." "$target/assets/"
rm -rf "$merged"

# Combined list of selected tweaks: the old ones first, then any new ones.
new_packs=$(sed -n '/^Packs:/,$p' "$tmp/Selected Packs.txt" | tail -n +2 | sed 's/^[[:space:]]*//' | grep -v '^$' || true)
{
  echo "Vanilla Tweaks Resource Pack"
  echo "Version: $version"
  echo "Packs:"
  printf '%s\n%s\n' "$old_packs" "$new_packs" | grep -v '^$' | awk '!seen[$0]++' | sed 's/^/\t/'
} > "$list"

# Programmer Art+ wins over Vanilla Tweaks on 26.x, so drop the files it replaces.
if [ "$target" = vanillatweaks ]; then
  tools/prune-vanillatweaks.sh
fi

echo "Done: $target/ has $(find "$target" -type f | wc -l) files."
echo "Selected tweaks are listed in $list; update the list in README.md to match."
