#!/bin/bash

set -e

. config
source ./helper.sh

VERSION_FILE="version"
INPUT_MINOR_VERSION=$1
NO_CACHE=$2

# return value from get_next_version_or_exit must be a digit, else exit with the error message
MINOR_VERSION=`get_next_version_or_exit "${INPUT_MINOR_VERSION}" ${VERSION_FILE}`
if ! [[ "${MINOR_VERSION}" =~ ^[0-9]+$ ]]; then
    echo ${MINOR_VERSION}
    exit
fi

docker pull ${BASE_IMAGE}

cd "$(dirname $0)"
./_build_version.sh Dockerfile ${TAG_WITHOUT_MINOR_VERSION} ${MINOR_VERSION} 0 ${NO_CACHE}

echo ${MINOR_VERSION} > ${VERSION_FILE}

