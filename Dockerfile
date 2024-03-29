# syntax=docker/dockerfile:1
#Download base image ubuntu 20.04
FROM ubuntu:20.04

# Install ubuntu without interactions
ARG DEBIAN_FRONTEND=noninteractive

# Set install Directory
WORKDIR /cloud9

# Install required packages
COPY apt-requirements.txt /cloud9/
RUN apt-get update
RUN grep -v '^#' apt-requirements.txt | xargs apt-get -y install

# Install Docker
RUN mkdir -p /etc/apt/keyrings
RUN curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg
RUN echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null
RUN apt-get update
RUN apt-get -y install docker-ce docker-ce-cli containerd.io docker-compose-plugin

# Add user
RUN useradd -u 99 -ms /bin/bash ubuntu
RUN adduser ubuntu sudo
RUN echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

# Install from user
USER ubuntu
CMD /bin/bash

# Clone and install cloud9 with sudo
RUN sudo chown -R ubuntu:ubuntu /cloud9
RUN git clone https://github.com/c9/core.git c9sdk
RUN sudo mkdir -p c9sdk/build /workspace/.ubuntu/.standalone
#RUN sudo chown -R ubuntu:ubuntu c9sdk /workspace
RUN ln -sf /workspace/.ubuntu/.standalone c9sdk/build/standalone
#RUN sudo mkdir -p /workspace
#RUN sudo chown ubuntu:ubuntu /workspace
RUN sudo chown -R ubuntu:ubuntu c9sdk /workspace
RUN sudo c9sdk/scripts/install-sdk.sh

# Add required packages for ubuntu user
RUN curl -L https://raw.githubusercontent.com/c9/install/master/install.sh | bash

# Reset Git
RUN cd /cloud9/c9sdk && git reset --hard

# Symlink user settings
RUN ln -sf /workspace/.ubuntu/user.settings /home/ubuntu/.c9/user.settings

EXPOSE 9999
VOLUME /workspace

# Setup environment
COPY start-cloud9.sh /cloud9/
COPY bashrc.default /home/ubuntu/.bashrc
RUN sudo chown ubuntu:ubuntu /cloud9/start-cloud9.sh

# Start service
STOPSIGNAL SIGTERM
#CMD tail -f /etc/fstab
CMD bash /cloud9/start-cloud9.sh
