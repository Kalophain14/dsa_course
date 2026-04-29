#!/usr/bin/env bash
# ─────────────────────────────────────────────
# add_main_stubs.sh
# Adds a runnable main() stub to every .java file
# so IntelliJ F5 / Run works on all of them.
#
# Usage: bash add_main_stubs.sh /path/to/dsa_course
# ─────────────────────────────────────────────

set -e

REPO="${1:-.}"

if [ ! -d "$REPO/.git" ]; then
  echo "❌  Not a git repo: $REPO"
  exit 1
fi

cd "$REPO"
echo "📁  Working in: $(pwd)"
echo ""
echo "🔧  Adding main() stubs to all .java files..."

find . -name "*.java" | grep -v ".git/" | while read -r f; do
  # Derive class name from filename (e.g. BubbleSort.java → BubbleSort)
  classname=$(basename "$f" .java)

  # Derive package from path (e.g. ./lectures/sorting/BubbleSort.java → kalophain.lectures.sorting)
  rel_path=$(dirname "$f" | sed 's|^\./||')          # strip leading ./
  package_path=$(echo "$rel_path" | sed 's|/|.|g')   # slashes → dots

  if [ -z "$package_path" ] || [ "$package_path" = "." ]; then
    package_line=""
  else
    package_line="package kalophain.${package_path};"
  fi

  # Write the stub
  {
    [ -n "$package_line" ] && echo "$package_line"
    echo ""
    echo "public class $classname {"
    echo ""
    echo "    public static void main(String[] args) {"
    echo "        // TODO: add your solution here"
    echo "    }"
    echo ""
    echo "}"
  } > "$f"

  echo "   ✅  $f"
done

echo ""
echo "🎉  Done! All .java files are now F5-runnable in IntelliJ."
echo "    Stage & commit with:"
echo "      git add -A && git commit -m 'chore: add main() stubs to all java files'"
