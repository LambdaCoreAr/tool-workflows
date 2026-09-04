#!/usr/bin/env bash
# Is the calling repository a template? Repository JSON on stdin.
# Anything unreadable is reported as a template, so a failed lookup blocks
# a release rather than permitting one.
set -euo pipefail

value=$(jq -r 'if (.is_template | type) == "boolean" then .is_template else "true" end' 2>/dev/null) \
  || value=true

# Load-bearing, not a formality: on empty stdin jq exits 0 printing nothing, so the
# fallback above never fires and value is the empty string. This line is the only
# thing that turns that into a decision. It also collapses multi-document input.
[[ $value == "false" ]] || value=true

echo "is_template=${value}"
