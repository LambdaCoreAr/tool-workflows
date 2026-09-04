#!/usr/bin/env bash
# Is the calling repository a template? Repository JSON on stdin.
# Anything unreadable is reported as a template, so a failed lookup blocks
# a release rather than permitting one.
set -euo pipefail

value=$(jq -r 'if (.is_template | type) == "boolean" then .is_template else "true" end' 2>/dev/null) \
  || value=true

[[ $value == "false" ]] || value=true

echo "is_template=${value}"
