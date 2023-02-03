#!/bin/sh
ansible-playbook -i inventory/virthost.inventory 99_teardown_vms.yml
