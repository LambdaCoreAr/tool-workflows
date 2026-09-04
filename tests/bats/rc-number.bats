#!/usr/bin/env bats

setup() {
  SCRIPT="${BATS_TEST_DIRNAME}/../../scripts/rc-number.sh"
}

@test "no existing prereleases starts at 1" {
  run bash -c "printf 'v1.2.0\nv1.2.1\n' | '$SCRIPT' 1.3.0"
  [ "$status" -eq 0 ]
  [[ "$output" == "rc=1" ]]
}

@test "empty input starts at 1" {
  run bash -c "printf '' | '$SCRIPT' 1.3.0"
  [[ "$output" == "rc=1" ]]
}

@test "counts from the highest existing prerelease" {
  run bash -c "printf 'v1.3.0-rc.1\nv1.3.0-rc.2\n' | '$SCRIPT' 1.3.0"
  [[ "$output" == "rc=3" ]]
}

@test "ignores prereleases of other versions" {
  run bash -c "printf 'v1.2.0-rc.7\nv1.3.0-rc.1\n' | '$SCRIPT' 1.3.0"
  [[ "$output" == "rc=2" ]]
}

@test "a changed target version restarts at 1" {
  run bash -c "printf 'v1.3.0-rc.9\n' | '$SCRIPT' 2.0.0"
  [[ "$output" == "rc=1" ]]
}

@test "tags without a v prefix are accepted" {
  run bash -c "printf '1.3.0-rc.4\n' | '$SCRIPT' 1.3.0"
  [[ "$output" == "rc=5" ]]
}

@test "a zero-padded prerelease number is read as decimal" {
  run bash -c "printf 'v1.3.0-rc.09\n' | '$SCRIPT' 1.3.0"
  [ "$status" -eq 0 ]
  [[ "$output" == "rc=10" ]]
}

@test "numeric order, not lexical" {
  run bash -c "printf 'v1.3.0-rc.9\nv1.3.0-rc.10\n' | '$SCRIPT' 1.3.0"
  [[ "$output" == "rc=11" ]]
}
