#!/usr/bin/env bash
# ─────────────────────────────────────────────
# clean_fork.sh
# Run this AFTER you've cloned your fork locally
# Usage: bash clean_fork.sh /path/to/dsa_course
# ─────────────────────────────────────────────

set -e

REPO="${1:-.}"   # defaults to current directory

if [ ! -d "$REPO/.git" ]; then
  echo "❌  Not a git repo: $REPO"
  exit 1
fi

cd "$REPO"
echo "📁  Working in: $(pwd)"

# ── 1. Remove all Java source code INSIDE .java files ───────────────────────
# Keeps the file but wipes its content (so git history is preserved cleanly)
echo ""
echo "🧹  Clearing Java source files..."

find . -name "*.java" | while read -r f; do
  # Strip package declaration if present and rewrite with kalophain package
  # Extract any package line first
  pkg_line=$(grep -m1 "^package " "$f" 2>/dev/null || true)

  if [ -n "$pkg_line" ]; then
    # Replace kunal with kalophain in the package line
    new_pkg=$(echo "$pkg_line" | sed 's/kunal/kalophain/g; s/Kunal/kalophain/g')
    echo "$new_pkg" > "$f"
  else
    # No package line — just leave file empty
    > "$f"
  fi
done

echo "   ✅  Java files cleared (package lines kept with kalophain namespace)"

# ── 2. Replace all remaining references to kunal package in any text file ───
echo ""
echo "🔄  Replacing 'kunal' → 'kalophain' in all text files..."

# File extensions to search through
TEXT_EXTS="java|kt|xml|gradle|properties|md|txt|json|yaml|yml"

find . -type f | grep -E "\.($TEXT_EXTS)$" | grep -v ".git/" | while read -r f; do
  # In-place replace, case-insensitive variants
  sed -i \
    -e 's/com\.kunal/com.kalophain/g' \
    -e 's/package kunal/package kalophain/g' \
    -e 's/import kunal/import kalophain/g' \
    -e 's/kunal-kushwaha/kalophain/g' \
    "$f" 2>/dev/null || true
done

echo "   ✅  References updated"

# ── 3. Rename any directory named 'kunal' to 'kalophain' ────────────────────
echo ""
echo "📂  Renaming directories named 'kunal' → 'kalophain'..."

# Process deepest directories first to avoid path conflicts
find . -depth -type d -iname "*kunal*" | grep -v ".git" | while read -r d; do
  new_d=$(echo "$d" | sed 's/kunal/kalophain/gi')
  if [ "$d" != "$new_d" ]; then
    mv "$d" "$new_d"
    echo "   Renamed: $d → $new_d"
  fi
done

echo "   ✅  Directories renamed"

# ── 4. Optional: delete files that are purely code and now empty/useless ─────
# (comment this block out if you want to keep empty .java files)
# 
# echo ""
# echo "🗑️  Removing empty .java files..."
# find . -name "*.java" -empty -delete
# echo "   ✅  Empty .java files removed"

# ── 5. Stage all changes ─────────────────────────────────────────────────────
echo ""
echo "📦  Staging all changes..."
git add -A

echo ""
echo "🎉  Done! Review changes with: git diff --cached"
echo "    Then commit with:           git commit -m 'refactor: clear code, replace kunal→kalophain package'"
echo "    Then push with:             git push origin main"
