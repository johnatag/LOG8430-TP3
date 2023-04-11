#!/bin/bash
cd /home/admin/caliper-benchmarks/ && npx caliper bind --caliper-bind-sut fabric:1.4.11
cd /home/admin/caliper-benchmarks/networks/fabric/config_raft/ && ./generate.sh
cd /home/admin/caliper-benchmarks/networks/fabric/config_solo_raft/ && ./generate.sh
cd /home/admin/caliper-benchmarks/ && npm rebuild

sudo docker pull hyperledger/fabric-ccenv:1.4.4 
sudo docker tag hyperledger/fabric-ccenv:1.4.4 hyperledger/fabric-ccenv:latest 

cd /home/admin/caliper-benchmarks/ && npx caliper launch manager --caliper-workspace . --caliper-benchconfig benchmarks/samples/fabric/marbles/config.yaml --caliper-networkconfig networks/fabric/v1/v1.4.4/2org1peercouchdb_raft/fabric-go-tls-solo.yaml

