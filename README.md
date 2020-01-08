# Project

[![Build Status](https://travis-ci.com/sachin-gupta/dkrhub-cinode-ubu.svg?branch=master)](https://travis-ci.com/sachin-gupta/dkrhub-cinode-ubu)

This repository contains code to generate docker image of **Ubuntu with essentials like git, rar etc.** including software like **docker, docker-compose, openssh, etc.**. Primary use is as a build-agent in CI's like Gitlab. Also this project may work as template for Gitflow based continuous deployment using Travis CI and Github.

- Making Tech. Contributions : [CONTRIBUTING.md](CONTRIBUTING.md)
- Licensing for the Project : [LICENSE](LICENSE)
- Travis CI Build Configuration: [.travis.yml](.travis.yml)
- Printing of Travis Env. Vars : [scripts/envinfo.sh](scripts/envinfo.sh)
- History of Changes (Detailed): [History.md](History.md)
- Quick CI Setup & Gitflow Theory : [docs/gitflow-guide.md](docs/gitflow-guide.md)

## Travis Dashboard Variables Required

In order to build the project in Travis CI following envirnment variables to be setup using it's project dashboard

- DKRHUB_USER="Dockerhub username here"
- DKRHUB_PASS="Dockerhub password here"
- DKRHUB_PROJ="Name of dockerhub project"
- DKRHUB_REPO="DKRHUB_USER/DKRHUB_PROJ"
- AUTH_EMAIL="Email of author for notifications"
