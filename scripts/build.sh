#!/bin/bash
##
## Script for Prepare stage  [LINT, BUILD, GENERATE, TEST]
##

set -Eeo pipefail # (-) is enable (+) is disable

echo "START: Build Script"

# Sourcing & testing global library functions
chmod 755 ./scripts/library.sh
source ./scripts/library.sh
echo "HELLO_VARIBLE: ${HELLO_VARIBLE}"
hello_world BuildSh

#--- STEPS
echo "Not doing anything just like that"

echo "~~~ BUILD & TEST SUCCESFULL ~~~"
echo "END  : Build Script"
