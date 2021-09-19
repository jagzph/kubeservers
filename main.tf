# Configure the OpenStack Provider

terraform {
  required_providers {
    openstack    = {
      source     = "terraform-provider-openstack/openstack"

    }
  }
}


# Configure the OpenStack Provider
provider "openstack" {
   cloud          = "openstack"
}


resource "openstack_blockstorage_volume_v2" "volumes" {
  count           = 3
  name            = "${format("vol-kube%02d", count.index+1)}"
  size            = 50
}

resource "openstack_compute_volume_attach_v2" "va_1" {
  count           = 3
  instance_id     = "${openstack_compute_instance_v2.kubeservers.*.id[count.index]}"
  volume_id       = "${openstack_blockstorage_volume_v2.volumes.*.id[count.index]}"
}

resource "openstack_compute_instance_v2" "kubeservers" {
  count           = 3
  name            = "${format("phvlkube%03d", count.index+1)}"
  image_name      = var.image
  flavor_name     = var.knodes
  key_pair        = var.sshkey
  security_groups = var.secgroup

  block_device {
    uuid          = "535a0180-df21-48c9-ae32-53e80eb133c7"
    source_type   = "image"
    volume_size   = 20
    boot_index    = 0
    destination_type  = "volume"
    delete_on_termination = true
  }

  network {
    port = data.openstack_networking_port_v2.vmnet1_ports.*.id[count.index]
  }

}

data openstack_networking_port_v2 "vmnet1_ports" {
  count           = 3
  name            = "${format("vmnet1_port0-kube%d", count.index+1)}"
}

