docker-compose -f redis/docker-compose.yml up --scale redis-master=1 --scale redis-replica=3 -d
cd /home/admin/YCSB/

# Run benchmarks a couple of times
