#!/bin/bash

echo "Starting Docker Stats..."
./save_docker_stats.sh $$ &

echo "Starting Redis Benchmark using YCSB..."
docker-compose -f docker-compose.yml up --scale redis-master=1 --scale redis-replica=4 -d

cd /home/admin/YCSB/

# Run benchmarks 3 times for each workload
workloads="/home/admin/YCSB/workloads"

#mkdir -p /home/admin/output/
sudo chown :999 /home/admin/output/
sudo chmod 770 /home/admin/output/
load_output="/home/admin/output/load_output.csv"
run_output="/home/admin/output/run_output.csv"

echo "Workload, Action, Type, Result" > $load_output
echo "Workload, Action, Type, Result" > $run_output

for i in {1..3}
do

	ycsb_load_output=$(./bin/ycsb load redis -s -P workloads/workloada -p "redis.host=127.0.0.1" -p "redis.port=6379" -p "redis.clustert=true")
	echo "A, $ycsb_load_output" >> $load_output
	ycsb_run_output=$(./bin/ycsb run redis -s -P workloads/workloada -p "redis.host=127.0.0.1" -p "redis.port=6379" -p "redis.clustert=true")
	echo "A, $ycsb_run_output" >> $run_output

	ycsb_load_output=$(./bin/ycsb load redis -s -P workloads/workloadb -p "redis.host=127.0.0.1" -p "redis.port=6379" -p "redis.clustert=true")
	echo "B, $ycsb_load_output" >> $load_output
	ycsb_run_output=$(./bin/ycsb run redis -s -P workloads/workloadb -p "redis.host=127.0.0.1" -p "redis.port=6379" -p "redis.clustert=true")
	echo "B, $ycsb_run_output" >> $run_output

	ycsb_load_output=$(./bin/ycsb load redis -s -P workloads/workloadc -p "redis.host=127.0.0.1" -p "redis.port=6379" -p "redis.clustert=true")
	echo "C, $ycsb_load_output" >> $load_output
	ycsb_run_output=$(./bin/ycsb run redis -s -P workloads/workloadc -p "redis.host=127.0.0.1" -p "redis.port=6379" -p "redis.clustert=true")
	echo "C, $ycsb_run_output" >> $run_output

done
docker-compose -f docker-compose.yml down -v
echo "Finished Redis Benchmark"
