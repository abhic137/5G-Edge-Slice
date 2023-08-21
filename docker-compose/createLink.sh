#!/bin/bash
## sudo bash createLink.sh <C1_name> <C2_Name>
#!/bin/bash

C1_NAME=$1
C2_NAME=$2
LINK_COUNTER=0

createNS(){
	C_ID=$1
	pid=$(docker inspect -f '{{.State.Pid}}' ${C_ID})
	CNAME=$(basename $(docker inspect --format='{{.Name}}' ${C_ID}))
	mkdir -p /var/run/netns/
	ln -sfT /proc/$pid/ns/net /var/run/netns/${CNAME}
}

addLink(){
	C1=$1
	C2=$2
	LINK_ID="dcp${LINK_COUNTER}"
	((LINK_COUNTER++))
	ip link add veth1_l type veth peer veth1_r
	ip link set veth1_l netns ${C1}
	ip link set veth1_r netns ${C2}
	ip netns exec ${C1} ip l set veth1_l name ${LINK_ID}
	ip netns exec ${C2} ip l set veth1_r name ${LINK_ID}
	ip netns exec ${C1} ip l set ${LINK_ID} up
	ip netns exec ${C2} ip l set ${LINK_ID} up
}

C1_ID=$(docker inspect --format="{{.Id}}" ${C1_NAME})
createNS ${C1_ID}
C2_ID=$(docker inspect --format="{{.Id}}" ${C2_NAME})
createNS ${C2_ID}
addLink ${C1_NAME} ${C2_NAME}
