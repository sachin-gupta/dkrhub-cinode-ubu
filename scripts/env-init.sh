#!/bin/bash
##
## 1. This file is used to export enviornment variables not present in travis dashboard
## - Must not have any secrets, better put them on travis dashbord or in .travi.yml using `travis encrypt`
## - Advantage is that file remains in source control and can be used with any CI wihtout dashboard
## - Just putting variables used in current travis dashboard for help (as comments)
## - Advantage of putting them outside on dashbords is that your actual code can remain open source
##   without you loosing your passwords
## - If you don't use export variables like `VAR=VALUE`, variables becomes local and lost once script
##   caller is returned (Yuk)
##
## 2. This file also export a sample hello_world() method to let you know that things are working

# Travis Dashboard Variables: F
# export DKRHUB_USER="Dockerhub username here"
# export DKRHUB_PASS="Dockerhub password here"
# export DKRHUB_PROJ="Name of dockerhub project"
# export DKRHUB_REPO="${DKRHUB_USER}/${DKRHUB_PROJ}""
# export AUTH_EMAIL="Email of author for notifications"


#!/bin/bash
##
## Script for Export Enviorment Variables & Functions
##

set -Eeo pipefail # (-) is enable (+) is disable

echo "START: Enviorment Initialization Script"

export HELLO_VARIABLE="! SACn Welcomes You [EnvVar]!"

hello_world_function() {
    echo "! $1 Welcomes You [SharedFn]!"
}

echo "END  : Enviorment Initialization Script"
