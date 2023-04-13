#!/bin/bash
cd /home/admin/caliper-benchmarks/ && npx caliper bind --caliper-bind-sut fabric:1.4.11
cd /home/admin/caliper-benchmarks/networks/fabric/config_raft/ && ./generate.sh
cd /home/admin/caliper-benchmarks/networks/fabric/config_solo_raft/ && ./generate.sh
cd /home/admin/caliper-benchmarks/ && npm rebuild

sudo docker pull hyperledger/fabric-ccenv:1.4.4 
sudo docker tag hyperledger/fabric-ccenv:1.4.4 hyperledger/fabric-ccenv:latest 

sudo chown :999 /home/admin/output

echo "Starting Docker Stats...."
./save_docker_stats.sh $$ &

echo "Starting Caliper using Caliper-benchmark..."

for i in {1..3}; do
	# Workload A
	rm -f /home/admin/caliper-benchmarks/benchmarks/samples/fabric/marbles/config.yaml
	cp /home/admin/workloads/workloada /home/admin/caliper-benchmarks/benchmarks/samples/fabric/marbles/config.yaml
	cd /home/admin/caliper-benchmarks/ && npx caliper launch manager --caliper-workspace . --caliper-benchconfig benchmarks/samples/fabric/marbles/config.yaml --caliper-networkconfig networks/fabric/v1/v1.4.4/2org1peercouchdb_raft/fabric-go-tls-solo.yaml
	cp /home/admin/caliper-benchmarks/report.html /home/admin/output/html-report-A-$i.html

	# Workload B
	rm -f /home/admin/caliper-benchmarks/benchmarks/samples/fabric/marbles/config.yaml
	cp /home/admin/workloads/workloadb /home/admin/caliper-benchmarks/benchmarks/samples/fabric/marbles/config.yaml
	cd /home/admin/caliper-benchmarks/ && npx caliper launch manager --caliper-workspace . --caliper-benchconfig benchmarks/samples/fabric/marbles/config.yaml --caliper-networkconfig networks/fabric/v1/v1.4.4/2org1peercouchdb_raft/fabric-go-tls-solo.yaml
	cp /home/admin/caliper-benchmarks/report.html /home/admin/output/html-report-B-$i.html

	# Workload C
	rm -f /home/admin/caliper-benchmarks/benchmarks/samples/fabric/marbles/config.yaml
	cp /home/admin/workloads/workloadc /home/admin/caliper-benchmarks/benchmarks/samples/fabric/marbles/config.yaml
	cd /home/admin/caliper-benchmarks/ && npx caliper launch manager --caliper-workspace . --caliper-benchconfig benchmarks/samples/fabric/marbles/config.yaml --caliper-networkconfig networks/fabric/v1/v1.4.4/2org1peercouchdb_raft/fabric-go-tls-solo.yaml
	cp /home/admin/caliper-benchmarks/report.html /home/admin/output/html-report-C-$i.html
done
