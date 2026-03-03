#!/bin/sh
# install-hooks.sh — installs pre-push safety hook for ecclesia-dev repos
# Maintained by: Albert (ecclesia-dev DevOps)

set -e

HOOK_DIR="$(git rev-parse --show-toplevel)/.git/hooks"
HOOK_FILE="$HOOK_DIR/pre-push"

mkdir -p "$HOOK_DIR"

cat > "$HOOK_FILE" << 'HOOKEOF'
#!/bin/sh
# Pre-push safety hook
# Blocks pushes of workspace configuration files and from the workspace root
# See internal documentation for the protected file list

# Check that git root is NOT the workspace root
GIT_ROOT=$(git rev-parse --show-toplevel)
WORKSPACE="${OPENCLAW_WORKSPACE:-}"

if [ -n "$WORKSPACE" ] && [ "$GIT_ROOT" = "$WORKSPACE" ]; then
  echo "❌ PUSH BLOCKED: cannot push from workspace root."
  echo "   Run git operations from inside the project directory only."
  exit 1
fi

# Load the protected file list from the workspace (not stored in this repo)
# See internal documentation for the protected file list
if [ -n "$WORKSPACE" ] && [ -f "$WORKSPACE/.protected-files" ]; then
  FORBIDDEN="$(cat "$WORKSPACE/.protected-files")"
else
  # Fall back to environment variable if workspace file is unavailable
  FORBIDDEN="${OPENCLAW_PROTECTED_FILES:-}"
fi

if [ -n "$FORBIDDEN" ]; then
  for f in $FORBIDDEN; do
    if git ls-files --error-unmatch "$f" 2>/dev/null; then
      echo "❌ PUSH BLOCKED: a protected workspace configuration file is tracked in this repo."
      echo "   Remove it with: git rm --cached $f"
      exit 1
    fi
  done
fi

echo "✅ Pre-push check passed."
exit 0
HOOKEOF

chmod +x "$HOOK_FILE"

echo "✅ Pre-push hook installed at $HOOK_FILE"
