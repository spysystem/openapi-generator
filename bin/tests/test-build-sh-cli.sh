#!/bin/bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_DIR="$(cd "${SCRIPT_DIR}/../.." && pwd)"
BUILD_SCRIPT="${REPO_DIR}/build.sh"

function assert_contains_or_exit()
{
    local HAYSTACK=$1
    local NEEDLE=$2
    local MESSAGE=$3
    if [[ "${HAYSTACK}" != *"${NEEDLE}"* ]]; then
        echo "Assertion failed: ${MESSAGE}"
        exit 1
    fi
}

function test_help_or_exit()
{
    local OUTPUT
    OUTPUT=$(bash "${BUILD_SCRIPT}" --help)
    assert_contains_or_exit "${OUTPUT}" "Usage:" "help output must include Usage"
    assert_contains_or_exit "${OUTPUT}" "--build-version <n>" "help output must include build-version option"
}

function test_unknown_argument_or_exit()
{
    set +e
    bash "${BUILD_SCRIPT}" --does-not-exist >/dev/null 2>&1
    local EXIT_CODE=$?
    set -e
    if [ "${EXIT_CODE}" -eq 0 ]; then
        echo "Assertion failed: unknown argument must fail"
        exit 1
    fi
}

function test_positional_arguments_rejected_or_exit()
{
    set +e
    bash "${BUILD_SCRIPT}" 1 >/dev/null 2>&1
    local EXIT_CODE=$?
    set -e
    if [ "${EXIT_CODE}" -eq 0 ]; then
        echo "Assertion failed: positional arguments must fail"
        exit 1
    fi
}

function test_dry_run_or_exit()
{
    if ! command -v docker >/dev/null 2>&1; then
        echo "Skipping dry-run test because docker is not available."
        return
    fi

    local OUTPUT
    OUTPUT=$(bash "${BUILD_SCRIPT}" --build-version 1 --skip-pull --dry-run)
    assert_contains_or_exit "${OUTPUT}" "[INFO] Dry run enabled. No commands will be executed." "dry-run should announce execution mode"
    assert_contains_or_exit "${OUTPUT}" "[DRY-RUN]" "dry-run should print planned commands"
}

test_help_or_exit
test_unknown_argument_or_exit
test_positional_arguments_rejected_or_exit
test_dry_run_or_exit

echo "All build.sh CLI tests passed."
