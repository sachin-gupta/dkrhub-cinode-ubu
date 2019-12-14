# 0.0.0 / 2019-12-13

Added code to generate docker image of **Ubuntu with essentials like git, rar etc.** including software like **docker, docker-compose, openssh, etc.**. Primary use is as a build-agent in CI's like Gitlab. Also this project may work as template for Gitflow based continuous deployment using Travis CI and Github.

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
