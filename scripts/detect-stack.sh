#!/usr/bin/env bash
# Does this directory hold project files yet?
# Usage: detect-stack.sh <dir> <node|dotnet>
set -euo pipefail

dir=${1:?directory required}
language=${2:?language required}

if [[ ! -d $dir ]]; then
  echo "no such directory: ${dir}" >&2
  exit 1
fi

case $language in
  node)
    if [[ -f "$dir/package.json" ]]; then found=true; else found=false; fi
    ;;
  dotnet)
    if find "$dir" -name '*.csproj' -o -name '*.sln' | grep -q .; then
      found=true
    else
      found=false
    fi
    ;;
  *)
    echo "unknown language: ${language}" >&2
    exit 1
    ;;
esac

echo "has_project=${found}"
