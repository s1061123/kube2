#!/bin/sh
ansible-playbook -i virthost.inventory 02_setup_vm.yml --skip-tags "vm_create"
