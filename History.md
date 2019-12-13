# 0.0.0 / 2019-12-13

Generates dockerhub image tags for build environment [sacn-ubuntu-build-agent](https://hub.docker.com/repository/docker/sachingpta/sacn-ubuntu-build-agent). This flavor generates only Ubuntu 18.04 with essentials like git. rar as wel as `docker`, `docker-compose`, & `SSH Client + Server`. Credentials of generated code will be `root:root` and `sshuser:sshuser`.

List of main development work (additions, fixes etc.) are as follows:

- MOD: History.md for upcoming Release-0.0.0
- ADD: `.travis.yml` for single stage build+deploy by travis on dockerhub
- ADD: TravisCI build tag for master branch added into README.md for visuals
- ADD: File for containing version of Dockerfile for maintaining image version.
- ADD: .gitignore for excluding windows, vscode and linux garbage
- ADD: Basic Ubuntu v18.08 Build Agent w/ Essentials, Docker, Compose, SSH Client + Server
