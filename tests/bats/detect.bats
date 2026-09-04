#!/usr/bin/env bats

setup() {
  STACK="${BATS_TEST_DIRNAME}/../../scripts/detect-stack.sh"
  BACKEND="${BATS_TEST_DIRNAME}/../../scripts/detect-backend.sh"
  FIX="${BATS_TEST_DIRNAME}/../fixtures"
}

@test "an empty node directory has no project" {
  run "$STACK" "$FIX/node-empty" node
  [ "$status" -eq 0 ]
  [[ "$output" == "has_project=false" ]]
}

@test "a populated node directory has a project" {
  run "$STACK" "$FIX/node-populated" node
  [[ "$output" == "has_project=true" ]]
}

@test "an empty dotnet directory has no project" {
  run "$STACK" "$FIX/dotnet-empty" dotnet
  [[ "$output" == "has_project=false" ]]
}

@test "a populated dotnet directory has a project" {
  run "$STACK" "$FIX/dotnet-populated" dotnet
  [[ "$output" == "has_project=true" ]]
}

@test "a node project is not mistaken for a dotnet one" {
  run "$STACK" "$FIX/node-populated" dotnet
  [[ "$output" == "has_project=false" ]]
}

@test "a csproj vendored under node_modules is not this repository's project" {
  run "$STACK" "$FIX/node-nested-csproj" dotnet
  [ "$status" -eq 0 ]
  [[ "$output" == "has_project=false" ]]
}

@test "an unknown language is rejected" {
  run "$STACK" "$FIX/node-populated" rust
  [ "$status" -eq 1 ]
}

@test "a missing directory is rejected" {
  run "$STACK" "$FIX/nope" node
  [ "$status" -eq 1 ]
}

@test "a placeholder backend is not configured" {
  run "$BACKEND" "$FIX/infra-placeholder" dev
  [ "$status" -eq 0 ]
  [[ "$output" == "configured=false" ]]
}

@test "a filled backend is configured" {
  run "$BACKEND" "$FIX/infra-configured" dev
  [[ "$output" == "configured=true" ]]
}

@test "a missing backend file is not configured" {
  run "$BACKEND" "$FIX/infra-configured" prod
  [[ "$output" == "configured=false" ]]
}

@test "a directory with tf files has a tofu project" {
  run "$STACK" "$FIX/infra-configured" tofu
  [ "$status" -eq 0 ]
  [[ "$output" == "has_project=true" ]]
}

@test "a directory without tf files has no tofu project" {
  run "$STACK" "$FIX/infra-placeholder" tofu
  [[ "$output" == "has_project=false" ]]
}
