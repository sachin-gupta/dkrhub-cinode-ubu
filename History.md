# 0.0.0 / 2019-12-13

Added code to generate docker image of **Ubuntu with essentials like git, rar etc.** including software like **docker, docker-compose, openssh, etc.**. Primary use is as a build-agent in CI's like Gitlab. Also this project may work as template for Gitflow based continuous deployment using Travis CI and Github. Revision 0.0.0 is an alpha, here no output will be generated. This is just to test iff Travis CI workflow with Gitlab is setup correctly or not as per: [docs/build-table.md](docs/build-table.md)

- ADD: File where file based environment variables can be placed for `source ./scripts/env-init.sh`
- FIX: As per common build errors in travis [my build fails unexpectedly](https://docs.travis-ci.com/user/common-build-problems/#my-build-fails-unexpectedly)
  - We can't use `set -e` either directly in your `.travis.yml`, or `sourceing` a script
  - Thus we've removed line `set -Eeo pipefail # (-) is enable (+) is disable`
  - Note that using set -e in external scripts does not cause this problem
  - Thus keeping line in `build.sh`, `deploy.sh`, but not in `library.sh` as this could be sources anywhere
- 000: Created basic 2 stage `.travis.yml` to simulate prepare and deploy.
  - This is a good starting point for first alpha release `0.0.0`
  - In `0.0.0` nothing will be built or deployed, just to test CI cycle
- MOV: Moved export of SHARED variables and functions from `envinfo.sh` to `library.sh`
- ADD: `docs/gitflow-guide.md` file for theory on Gitflow with `Quick CI Setup Checklist`
- MOD: `.travis.yml` with `os: linux`, `sudo: required`, `language: c` to make cfg complete
- MOD: `.travis.yml` with comments for env var needed in Travis Dashboard to run Project.
- MOD: README.md modified with quick links to important files like `.travis.yml`
- FTR: Added markdown in README.md for Travis build status of master branch on Github project
- FTR: Send email notifications to travis env var# `${AUTH_EMAIL}` in travis configuration
- FTR: Travis build-configuration conditions for Gtiflow model wrt simple 2 stage deployment
- ADD: Made History.md using `git changelog` and edited with details about next 0.0.0 version
- MOD: Description of project in README.md for next Alpha Version (0.0.0)
- ADD: Basic 2 stage travis configuration (.travis.yml) to print env vars using BASH script
- ADD: BASH script to print travis environment variables & export dummy data
- ADD: Vanilla ubuntu:1804 based docker image with `Hello World`
- ADD: CONTRIBUTING.md file for contributions making process for this repository.
- ADD: .gitignore file for arresting commit of windows, vscode and linux trash to git repo.
