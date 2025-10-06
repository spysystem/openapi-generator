#!/bin/bash
set -e

TAG=$1
NO_CACHE=$2

# if version is empty, then echo error
if [ -z "${TAG}" ]; then
    echo "No tag provided!"
    exit
fi

if [ -z "${NO_CACHE}" ]; then
    NO_CACHE="0"
fi


. config
source ./helper.sh

docker pull ${BASE_IMAGE}

TAG="${REPO}:${TAG}"

cd "$(dirname $0)"
./_build_version.sh Dockerfile ${TAG} 0 1 ${NO_CACHE}

echo "Tag: ${TAG}"

