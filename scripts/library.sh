#!/bin/bash
##
## Library of exports and functions that can be used anywhere after sourcing the file

# As this file will be sourced maybe in `.travis.yml` we can't use `set -e`
# (Permamently Disabled Next Command)
#set -Eeo pipefail # (-) is enable (+) is disable

# Exporting sample enviornment variable
export HELLO_VARIABLE="! SACn Welcomes You [library.sh]!"

# Exporting sample hello-world function
hello_world() {
    echo "Hello World $1"
}
export -f hello_world
