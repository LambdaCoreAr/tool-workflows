#!/usr/bin/env bash
# Does this directory hold project files yet?
# Usage: detect-stack.sh <dir> <node|dotnet|tofu>
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
    # The group parentheses are load-bearing: without them the implicit -print
    # binds only to the last -name. The exclusions keep a vendored sample
    # project inside node_modules from passing as this repository's own.
    if find "$dir" \( -name '*.csproj' -o -name '*.sln' \) \
         -not -path '*/node_modules/*' -not -path '*/.git/*' | grep -q .; then
      found=true
    else
      found=false
    fi
    ;;
  tofu)
    if find "$dir" -maxdepth 1 -name '*.tf' | grep -q .; then
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
