#!/usr/bin/env bash
# Builds the Rewind Edition resource pack zip.
#
#   ./build.sh          -> version from `git describe`, or "dev"
#   ./build.sh 1.1.0    -> explicit version
#
# Output: dist/RewindEdition-<version>.zip
set -euo pipefail
cd "$(dirname "$0")"

command -v zip >/dev/null || { echo "error: 'zip' is not installed (sudo apt install zip)" >&2; exit 1; }

VERSION="${1:-$(git describe --tags --always 2>/dev/null || echo dev)}"
OUT="dist/RewindEdition-$VERSION.zip"

# Everything that goes into the pack. Repo-only files (README, build.sh, tools/) stay out.
FILES=(
  pack.mcmeta
  pack.png
  assets
  mc_1_21_11
  vanillatweaks
  credits.txt
  LICENSE.md
)

for f in "${FILES[@]}"; do
  [ -e "$f" ] || { echo "error: '$f' is missing" >&2; exit 1; }
done

mkdir -p dist
rm -f "$OUT"
zip -qr -X "$OUT" "${FILES[@]}"

echo "Built $OUT ($(du -h "$OUT" | cut -f1))"
