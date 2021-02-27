#!/bin/bash
##
## Script for Deploy stage [TEST-IMG, TEST-DEPLOY, DEPLOY & VERIFY]
##

set -Eeo pipefail # (-) is enable (+) is disable

echo "START: Deploy Script"

# Sourcing & testing global library functions
chmod 755 ./scripts/library.sh
source ./scripts/library.sh
echo "HELLO_VARIBLE: ${HELLO_VARIBLE}"
hello_world DeploySh

#--- STEPS
echo "Not doing anything just like that"

echo "~~~ TEST, DEPLOY & VERIFY SUCCESFULL ~~~"
echo "END  : Deploy Script"
