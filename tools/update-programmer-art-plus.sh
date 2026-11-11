#!/usr/bin/env bash
# Rebuilds programmer_art_plus/ from Programmer Art+ (CC BY 4.0, by Crackers0106).
#
#   tools/update-programmer-art-plus.sh                 # latest version from GitHub
#   tools/update-programmer-art-plus.sh ~/some/folder   # a local copy of the repo
#
# - Copies all of Programmer Art+, except the files listed in
#   tools/programmer-art-plus-exclude.txt.
# - Programmer Art+'s own overlay folders are merged in when they apply to every
#   version programmer_art_plus/ loads on; others are reported.
# - Afterwards, Vanilla Tweaks files that Programmer Art+ replaces are deleted
#   (tools/prune-vanillatweaks.sh), because Programmer Art+ wins those conflicts.
set -euo pipefail
cd "$(dirname "$0")/.."

command -v jq >/dev/null || { echo "error: 'jq' is not installed (sudo apt install jq)" >&2; exit 1; }

src="${1:-}"
tmp=$(mktemp -d)
trap 'rm -rf "$tmp"' EXIT
if [ -z "$src" ]; then
  git clone -q --depth 1 https://github.com/Crackers0106/Programmer-Art-Plus.git "$tmp/pap"
  src="$tmp/pap"
fi
commit=$(git -C "$src" log -1 --format='%h %ad' --date=short 2>/dev/null || echo "unknown")

target=programmer_art_plus
read -r tmin tmax < <(jq -r --arg d "$target" '.overlays.entries[] | select(.directory == $d) | "\(.min_format) \(.max_format)"' pack.mcmeta)
[ -n "${tmin:-}" ] || { echo "error: pack.mcmeta has no overlay entry for '$target'" >&2; exit 1; }
echo "Programmer Art+ $commit -> $target/ (pack formats $tmin - $tmax)"

# Exclusion patterns, without comments and blank lines.
mapfile -t excludes < <(grep -v -E '^\s*(#|$)' tools/programmer-art-plus-exclude.txt)
excluded() {
  local p
  for p in "${excludes[@]}"; do
    # shellcheck disable=SC2053
    [[ "$1" == $p ]] && return 0
  done
  return 1
}

stage="$tmp/stage"
mkdir -p "$stage"
skipped=0
copy_in() {
  local from="$1" f rel
  while IFS= read -r -d '' f; do
    rel=${f#"$from"/}
    if excluded "$rel"; then
      skipped=$((skipped + 1))
      continue
    fi
    mkdir -p "$stage/$(dirname "$rel")"
    cp "$f" "$stage/$rel"
  done < <(find "$from/assets" -type f -print0)
}

copy_in "$src"

# Programmer Art+'s own overlays, in pack.mcmeta order (later ones win).
while IFS=' ' read -r dir omin omax; do
  [ -d "$src/$dir" ] || continue
  if awk -v a="$omin" -v b="$omax" -v x="$tmin" -v y="$tmax" 'BEGIN { exit !(a <= x && b >= y) }'; then
    copy_in "$src/$dir"
    echo "  merged overlay $dir"
  elif awk -v a="$omin" -v b="$omax" -v x="$tmin" -v y="$tmax" 'BEGIN { exit !(b < x || a > y) }'; then
    echo "  skipped overlay $dir (not for versions this folder loads on)"
  else
    echo "warning: overlay '$dir' (formats $omin - $omax) only covers part of $tmin - $tmax and was NOT copied; ask before shipping" >&2
  fi
done < <(jq -r '.overlays.entries[]? | "\(.directory) \(.min_format) \(.max_format)"' "$src/pack.mcmeta")

rm -rf "$target"
mkdir -p "$target"
cp -a "$stage/assets" "$target/"
[ -f "$src/CREDITS.txt" ] && cp "$src/CREDITS.txt" "$target/CREDITS.txt"
echo "$commit" > "$target/VERSION.txt"

echo "Copied $(find "$target/assets" -type f | wc -l) files, left out $skipped (see tools/programmer-art-plus-exclude.txt)."
tools/prune-vanillatweaks.sh
