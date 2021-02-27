#!/bin/bash

# Set bash parameters: Exit on first error, etc.
set -Eeo pipefail # (-) is enable (+) is disable

# Welcome messge to be printed in the terminal.
echo "!! Hello World !!"

# Loop to make sure that container keeps running.
tail -f /dev/null
