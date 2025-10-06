#!/usr/bin/env bash

set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
COMPLETION_SCRIPT="${REPO_ROOT}/scripts/spy-build-completion.bash"
BASHRC_FILE="${HOME}/.bashrc"
SOURCE_LINE="source ${COMPLETION_SCRIPT}"

if [[ ! -f "${COMPLETION_SCRIPT}" ]]; then
    echo "[ERROR] Completion script not found: ${COMPLETION_SCRIPT}" >&2
    exit 1
fi

touch "${BASHRC_FILE}"

if grep -Fqx "${SOURCE_LINE}" "${BASHRC_FILE}"; then
    echo "[INFO] Completion is already configured in ${BASHRC_FILE}."
else
    echo "${SOURCE_LINE}" >> "${BASHRC_FILE}"
    echo "[INFO] Added completion source line to ${BASHRC_FILE}."
fi

# Load for current shell session when possible.
# shellcheck disable=SC1090
source "${COMPLETION_SCRIPT}" || true
echo "[INFO] SPY build completion loaded for current shell."
echo "[INFO] Open a new shell to ensure completion is active everywhere."
