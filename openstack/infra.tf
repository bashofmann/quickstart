# OpenStack Infrastructure Resources

data "openstack_networking_network_v2" "ext_net" {
  name = var.openstack_ext_net_name
}

# Public IP of Rancher server
resource "openstack_networking_floatingip_v2" "rancher-server-ip" {
  pool = data.openstack_networking_network_v2.ext_net.name
}

# OpenStack virtual network space for quickstart resources
resource "openstack_networking_network_v2" "rancher-quickstart" {
  name           = "${var.prefix}-network"
  admin_state_up = "true"
}

# OpenStack internal subnet for quickstart resources
resource "openstack_networking_subnet_v2" "rancher-quickstart-internal" {
  name            = "rancher-quickstart-internal"
  network_id      = openstack_networking_network_v2.rancher-quickstart.id
  cidr            = "10.0.0.0/16"
  ip_version      = 4
  enable_dhcp     = "true"
  dns_nameservers = ["8.8.8.8"]
}

resource "openstack_networking_router_v2" "rancher-quickstart" {
  name                = "router2ext.rke"
  admin_state_up      = "true"
  external_network_id = data.openstack_networking_network_v2.ext_net.id
}

resource "openstack_networking_router_interface_v2" "rancher-quickstart" {
  router_id = openstack_networking_router_v2.rancher-quickstart.id
  subnet_id = openstack_networking_subnet_v2.rancher-quickstart-internal.id
}

resource "openstack_compute_secgroup_v2" "rancher-quickstart" {
  name        = "rke-ssh-access"
  description = "Security group for ssh access"

  rule {
    from_port   = 22
    to_port     = 22
    ip_protocol = "tcp"
    cidr        = "0.0.0.0/0"
  }
  rule {
    from_port   = 6443
    to_port     = 6443
    ip_protocol = "tcp"
    cidr        = "0.0.0.0/0"
  }
  rule {
    from_port   = 80
    to_port     = 80
    ip_protocol = "tcp"
    cidr        = "0.0.0.0/0"
  }
  rule {
    from_port   = 443
    to_port     = 443
    ip_protocol = "tcp"
    cidr        = "0.0.0.0/0"
  }
}

resource "openstack_compute_keypair_v2" "rancher-quickstart" {
  name       = "rancher-quickstart"
  public_key = file("${var.ssh_key_file_name}.pub")
}

resource "openstack_compute_instance_v2" "rancher-server" {
  name        = "${var.prefix}-rancher-server"
  image_name  = var.image_name
  flavor_name = var.flavor
  key_pair    = openstack_compute_keypair_v2.rancher-quickstart.name

  user_data = templatefile("../cloud-common/files/userdata_rancher_server.template", {
    docker_version = var.docker_version
    username       = local.node_username
  })
  security_groups = [
    openstack_compute_secgroup_v2.rancher-quickstart.name
  ]
  network {
    name = openstack_networking_network_v2.rancher-quickstart.name
  }
}

resource "openstack_compute_floatingip_associate_v2" "rancher-server-ip-assoc" {
  instance_id = openstack_compute_instance_v2.rancher-server.id
  floating_ip = openstack_networking_floatingip_v2.rancher-server-ip.address

  provisioner "remote-exec" {
    inline = [
      "cloud-init status --wait"
    ]

    connection {
      type        = "ssh"
      host        = openstack_networking_floatingip_v2.rancher-server-ip.address
      user        = local.node_username
      private_key = file(var.ssh_key_file_name)
    }
  }
}

# Rancher resources
module "rancher_common" {
  source = "../rancher-common"

  node_public_ip         = openstack_compute_floatingip_associate_v2.rancher-server-ip-assoc.floating_ip
  node_internal_ip       = openstack_compute_instance_v2.rancher-server.access_ip_v4
  node_username          = local.node_username
  ssh_key_file_name      = var.ssh_key_file_name
  rke_kubernetes_version = var.rke_kubernetes_version

  cert_manager_version = var.cert_manager_version
  rancher_version      = var.rancher_version

  rancher_server_dns = "${replace(openstack_networking_floatingip_v2.rancher-server-ip.address, ".", "-")}.nip.io"
  admin_password     = var.rancher_server_admin_password

  workload_kubernetes_version = var.workload_kubernetes_version
  workload_cluster_name       = "quickstart-openstack-custom"
}

# Public IP of quickstart node
resource "openstack_networking_floatingip_v2" "quickstart-node-ip" {
  pool = data.openstack_networking_network_v2.ext_net.name
}

resource "openstack_compute_instance_v2" "quickstart-node" {
  name        = "${var.prefix}-rancher-server"
  image_name  = var.image_name
  flavor_name = var.flavor
  key_pair    = openstack_compute_keypair_v2.rancher-quickstart.name
  user_data = templatefile("../cloud-common/files/userdata_quickstart_node.template", {
    docker_version   = var.docker_version
    username         = local.node_username
    register_command = module.rancher_common.custom_cluster_command
  })
  security_groups = [
    openstack_compute_secgroup_v2.rancher-quickstart.name
  ]
  network {
    name = openstack_networking_network_v2.rancher-quickstart.name
  }
}

resource "openstack_compute_floatingip_associate_v2" "quickstart-node-ip-assoc" {
  instance_id = openstack_compute_instance_v2.quickstart-node.id
  floating_ip = openstack_networking_floatingip_v2.quickstart-node-ip.address

  provisioner "remote-exec" {
    inline = [
      "cloud-init status --wait"
    ]

    connection {
      type        = "ssh"
      host        = openstack_networking_floatingip_v2.quickstart-node-ip.address
      user        = local.node_username
      private_key = file(var.ssh_key_file_name)
    }
  }
}