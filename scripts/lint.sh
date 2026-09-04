#!/usr/bin/env bash
# Static checks over this repository: workflow syntax and shell correctness.
set -euo pipefail

root=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)
cd "$root"

if compgen -G ".github/workflows/*.yml" > /dev/null; then
  actionlint
fi

shellcheck scripts/*.sh
