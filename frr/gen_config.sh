#!/bin/bash

basedir=$(dirname $(readlink -f $0))

if [ "${KUBECONFIG}" == "" ]; then
	echo "no kubeconfig!"
	exit
fi
nodes_ip=$(kubectl get node -o jsonpath='{.items[*].status.addresses[0].address}')
config_file="${basedir}/config"

cat <<EOF > ${config_file}
!
frr version 7.7-dev_git
frr defaults traditional
hostname 3cbf17645ef1
no ipv6 forwarding
!
ip route 0.0.0.0/0 192.168.122.1
!
interface eth0
 ip address 192.168.122.254/24
!
interface net1
 ip address 192.168.1.254/24
!
router bgp 64500
 no bgp ebgp-requires-policy
 no bgp suppress-duplicates
 no bgp network import-check
EOF

for i in ${nodes_ip}; do
echo " neighbor $i remote-as 64500" >> ${config_file}
done

cat <<EOF >> ${config_file}
!
line vty
!
end
EOF
