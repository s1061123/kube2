# Quickstart

```
# install requirements
$ ansible-galaxy install -r requirements.yml
# setup libvirt and download cloud image (called once at installation)
$ ansible-playbook -i virthost.inventory 01_setup_env.yml

# create VM
$ ansible-playbook -i virthost.inventory 02_setup_vm.yml

# setup Kubernetes
$ ansible-playbook -i vms.local.generated 03_kube_install.yml

# manipulate cluster
$ export KUBECONFIG=kubeconfig
$ kubectl ...

# teardown VMs
$ ansible-playbook -i virthost.inventory 99_teardown_vms.yml

# (if you setup VMs again)
$ ansible-playbook -i virthost.inventory 02_setup_vm.yml
...
```

## Introduction

This playbook installs Kubernetes on Fedora-based libvirt VMs which are provisioned by Terraform.

When we refer to the "virthost" (short for "virtualization host") we are talking about a machine which runs virtual machines. This can be the same machine the playbook is running on, or a remote host.

## Requirements

The virthost is assumed to be a Fedora machine.

# Options

## Remote Virthost

For details see the [using a remote virthost](docs/remote-virthost.md) document.

## Building the libvirt provider from source

You may set the `build_libvirt_provider` variable to true to build the libvirt provider from source. If you are not using the latest Fedora, this may be necessary.
