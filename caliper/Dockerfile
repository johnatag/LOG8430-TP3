# Sample container image with Ubuntu Focal + Systemd + Sshd + Docker.
#
# Usage:
#
# $ docker run --runtime=sysbox-runc -it --rm -P --name=syscont nestybox/ubuntu-focal-systemd-docker
#
# This will run systemd and prompt for a user login; the default
# user/password in this image is "admin/admin". Once you log in you
# can run Docker inside as usual. You can also ssh into the image:
#
# $ ssh admin@<host-ip> -p <host-port>
#
# where <host-port> is chosen by Docker and mapped into the system container's sshd port.
#

FROM ghcr.io/nestybox/ubuntu-jammy-systemd:latest

# Install Docker
RUN apt-get update && apt-get install -y curl \
    && rm -rf /var/lib/apt/lists/* \
    && curl -fsSL https://get.docker.com -o get-docker.sh && sh get-docker.sh \
    # Add user "admin" to the Docker group
    && usermod -a -G docker admin
ADD https://raw.githubusercontent.com/docker/docker-ce/master/components/cli/contrib/completion/bash/docker /etc/bash_completion.d/docker.sh

# Install Sshd
RUN apt-get update && apt-get install --no-install-recommends -y openssh-server \
    && rm -rf /var/lib/apt/lists/* \
    && mkdir /home/admin/.ssh \
    && chown admin:admin /home/admin/.ssh

RUN echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers
USER admin
# Intall dependencies
RUN sudo apt-get update && sudo apt-get install --no-install-recommends -y build-essential \
	npm \
	docker-compose \
	libssl-dev \
	python2.7

# Cloning Caliper
WORKDIR /home/admin/
RUN git clone https://github.com/hyperledger/caliper-benchmarks.git

WORKDIR /home/admin/caliper-benchmarks/
RUN git checkout d02cc8bbc17afda13a0d3af1122d43bfbfc45b0a 
RUN npm init -y
RUN npm install --only=prod @hyperledger/caliper-cli@0.4 
RUN npm audit fix || true

# Installing NVM and NodeJS
#ENV NVM_DIR /home/admin/.nvm
#RUN mkdir -p $NVM_DIR
SHELL ["/bin/bash", "--login", "-i",  "-c"]
RUN curl https://raw.githubusercontent.com/creationix/nvm/v0.25.0/install.sh | bash
RUN source /home/admin/.bashrc && nvm install 8.9 && nvm alias default 8.9 && nvm use default 
SHELL ["/bin/bash", "--login", "-c"]
#RUN sudo .$HOME/.nvm/nvm.sh && nvm install 8.9 && nvm default alias 8.9 && nvm use default

#ENV NODE_VERSION v8.9

#RUN /bin/bash -c "echo 'export NVM_DIR=$NVM_DIR' >> /home/admin/.bashrc"
#RUN /bin/bash -c "echo '[ -s \"$NVM_DIR/nvm.sh\" ] && \\. \"$NVM_DIR/nvm.sh\"' >> /home/admin/.bashrc"
#RUN /bin/bash -c "source $NVM_DIR/nvm.sh && nvm install $NODE_VERSION && nvm use $NODE_VERSION && nvm alias default $NODE_VERSION"

#ENV NODE_PATH $NVM_DIR/versions/node/$NODE_VERSION/lib/node_modules
#ENV PATH $NVM_DIR/versions/node/$NODE_VERSION/bin:$PATH

RUN sudo update-alternatives --install /usr/bin/python python /usr/bin/python2.7 1

COPY script.sh /home/admin/
RUN sudo chmod +x /home/admin/script.sh

#RUN npx caliper bind --caliper-bind-sut fabric:1.4.11  

#WORKDIR /home/admin/caliper-benchmarks/networks/fabric/config_raft/
#RUN ./generate.sh
#WORKDIR /home/admin/caliper-benchmarks/networks/fabric/config_solo_raft/
#RUN ./generate.sh

#WORKDIR /home/admin/caliper-benchmarks/
#RUN npm rebuild
USER root
EXPOSE 22

# Set systemd as entrypoint.
ENTRYPOINT [ "/sbin/init", "--log-level=err" ]
CMD ["sh", "/home/admin/script.sh"]
