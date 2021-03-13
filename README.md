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

# teardown VMs
$ ansible-playbook -i virthost.inventory 99_teardown_vms.yml

# (if you setup VMs again)
$ ansible-playbook -i virthost.inventory 02_setup_vm.yml
...
```
