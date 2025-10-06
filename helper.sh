#!/bin/bash

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
    MINOR_VERSION=$1
    VERSION_FILE=$2

    # if no version is provided then read from version file is possible
    if [[ -z "${MINOR_VERSION}" && -f ${VERSION_FILE} ]]; then
        #Read last used version from file and increment
        MINOR_VERSION=$(($(cat ${VERSION_FILE})+1))
    fi

    # if version is empty, then echo error
    if [ -z "${MINOR_VERSION}" ]; then
        echo "No version provided and no version file found!"
        exit
    fi

    # return version
    echo "${MINOR_VERSION}"
}

