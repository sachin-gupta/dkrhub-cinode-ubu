# 1.0.2 / 2019-12-12

- FIX: Skip dockerhub image pushes for non-master branches

# 1.0.1 / 2019-12-12

- FIX: Built for `master`, `release/*` and not tags and hotfixes
  - Idea is convert `feature/*` to `release/<semver>` then once
    build succeeds put-up pull request to master
  - When pull-request of `release/<semver>` is merged as it's
    built successfully master will rebuild and deploy to staging
  - Now you can tag `feature/*` id deploy success or `hotfix/*`
    `release to master` if it fails
  - Tags will not be built to avoid third time build of same code.

# 1.0.0 / 2019-12-12

- FIX: Replace all /, - and . with \_ in `${TRAVIS_BRANCH}` for
  dockerhub tag slug.
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
