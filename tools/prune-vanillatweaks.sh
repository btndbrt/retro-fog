#!/usr/bin/env bash
# Deletes Vanilla Tweaks files that Programmer Art+ replaces anyway.
#
# Programmer Art+ wins over Vanilla Tweaks wherever both have a file, so the
# Vanilla Tweaks copy would never be used. Removing it keeps the pack smaller
# and SOURCES.md honest. Only the 26.x folders are compared, because
# programmer_art_plus/ only loads on 26.x.
set -euo pipefail
cd "$(dirname "$0")/.."

[ -d programmer_art_plus ] && [ -d vanillatweaks ] || exit 0

removed=0
while IFS= read -r -d '' f; do
  rel=${f#programmer_art_plus/}
  if [ -f "vanillatweaks/$rel" ]; then
    rm "vanillatweaks/$rel"
    removed=$((removed + 1))
  fi
done < <(find programmer_art_plus/assets -type f -print0)

# Clean up folders that became empty.
find vanillatweaks -type d -empty -delete
echo "Removed $removed Vanilla Tweaks file(s) that Programmer Art+ replaces."
