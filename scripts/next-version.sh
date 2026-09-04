#!/usr/bin/env bash
# Fold pull request titles into the next semantic version.
# Usage: next-version.sh <latest-version>   (titles on stdin, one per line)
set -euo pipefail

here=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)

latest=${1-}
latest=${latest#v}
[[ -z $latest ]] && latest=0.0.0

IFS=. read -r major minor patch <<<"$latest"

rank=0
while IFS= read -r title; do
  [[ -z $title ]] && continue
  out=$("$here/pr-title-check.sh" "$title" 2>/dev/null) || continue
  case $out in
    *bump=major*) [[ $rank -lt 3 ]] && rank=3 ;;
    *bump=minor*) [[ $rank -lt 2 ]] && rank=2 ;;
    *bump=patch*) [[ $rank -lt 1 ]] && rank=1 ;;
  esac
done

case $rank in
  3) major=$((major + 1)) minor=0 patch=0 bump=major ;;
  2) minor=$((minor + 1)) patch=0 bump=minor ;;
  1) patch=$((patch + 1)) bump=patch ;;
  *) bump=none ;;
esac

echo "bump=${bump}"
echo "version=${major}.${minor}.${patch}"
