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
  n=$((10#$n))   # 10# forces base 10; bare 08 or 09 is an invalid octal literal
  (( n > highest )) && highest=$n
done

echo "rc=$((highest + 1))"
