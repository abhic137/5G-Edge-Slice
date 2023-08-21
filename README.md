# 5G-Edge_Slice
## Pulling the images
```
docker pull abhic137/ovs:latest
docker pull abhic137/oai-amf:v1.5.1
docker pull abhic137/oai-smf:v1.5.1
docker pull abhic137/oai-nrf:v1.5.1
docker pull abhic137/oai-ausf:v1.5.1
docker pull abhic137/oai-udm:v1.5.1
docker pull abhic137/oai-udr:v1.5.1
docker pull abhic137/ryu:latest
docker pull abhic137/oai-spgwu-tiny:v1.5.1
docker pull abhic137/ubuntu:latest
docker pull abhic137/gnbsim
```
## Starting the core
```
sudo docker compose -f docker-compose-basic-nrf-ovs.yaml up -d
sudo docker ps -a

```
## Running the configurations
```
chmod 777 run.sh
sudo ./run.sh
```
## Running the controller code

For Network slicing
```
sudo docker exec ryu ryu-manager --observe-links ryu/ryu/app/ryucode.py
```
```(OR)```

For simple switch
```
sudo docker exec ryu ryu-manager --observe-links ryu/ryu/app/simple_switch.py 
```
