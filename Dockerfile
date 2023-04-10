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

RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.38.0/install.sh | bash
RUN . ~/.nvm/nvm.sh && nvm install 12 && nvm use 12

WORKDIR /TP3
RUN git clone https://github.com/hyperledger/caliper-benchmarks.git

WORKDIR /TP3/caliper-benchmarks
RUN git checkout d02cc8bbc17afda13a0d3af1122d43bfbfc45b0a
RUN apt-get update -y && \
    apt-get install -y npm
RUN npm init -y
RUN npm install --only=prod @hyperledger/caliper-cli@0.4 -y

WORKDIR /TP3/caliper-benchmarks/networks/fabric/config_solo_raft/
RUN ./generate.sh

WORKDIR /TP3/caliper-benchmarks/
RUN npm install --save fabric-client fabric-ca-client -y

RUN apt-get install python2.7 -y
RUN apt-get remove python3 -y
RUN update-alternatives --install /usr/bin/python python /usr/bin/python2.7 1
RUN apt install npm -y && npm rebuild grpc --force && npm i -g npx -y

EXPOSE 22

# Set systemd as entrypoint.
ENTRYPOINT [ "docker pull --platform=linux/amd64 hyperledger/fabric-ccenv:1.4.4;docker tag hyperledger/fabric-ccenv:1.4.4 hyperledger/fabric-ccenv:latest;/sbin/init", "--log-level=err" ]

