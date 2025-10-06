# SPY Build Scripts

This document describes the SPY-specific Docker build scripts in this repository.

## Files

- `build.sh` - Main release build flow (versioned SPY tag).
- `build-test.sh` - Test build flow (single test tag).
- `helper.sh` - Shared utilities and version helpers used by both scripts.
- `_build_version.sh` - Low-level Docker build/push script used by both flows.
- `config` - Required environment values (`BASE_IMAGE`, `REPO`).
- `version` - SPY build version storage in `<upstreamMajorMinor>=<buildVersion>` format.

## How `build.sh` Works

1. Parses CLI arguments (new flags or legacy positional format).
2. Validates required files/commands and loads `config` + `helper.sh`.
3. Reads upstream version from `pom.xml` release block.
4. Derives `major.minor` (for example `7.19`).
5. Resolves SPY build version:
   - Uses `--build-version` if provided.
   - Otherwise auto-increments from `version` file entry for that upstream line.
6. Optionally pulls base image (`--pull-base-image` or `--skip-pull`).
7. Calls `_build_version.sh` to build and push:
   - release tag: `<repo>:spy-<major.minor>.<buildVersion>`
   - latest tag: `<repo>:spy-<major.minor>.latest`
8. Persists build version back to `version` (idempotent update).

## How `build-test.sh` Works

1. Parses CLI arguments (new flags or legacy positional format).
2. Validates required files/commands and loads `config` + `helper.sh`.
3. Builds test image using `_build_version.sh` in test mode.
4. Pushes only one tag: `<repo>:<tag>`.
5. Does not update the `version` file.

## CLI Usage

### `build.sh`

```bash
./build.sh --build-version 7 --no-cache --pull-base-image

# Auto-increment from version file entry
./build.sh --skip-pull

# Inspect without executing
./build.sh --build-version 7 --no-cache --skip-pull --dry-run
```

### `build-test.sh`

```bash
./build-test.sh --tag smoke --no-cache --pull-base-image

# Inspect without executing
./build-test.sh --tag smoke --skip-pull --dry-run
```

## Common Notes

- `--no-cache` maps to Docker `--no-cache`.
- `--dry-run` prints resolved values and planned commands without running them.
- Shared logging and validation helpers are centralized in `helper.sh`.
- Both scripts fail fast with clear error messages when required inputs are missing.

## Bash Autocomplete

A completion script is available at:

- `scripts/spy-build-completion.bash`
- `scripts/install-spy-build-completion.sh` (one-time setup helper)

One-command setup:

```bash
bash scripts/install-spy-build-completion.sh
```

Load it in your current shell:

```bash
source scripts/spy-build-completion.bash
```

Persist it for future shells (example):

```bash
echo 'source /absolute/path/to/openapi-generator/scripts/spy-build-completion.bash' >> ~/.bashrc
```

What it completes:

- `build.sh` / `./build.sh`
  - options: `--build-version`, `--no-cache`, `--pull-base-image`, `--skip-pull`, `--dry-run`, `--help`
- `build-test.sh` / `./build-test.sh`
  - options: `--tag`, `--no-cache`, `--pull-base-image`, `--skip-pull`, `--dry-run`, `--help`
