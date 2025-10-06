#!/usr/bin/env bash

# Bash completion for SPY build scripts.

_spy_build_complete_file_from_repo_root() {
    local repo_root
    repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
    printf '%s/%s' "${repo_root}" "$1"
}

_spy_build_complete_version_values() {
    local version_file
    version_file="$(_spy_build_complete_file_from_repo_root "version")"
    if [[ -f "${version_file}" ]]; then
        awk -F'=' '
            {
                value = $2
                gsub(/\r/, "", value)
                gsub(/^[[:space:]]+|[[:space:]]+$/, "", value)
                if (value ~ /^[0-9]+$/) {
                    print value
                    print value + 1
                }
            }
        ' "${version_file}" | sort -nu
    else
        printf '1\n2\n3\n'
    fi
}

_spy_build_complete_build_sh() {
    local cur prev
    cur="${COMP_WORDS[COMP_CWORD]}"
    prev="${COMP_WORDS[COMP_CWORD-1]}"

    local options
    options="--build-version --no-cache --pull-base-image --skip-pull --dry-run --help -h"

    case "${prev}" in
        --build-version)
            COMPREPLY=( $(compgen -W "$(_spy_build_complete_version_values)" -- "${cur}") )
            return 0
            ;;
    esac

    COMPREPLY=( $(compgen -W "${options}" -- "${cur}") )
}

_spy_build_complete_build_test_sh() {
    local cur prev
    cur="${COMP_WORDS[COMP_CWORD]}"
    prev="${COMP_WORDS[COMP_CWORD-1]}"

    local options
    options="--tag --no-cache --pull-base-image --skip-pull --dry-run --help -h"

    case "${prev}" in
        --tag)
            COMPREPLY=()
            return 0
            ;;
    esac

    COMPREPLY=( $(compgen -W "${options}" -- "${cur}") )
}

complete -F _spy_build_complete_build_sh build.sh
complete -F _spy_build_complete_build_sh ./build.sh
complete -F _spy_build_complete_build_test_sh build-test.sh
complete -F _spy_build_complete_build_test_sh ./build-test.sh
