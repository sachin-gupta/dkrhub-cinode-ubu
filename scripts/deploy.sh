#!/bin/bash
##
## Script for Deploy stage [TEST, DEPLOY & VERIFY]
##

set -Eeo pipefail # (-) is enable (+) is disable

echo "START: Deploy Script"

# Check global variables or function imported ?
# (or needs a fix | done from ./scripts/env-init.sh)
echo ${HELLO_VARIABLE}
hello_world_function DeploySh

echo "~~~ TEST, DEPLOY & VERIFY SUCCESFULL ~~~"
echo "END  : Deploy Script"
