#!/usr/bin/env bash
# ─────────────────────────────────────────────
# organize_notes.sh
# Groups all PDFs, markdown, and text files into
# a "notes" subfolder inside each top-level folder
# of dsa_course.
#
# Usage: bash organize_notes.sh /path/to/dsa_course
# ─────────────────────────────────────────────

set -e

REPO="${1:-.}"

if [ ! -d "$REPO" ]; then
  echo "❌  Directory not found: $REPO"
  exit 1
fi

cd "$REPO"
echo "📁  Working in: $(pwd)"
echo ""

# Loop over each top-level folder only (not nested ones)
for dir in */; do
  dir="${dir%/}"  # strip trailing slash

  # Skip if not a real directory
  [ -d "$dir" ] || continue

  echo "📂  Scanning: $dir"

  # Find PDFs, markdown, and text files anywhere inside this folder
  found=0
  while IFS= read -r -d '' file; do
    # Skip files already inside a notes folder
    if [[ "$file" == *"/notes/"* ]]; then
      continue
    fi

    # Create notes folder if it doesn't exist yet
    if [ ! -d "$dir/notes" ]; then
      mkdir -p "$dir/notes"
      echo "   📁  Created: $dir/notes/"
    fi

    filename=$(basename "$file")

    # Avoid overwriting if a file with same name already exists
    dest="$dir/notes/$filename"
    if [ -f "$dest" ]; then
      echo "   ⚠️   Skipped (already exists): $dest"
      continue
    fi

    mv "$file" "$dest"
    echo "   ✅  Moved: $file → $dest"
    found=1

  done < <(find "$dir" -type f \( \
    -iname "*.pdf" \
    -o -iname "*.md" \
    -o -iname "*.txt" \
    -o -iname "*.docx" \
    -o -iname "*.pptx" \
    -o -iname "*.png" \
    -o -iname "*.jpg" \
    -o -iname "*.jpeg" \
    -o -iname "*.gif" \
    -o -iname "*.svg" \
    -o -iname "*.webp" \
  \) -print0)

  if [ "$found" -eq 0 ]; then
    echo "   ℹ️   No notes/PDFs found"
  fi

done

echo ""
echo "🎉  Done! All notes and PDFs grouped into notes/ folders."
echo "    Stage & commit with:"
echo "      git add -A && git commit -m 'chore: organize notes and PDFs into notes/ folders'"
