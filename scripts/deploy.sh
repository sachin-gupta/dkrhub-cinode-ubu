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

#--- DEPLOY STEPS:
# ADD: Add first level TOC to History.md and Releases.md file by script
bash ./scripts/add-toc.sh History.md
bash ./scripts/add-toc.sh Releases.md

# ADD: Git credentials to travis so that we can create tags from script
git config --global user.email "${GIT_USEREMAIL}"
git config --global user.name "${GIT_USERNAME}"

#CASE-1. UnTagged Master         : Deploy to [STAGING]
#   - Use dpl tool to create github release named `STAGING`, note dpl requires tag to be present but master is untagged so
#   - Create (*or update*) tag named `STAGING` on master branch first before using dpl tool
if [[ ${TRAVIS_TAG} == "" ]]
then
    echo "!!! Deploying Branch# ${TRAVIS_BRANCH}"

    # Create (*or update*) tag named `staging` on master branch first before using dpl tool

    echo "~ deleting tags locally and remotely"
    git tag -d STAGING || true
    git push -f https://${DEPLOY_TOKEN}@github.com/${TRAVIS_REPO_SLUG} :STAGING

    echo "~ create tag locally and push remotely"
    git tag -f -a STAGING -m "AUTOTAG: From Branch# ${TRAVIS_BRANCH}"
    git push -f https://${DEPLOY_TOKEN}@github.com/${TRAVIS_REPO_SLUG} STAGING

    # Use dpl tool to create github release named `STAGING` and exit if error
    dpl releases --token ${DEPLOY_TOKEN} --repo ${TRAVIS_REPO_SLUG} --file LICENSE --file Releases.md --file History.md --overwrite --release_notes_file Releases.md --tag_name STAGING --target_commitish ${TRAVIS_COMMIT} --name "Non-Production Staging Build for Branch# ${TRAVIS_BRANCH}"

    DPL_STATUS=$?
    if [[ $DPL_STATUS -ne 0 ]]; then echo "ERR! (Deploy Failed, DPL_STATUS=$DPL_STATUS)" && exit $DPL_STATUS; fi
fi

#CASE-2. Tagged Master (tmp*.*.*): Deploy to [QA]
#   - Use dpl tool to create github release named `tmp*.*.*`, this will clutter github dashboard
#   - No need to create (*or update*) tag named `tmp*.*.*`, as user has already tagged manually
if [[ ${TRAVIS_TAG} != "" ]] && [[ ${TRAVIS_TAG} == tmp* ]]; then
    echo "!!! Deploying Temporary Tag# ${TRAVIS_TAG}"

    # Use dpl tool to create github release named `tmp*.*.*` and exit if error
    dpl releases --token ${DEPLOY_TOKEN} --repo ${TRAVIS_REPO_SLUG} --file LICENSE --file Releases.md --file History.md --overwrite --release_notes_file Releases.md --tag_name ${TRAVIS_TAG} --target_commitish ${TRAVIS_COMMIT} --name "Non-Production QA Build for Temporary Tag# ${TRAVIS_TAG}"

    DPL_STATUS=$?
    if [[ $DPL_STATUS -ne 0 ]]; then echo "ERR! (Deploy Failed, DPL_STATUS=$DPL_STATUS)" && exit $DPL_STATUS; fi
fi

#CASE-3. Tagged Master (qa*.*.*) : Deploy to [QA & UAT]
#   - Use dpl tool to create github release named `qa*.*.*`, this will clutter github dashboard
#   - No need to create (*or update*) tag named `qa*.*.*`, as user has already tagged manually
if [[ ${TRAVIS_TAG} != "" ]] && [[ ${TRAVIS_TAG} == qa* ]]; then
    echo "!!! Deploying Quality Tag# ${TRAVIS_TAG}"

    # Use dpl tool to create github release named `qa*.*.*` and exit if error
    dpl releases --token ${DEPLOY_TOKEN} --repo ${TRAVIS_REPO_SLUG} --file LICENSE --file Releases.md --file History.md --overwrite --release_notes_file Releases.md --tag_name ${TRAVIS_TAG} --target_commitish ${TRAVIS_COMMIT} --name "Non-Production QA+UAT Build for Quality Tag# ${TRAVIS_TAG}"

    DPL_STATUS=$?
    if [[ $DPL_STATUS -ne 0 ]]; then echo "ERR! (Deploy Failed, DPL_STATUS=$DPL_STATUS)" && exit $DPL_STATUS; fi
fi

#CASE-4. Tagged Master (v*.*.*)  : Deploy to [QA, UAT & PROD]
#   - Use dpl tool to create github release named `v*.*.*`, this will clutter github dashboard
#   - No need to create (*or update*) tag named `v*.*.*`, as user has already tagged manually
if [[ ${TRAVIS_TAG} != "" ]] && [[ ${TRAVIS_TAG} == v* ]]; then
    echo "!!! Deploying Release Tag# ${TRAVIS_TAG}"

    # Use dpl tool to create github release named `v*.*.*` and exit if error
    dpl releases --token ${DEPLOY_TOKEN} --repo ${TRAVIS_REPO_SLUG} --file LICENSE --file Releases.md --file History.md --overwrite --release_notes_file Releases.md ${TRAVIS_TAG}." --tag_name ${TRAVIS_TAG} --target_commitish ${TRAVIS_COMMIT} --name "Release#${TRAVIS_TAG}: Production QA+UAT+PROD Build for Release Tag#

    export DPL_STATUS=$?
    if [[ $DPL_STATUS -ne 0 ]]; then echo "ERR! (Deploy Failed, DPL_STATUS=$DPL_STATUS)" && exit $DPL_STATUS; fi
fi

echo "END  : Deploy Script"
