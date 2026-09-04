#!/usr/bin/env bats

setup() {
  SCRIPT="${BATS_TEST_DIRNAME}/../../scripts/next-version.sh"
}

@test "no previous tag and a feat gives 0.1.0" {
  run bash -c "printf 'feat: first thing\n' | '$SCRIPT' ''"
  [ "$status" -eq 0 ]
  [[ "$output" == *"version=0.1.0"* ]]
  [[ "$output" == *"bump=minor"* ]]
}

@test "no previous tag and a fix gives 0.0.1" {
  run bash -c "printf 'fix: first thing\n' | '$SCRIPT' ''"
  [[ "$output" == *"version=0.0.1"* ]]
}

@test "a v prefix on the latest tag is tolerated" {
  run bash -c "printf 'fix: a\n' | '$SCRIPT' v1.2.3"
  [[ "$output" == *"version=1.2.4"* ]]
}

@test "the highest bump wins" {
  run bash -c "printf 'fix: a\nfeat: b\nchore: c\n' | '$SCRIPT' 1.2.3"
  [[ "$output" == *"bump=minor"* ]]
  [[ "$output" == *"version=1.3.0"* ]]
}

@test "a breaking change wins over everything" {
  run bash -c "printf 'feat: a\nfix!: b\n' | '$SCRIPT' 1.2.3"
  [[ "$output" == *"bump=major"* ]]
  [[ "$output" == *"version=2.0.0"* ]]
}

@test "a minor bump resets patch" {
  run bash -c "printf 'feat: a\n' | '$SCRIPT' 1.2.9"
  [[ "$output" == *"version=1.3.0"* ]]
}

@test "no version-bearing titles leaves the version alone" {
  run bash -c "printf 'chore: a\ndocs: b\n' | '$SCRIPT' 1.2.3"
  [[ "$output" == *"bump=none"* ]]
  [[ "$output" == *"version=1.2.3"* ]]
}

@test "titles that are not conventional commits are ignored, not fatal" {
  run bash -c "printf 'merge branch main\nfix: a\n' | '$SCRIPT' 1.2.3"
  [ "$status" -eq 0 ]
  [[ "$output" == *"version=1.2.4"* ]]
}

@test "empty input leaves the version alone" {
  run bash -c "printf '' | '$SCRIPT' 1.2.3"
  [[ "$output" == *"bump=none"* ]]
  [[ "$output" == *"version=1.2.3"* ]]
}
