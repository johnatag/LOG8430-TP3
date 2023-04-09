#!/usr/bin/env bash
sudo apt-get update -y

curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.38.0/install.sh | bash
source ~/.profile
nvm install 12 && nvm use 12

sudo apt-get install build-essential
sudo apt install npm
git clone https://github.com/hyperledger/caliper-benchmarks.git
cd caliper-benchmarks/ && git checkout d02cc8bbc17afda13a0d3af1122d43bfbfc45b0a
npm init -y
npm install --only=prod @hyperledger/caliper-cli@0.4

cd networks/fabric/config_solo_raft/
./generate.sh
cd
cd caliper-benchmarks/
npm install --save fabric-client fabric-ca-client


sudo apt-get install python2.7 -y && apt-get remove python3 -y && update-alternatives --install /usr/bin/python python /usr/bin/python2.7 1
npm rebuild grpc --force
sudo npx caliper launch manager --caliper-workspace . --caliper-benchconfig benchmarks/samples/fabric/marbles/config.yaml --caliper-networkconfig networks/fabric/v1/v1.4.4/2org1peercouchdb_raft/fabric-go-tls-solo.yaml