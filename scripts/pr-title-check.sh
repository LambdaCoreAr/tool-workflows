#!/usr/bin/env bash
# Validate one pull request title as a conventional commit and print its bump.
# Usage: pr-title-check.sh "<title>" ["<body>"]
set -euo pipefail

title=${1-}
body=${2-}

types='feat|fix|docs|chore|refactor|test|ci|build|style|perf'

if [[ ! $title =~ ^($types)(\([a-zA-Z0-9._/-]+\))?(!)?:[[:space:]]+[^[:space:]] ]]; then
  echo "not a conventional commit title: ${title}" >&2
  echo "expected one of: ${types//|/, } optionally with a scope, then ': ' and a subject" >&2
  exit 1
fi

type=${BASH_REMATCH[1]}
bang=${BASH_REMATCH[3]}

breaking=false
bump=none

case $type in
  feat) bump="minor" ;;
  fix)  bump="patch" ;;
esac

if [[ -n $bang ]] || [[ $body == *"BREAKING CHANGE:"* ]]; then
  breaking=true
  bump=major
fi

echo "type=${type}"
echo "breaking=${breaking}"
echo "bump=${bump}"
