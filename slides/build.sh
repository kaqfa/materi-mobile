#!/usr/bin/env bash
# Render deck slide ke build/. Tanpa argumen: semua deck.
#   ./build.sh                    -> semua deck, format pdf
#   ./build.sh P03                -> hanya P03, format pdf
#   ./build.sh P03 html           -> P03 ke html (mode presentasi di kelas)
#   ./build.sh all pptx           -> semua deck ke pptx
set -euo pipefail
cd "$(dirname "$0")"

target="${1:-all}"
format="${2:-pdf}"
mkdir -p build

# Diagram di-pre-render lebih dulu; hanya yang definisinya berubah yang dirender ulang.
python3 tools/render_diagrams.py

case "$format" in
  pdf|html|pptx|png) ;;
  *) echo "format tidak dikenal: $format (pdf|html|pptx|png)" >&2; exit 1 ;;
esac

if [ "$target" = "all" ]; then
  decks=(P*.md)
else
  decks=("$target"*.md)
fi

for deck in "${decks[@]}"; do
  name="$(basename "$deck" .md)"
  case "$format" in
    png) out="build/$name.png" ;;
    *)   out="build/$name.$format" ;;
  esac
  echo "==> $deck -> $out"
  npx -y @marp-team/marp-cli@latest "$deck" \
    $([ "$format" = "png" ] && echo "--images png" || echo "--$format") \
    -o "$out"
  # HTML di build/ tidak bisa menemukan assets/ dan diagrams/ yang direferensikan
  # relatif oleh theme dan diagram — ikatkan salinannya.
  if [ "$format" = "html" ]; then
    cp -R assets diagrams "build/"
  fi
done
