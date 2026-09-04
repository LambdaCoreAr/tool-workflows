#!/usr/bin/env bash
# Is an OpenTofu state backend configured, or still the template placeholder?
# Usage: detect-backend.sh <dir> <environment>
set -euo pipefail

dir=${1:?directory required}
env=${2:?environment required}

file="${dir}/backend-${env}.hcl"

if [[ -f $file ]] && ! grep -q 'PLACEHOLDER' "$file"; then
  echo "configured=true"
else
  echo "configured=false"
fi
