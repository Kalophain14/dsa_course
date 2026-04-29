#!/usr/bin/env bash
# ─────────────────────────────────────────────
# organize_notes.sh
# In each top-level folder of dsa_course:
#   - Move PDFs and images into a "notes" subfolder
#   - Leave .java files exactly where they are
#
# Usage: bash organize_notes.sh /path/to/dsa_course
# ─────────────────────────────────────────────

set -e

REPO="${1:-.}"

cd "$REPO"
echo "📁  Working in: $(pwd)"
echo ""

for dir in */; do
  dir="${dir%/}"
  [ -d "$dir" ] || continue

  echo "📂  $dir"

  while IFS= read -r -d '' file; do
    mkdir -p "$dir/notes"

    filename=$(basename "$file")
    dest="$dir/notes/$filename"

    if [ -f "$dest" ]; then
      echo "   ⚠️   Skipped (already exists): $filename"
      continue
    fi

    mv "$file" "$dest"
    echo "   ✅  $filename → $dir/notes/"

  done < <(find "$dir" -maxdepth 1 -type f \( \
    -iname "*.pdf" \
    -o -iname "*.png" \
    -o -iname "*.jpg" \
    -o -iname "*.jpeg" \
    -o -iname "*.gif" \
    -o -iname "*.svg" \
    -o -iname "*.webp" \
  \) -print0)

done

echo ""
echo "🎉  Done!"
echo "    git add -A && git commit -m 'chore: group PDFs and images into notes/ folders'"
