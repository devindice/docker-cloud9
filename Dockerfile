# syntax=docker/dockerfile:1
#Download base image ubuntu 20.04
FROM ubuntu:20.04

ARG UNAME=ubuntu
ARG UID=1000
ARG GID=1000

# Install ubuntu without interactions
ARG DEBIAN_FRONTEND=noninteractive

# Set install Directory
WORKDIR /cloud9

# Install required packages
COPY apt-requirements.txt /cloud9/
RUN apt-get update
RUN xargs apt-get install -y --no-install-recommends <apt-requirements.txt

# Add user
RUN groupadd -g $PGID -o $C9_USER
RUN useradd -ms /bin/bash ubuntu
RUN useradd -m -u $PUID -g $PGID -o -s /bin/bash $C9_USER

RUN adduser ubuntu sudo
RUN echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

# Install from user
USER $C9_USER
CMD /bin/bash

# Clone and install cloud9 with sudo
RUN sudo git clone https://github.com/c9/core.git c9sdk
RUN sudo c9sdk/scripts/install-sdk.sh

# Add required packages for cloud9 user
RUN curl -L https://raw.githubusercontent.com/c9/install/master/install.sh | bash

# Make workspace directory
RUN sudo mkdir -p /workspace
RUN sudo chown ubuntu:ubuntu /workspace

EXPOSE 9999
VOLUME /workspace

# Setup environment
COPY start-cloud9.sh /cloud9/
RUN sudo chown ubuntu:ubuntu /cloud9/start-cloud9.sh

# Start service
STOPSIGNAL SIGTERM
CMD bash /cloud9/start-cloud9.sh
