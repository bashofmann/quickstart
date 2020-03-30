output "rancher_server_url" {
  value = module.rancher_common.rancher_url
}

output "rancher_node_ip" {
  value = openstack_networking_floatingip_v2.rancher-server-ip.address
}

output "workload_node_ip" {
  value = openstack_networking_floatingip_v2.quickstart-node-ip.address
}
