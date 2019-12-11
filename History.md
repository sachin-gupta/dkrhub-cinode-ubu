# 1.0.0 / 2019-12-12

- FIX: Built for `master`, `release/*`, `hotfix/*` and tags only
- Added ubuntu flavors 16.04, 18.04 and 19.04 to travis matrix
- Added `set -Eeo pipefail` to make travis exit on first error
- FIX: /bin/sh: 1: locale-gen: not found by removing locales
- FIX: Encrypted vars not populating by using them from dashboard
- FIX: Replacing `- with _` in BRANCH_SLUG for valid dockerhub tag
- ADD: TravisCI build status tag for master branch into README.md
- FIX: Replaced `/ in branch names with -` for valid dockerhub tag
- ADD: `.travis.yml` for build and upload of image to dockerhub
- ADD: `Dockerfile.template` for build against various travis versions
- ADD: File for containing version of Dockerfile to be bumped on need
- ADD: Dockerfile for Ubuntu v18.04 based build agent with docker & ssh
