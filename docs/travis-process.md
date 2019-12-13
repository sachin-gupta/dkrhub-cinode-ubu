# Gitflow:= Travis +Gitlab

Here presents a short summary about concepts and choices for achieving pull-request based Gtifow development using Travis and Github. Concepts here will help one understand and setup CI for gitflow development strategy with minimal build loads on CI Server (`builds-minmization`)

**Table Of Contents:**

[TOC]

## Quick Reference List

Same can be applied to any CI system apart from Travis, However - way to apply may change. For example Gitlab CI may not have these settings in dashboard and you've to find a workaround.

- Setup CI settings in dashboard for:
  - `Build Pushed Branches: Yes` and as per overriding conditions in `.travis.yml`
  - `Build Pull-Requests: Yes` and as per overriding conditions in `.travis.yml`
  - `Auto-Cancel Queued Builds: Yes` to reduce number of builds on build server
  - `Auto-Cancel Pull-request Builds: No` to keep old PRs active with no need to `Re-PR`
- Setup CI for automatic build of PRs as:
  - `merge-builds` for `OPENED` PRs excluding: `DRAFT` & `CLOSED`
  - `merge-builds` for `New Commits on OPENED PRs` only.
- Setup to skip any commit with message having `[skip travis] ...`
- Setup desired custom build conditions based on
  - `$TRAVIS_BRANCH`: name of the branch
  - `$TRAVIS_TAG`: name of the tag otherwise blank
  - `$TRAVIS_PULL_REQUEST`: true or false
- Setup bash script for proper error throwing:
  - With suitable options from: `set Eeuox pipefail` with `set +` or `set -`
  - Capture exit status anytime using `EXIT_STAT=$?` after a command
  - Test exit status for actions `if [[ $EXIT_STAT != 0 ]]; then echo "Error ..." && exit $EXIT_STAT; fi`
  - Simply exit using `exit $EXIT_STAT` or `exit -100` as per liking
- For environment variables or variables use `export VAR=value` otherwise they become local variable to the .sh script and will not be transferred to CI process
- To export functions globally use `export -f docker_build_push()` syntax
- A generic Gitflow table to setup builds, tests and deployments follows:

| Type   | REFs                 | Build | Test |  Review   | Staging<sup>4</sup> | QA<sup>5</sup> | UAT, PROD | Remarks                |
| :----- | :------------------- | :---: | :--: | :-------: | :-----------------: | :------------: | :-------: | :--------------------- |
| Branch | master               |  yes  | yes  |    no     |      auto-inst      |       no       |    no     | <sup>1</sup>           |
| Tag    | tag (v\*) [master]   |   -   |  -   |    no     |          -          |    man-inst    | man-inst  | <sup>2</sup>           |
| Branch | hotfix/\*            |  yes  | yes  | auto-inst |         no          |       no       | man-inst  | <sup>3</sup>, Raise PR |
| Branch | bugfix/\*            |  yes  | yes  | auto-inst |         no          |       no       |    no     | Raise PR               |
| Branch | release/\*           |  yes  | yes  |    no     |         no          |       no       |    no     | Raise PR               |
| Branch | features/\*          |  no   |  no  |    no     |         no          |       no       |    no     | PR Not Allowed         |
| Branch | builds/\*            |  yes  |  no  |    no     |         no          |       no       |    no     | PR Not Allowed         |
| Branch | tests/\*             |  yes  | yes  |    no     |         no          |       no       |    no     | PR Not Allowed         |
| Branch | topic/\*             |  yes  | yes  |    yes    |         no          |       no       |    no     | PR Not Allowed         |
| Pull   | pull-requests        |  yes  | yes  |    no     |         no          |       no       |    no     | Don't Approve Failed   |
| Tag    | tag (tmp\*) [master] |   -   |  -   |    no     |          -          |    man-inst    |    no     | <sup>2</sup>           |
| Tag    | tag (\*)             |  no   |  no  |    no     |         no          |       no       |    no     | no                     |

1. Master must be built and tested to ensure it's always deployable as per Gitflow. Moreover ONLY master commits can be deployed apart from it's `v*.*.*` tags (automatically up to staging and rest manual). Inclusion of master commit deployment also makes manager happy.

