#!/bin/sh
ansible-playbook -i inventory/virthost.inventory 01a_download_vm_image.yml
