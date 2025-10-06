#!/bin/bash

set -Eeuo pipefail
IFS=$'\n\t'

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
CONFIG_FILE="${SCRIPT_DIR}/config"
HELPER_FILE="${SCRIPT_DIR}/helper.sh"
VERSION_FILE="${SCRIPT_DIR}/version"
POM_FILE="${SCRIPT_DIR}/pom.xml"
DOCKER_FILE="Dockerfile"
TEST_BUILD="0"

INPUT_SPY_BUILD_VERSION=""
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
  ./build.sh [options]

Options:
  --build-version <n>  Explicit spy build version (numeric)
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
    log_error "Build failed at line ${LINE_NO} (exit code: ${EXIT_CODE})."
    log_error "Failed command: ${FAILED_COMMAND}"
}

trap 'on_error "$?" "$LINENO" "${BASH_COMMAND}"' ERR

function parse_args_or_exit()
{
    while [ "${#}" -gt 0 ]; do
        case "$1" in
            --build-version)
                shift
                [ "${#}" -gt 0 ] || fail "Missing value for --build-version."
                INPUT_SPY_BUILD_VERSION=$1
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
                    fail "Positional arguments are no longer supported. Use flags such as --build-version and --no-cache."
                fi
                fail "Unknown argument: $1"
                ;;
        esac
        shift
    done

    if [ -n "${INPUT_SPY_BUILD_VERSION}" ] && ! is_numeric "${INPUT_SPY_BUILD_VERSION}"; then
        fail "Build version must be numeric: ${INPUT_SPY_BUILD_VERSION}"
    fi
}

function preflight_or_exit()
{
    require_file "${CONFIG_FILE}" "config file"
    require_file "${HELPER_FILE}" "helper file"
    require_file "${POM_FILE}" "pom file"

    require_command "docker"
    require_command "awk"
    require_command "mktemp"
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

function print_dry_run_context()
{
    local UPSTREAM_VERSION=$1
    local UPSTREAM_MAJOR_MINOR=$2
    local TAG_WITHOUT_MINOR_VERSION=$3
    local SPY_BUILD_VERSION=$4
    local NO_CACHE_BINARY=$5
    local RELEASE_TAG
    local LATEST_TAG

    RELEASE_TAG="${TAG_WITHOUT_MINOR_VERSION}.${SPY_BUILD_VERSION}"
    LATEST_TAG="${TAG_WITHOUT_MINOR_VERSION}.latest"

    log_info "Dry run enabled. No commands will be executed."
    log_info "Resolved upstream version: ${UPSTREAM_VERSION}"
    log_info "Resolved upstream major.minor: ${UPSTREAM_MAJOR_MINOR}"
    log_info "Resolved spy build version: ${SPY_BUILD_VERSION}"
    log_info "Resolved image tag prefix: ${TAG_WITHOUT_MINOR_VERSION}"
    log_info "Resolved final tags: ${RELEASE_TAG}, ${LATEST_TAG}"
    log_info "Resolved no-cache flag: ${NO_CACHE_BINARY}"
    log_info "Resolved pull-base-image: ${PULL_BASE_IMAGE}"
}

function run_build_version()
{
    local TAG_WITHOUT_MINOR_VERSION=$1
    local SPY_BUILD_VERSION=$2
    local NO_CACHE_BINARY=$3

    if [ "${DRY_RUN}" = "true" ]; then
        printf '[DRY-RUN] (cd %q && ./_build_version.sh %q %q %q %q %q)\n' \
            "${SCRIPT_DIR}" "${DOCKER_FILE}" "${TAG_WITHOUT_MINOR_VERSION}" "${SPY_BUILD_VERSION}" "${TEST_BUILD}" "${NO_CACHE_BINARY}"
        return
    fi

    (
        cd "${SCRIPT_DIR}"
        ./_build_version.sh "${DOCKER_FILE}" "${TAG_WITHOUT_MINOR_VERSION}" "${SPY_BUILD_VERSION}" "${TEST_BUILD}" "${NO_CACHE_BINARY}"
    )
}

function get_current_spy_build_version()
{
    local UPSTREAM_MAJOR_MINOR=$1

    if [ ! -f "${VERSION_FILE}" ]; then
        echo ""
        return
    fi

    awk -F'=' -v key="${UPSTREAM_MAJOR_MINOR}" '
        {
            k = $1
            v = $2
            gsub(/\r/, "", k)
            gsub(/\r/, "", v)
            gsub(/^[[:space:]]+|[[:space:]]+$/, "", k)
            gsub(/^[[:space:]]+|[[:space:]]+$/, "", v)
            if (k == key) {
                print v
                exit
            }
        }
    ' "${VERSION_FILE}"
}

function persist_spy_build_version()
{
    local UPSTREAM_MAJOR_MINOR=$1
    local SPY_BUILD_VERSION=$2
    local CURRENT_VERSION

    CURRENT_VERSION=$(get_current_spy_build_version "${UPSTREAM_MAJOR_MINOR}")
    if [ "${CURRENT_VERSION}" = "${SPY_BUILD_VERSION}" ]; then
        log_info "Version file already contains ${UPSTREAM_MAJOR_MINOR}=${SPY_BUILD_VERSION}, skipping update."
        return
    fi

    run_cmd set_spy_build_version "${VERSION_FILE}" "${UPSTREAM_MAJOR_MINOR}" "${SPY_BUILD_VERSION}"
}

function main()
{
    parse_args_or_exit "$@"
    preflight_or_exit

    # shellcheck disable=SC1090
    . "${CONFIG_FILE}"
    validate_config_or_exit

    local UPSTREAM_VERSION
    local UPSTREAM_MAJOR_MINOR
    local TAG_WITHOUT_MINOR_VERSION
    local SPY_BUILD_VERSION
    local NO_CACHE_BINARY

    UPSTREAM_VERSION=$(get_upstream_version_or_exit "${POM_FILE}")
    UPSTREAM_MAJOR_MINOR=$(get_upstream_major_minor_or_exit "${UPSTREAM_VERSION}")
    TAG_WITHOUT_MINOR_VERSION="${REPO}:spy-${UPSTREAM_MAJOR_MINOR}"

    SPY_BUILD_VERSION=$(get_spy_build_version_or_exit "${INPUT_SPY_BUILD_VERSION}" "${VERSION_FILE}" "${UPSTREAM_MAJOR_MINOR}")
    NO_CACHE_BINARY=$(bool_to_binary "${NO_CACHE}")

    if [ "${DRY_RUN}" = "true" ]; then
        print_dry_run_context "${UPSTREAM_VERSION}" "${UPSTREAM_MAJOR_MINOR}" "${TAG_WITHOUT_MINOR_VERSION}" "${SPY_BUILD_VERSION}" "${NO_CACHE_BINARY}"
    fi

    if [ "${PULL_BASE_IMAGE}" = "true" ]; then
        run_cmd docker pull "${BASE_IMAGE}"
    else
        log_warn "Skipping base image pull for ${BASE_IMAGE}."
    fi

    run_build_version "${TAG_WITHOUT_MINOR_VERSION}" "${SPY_BUILD_VERSION}" "${NO_CACHE_BINARY}"
    persist_spy_build_version "${UPSTREAM_MAJOR_MINOR}" "${SPY_BUILD_VERSION}"
}

main "$@"
