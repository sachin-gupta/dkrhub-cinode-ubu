# 0.0.0 / 2019-12-13

Generates dockerhub image tags for build environment [sacn-ubuntu-build-agent](https://hub.docker.com/repository/docker/sachingpta/sacn-ubuntu-build-agent). This flavor generates only Ubuntu 18.04 with essentials like git. rar as wel as `docker`, `docker-compose`, & `SSH Client + Server`. Credentials of generated code will be `root:root` and `sshuser:sshuser`.

List of main development work (additions, fixes etc.) are as follows:

- PR#6
  - FIX: Build error - "cannot open 'Dockerfile.18.04' for reading: No such file or directory"
    - Mistakenly generated `Dockerfile` instead of `Dockerfile.${UBUNTU_VER}`
  - FIX: Build error - "/bin/sh: 1: locale-gen: not found"
    - Removed locale generation code from Dockerfile (not imp)
  - FTR: Added code to print environment information for easy debug on travis (printed on build agent)
  - FTR: Enhanced printing of build information (what is built: branch, tag or pull-request)
    - Also computed environment variables `IS_BRA_BLD`, `IS_TAG_BLD`, & `IS_PR_BLD`
  - FIX: Deploy should only occur to master and it's tag and not to pull-requests
    - Fixed checks in `.travis.yml` for suitable exit conditions
      - RULE Added: Pull Requests Deploys (Not Allowed)
      - RULE Added: Non Master Branch Deploys (Not Allowed)
      - RULE Added: Tags for Non Master Branch Deploys (Not Allowed)
- MOD: History.md for upcoming Release-0.0.0
- ADD: `.travis.yml` for single stage build+deploy by travis on dockerhub
- ADD: TravisCI build tag for master branch added into README.md for visuals
- ADD: File for containing version of Dockerfile for maintaining image version.
- ADD: .gitignore for excluding windows, vscode and linux garbage
- ADD: Basic Ubuntu v18.08 Build Agent w/ Essentials, Docker, Compose, SSH Client + Server
