#!/bin/bash
##
## Script for printing enviornment information
##

set -Eeo pipefail # (-) is enable (+) is disable

echo "^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^TRAVIS CI ENVIORNMETN VARIABBLES^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^"
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
echo "COMMIT MESSAGE   - ${TRAVIS_COMMIT_MESSAGE::128}"
echo "REPO SLUG        - ${TRAVIS_REPO_SLUG}"
echo "BRANCH NAME      - ${TRAVIS_BRANCH}"
echo "TAG NAME         - ${TRAVIS_TAG}"
echo "PULL REQUEST ??  - ${TRAVIS_PULL_REQUEST}"
echo "PULL REQUEST BR. - ${TRAVIS_PULL_REQUEST_BRANCH}"
echo "PULL REQUEST SHA - ${TRAVIS_PULL_REQUEST_SHA::8}"

# Is this request for branch only (no tags no pull requests)
echo ""
echo "------------------------------------------------------------------------------------------------------"
# Is this a pull-request if so display it's number
export IS_BRA_BLD=0
if [ ${TRAVIS_PULL_REQUEST} != "false" ]
then
    export IS_PR_BLD=1
    echo "@@@ PR-Build# Yes, this build is for Pull-Request# ${TRAVIS_PULL_REQUEST}"
    echo "            # PR SOURCE: ${TRAVIS_PULL_REQUEST_BRANCH}, ${TRAVIS_PULL_REQUEST_SHA::8}"
    echo "            # PR TARGET: ${TRAVIS_BRANCH}"
    echo "            # PR MESAGE: ${TRAVIS_COMMIT_MESSAGE}"
else
    export IS_PR_BLD=0
    echo "@@@ PR-Build# No, this build is NOT for Pull-Request"

    # Is this build for tag only (tag is set but no pull request)
    if [ ${TRAVIS_TAG} != "" ] ]
    then
        export IS_TAG_BLD=1
        echo "@@@ Tag-Build# Yes, this build is for Tag# ${TRAVIS_TAG} on Branch# ${TRAVIS_BRANCH}"
        export IS_BRA_BLD=0
        echo "@@@ Branch-Build# No, this build is NOT for Branch"
    else
        export IS_TAG_BLD=0
        echo "@@@ Tag-Build# No, this is NOT for Tag"
        export IS_BRA_BLD=1
        echo "@@@ Tag-Build# Yes, this build is for Branch# ${TRAVIS_BRANCH}"
    fi
fi

# Exporting hello-world function
hello_world() {
    echo "Hello World"
}
export -f hello_world

# Exporting dummy env. variable
export ENV_LOADED=1

echo "------------------------------------------------------------------------------------------------------"
