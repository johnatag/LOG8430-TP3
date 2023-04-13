#!/bin/bash
cd /home/admin/caliper-benchmarks/ && npx caliper bind --caliper-bind-sut fabric:1.4.11
cd /home/admin/caliper-benchmarks/networks/fabric/config_raft/ && ./generate.sh
cd /home/admin/caliper-benchmarks/networks/fabric/config_solo_raft/ && ./generate.sh
cd /home/admin/caliper-benchmarks/ && npm rebuild

sudo docker pull hyperledger/fabric-ccenv:1.4.4 
sudo docker tag hyperledger/fabric-ccenv:1.4.4 hyperledger/fabric-ccenv:latest 

echo "Starting Docker Stats...."
./save_docker_stats.sh $$ &

echo "Starting Caliper using YCSB..."

caliper-config="/home/admin/caliper-benchmarks/benchmarks/samples/fabric/marbles/config.yaml"
html-report="/home/admin/caliper-benchmarks/report.html"

# Workload A
rm -f ${caliper-config}
cp /home/admin/workloads/workloada ${caliper-config}
cd /home/admin/caliper-benchmarks/ && npx caliper launch manager --caliper-workspace . --caliper-benchconfig benchmarks/>
cp ${html-report} /home/admin/output/${html-report}-A.html

# Workload B
rm -f ${caliper-config}
cp /home/admin/workloads/workloadb ${caliper-config}
cd /home/admin/caliper-benchmarks/ && npx caliper launch manager --caliper-workspace . --caliper-benchconfig benchmarks/>
cp ${html-report} /home/admin/output/${html-report}-B.html

# Workload C
rm -f ${caliper-config}
cp /home/admin/workloads/workloadc ${caliper-config}
cd /home/admin/caliper-benchmarks/ && npx caliper launch manager --caliper-workspace . --caliper-benchconfig benchmarks/>
cp ${html-report} /home/admin/output/${html-report}-C.html
