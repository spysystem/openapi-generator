#!/bin/bash

function log_info()
{
    echo "[INFO] $*"
}

function log_warn()
{
    echo "[WARN] $*" >&2
}

function log_error()
{
    echo "[ERROR] $*" >&2
}

function fail()
{
    log_error "$1"
    exit 1
}

function fail_with_steps()
{
    local MESSAGE=$1
    shift

    log_error "${MESSAGE}"
    while [ "${#}" -gt 0 ]; do
        log_error "$1"
        shift
    done
    exit 1
}

function require_file()
{
    local FILE_PATH=$1
    local DESCRIPTION=$2
    if [ ! -r "${FILE_PATH}" ]; then
        fail "Cannot read ${DESCRIPTION}: ${FILE_PATH}"
    fi
}

function require_command()
{
    local COMMAND_NAME=$1
    if ! command -v "${COMMAND_NAME}" >/dev/null 2>&1; then
        fail "Required command not found: ${COMMAND_NAME}"
    fi
}

function is_numeric()
{
    local VALUE=$1
    [[ "${VALUE}" =~ ^[0-9]+$ ]]
}

function to_bool_or_exit()
{
    local VALUE=${1:-}
    case "${VALUE,,}" in
        1|true|yes|y)
            echo "true"
            ;;
        0|false|no|n|"")
            echo "false"
            ;;
        *)
            fail "Invalid boolean value: ${VALUE}. Use 1/0, true/false, yes/no."
            ;;
    esac
}

function bool_to_binary()
{
    local VALUE=$1
    if [ "${VALUE}" = "true" ]; then
        echo "1"
    else
        echo "0"
    fi
}

function run_cmd()
{
    if [ "${DRY_RUN:-false}" = "true" ]; then
        printf '[DRY-RUN] '
        printf '%q ' "$@"
        printf '\n'
        return
    fi

    "$@"
}

function pull_base_image()
{
    BASE_IMAGE=$1

    echo "Pull base image: ${BASE_IMAGE} from remote repository? (y/n)"
    read PULL_BASE_IMAGE
    # Case insensitive comparison
    if [ "${PULL_BASE_IMAGE,,}" = "y" ]; then
        echo "Pulling base image: ${BASE_IMAGE}"
        docker pull ${BASE_IMAGE}
    fi
}

function get_next_version_or_exit()
{
    local MINOR_VERSION=$1
    local VERSION_FILE=$2

    # if no version is provided then read from version file is possible
    if [[ -z "${MINOR_VERSION}" && -f "${VERSION_FILE}" ]]; then
        #Read last used version from file and increment
        MINOR_VERSION=$(($(cat "${VERSION_FILE}") + 1))
    fi

    # if version is empty, then echo error
    if [ -z "${MINOR_VERSION}" ]; then
        fail "No version provided and no version file found."
    fi

    # return version
    echo "${MINOR_VERSION}"
}

function get_upstream_version_or_exit()
{
    local POM_FILE=$1
    local UPSTREAM_VERSION

    if [ ! -f "${POM_FILE}" ]; then
        fail "Cannot read pom file: ${POM_FILE}"
    fi

    # Read the version from the explicitly marked RELEASE_VERSION section in pom.xml.
    UPSTREAM_VERSION=$(
        awk '
            /<!-- RELEASE_VERSION -->/ { in_release = 1; next }
            /<!-- \/RELEASE_VERSION -->/ { in_release = 0 }
            in_release && /<version>/ {
                line = $0
                sub(/^.*<version>/, "", line)
                sub(/<\/version>.*$/, "", line)
                print line
                exit
            }
        ' "${POM_FILE}"
    )

    if [ -z "${UPSTREAM_VERSION}" ]; then
        fail "Unable to parse upstream version from ${POM_FILE}"
    fi

    echo "${UPSTREAM_VERSION}"
}

function get_upstream_major_minor_or_exit()
{
    local UPSTREAM_VERSION=$1
    local BASE_VERSION
    local MAJOR
    local MINOR

    # Drop suffixes like -SNAPSHOT, then extract major.minor.
    BASE_VERSION=${UPSTREAM_VERSION%%-*}
    if ! [[ "${BASE_VERSION}" =~ ^[0-9]+\.[0-9]+(\.[0-9]+)?$ ]]; then
        fail "Unsupported upstream version format: ${UPSTREAM_VERSION}"
    fi

    IFS='.' read -r MAJOR MINOR _ <<< "${BASE_VERSION}"
    if ! [[ "${MAJOR}" =~ ^[0-9]+$ && "${MINOR}" =~ ^[0-9]+$ ]]; then
        fail "Unable to derive major.minor from upstream version: ${UPSTREAM_VERSION}"
    fi

    echo "${MAJOR}.${MINOR}"
}

