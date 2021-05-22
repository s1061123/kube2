#!/bin/bash

if [ $(whoami) != "root" ]; then
	echo "need to run root!"
	exit
fi

frr_name="kube2-frr"
frr_path="$(dirname $(readlink -f $0))"

${frr_path}/gen_config.sh

podman inspect ${frr_name} 2>/dev/null >/dev/null
if [ $? -eq 0 ]; then
	podman kill ${frr_name}
	sleep 1
fi

podman run -d --rm --name=${frr_name} \
	-v ${frr_path}/daemons:/etc/frr/daemons \
	-v ${frr_path}/config:/config \
	-v ${frr_path}/sysctl.conf:/etc/sysctl.conf \
	--net=kube2-frr --privileged docker.io/frrouting/frr:v7.5.1
podman exec kube2-frr sysctl -p
sleep 3
# create veth 
sandboxkey=$(podman inspect kube2-frr | jq .[0].NetworkSettings.SandboxKey -r)
koko -a ${sandboxkey},net1,192.168.1.254/24 -c test,192.168.1.1/24
# load config
podman exec kube2-frr vtysh -f /config

# add metal-lb route
ip route add 172.19.100.0/24 via 192.168.1.254
