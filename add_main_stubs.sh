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
  classname=$(basename "$f" .java)

  cat > "$f" <<EOF
package kalophain;

public class $classname {

    public static void main(String[] args) {
        // TODO: add your solution here
    }

}
EOF

  echo "   ✅  $f"
done

echo ""
echo "🎉  Done! All .java files are now F5-runnable in IntelliJ."
echo "    Stage & commit with:"
echo "      git add -A && git commit -m 'chore: add main() stubs to all java files'"