2. Master tags (v\*) are placed to start promote to QA onwards, and should not be built (they should use earlier artifact id re-deployed, otherwise tags have artifact when you tag master SHA to promote it from staging to quality.

   - Master tags (tmp* or qa*) are not for clients but maybe needed by managers for say monthly internal sub-releases to be deployable on QA again without re-build (as artifact of master is already there)

3. Hotfix can't go full QA thus are risky too, and few people would like you to delay with raising PRs and promoting hotfixes. Hotfixes should not enter staging as auto-installed by master. One can after quick checking hotfix in review deploy it to client UAT then to PROD.

   - If things fail PROD can be rolled back and master is intact. If hotfix succeeds then make next release PR with master (it is not necessary to send this to client) - this can remain on master/staging and await merging by next feature in line on new PR.

   - Hotfix should not go to production area (staging onwards is for master) so it should be deployed to review area before a PR is put-up for master-merge and tagging (promotion to QA/UAT/PROD).

4. Staging ?: Everything from Staging onwards: **_Test with production database copy, against production services, in a isolated-production (*or non-production*) environment. This will ensure that your database scripts will not fuss your production database_**

   - Intended for previously defined pilot or internal _in-house users only_
   - Not exposed to full or partial production user groups
   - Automatically deployed from master only using PRs (many times a day) to keep everybody aligned.
   - Typically torn-down or removed after production deployment
   - Sometimes not a complete 1:1with production (_can't replace it _)

5. QA ?: Manager pushes final releases from master after tagging it with next release number like `v*.*.*` as per delivery schedule. Then QA lead needs to approval after full-testing of new features and old-features. Once approved, manager promotes release to client (UAT then PROD). Usually clients are not given access to this as many internal non-delivered items can also being tested by QA like future plan releases.

6. UAT + PROD ?: Actually client access, anything here is considered live and on-prod changes could be occurring that needs to be updated to UAT (on_change immediate)

## Achieving Containerized DEVOPs

Should read [Flawless Releases with Continuous Deployment and Docker](https://hackernoon.com/continuous-deployment-of-a-python-flask-application-with-docker-and-semaphore-b21aq12v1). Why you need this ??

- Consistency : Production and development environments are equal.
- Portability : Fewer dependencies with the underlying OS; the same image can be deployed on any cloud provider.
- Overhead : Better performance than virtual machines, may use alpine on production and ubuntu based docker for dev.
- Divide and conquer: Distribute services among different containers (Micro-services & Scaling)
- Ready Offerings: 100's of ready containerized tools and server (no need to learn install process, tools remains same for all in organization)
- DIY Images: Create own images for dev-envs, libs, compiler / build-tools, test-tools, prod-servers for entire organization or project level (achieving zero parity)

Docker introduces a new variable to the equation: the app must be baked into the container image, then correctly deployed. In addition, setting up a test environment can prove more challenging. In this semaphore, at very high level:

- Continuous Integration: Build and test the app image.
  - Create/update on merge request
    - Build image
    - Push to container registry using commit SHA
    - Run parallel tests
    - Tag image with branch name
  - Push/merge to master
    - Build image (would be great to re-use image if same SHA)
    - Run parallel tests (would be great to skip if same SHA)
    - Tag image with latest (or staging)
    - Deploy to staging
- Continuous Deployment: Send the image to Heroku etc to run online with scaling.
  - Tag
    - Pull image for SHA (would be nice to re-build if needed for some reason)
    - Tag image with new tag
    - Deploy to production

Typical docker based workflow may be devised as, see [kubernetes-example](https://gitlab.com/gitlab-examples/kubernetes-example)

## [Configuring Bash Scripts](https://buildkite.com/docs/pipelines/writing-build-scripts)

Bash scripts may continue on-error which is dangreours when using these `.sh` scripts for build, test or deploy activitie on any CI. When writing Bash shell scripts there are a number of options you can set to help prevent unexpected errors:

| Switch     | Purpose                                                                     | Remarks                                |
| :--------- | :-------------------------------------------------------------------------- | :------------------------------------- |
| e          | Exit script immediately if any command returns a non-zero exit status.      | Without this script continues on error |
| u          | Exit script immediately if an undefined variable is used                    | Sometimes not a liked behavior         |
| o pipefail | Ensure Bash pipelines eturns if any cmd fail instead of last command status | At times required sudo                 |
| x          | Expand and print each command before executing.                             | Rarely required                        |

Thus one may have `set +Eeuox pipefail`, `set +Eeo pipefail`, `set +Ee`, or `set +Eeu` in their bash script to control errors returned.

In next example capturing and returning status of intermediate method using `EXIT_STAT=$?`

```
#!/bin/bash

# Note that we don't enable the 'e' option, which would cause the script to
# immediately exit if 'run_tests' failed
set -uo pipefail

# Run the main command we're most interested in
run_tests

# Capture the exit status
EXIT_STAT=$?

# Run additional commands
clean_up

# Exit with the status of the original command
exit $EXIT_STAT
```

## How Travis & Github Works ?

- Travis builds a PR as soon as it is `OPENED` in `DRAFT` state as `merge-build`
  - It keeps on re-building PRs as `merge-build` if new commits appear for PR fix
  - Thus it's better to allow pull requests from `release/*` to be built
  - User creates `release\*` gets build status and once done ready-to-merge
- After allowing pull request, it may fail in master-merge or built after commit
  - So you should never approve a failing build PR, take master update in PR (fix n commit)
  - If master-merge is failing, you must take master update in `release/*` and fix release PR. Then either create new pull request or send email to admin to push current
  - If master build is failing, somehow one has to notify and wait for revert last commit (no risk as deployments will not be made), or have a hotfix done. !!If master is failing everything is wrong!!

## Pull-Requests (PRs) in Travis

PR builds are an essential part of Gitflow. This is how travis handles them:

### Build Strategy

> - PRs in travis are always built as `merge-builds between source and upstream branch`. This is a good beahaviour.
> - Travis builds PRs on `OPEN` automatically, thus `DRAFT` PRs are also built including `OPENED`. Should change this.
> - Travis automatically merge-build `new commits that are added to PRs`, good for release branch edit till PR succeeds.

### Double Builds

You may've two builds in queue one for `branch-build` and another `merge-build` for PR. I don't see any reason to build branch seperately. Thus we can disable build of `release` branch provided it won't stop build of PRs (_from relese to master_). There is no harm if release branch is built (_releases are not frequent_)

## Travis Dashboard Settings

### Build Pushed Branches

Obviously make this setting yes, everybody wants to buld branches as per strategy like `master`, `release/*`, `hotfix/*`. If ON, builds will be run on branches that are not explicitly excluded in your .travis.yml.

### Build Pull-Requests

If ON, builds will be run on new [pull requests](https://docs.travis-ci.com/user/pull-requests/). This is a desired behaviour for Gitflow.

## Auto-Cancel Queued Builds

Auto-cancel is required if you want travis to build only the latest commit saving resources

### Branch Builds

`Auto Cancel Branch Builds` if ON cancels queued builds for your branch, and appears in the build history. It's good not to build multiple pushes so turn it on.

> Existing builds, if any will be allowed to finish

### Pull-Request Builds

Pull-request automatically builds on-creation as well as on-future-commit a merge of source and target branches in travis.

This cancels queued builds for pull requests (the future merge result of your change/feature branch against its target) and appears in the Pull Requests tab of your repository.

Thus, if this is disabled than travis will build new commits on a pull-request of release/\* branch keeping you updated. So after n-commits on release one can be comfortable to approve it.

If you enable this future-commits of release/\* will not be built and merge-tested. So one will not be confident to merge request or not. In this case you've to create a new pull request to see if new commits are mergeable.

## Skip Build for Any Commit

Commit your code with message as `[skip <keyword>] ...` and travis will not built it. As **<keyword>** avaiable choices are: `ci`, `travis`, `travis ci`, `travis-ci`, or `travisci`.

## Controlling Build Conditions ?

Build conditions are entered in `.travis.yml` file which will be one of the deciding factors in determining that build will proceed or not apart from dashboard settings.

For building conditions in `.travis.yml` two choices can be used: either with `only:/exclude:` based `string/regex` matching or logical `&& / ||` based `if:` conditions

Inside `.travis.yml` these can be applied at 3 levels:

- **File Level:** By using `branches: only:/except:` tag on top of `.travis.yml` conditions are applied to all stages and all jobs.
- **Stage-Level:** Applies to all jobs inside (_jobs are parallel_). Two choices are there use `only:/exclude:` based regex conditions or use `if:` based logical conditions.
- **Job-Level:**`: Applied to specific job, Two choices are there use`only:/exclude:`based regex conditions or use`if:` based logical conditions.

### EX1: Programmatic Exiting Build

```bashh
    - stage: Prepare
      script:
      	- if [ "$TRAVIS_PULL_REQUEST" != "true" ]; then echo 'Not Allowed' && exit -100; fi
      	- echo "Build State Continues ..."
```

### EX2: Using Only or Except

Can use strings and reges

```bash
    - stage: Prepare
      script:
      	- echo "Build State Continues ..."
      only:
        - master
        - /^hotfix*/
        - ^[0-9]+\.[0-9]+\.[0-9]+$
```

## EX3: Using If (Logical Test)

```
    - stage: Deploy
      script:
      	- echo "Build State Continues ..."
      if:
      	- $TRAVIS_TAG =~ ^[0-9]+\.[0-9]+\.[0-9]+$
      	- $TRAVIS_BRANCH =~ ^master|release|hotfix|quality$ || -n $TRAVIS_TAG
      	- [ -n $TRAVIS_TAG ]

```
