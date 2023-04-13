#!/bin/bash

echo "Starting Docker Stats...\n"
./save_docker_stats.sh $$

echo "Start Redis Benchmark using YCSB..."
docker-compose -f docker-compose.yml up --scale redis-master=1 --scale redis-replica=5 -d

cd /home/admin/YCSB/

# Run benchmarks 3 times for each workload
workloads="/home/admin/YCSB/workloads"
load_output="/home/admin/load_output.csv"
run_output="/home/admin/run_output.csv"

for workload in "$workloads"/workload*[a-f]
do
	if [[ -f "$workload" ]]; then
		for i in {1..3}
		do
			printf "\n##################################################################################\n" >> $load_output
			printf "Loading data $(basename "$workload") try $i \n" >> $load_output
			./bin/ycsb load redis -s -P $workload -p "redis.host=127.0.0.1" -p "redis.port=6379" -p "redis.clustert=true" >> $load_output
			printf "\n##################################################################################\n" >> $run_outputv
			printf "Running test $(basename "$workload") try $i\n" >> $run_output
			./bin/ycsb run redis -s -P $workload -p "redis.host=127.0.0.1" -p "redis.port=6379" -p "redis.clustert=true" >> $run_output
		done
	fi
done

docker-compose -f docker-compose.yml down -v
printf "\nFinished Redis Benchmark\n\n"
