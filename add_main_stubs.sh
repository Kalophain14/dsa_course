#!/usr/bin/env bash
# ─────────────────────────────────────────────
# add_main_stubs.sh
# Adds a runnable main() stub to every .java file
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
  classname=$(basename "$f" .java)

  cat > "$f" <<JAVA
package kalo;

public class $classname {

    public static void main(String[] args) {

    }

}
JAVA

  echo "   ✅  $f"
done

echo ""
echo "🎉  Done!"
echo "    git add -A && git commit -m 'refactor: update all java stubs to package kalo'"
