# Project

This repository contains code to generate small docker image of **++Ubuntu with essentials docker, docker-compose, openssh, git etc.++** that can be used as build-agent in CI's like Gitlab.

- On ubuntu, one can run familiar `apt-get` commands to install special build, test or deploy tools. It's much easier as ubuntu is much too popular.
- With inclusion of `docker` in this image one can run any external docker image to link, build, test, or deploy their application source code. Including docker have following merits:
  - It saves tremendous effort from installing tools in `build-agent`. Why install jekyll on build agent ?, call it using docker to compile.
  - It helps in isolating required libraries, build-tools, test-tools, & deploy-tools as external docker images - Excellent DEVOPs practice.
- With inclusion of `openssh-client` and `git` when using this project's docker image one will be able to checkout private repositories from Gitlab, Github etc. on build-agent. Who knows it is required to install a special tool via `git clone ... && ./folder/install.sh`

> Keep looking here for inclusion of other stuff in this docker image. A quick read to `Background` will be fun :smiley:.

# Inclusions

Ubuntu with following:

- apt-transport-https, ca-certificates, software-properties-common
- openssl, openssh-client, openssh-server
- curl, wget, rar, unrar, p7zip-full, p7zip-rar
- git, subversion, gnupg-agent, neofetch
- asciinema, neofetch, nano, mc
- docker-ce, docker-compose

This image runs SSHd server on launch and integrated with SSH Keys, very good if you want to remote login when running directly using `docker run ..` (_not as build-agent_). You've to forward SSH port 22 to host pc's port while using `docker run` and then use ssh command at host address (_ip or fqdn_) to connect to ssh like `ssh root@my-docker-host.com`.

# Background

Any CI Server will execute user configured tasks to `build`, `test` & `deploy` applications on it's multiple build-agents. These build-agents will run commands as per user (_defined against jobs in stages in yml configuration of CI_) on it's operating system to give results: That is built, tested & deployed source code. Obviously, capabilities of a build agent can restrict what you can do or not. Let's say a docker image `ruby:latest` when launched as `build-agent` will not be able to build a **++python code++**. Thus -

> build-agent features restricts on what you can build, test or deploy on the agent

Generally, everybody wants build-agent to be a `docker-container` so that it gives same execution results overtime. It's required and good DEVOPs practice. Lets, say if using physical `windows install` as a remote `gitlab-runner` then after **Windows Update**, GitlabCI's built job in `.gitlab-ci.yml` may go haywire as agent execution enviornment is modified. Thus -

> build-agents are best suited as docker containers for zero-parity in build, test & deploy

Generally `CI Engines` like [travis](https://travis-ci.com/), or (appveyor)[https://www.appveyor.com/] provides with _selectable & static_ container images on which your build commands & invoked scripts (_as configured in yml file_) will be executed. This [url](https://docs.travis-ci.com/user/reference/linux/) at TraviCI lets shows that right now TraviCI won't provide `Alpine Linux` for use as `build-agent`. How one gets affected ?, lets see:

- If your build, build-commands or build scripts (.sh files) are for Alpine Linux. You've no other option then launching an alpine container from inside `Travis Build-Agent (Ubuntu v18.04)` and pass the code to be build. Yes, its possible but a lot of fuss. If `Travis Build-Agent (Ubuntu v18.04)` does not have docker installed (_inability to launch alpine helper container_):
  - You'll need install docker in `pre-build` stage in CI yml configuration file on your own. This could be tough or one is not aware of how to do it. It's a show-blocker.
  - Every-time installing `docker` or any other specific requirement in pre-build will increase build time to lot. And you've to put manually in all projects.

> CI Engines allowing any docker image as build-agent, instead of selectable-only desired

! **++GitlabCI++** is one that `CI Engine`, where you define `image: xyz:latest` in top of `.gitlab-ci.yml` and gitlab's runner will execute build, test and deploy commands inside a container launched from `image: xyz:latest` image pulled from dockerhub. Thus you can have an `Custom Alpine with Docker` image used as build-agent in GitlabCI where your build scripts in `.gitlab-ci.yml` will directly execute in `Custom Alpine with Docker` image.

> Allowing any docker-image as "ci agent" or "ci node", brings zero-parity in app production

So, One can use a custom image for specific build jobs across organization loaded with desired tools.

> Your build-agent, Your world, You Rule !!!
