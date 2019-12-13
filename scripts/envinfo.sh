#!/bin/bash
##
## Script for printing enviornemtn information
##

set -Eeo pipefail # (-) is enable (+) is disable

echo "^^^ Travis CI Enviornament Variables ^^^"
echo ""
echo "BUILD ID   - ${TRAVIS_BUILD_ID}"
echo "BUILD NO   - ${TRAVIS_BUILD_NUMBER}"
echo "STAGE NAME - ${TRAVIS_BUILD_STAGE_NAME}"

echo ""
echo "JOB NAME - ${TRAVIS_JOB_NAME}"
echo "JOB NO   - ${TRAVIS_JOB_NUMBER}"
echo "JOB ID   - ${TRAVIS_JOB_ID}"

echo ""
echo "USER      - ${USER}"
echo "HOME      - ${HOME}"
echo "CURR DIR  - ${PWD}"
echo "BUILD DIR - ${TRAVIS_BUILD_DIR}"
echo "SUDO      - ${TRAVIS_SUDO}"

echo ""
export COMMIT_MESSAGE=${TRAVIS_COMMIT_MESSAGE::128}
echo "COMMIT ID (SHA)  - ${TRAVIS_COMMIT::8}"
echo "COMMIT MESSAGE   - ${COMMIT_MESSAGE}"
echo "REPO SLUG        - ${TRAVIS_REPO_SLUG}"
echo "BRANCH NAME      - ${TRAVIS_BRANCH}"
echo "TAG NAME         - ${TRAVIS_TAG}"
echo "PULL REQUEST ??  - ${TRAVIS_PULL_REQUEST}"
echo "PULL REQUEST BR. - ${TRAVIS_PULL_REQUEST_BRANCH}"
echo "PULL REQUEST SHA - ${TRAVIS_PULL_REQUEST_SHA::8}"

# Is this request for branch only (no tags no pull requests)
echo ""
echo "------------------------------------------------------------------------------------------------------"
if [ ${TRAVIS_TAG} == "" ] && [ ${TRAVIS_PULL_REQUEST} == "false" ]
then
    export IS_BRA_BLD=1
    echo "@@@ Branch-Build# Yes, this is pure branch build (not for tag or pull-request)"
else
    export IS_BRA_BLD=0
    echo "@@@ Branch-Build# No, this is not a pure branch (could be for a tag or pull-request)"
fi

# Is this build for tag only (tag is set but no pull request)
if [ ${TRAVIS_TAG} != "" ] && [ ${TRAVIS_PULL_REQUEST} == "false" ]
then
    export IS_TAG_BLD=1
    echo "@@@ Tag-Build# Yes, this is pure tag build (not for branch or pull-request)"
else
    export IS_TAG_BLD=0
    echo "@@@ Tag-Build# No, this is not a pure tag build (could be for a branch or pull-request)"
fi

# Is this a pull-request if so display it's number
if [ ${TRAVIS_PULL_REQUEST} == "false" ]]
then
    export IS_PR_BLD=0
    echo "@@@ PR-Build# This build is not for Pull-Request";
else
    export IS_PR_BLD=1
    echo "@@@ PR-Build# This build is for Pull-Request no ${TRAVIS_PULL_REQUEST}"
    echo "            # PR SOURCE: ${TRAVIS_PULL_REQUEST_BRANCH}, ${TRAVIS_PULL_REQUEST_SHA::8}"
    echo "            # PR TARGET: ${TRAVIS_BRANCH}"
    echo "            # PR MESAGE: ${COMMIT_MESSAGE}"
fi
echo "------------------------------------------------------------------------------------------------------"
