#!/bin/bash
##
## Script for Deploy stage [TEST-IMG, TEST-DEPLOY, DEPLOY & VERIFY]
##

set -Eeo pipefail # (-) is enable (+) is disable

echo "START: Deploy Script"

# Sourcing & testing global library functions
chmod 755 ./scripts/library.sh
source ./scripts/library.sh
echo "HELLO_VARIBLE: ${HELLO_VARIBLE}"
hello_world DeploySh

#--- DEPLOY THEORY:
#~~ Quick Recap: Master Branch Builds Deployments ~~
# TAG NAMES   ?  !!ENABLED!!
#   1. Untagged     : master     [--draft]
#   2. Tagged (tmp*): tmp*       [--draft]
#   3. Tagged (qa* ): qa*        [--prerelease]
#   4. Tagged (v*  ): v*, latest [--release]
# ENVIORNMENTS ? !!DISABLED!!
#   1. Untagged     : STAGING
#   2. Tagged (tmp*): QA
#   3. Tagged (qa* ): QA, UAT
#   4. Tagged (v*  ): QA, UAT, PROD

#~~ Quickj Help on DPL Tool Command Line Switches ~~
# dpl releases
#   --token ${DEPLOY_TOKEN}
#   --repo ${TRAVIS_REPO_SLUG}
#   --file GLOB
#   --overwrite
#   --prerelease
#   --draft
#   --release_number NUM
#   --release_notes STR  or --release_notes_file PATH
#   --tag_name TAG
#   --target_commitish STR
#   --name NAME

#--- DEPLOY STEPS:
# ADD: Add first level TOC to History.md and Releases.md file by script
bash ./scripts/add-toc.sh History.md
bash ./scripts/add-toc.sh Releases.md

# CHK: Untagged Master Branch Builds
if [[ ${TRAVIS_TAG} == "" ]]
then
    echo "!!! Deploying Branch# ${TRAVIS_BRANCH}"

    # Call deployment function [Deploy: Publish To Tags] and exit if error
    dpl releases --token ${DEPLOY_TOKEN} --repo ${TRAVIS_REPO_SLUG} --file README.md --file LICENSE --file Releases.md --file History.md --overwrite --draft --release_notes "Non-Production Staging Build for Branch# ${TRAVIS_BRANCH}" --tag_name ${TRAVIS_BRANCH} --target_commitish ${TRAVIS_COMMIT} --name ${TRAVIS_BRANCH}

    DPL_STATUS=$?
    if [[ $DPL_STATUS -ne 0 ]]; then echo "ERR! (Deploy Failed, DPL_STATUS=$DPL_STATUS)" && exit $DPL_STATUS; fi
fi

# CHK: Tagged (tmp*) Master Branch Builds
if [[ ${TRAVIS_TAG} != "" ]] && [[ ${TRAVIS_TAG} == tmp* ]]; then
    echo "!!! Deploying Temporary Tag# ${TRAVIS_TAG}"

    # Call deployment function [Deploy: Publish To Tags] and exit if error
    dpl releases --token ${DEPLOY_TOKEN} --repo ${TRAVIS_REPO_SLUG} --file README.md --file LICENSE --file Releases.md --file History.md --overwrite --draft --release_notes "Non-Production QA Build for Temporary Tag# ${TRAVIS_TAG}" --tag_name ${TRAVIS_TAG} --target_commitish ${TRAVIS_COMMIT} --name ${TRAVIS_TAG}

    DPL_STATUS=$?
    if [[ $DPL_STATUS -ne 0 ]]; then echo "ERR! (Deploy Failed, DPL_STATUS=$DPL_STATUS)" && exit $DPL_STATUS; fi
fi

# CHK: Tagged (qa*) Master Branch Builds
if [[ ${TRAVIS_TAG} != "" ]] && [[ ${TRAVIS_TAG} == qa* ]]; then
    echo "!!! Deploying Quality Tag# ${TRAVIS_TAG}"

    # Call deployment function [Deploy: Publish To Tags] and exit if error
    dpl releases --token ${DEPLOY_TOKEN} --repo ${TRAVIS_REPO_SLUG} --file README.md --file LICENSE --file Releases.md --file History.md --overwrite --prerelease --release_notes "Non-Production QA+UAT Build for Quality Tag# ${TRAVIS_TAG}" --tag_name ${TRAVIS_TAG} --target_commitish ${TRAVIS_COMMIT} --name ${TRAVIS_TAG}

    DPL_STATUS=$?
    if [[ $DPL_STATUS -ne 0 ]]; then echo "ERR! (Deploy Failed, DPL_STATUS=$DPL_STATUS)" && exit $DPL_STATUS; fi
fi

# CHK: Tagged (v*) Master Branch Builds
if [[ ${TRAVIS_TAG} != "" ]] && [[ ${TRAVIS_TAG} == v* ]]; then
    echo "!!! Deploying Release Tag# ${TRAVIS_TAG}"

    # Call deployment function [Deploy: Publish To Tags] and exit if error
    dpl releases --token ${DEPLOY_TOKEN} --repo ${TRAVIS_REPO_SLUG} --file README.md --file LICENSE --file Releases.md --file History.md --overwrite --release_notes "Release#${TRAVIS_TAG}: Production QA+UAT+PROD Build for Release Tag# ${TRAVIS_TAG}. See attachment `Releases.md` for details." --tag_name ${TRAVIS_TAG} --target_commitish ${TRAVIS_COMMIT} --name ${TRAVIS_TAG}

    export DPL_STATUS=$?
    if [[ $DPL_STATUS -ne 0 ]]; then echo "ERR! (Deploy Failed, DPL_STATUS=$DPL_STATUS)" && exit $DPL_STATUS; fi
fi

echo "END  : Deploy Script"