function get_spy_build_version_or_exit()
{
    local INPUT_SPY_BUILD_VERSION=$1
    local VERSION_FILE=$2
    local UPSTREAM_MAJOR_MINOR=$3
    local SPY_BUILD_VERSION=""
    local LAST_VERSION=""

    if [ -n "${INPUT_SPY_BUILD_VERSION}" ]; then
        SPY_BUILD_VERSION="${INPUT_SPY_BUILD_VERSION}"
    else
        # Fail fast on legacy one-number files to avoid mixing old/new formats.
        if [ -f "${VERSION_FILE}" ] && ! grep -q '=' "${VERSION_FILE}" && grep -Eq '^[[:space:]]*[0-9]+[[:space:]]*$' "${VERSION_FILE}"; then
            fail_with_steps \
                "Legacy version file format detected in ${VERSION_FILE}." \
                "Fix now with explicit build version: ./build.sh --build-version 1" \
                "Then migrate version file (copy/paste): printf '%s=%s\\n' '${UPSTREAM_MAJOR_MINOR}' '1' > '${VERSION_FILE}'" \
                "If you need to preserve old number N, use: printf '%s=%s\\n' '${UPSTREAM_MAJOR_MINOR}' 'N' > '${VERSION_FILE}'"
        fi

        if [ -f "${VERSION_FILE}" ]; then
            # Normalize CRLF and surrounding spaces so Windows/manual edits still parse.
            LAST_VERSION=$(
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
            )
        fi

        if [ -z "${LAST_VERSION}" ]; then
            fail_with_steps \
                "No version entry found for upstream ${UPSTREAM_MAJOR_MINOR} in ${VERSION_FILE}." \
                "Fix now with explicit build version: ./build.sh --build-version 1" \
                "Or add an entry manually (copy/paste): printf '%s=%s\\n' '${UPSTREAM_MAJOR_MINOR}' '1' >> '${VERSION_FILE}'" \
                "Then you can run: ./build.sh"
        fi

        if ! [[ "${LAST_VERSION}" =~ ^[0-9]+$ ]]; then
            fail_with_steps \
                "Invalid version value for ${UPSTREAM_MAJOR_MINOR} in ${VERSION_FILE}: ${LAST_VERSION}" \
                "Fix the entry to a number, for example (copy/paste): sed -i 's/^${UPSTREAM_MAJOR_MINOR}=.*/${UPSTREAM_MAJOR_MINOR}=1/' '${VERSION_FILE}'" \
                "Or bypass once with: ./build.sh --build-version 1"
        fi

        SPY_BUILD_VERSION=$((LAST_VERSION + 1))
    fi

    if ! [[ "${SPY_BUILD_VERSION}" =~ ^[0-9]+$ ]]; then
        fail "Spy build version must be numeric: ${SPY_BUILD_VERSION}"
    fi

    echo "${SPY_BUILD_VERSION}"
}

function set_spy_build_version()
{
    local VERSION_FILE=$1
    local UPSTREAM_MAJOR_MINOR=$2
    local SPY_BUILD_VERSION=$3
    local TMP_FILE

    TMP_FILE=$(mktemp)

    if [ -f "${VERSION_FILE}" ]; then
        # Replace matching key (whitespace/CRLF tolerant) or append when missing.
        awk -F'=' -v key="${UPSTREAM_MAJOR_MINOR}" -v value="${SPY_BUILD_VERSION}" '
            BEGIN { updated = 0 }
            {
                raw = $0
                current_key = $1
                gsub(/\r/, "", current_key)
                gsub(/^[[:space:]]+|[[:space:]]+$/, "", current_key)

                if (current_key == key) {
                    print key "=" value
                    updated = 1
                    next
                }

                print raw
            }
            END {
                if (!updated) {
                    print key "=" value
                }
            }
        ' "${VERSION_FILE}" > "${TMP_FILE}"
    else
        echo "${UPSTREAM_MAJOR_MINOR}=${SPY_BUILD_VERSION}" > "${TMP_FILE}"
    fi

    mv "${TMP_FILE}" "${VERSION_FILE}"
}
