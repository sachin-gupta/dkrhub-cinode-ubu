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

echo "END  : Deploy Script"

# Exporting function execution result to fnresult.txt (Unfortunately using EXIT_CODE=$? always makes EXIT_CODE=1
# when returing to .travis.yml thus "if [[ $EXIT_CODE -ne 0 ]]; then set +e && exit $EXIT_CODE; fi" command fails)
echo "export EXIT_CODE=$?" > fnresult.txt
