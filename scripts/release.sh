#!/usr/bin/env bash
# Build the Reminder Desk plugin zip for a GitHub Release.
#
#   bash scripts/release.sh            build dist/reminder-desk-plugin-v<version>.zip
#   bash scripts/release.sh --publish  build, tag v<version>, push the tag, create the GitHub Release
#
# The zip holds only the plugin: plugins/reminder-desk/ (.claude-plugin, hooks, scripts, skills).
# Repo files such as README, LICENSE, .gitignore and dotfiles are left out.
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
PLUGIN_DIR="$ROOT/plugins/reminder-desk"
MANIFEST="$PLUGIN_DIR/.claude-plugin/plugin.json"
DIST="$ROOT/dist"
PUBLISH=false
[ "${1:-}" = "--publish" ] && PUBLISH=true

die() { echo "✘ $*" >&2; exit 1; }

[ -f "$MANIFEST" ] || die "Missing $MANIFEST"
command -v zip >/dev/null || die "zip is not installed"

# Version from plugin.json, e.g. "version": "1.0.0"
VERSION="$(sed -n 's/.*"version"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/p' "$MANIFEST" | head -n1)"
[ -n "$VERSION" ] || die "No \"version\" in plugin.json"
TAG="v$VERSION"
ZIP="$DIST/reminder-desk-plugin-$TAG.zip"

# Checks before packaging
if command -v claude >/dev/null; then
  claude plugin validate "$PLUGIN_DIR" >/dev/null || die "claude plugin validate failed for $PLUGIN_DIR"
  claude plugin validate "$ROOT" >/dev/null || die "claude plugin validate failed for the marketplace"
  echo "✔ Plugin and marketplace validated"
else
  echo "• claude CLI not found, skipping validation"
fi
# Build: zip the plugin folder itself, so the zip opens to reminder-desk/
rm -f "$ZIP"
mkdir -p "$DIST"
(
  cd "$ROOT/plugins"
  zip -rq "$ZIP" reminder-desk \
    -x '*/.DS_Store' '*/.git*' '*/node_modules/*' '*.zip' \
      'reminder-desk/README*' 'reminder-desk/LICENSE*'
)
echo "✔ Built ${ZIP#$ROOT/}"
unzip -l "$ZIP" | awk 'NR>3 && $4 != "" && $4 !~ /\/$/ {print "   " $4}' | sed '$d'

$PUBLISH || { echo "Done. Run with --publish to create the GitHub Release $TAG."; exit 0; }

# Publish
command -v gh >/dev/null || die "GitHub CLI (gh) is not installed"
cd "$ROOT"
[ -z "$(git status --porcelain)" ] || die "Commit or stash your changes first"
git rev-parse -q --verify "refs/tags/$TAG" >/dev/null && die "Tag $TAG already exists; bump \"version\" in plugin.json"
git tag -a "$TAG" -m "Reminder Desk $TAG"
git push origin "$TAG"
gh release create "$TAG" "$ZIP" --title "Reminder Desk $TAG" --generate-notes
echo "✔ Released $TAG"
