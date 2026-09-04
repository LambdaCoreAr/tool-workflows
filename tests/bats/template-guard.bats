#!/usr/bin/env bats

setup() {
  SCRIPT="${BATS_TEST_DIRNAME}/../../scripts/template-guard.sh"
}

@test "a template repository is reported as one" {
  run bash -c "echo '{\"is_template\":true}' | '$SCRIPT'"
  [ "$status" -eq 0 ]
  [[ "$output" == "is_template=true" ]]
}

@test "an ordinary repository is reported as one" {
  run bash -c "echo '{\"is_template\":false}' | '$SCRIPT'"
  [ "$status" -eq 0 ]
  [[ "$output" == "is_template=false" ]]
}

@test "a missing field fails closed" {
  run bash -c "echo '{\"name\":\"svc-billing\"}' | '$SCRIPT'"
  [ "$status" -eq 0 ]
  [[ "$output" == "is_template=true" ]]
}

@test "a null field fails closed" {
  run bash -c "echo '{\"is_template\":null}' | '$SCRIPT'"
  [ "$status" -eq 0 ]
  [[ "$output" == "is_template=true" ]]
}

@test "malformed json fails closed" {
  run bash -c "echo 'not json' | '$SCRIPT'"
  [ "$status" -eq 0 ]
  [[ "$output" == "is_template=true" ]]
}

@test "empty input fails closed" {
  run bash -c "printf '' | '$SCRIPT'"
  [ "$status" -eq 0 ]
  [[ "$output" == "is_template=true" ]]
}
