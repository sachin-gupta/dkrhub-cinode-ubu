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
echo "COMMIT ID (SHA)  - ${TRAVIS_COMMIT::8}"
echo "COMMIT MESSAGE   - ${TRAVIS_COMMIT_MESSAGE}"
echo "REPO SLUG        - ${TRAVIS_REPO_SLUG}"
echo "BRANCH NAME      - ${TRAVIS_BRANCH}"
echo "TAG NAME         - ${TRAVIS_TAG}"
echo "PULL REQUEST ??  - ${TRAVIS_PULL_REQUEST}"
echo "PULL REQUEST BR. - ${TRAVIS_PULL_REQUEST_BRANCH}"
echo "PULL REQUEST SHA - ${TRAVIS_PULL_REQUEST_SHA}"
