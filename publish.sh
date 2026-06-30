#!/usr/bin/env bash
# Publishes the repo's changes to GitHub Pages.
# Generic: detects owner/repo from the git remote, so it works in any clone.
# Usage:
#   ./publish.sh                 -> commit with an automatic message (date)
#   ./publish.sh "your message"  -> commit with your own message
set -euo pipefail

cd "$(dirname "$0")"

MSG="${1:-Update gantt $(date '+%B %Y')}"

if [ -z "$(git status --porcelain)" ]; then
  echo "Nothing to publish."
  exit 0
fi

git add -A
git commit -m "$MSG"
git push

# Derive the GitHub Pages base URL from the origin remote.
REMOTE="$(git remote get-url origin)"
SLUG="$(echo "$REMOTE" | sed -E 's#^.*github\.com[:/]##; s#\.git$##')"
OWNER="${SLUG%%/*}"
REPO="${SLUG##*/}"
BASE="https://${OWNER}.github.io/${REPO}/"

echo
echo "Published. Live in ~1 minute:"
echo "  Base: ${BASE}"
for f in *.html; do
  [ -e "$f" ] && echo "  ${BASE}${f}"
done
