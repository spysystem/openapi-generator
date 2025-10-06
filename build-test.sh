#!/bin/bash

set -Eeuo pipefail
IFS=$'\n\t'

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
CONFIG_FILE="${SCRIPT_DIR}/config"
HELPER_FILE="${SCRIPT_DIR}/helper.sh"
DOCKER_FILE="Dockerfile"
MINOR_VERSION="0"
TEST_BUILD="1"

INPUT_TEST_TAG=""
NO_CACHE=false
PULL_BASE_IMAGE=true
DRY_RUN=false

if [ ! -r "${HELPER_FILE}" ]; then
    echo "[ERROR] Cannot read helper file: ${HELPER_FILE}" >&2
    exit 1
fi

# shellcheck disable=SC1090
source "${HELPER_FILE}"

function usage()
{
    cat <<'EOF'
Usage:
  ./build-test.sh [options]

Options:
  --tag <name>         Test tag suffix (required)
  --no-cache           Enable docker --no-cache
  --pull-base-image    Pull BASE_IMAGE before build (default)
  --skip-pull          Skip docker pull for BASE_IMAGE
  --dry-run            Print resolved values and commands without executing
  --help, -h           Show this help message
EOF
}

function on_error()
{
    local EXIT_CODE=$1
    local LINE_NO=$2
    local FAILED_COMMAND=${3:-unknown}
    log_error "Test build failed at line ${LINE_NO} (exit code: ${EXIT_CODE})."
    log_error "Failed command: ${FAILED_COMMAND}"
}

trap 'on_error "$?" "$LINENO" "${BASH_COMMAND}"' ERR

function parse_args_or_exit()
{
    while [ "${#}" -gt 0 ]; do
        case "$1" in
            --tag)
                shift
                [ "${#}" -gt 0 ] || fail "Missing value for --tag."
                INPUT_TEST_TAG=$1
                ;;
            --no-cache)
                NO_CACHE=true
                ;;
            --pull-base-image)
                PULL_BASE_IMAGE=true
                ;;
            --skip-pull)
                PULL_BASE_IMAGE=false
                ;;
            --dry-run)
                DRY_RUN=true
                ;;
            --help|-h)
                usage
                exit 0
                ;;
            *)
                usage
                if [[ "$1" != --* ]] && [[ "$1" != "-"* ]]; then
                    fail "Positional arguments are no longer supported. Use flags such as --tag and --no-cache."
                fi
                fail "Unknown argument: $1"
                ;;
        esac
        shift
    done

    [ -n "${INPUT_TEST_TAG}" ] || fail "No test tag provided. Use --tag <name>."
}

function preflight_or_exit()
{
    require_file "${CONFIG_FILE}" "config file"
    require_file "${HELPER_FILE}" "helper file"
    require_command "docker"
}

function validate_config_or_exit()
{
    if [ -z "${BASE_IMAGE:-}" ]; then
        fail "BASE_IMAGE must be set in ${CONFIG_FILE}"
    fi

    if [ -z "${REPO:-}" ]; then
        fail "REPO must be set in ${CONFIG_FILE}"
    fi
}

function run_build_test()
{
    local FULL_TAG=$1
    local NO_CACHE_BINARY=$2

    if [ "${DRY_RUN}" = "true" ]; then
        printf '[DRY-RUN] (cd %q && ./_build_version.sh %q %q %q %q %q)\n' \
            "${SCRIPT_DIR}" "${DOCKER_FILE}" "${FULL_TAG}" "${MINOR_VERSION}" "${TEST_BUILD}" "${NO_CACHE_BINARY}"
        return
    fi

    (
        cd "${SCRIPT_DIR}"
        ./_build_version.sh "${DOCKER_FILE}" "${FULL_TAG}" "${MINOR_VERSION}" "${TEST_BUILD}" "${NO_CACHE_BINARY}"
    )
}

function main()
{
    parse_args_or_exit "$@"
    preflight_or_exit

    # shellcheck disable=SC1090
    . "${CONFIG_FILE}"
    validate_config_or_exit

    local FULL_TAG
    local NO_CACHE_BINARY
    FULL_TAG="${REPO}:${INPUT_TEST_TAG}"
    NO_CACHE_BINARY=$(bool_to_binary "${NO_CACHE}")

    if [ "${DRY_RUN}" = "true" ]; then
        log_info "Dry run enabled. No commands will be executed."
        log_info "Resolved final tag: ${FULL_TAG}"
        log_info "Resolved no-cache flag: ${NO_CACHE_BINARY}"
        log_info "Resolved pull-base-image: ${PULL_BASE_IMAGE}"
    fi

    if [ "${PULL_BASE_IMAGE}" = "true" ]; then
        run_cmd docker pull "${BASE_IMAGE}"
    else
        log_warn "Skipping base image pull for ${BASE_IMAGE}."
    fi

    run_build_test "${FULL_TAG}" "${NO_CACHE_BINARY}"
    log_info "Tag: ${FULL_TAG}"
}

main "$@"

