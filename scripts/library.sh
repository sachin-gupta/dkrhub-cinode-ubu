#!/bin/bash
##
## Library of exports and functions that can be used anywhere after sourcing the file

# Exporting sample enviornment variable
export HELLO_VARIBLE="! SACn Welcomes You [SharedEnvVar]!"

# Exporting sample hello-world function
hello_world() {
    echo "Hello World"
}
export -f hello_world
