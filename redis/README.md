# Redis Benchmark

This folder contains all the files necessary to run the Redis Benchmark using YSCB

Here are all the steps to run it:
- Install Docker
- Use sysbox as the docker runtime
- ```sudo docker build -t redis-benchmark .```
- ```sudo docker run -it redis-benchmark```

After running the docker, the container will prompt you to login. The default password for the admin account is: admin.

After logging into the admin account, the benchmark will automatically start.
