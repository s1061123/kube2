#!/bin/sh
ansible-playbook -i inventory/virthost.inventory 99_teardown_vms.yml; \
	sleep 5; \
	ansible-playbook -i inventory/virthost.inventory 02_setup_vm.yml; \
	sleep 10; \
	ansible-playbook -i inventory/vms.local.generated 03_kube_install.yml
