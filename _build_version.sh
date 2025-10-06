#!/bin/bash

set -e

. config

DOCKER_FILE=$1
TAG_WITHOUT_MINOR_VERSION=$2
MINOR_VERSION=$3
TEST_BUILD=$4
NO_CACHE=$5

PARAMETERS="'_build_version.sh [DOCKER_FILE] [TAG_WITHOUT_MINOR_VERSION] [MINOR_VERSION] [TEST_BUILD=0] [NO_CACHE=0]'"

if [ -z "${DOCKER_FILE}" ]; then
    echo "Provide Docker File! ${PARAMETERS}"
    exit
fi

if [ -z "${TAG_WITHOUT_MINOR_VERSION}" ]; then
    echo "Provide full tag without minor version! ${PARAMETERS}"
    exit
fi

if [ "${TEST_BUILD}" = "1" ]; then
    IS_TEST_BUILD="true"
else
    IS_TEST_BUILD="false"
fi

if [ -z "${MINOR_VERSION}" ] && [ "${IS_TEST_BUILD}" = "false" ]; then
    echo "Provide Version! ${PARAMETERS}"
    exit
fi

if [ "${IS_TEST_BUILD}" = "true" ]; then
    TAG="${TAG_WITHOUT_MINOR_VERSION}"
    TAGS="-t ${TAG}"
else
    TAG=${TAG_WITHOUT_MINOR_VERSION}.${MINOR_VERSION}
    LATESTTAG=${TAG_WITHOUT_MINOR_VERSION}.latest
    TAGS="-t ${TAG} -t ${LATESTTAG}"
fi

echo " -> Building image"
echo " -> DOCKER_FILE: ${DOCKER_FILE}"
echo " -> BASE_IMAGE: ${BASE_IMAGE}"
echo " -> TAG_WITHOUT_MINOR_VERSION: ${TAG_WITHOUT_MINOR_VERSION}"
echo " -> MINOR_VERSION: ${MINOR_VERSION}"
echo " -> NO_CACHE: ${NO_CACHE}"
echo " -> TEST_BUILD: ${TEST_BUILD}"
echo " -> IS_TEST_BUILD: ${IS_TEST_BUILD}"
echo " -> TAGS: ${TAGS}"

if [ "${NO_CACHE}" = "1" ]; then
    DOCKER_BUILDKIT=1 docker build \
        --no-cache \
        -f ${DOCKER_FILE} \
        ${TAGS} .
else
    DOCKER_BUILDKIT=1 docker build \
        -f ${DOCKER_FILE} \
        ${TAGS} .
fi

if [ "${IS_TEST_BUILD}" = "true" ]; then
  echo "Pushing tag ${TAG} for testing only"
    docker push ${TAG}
else
  echo "Pushing TAGS ${TAG}, ${LATESTTAG}"
  docker push ${TAG}
  docker push ${LATESTTAG}
fi
