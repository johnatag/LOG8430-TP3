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

for i in {1..3}
do
printf "\n##################################################################################\n" >> $load_output
printf "Loading data worload A try $i \n" >> $load_output
./bin/ycsb load redis -s -P workloads/workloada -p "redis.host=127.0.0.1" -p "redis.port=6379" -p "redis.clustert=true" >> $load_output
printf "\n##################################################################################\n" >> $run_output
printf "Running test workoad A try $i\n" >> $run_output
./bin/ycsb run redis -s -P workloads/workloada -p "redis.host=127.0.0.1" -p "redis.port=6379" -p "redis.clustert=true" >> $run_output

printf "\n##################################################################################\n" >> $load_output
printf " Loading data worload B try $i \n" >> $load_output
./bin/ycsb load redis -s -P workloads/workloadb -p "redis.host=127.0.0.1" -p "redis.port=6379" -p "redis.clustert=true" >> $load_output
printf "\n##################################################################################\n" >> $run_output
printf "Running test workoad B try $i\n" >> $run_output
./bin/ycsb run redis -s -P workloads/workloadb -p "redis.host=127.0.0.1" -p "redis.port=6379" -p "redis.clustert=true" >> $run_output

printf "\n##################################################################################\n" >> $load_output
printf "Loading data worload C try $i\n" >> $load_output
./bin/ycsb load redis -s -P workloads/workloadc -p "redis.host=127.0.0.1" -p "redis.port=6379" -p "redis.clustert=true" >> $load_output
printf "\n##################################################################################\n" >> $run_output
printf "Running test workoad C try $i\n" >> $run_output
./bin/ycsb run redis -s -P workloads/workloadc -p "redis.host=127.0.0.1" -p "redis.port=6379" -p "redis.clustert=true" >> $run_output

#for workload in "$workloads"/workload*[a-c]
#do
#	if [[ -f "$workload" ]]; then
#		for i in {1..3}
#		do
#			printf "\n##################################################################################\n" >> $load_output
#			printf "Loading data $(basename "$workload") try $i \n" >> $load_output
#			./bin/ycsb load redis -s -P $workload -p "redis.host=127.0.0.1" -p "redis.port=6379" -p "redis.clustert=true" >> $load_output
#			printf "\n##################################################################################\n" >> $run_output
#			printf "Running test $(basename "$workload") try $i\n" >> $run_output
#			./bin/ycsb run redis -s -P $workload -p "redis.host=127.0.0.1" -p "redis.port=6379" -p "redis.clustert=true" >> $run_output
#		done
#	fi
#done

docker-compose -f docker-compose.yml down -v
echo "Finished Redis Benchmark"
