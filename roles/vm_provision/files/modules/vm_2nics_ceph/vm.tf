terraform {
  required_providers {
    libvirt = {
      source = "dmacvicar/libvirt"
    }
  }
}

variable name {}
variable memory {}
variable vcpu {}
variable user {}
variable ssh_pub_key {}
variable network_name {}
variable eth1_addr {
  type = list
  default = null
}
variable base_image {}
variable ceph_image {
  default = "images/empty.qcow2"
}

resource "libvirt_volume" "image-node" {
  name = "${var.name}.img"
  source = var.base_image
}

resource "libvirt_volume" "ceph-node" {
  name = "${var.name}_ceph.img"
  size = 1024*1024*1024*20 # 20G
}

resource "libvirt_cloudinit_disk" "ci-node" {
  name = "ci-${var.name}.iso"

  meta_data = <<-EOS
    instance-id: ${var.name}
    local-hostname: ${var.name}
  EOS

  user_data = <<-EOS
    #cloud-config
    timezone: Asia/Tokyo
    ssh_pwauth: true
    chpasswd:
      list: root:password
      expire: false
    users:
      - name: ${var.user}
        groups: wheel
        sudo: ALL=(ALL) NOPASSWD:ALL
        ssh_authorized_keys:
          - ${var.ssh_pub_key}
  EOS
}

resource "libvirt_domain" "vm-node" {
  name = var.name
  memory = var.memory
  vcpu = var.vcpu

  cpu {
    mode = "host-passthrough"
  }

  disk { volume_id = libvirt_volume.image-node.id }
  disk { volume_id = libvirt_volume.ceph-node.id }

  network_interface {
    network_name = "default"
    wait_for_lease = true
  }

  network_interface {
    network_name = "{$var.network_name}"
    addresses = var.eth1_addr
  }

  console {
    type = "pty"
    target_port = "0"
  }

  graphics {
    type = "vnc"
    listen_type = "address"
    listen_address = "0.0.0.0"
    autoport = "true"
  }

  cloudinit = libvirt_cloudinit_disk.ci-node.id
}

output "ips" {
  value = flatten(libvirt_domain.vm-node.*.network_interface.0.addresses)
}
