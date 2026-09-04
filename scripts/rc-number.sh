#!/usr/bin/env bash
# Next prerelease number for a target version. Existing tags on stdin.
# Usage: rc-number.sh <X.Y.Z>
set -euo pipefail

version=${1:?target version required}
version=${version#v}

highest=0
while IFS= read -r tag; do
  tag=${tag#v}
  [[ $tag == "${version}-rc."* ]] || continue
  n=${tag#"${version}-rc."}
  [[ $n =~ ^[0-9]+$ ]] || continue
  (( n > highest )) && highest=$n
done

echo "rc=$((highest + 1))"
