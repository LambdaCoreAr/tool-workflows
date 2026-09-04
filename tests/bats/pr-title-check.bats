#!/usr/bin/env bats

setup() {
  SCRIPT="${BATS_TEST_DIRNAME}/../../scripts/pr-title-check.sh"
}

@test "feat bumps minor" {
  run "$SCRIPT" "feat: retry policy"
  [ "$status" -eq 0 ]
  [[ "$output" == *"type=feat"* ]]
  [[ "$output" == *"breaking=false"* ]]
  [[ "$output" == *"bump=minor"* ]]
}

@test "fix bumps patch" {
  run "$SCRIPT" "fix: header parsing"
  [ "$status" -eq 0 ]
  [[ "$output" == *"bump=patch"* ]]
}

@test "a scope is allowed" {
  run "$SCRIPT" "fix(api): null guard"
  [ "$status" -eq 0 ]
  [[ "$output" == *"bump=patch"* ]]
}

@test "bang bumps major" {
  run "$SCRIPT" "feat!: drop v1 endpoint"
  [ "$status" -eq 0 ]
  [[ "$output" == *"breaking=true"* ]]
  [[ "$output" == *"bump=major"* ]]
}

@test "a BREAKING CHANGE footer bumps major" {
  run "$SCRIPT" "fix: header parsing" $'why\n\nBREAKING CHANGE: header renamed'
  [ "$status" -eq 0 ]
  [[ "$output" == *"bump=major"* ]]
}

@test "a BREAKING CHANGE mention in prose is not a footer" {
  run "$SCRIPT" "fix: header parsing" "we once had a BREAKING CHANGE: incident, but not this time"
  [ "$status" -eq 0 ]
  [[ "$output" == *"bump=patch"* ]]
}

@test "non-version-bearing types bump nothing" {
  run "$SCRIPT" "chore: bump deps"
  [ "$status" -eq 0 ]
  [[ "$output" == *"bump=none"* ]]
}

@test "an unknown type is rejected" {
  run "$SCRIPT" "wip: something"
  [ "$status" -eq 1 ]
}

@test "a missing colon is rejected" {
  run "$SCRIPT" "feat add retries"
  [ "$status" -eq 1 ]
}

@test "an empty subject is rejected" {
  run "$SCRIPT" "feat: "
  [ "$status" -eq 1 ]
}
