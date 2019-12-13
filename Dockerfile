# Base image for docker image genration
FROM ubuntu:18.04 AS sacn-ubuntu-build-agent

# Labelling of the image (author, version)
LABEL maintainer="SACn <no-reply@unknown.com>"
ENV IMG_AUTH="SACn <no-reply@unknown.com>"
LABEL name="sacn-ubuntu-build-agent"
ENV IMG_NAME "sacn-ubuntu-build-agent"
LABEL version="0.0.0"
ENV IMG_VER="0.0.0"

# Set packages install in noninteractive mode.
ENV DEBIAN_FRONTEND noninteractive
RUN export DEBIAN_FRONTEND=noninteractive

# --------------- Launch Startup Script ---------------
# Using `docker run --ti` you can see the output log of script
#
COPY startup.sh /startup.sh
RUN chmod 755 /startup.sh
CMD [ "/bin/bash", "-c", "/startup.sh" ]
