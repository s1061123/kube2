# Remote virthost

This is a situation where you have a "virthost" (a machine that runs virtual machines) that is a different host than where this ansible playbook runs.

## Diagram

```
┌─────────────────────┐      ┌─────────────────────┐
│workstation          ├─────►| virthost            │
│where ansible runs.  │      │ runs libvirt VMs    │
└─────────────────────┘      │ ┌──────┐   ┌──────┐ │
                             │ │vm1   │   │vm..n │ │
                             │ │      │   │      │ │
                             │ │      │   │      │ │
                             │ └──────┘   └──────┘ │
                             └─────────────────────┘
```

## Instructions

If using a remote virthost, you may create an inventory which refers to your virthost as a member of the `virthost` group, such as:

```
labmachine ansible_host=192.168.50.200 ansible_ssh_user=root ansible_user=root

[virthost]
labmachine
```

Additionally, set some extra variables to re-use a key which can be used on your remote virthost:

```
terraform_workdir: "/home/user/tf"
ssh_pub_key: /remoteuser/.ssh/id_vm_rsa.pub
use_local_sshkey_path: /home/user/.ssh/id_vm_rsa.pub
use_local_sshprivatekey_path: /home/user/.ssh/id_vm_rsa
ssh_proxy_command: '-o ProxyCommand="ssh -W %h:%p remoteuser@YOUR-VIRTHOST"'
```

You may store these in a file, for example the inventory in `inventory/virthost.inventory` and the extra variables `inventory/extra-vars.yml` and use those from the command line with:

```
ansible-playbook -i ./inventory/virthost.inventory -e "@./inventory/extra-vars.yml" 01_setup_env.yml
```

Here, `use_local_sshkey_path` is a path to an SSH public key on the same host which is running the playbook. There is also a reciprocal private key, `use_local_sshprivatekey_path`. The `ssh_pub_key` is the path where this public key will be copied to on the virthost. `terraform_workdir` is the workdir for Terraform, and should be the path where you'd like to store terraform on your remote host.

Additionally, an SSH proxy is configured, replace `YOUR-VIRTHOST` with the IP and hostname of your virthost.

In such a case, if both the public key is available on the virthost, this will make it available on the guests, and you can ssh to a guest with:

```
ssh -i /path/to/specific/id_rsa.pub -o ProxyCommand="ssh -W %h:%p user@YOUR-VIRTHOST" fedora@YOUR-VM
```

(replace `YOUR-VIRTHOST` and `YOUR-VM` with the IP or hostname of your virthost and VM)
