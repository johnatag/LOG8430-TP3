#!/usr/bin/env bash
sudo apt-get update -y

curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.38.0/install.sh | bash
source ~/.profile
nvm install 12 && nvm use 12

sudo apt-get install build-essential -y
sudo apt install npm -y

# WORKDIR ~
cd ~
git clone https://github.com/hyperledger/caliper-benchmarks.git

# WORKDIR ~/caliper-benchmarks
cd ~/caliper-benchmarks/
git checkout d02cc8bbc17afda13a0d3af1122d43bfbfc45b0a
npm init -y
npm install --only=prod @hyperledger/caliper-cli@0.4

# WORKDIR ~/caliper-benchmarks/networks/fabric/config_solo_raft/
cd ~/caliper-benchmarks/networks/fabric/config_solo_raft/
./generate.sh

# WORKDIR ~/caliper-benchmarks
cd ~/caliper-benchmarks/
npm install --save fabric-client fabric-ca-client

sudo apt-get install python2.7 -y && apt-get remove python3 -y && update-alternatives --install /usr/bin/python python /usr/bin/python2.7 1
npm rebuild grpc --force

sudo snap install docker
sudo docker pull hyperledger/fabric-ccenv:1.4.4
sudo docker tag hyperledger/fabric-ccenv:1.4.4 hyperledger/fabric-ccenv:latest

sudo npx caliper launch manager --caliper-workspace . --caliper-benchconfig benchmarks/samples/fabric/marbles/config.yaml --caliper-networkconfig networks/fabric/v1/v1.4.4/2org1peercouchdb_raft/fabric-go-tls-solo.yaml