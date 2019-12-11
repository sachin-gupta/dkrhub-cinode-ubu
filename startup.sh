#!/bin/bash

# Exit on first error, don't continure
set -Ee

# Welcome messge showing version of image
echo "!! BUILD AGENT: ${IMG_NAME}, v{IMG_VER} by ${IMG_AUTH} !!"

# Displaying complete deatils of OS (build env)
echo "Build Agent OS Info:"
neofetch

# Displaying versions of installed software
echo "Installed Docker Versions:"
docker --version
docker-compose --version

# Don't terminate keep running, other need work
tail -f /dev/null
