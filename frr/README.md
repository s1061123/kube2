# How to use frr (for MetalLB)

# Prerequisites

Install [koko](https://github.com/redhat-nfvpe/koko/releases) into your path

- Copy `99-kube2-frr.conf` into /etc/cni/net.d
- Get kube-nodes IP address (i.e. master/worker node IP)
- Update neighbor IP address in config
- Run `run_frr.sh` to run frr BGPd
