#!/bin/bash
##
## Script for Prepare stage  [BUILD, TEST, TST-DEPLOY]
##

set -Eeo pipefail # (-) is enable (+) is disable

echo "START: Build Script"

# Check global variables or function imported ?
# (or needs a fix | done from ./scripts/env-init.sh)
echo ${HELLO_VARIABLE}
hello_world_function BuildTestSh

echo "~~~ BUILD & TEST SUCCESFULL ~~~"
echo "END  : Build Script"
