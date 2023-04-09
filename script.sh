sudo apt-get update 
node
sudo apt-get install build-essential 
npm
sudo apt install npm -y
git clone https://github.com/hyperledger/caliper-benchmarks.git
cd caliper-benchmarks 
git checkout d02cc8bbc17afda13a0d3af1122d43bfbfc45b0a 
npm init
npm install --only=prod @hyperledger/caliper-cli@0.4 
npm audit fix
curl https://raw.githubusercontent.com/creationix/nvm/v0.25.0/install.sh | bash 
exit

cd caliper-benchmarks
nvm install 8.9
sudo apt update
sudo apt-get remove python3
sudo apt-get install python2.7
sudo update-alternatives --install /usr/bin/python python /usr/bin/python2.7 1 
npx caliper bind --caliper-bind-sut fabric:1.4.11  
sudo apt install docker.io
sudo usermod -aG docker $USER
sudo apt install docker-compose
cd networks/fabric/config_raft/
./generate.sh
cd ..
cd ..
cd ..
sudo docker pull hyperledger/fabric-ccenv:1.4.4 
sudo docker tag hyperledger/fabric-ccenv:1.4.4 hyperledger/fabric-ccenv:latest 
sudo apt-get update
sudo apt-get install build-essential libssl-devy
ls
cd networks/fabric/config_solo_raft/
./generate.sh
cd ..
cd ..
cd ..
npm rebuild
exit


nvm install 8.9
cd caliper-benchmarks
npx caliper launch manager --caliper-workspace . --caliper-benchconfig benchmarks/samples/fabric/marbles/config.yaml --caliper-networkconfig networks/fabric/v1/v1.4.4/2org1peercouchdb_raft/fabric-go-tls-solo.yaml