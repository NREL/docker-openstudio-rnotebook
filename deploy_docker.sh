#!/usr/bin/env bash

IMAGETAG=skip
if [ "${TRAVIS_BRANCH}" == "develop" ]; then
    IMAGETAG=develop
elif [ "${TRAVIS_BRANCH}" == "master" ]; then
    VERSION=$( docker run -it openstudio-rnotebook:latest  R --version | grep -o '[0-99][.][0-99][.][0-99]' | tr -d '' )
    OUT=$?

    # Extended version (independent of $OUT)
    VERSION_EXT=$( docker run -it openstudio-rnotebook:latest Rscript version.R | grep -o '".*"' | tr -d '"' )

    if [ $OUT -eq 0 ]; then
        # strip off the \r that is in the result of the docker run command
        IMAGETAG=$( echo $VERSION | tr -d '\r' )$VERSION_EXT
        echo "Found Version: $IMAGETAG"
    else
        echo "ERROR Trying to find Version"
        IMAGETAG=skip
    fi
fi

if [ "${IMAGETAG}" != "skip" ] && [ "${TRAVIS_PULL_REQUEST}" == "false" ]; then
    echo "Tagging image as $IMAGETAG"

    docker login -u $DOCKER_USER -p $DOCKER_PASS
    docker build -f Dockerfile -t nrel/openstudio-rnotebook:$IMAGETAG -t nrel/openstudio-rnotebook:latest .
    docker push nrel/openstudio-rnotebook:$IMAGETAG
    docker push nrel/openstudio-rnotebook:latest
else
    echo "Not on a deployable branch, this is a pull request or has been explicity skipped"
fi
