# 5G-Edge-Slice
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
## hosting a simple server
```
sudo docker exec server python3 -m http.server 9999
```

## Commmands to be executed in Core VM in order to connect to the gNB
```
sudo sysctl net.ipv4.ip_forward=1
sudo iptables -P FORWARD ACCEPT
sudo ip route add 192.168.71.194 via <GNB Baremetal IP>
sudo ip route add 12.1.1.0/24 via 192.168.70.134 # Forward packets to Mobiles from external sources
```
To check if the devices are connected to core follow the AMF logs
```
sudo docker logs --follow oai-amf
```
# Setting up gNB
Clone this repo  and follow the instructions ref: https://github.com/5g-ucl-idrbt/oai-gnodeb-b210
## Commands to be executed in gNB

```
sudo sysctl net.ipv4.ip_forward=1
sudo iptables -P FORWARD ACCEPT
sudo ip route add 192.168.70.128/26 via <Bridge IP of Core VM>
```
```
cd ci-scripts/yaml_files/sa_b200_gnb/
sudo docker-compose up -d
```
```
sudo docker exec -it sa-b200-gnb bash
```
```
bash bin/entrypoint.sh
/opt/oai-gnb/bin/nr-softmodem -O /opt/oai-gnb/etc/gnb.conf $USE_ADDITIONAL_OPTIONS
```
Ping tests to perform in UE 
```
ping 8.8.8.8
```
```
ping 10.0.0.1
ping 10.0.0.2
ping 10.0.0.3
```
## To verify that network slicing is working
Run simple python server on server.
NOTE: Always run the python server on the port 9999 (according to the RYU code)
```
sudo docker exec server python -m http.server 9999
```
Run simple python server on router
```
sudo docker exec router python -m http.server 9988
```
Now if you will do the wget command by the ip of router but the tcp_port on which the server is running, it will be replied by server and not router. You can also verify it on the terminal, from where you got the reply.
To do the wget command. Run following command in gnbsim
```
wget --bind-address= <UE_ip_address> <router_ip_address>:9999
```
And if we give some other tcp_port, it will be replied by router
```
wget --bind-address= <UE_ip_address> <router_ip_address>:9988
```
So, you can observe in the terminal(router & server) that even if the ip was same but was answered by differenrt systems.
