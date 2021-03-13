terraform {
  required_version = ">= 0.13"
  required_providers {
    libvirt = {
      version = ">= 0.6.2"
      source = "dmacvicar/libvirt"
    }
  }
}

variable name {}
variable memory {}
variable vcpu {}
variable user {}
variable ssh_pub_key {}
variable base_image {}

resource "libvirt_volume" "image-node" {
  name = "${var.name}.img"
  source = base_image
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

  cpu = {
    mode = "host-passthrough"
  }

  disk { volume_id = libvirt_volume.image-node.id }

  network_interface {
    network_name = "default"
    wait_for_lease = true
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
