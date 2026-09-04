#!/usr/bin/env bats

@test "lint.sh passes on a clean repository" {
  run "${BATS_TEST_DIRNAME}/../../scripts/lint.sh"
  [ "$status" -eq 0 ]
}
