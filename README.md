# Quickstart

```
# install requirements
$ ansible-galaxy install -r requirements.yml

# modify inventory/virthost.inventory to fit to your environment
$ vi inventory/virthost.inventory

# setup libvirt and download cloud image (called once at installation)
$ ansible-playbook -i inventory/virthost.inventory 01_setup_env.yml

# create VM and setup Kubernetes
$ ./scripts/launch.sh

# manipulate cluster
$ export KUBECONFIG=kubeconfig
$ kubectl ...

# teardown VMs
$ ./scripts/teardown.sh

# (if you want to use another VM image)
$ vi group_vars/all
<modify vm_image_url>
$ ./scripts/download_vm_image.sh

# (if you setup VMs again, with new VM image and install Kubernetes)
$ ./scripts/launch.sh
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
