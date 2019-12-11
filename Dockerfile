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

# Setting for building image (passwords etc.)
ARG ROOT_PASS="root"
ARG SSH_USER="sshuser"
ARG SSH_PASS="sshuser"
ARG ADMIN_EMAIL="no-reply@unknown.com"

# Update repository source for package install.
RUN apt-get update -y

# Setup en_US.UTF-8 locale and verify
RUN locale-gen en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

# --------------- Install must've packages for build-agent ---------------
RUN apt-get install -y \
    apt-transport-https \
    ca-certificates \
    software-properties-common \
    curl \
    wget \
    openssl \
    gnupg-agent \
    git \
    subversion \
    rar \
    unrar \
    p7zip-full \
    p7zip-rar \
    neofetch \
    asciinema \
    nano \
    mc \
    --no-install-recommends

# Configure root password as root
RUN echo "root:${ROOT_PASS}" | chpasswd

# --------------- Add OpenSSH Software (Server & Client) ---------------
# Install OpenSSH Packages (Server & Client)
RUN apt-get install -y \
    openssh-server \
    openssh-client \
    --no-install-recommends

# Generate Host SSH Keys (SSHd won't use these)
RUN mkdir -p ~/.ssh && \
    chmod 700 ~/.ssh && \
    yes | ssh-keygen -q -N "${SSH_PASS}" -C "${ADMIN_EMAIL}" -t rsa -b 4096 -f ~/.ssh/id_rsa && \
    chmod 600 ~/.ssh/id_rsa && \
    chmod 644 ~/.ssh/id_rsa.pub && \
    ls -al ~/.ssh

# Create standard directory for SSHd Server
RUN mkdir /var/run/sshd

# Create linux user remote SSH terminal use
RUN useradd -ms /bin/bash ${SSH_USER} && \
    echo "${SSH_USER}:${SSH_PASS}" |chpasswd

# Transfer strict configuration for SSHd
COPY sshd_config /etc/ssh/sshd_config

# Force enable login of root user in /etc/ssh/sshd_config
RUN sed -ri 's/^#?PermitRootLogin\s+.*/PermitRootLogin yes/' /etc/ssh/sshd_config
RUN sed -ri 's/^PermitRootLogin\s+.*/PermitRootLogin yes/' /etc/ssh/sshd_config

#Force disable PAM authentication (hinders with ssh working)
RUN sed -ri 's/^#?UsePAM\s+.*/UsePAM no/' /etc/ssh/sshd_config
RUN sed -ri 's/^UsePAM\s+.*/UsePAM no/' /etc/ssh/sshd_config

# SSH login fix. Otherwise user is kicked off after login
# [Not Used, Recommedned @Docker]
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd
ENV NOTVISIBLE "in users profile"
RUN echo "export VISIBLE=now" >> /etc/profile

# Secure SSH Confugration [/etc/ssh/sshd_config]
RUN chmod 644 /etc/ssh/sshd_config

# Expose SSH Port (22) for remote SSH Access by parties
EXPOSE 22

# --------------- Add docker-ce engine (Official Method: 2019) ---------------
# https://docs.docker.com/install/linux/docker-ce/ubuntu/
RUN curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
RUN apt-key fingerprint 0EBFCD88
RUN add-apt-repository -r -y "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) edge" && \
    add-apt-repository -y "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) edge"
RUN apt-get update -y
RUN apt-get remove -y docker docker-engine docker.io containerd runc
RUN apt-get install -y docker-ce docker-ce-cli containerd.io

# --------------- Add docker-compose (Official Method: 2019) ---------------
# https://docs.docker.com/compose/install/
RUN latesturl=$(curl -s https://api.github.com/repos/docker/compose/releases/latest \
    | grep "browser_download_url" \
    | grep docker-compose-$(uname -s)-$(uname -m) \
    | grep -v ".sha256" \
    | cut -d\" -f4) && \
    echo "\tFound Compose# ${latesturl}\r\n" && \
    curl -L "${latesturl}" -o /usr/local/bin/docker-compose && \
    chmod +x /usr/local/bin/docker-compose


# --------------- Ubuntu Cache Cleanup ---------------
# Cleanup saves space
RUN apt-get clean -y && \
    apt-get autoclean -y && \
    apt-get autoremove -y && \
    apt-get autoremove -y && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# --------------- Launch Startup Script ---------------
# Using `docker run --ti` you can see the output log of script
#
COPY startup.sh /startup.sh
RUN chmod 755 /startup.sh
CMD [ "/bin/bash", "-c", "/startup.sh" ]
