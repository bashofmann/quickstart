# Variables for OpenStack infrastructure module

variable "openstack_auth_url" {
  type        = string
  description = "OpenStack authorization endpoint"
}

variable "openstack_insecure" {
  type        = bool
  description = "Trust self-signed certificates on OpenStack authorization endpoint"
  default     = false
}

variable "openstack_cacert_file" {
  type        = string
  description = "Custom CA certificate for OpenStack authorization endpoint"
  default     = ""
}

variable "openstack_cert" {
  type        = string
  description = "Client certificate for SSL authentication on OpenStack authorization endpoint"
  default     = ""
}

variable "openstack_key" {
  type        = string
  description = "Private key for SSL authentication on OpenStack authorization endpoint"
  default     = ""
}

variable "openstack_region" {
  type        = string
  description = "OpenStack region in which resources will be provisioned"
}

variable "openstack_user_domain_name" {
  type        = string
  description = "OpenStack user domain name used for all resources"
  default     = ""
}

variable "openstack_user_domain_id" {
  type        = string
  description = "OpenStack user domain id used for all resources"
  default     = ""
}

variable "openstack_project_domain_name" {
  type        = string
  description = "OpenStack project domain name used for all resources"
  default     = ""
}

variable "openstack_project_domain_id" {
  type        = string
  description = "OpenStack project domain id used for all resources"
  default     = ""
}

variable "openstack_domain_name" {
  type        = string
  description = "OpenStack domain name used for all resources"
  default     = ""
}

variable "openstack_domain_id" {
  type        = string
  description = "OpenStack domain id used for all resources"
  default     = ""
}

variable "openstack_tenant_name" {
  type        = string
  description = "OpenStack tenant name used for all resources"
  default     = ""
}

variable "openstack_tenant_id" {
  type        = string
  description = "OpenStack tenant id used for all resources"
  default     = ""
}

variable "openstack_user_name" {
  type        = string
  description = "OpenStack user name used to create resources"
  default     = ""
}

variable "openstack_user_id" {
  type        = string
  description = "OpenStack user id used for all resources"
  default     = ""
}

variable "openstack_password" {
  type        = string
  description = "OpenStack password used for all resources"
  default     = ""
}

variable "openstack_token" {
  type        = string
  description = "OpenStack token used for all resources"
  default     = ""
}

variable "openstack_application_credential_name" {
  type        = string
  description = "OpenStack application credential name used for all resources"
  default     = ""
}

variable "openstack_application_credential_id" {
  type        = string
  description = "OpenStack application credential id used for all resources"
  default     = ""
}

variable "openstack_application_credential_secret" {
  type        = string
  description = "OpenStack application credential secret used for all resources"
  default     = ""
}

variable "flavor" {
  type        = string
  description = "Flavor used for all linux virtual machines"
}

variable "image_name" {
  type        = string
  description = "Name of image used all linux virtual machines, must be an Ubuntu 18.04"
}

variable "openstack_ext_net_name" {
  type        = string
  description = "Name of the external network in OpenStack for internet access"
  default     = "ext-net"
}

variable "prefix" {
  type        = string
  description = "Prefix added to names of all resources"
  default     = "quickstart"
}

variable "docker_version" {
  type        = string
  description = "Docker version to install on nodes"
  default     = "19.03"
}

variable "ssh_key_file_name" {
  type        = string
  description = "File path and name of SSH private key used for infrastructure and RKE"
  default     = "~/.ssh/id_rsa"
}

variable "rke_kubernetes_version" {
  type        = string
  description = "Kubernetes version to use for Rancher server RKE cluster"
  default     = "v1.15.3-rancher1-1"
}

variable "workload_kubernetes_version" {
  type        = string
  description = "Kubernetes version to use for managed workload cluster"
  default     = "v1.16.6-rancher1-2"
}

variable "cert_manager_version" {
  type        = string
  description = "Version of cert-mananger to install alongside Rancher (format: 0.0.0)"
  default     = "0.12.0"
}

variable "rancher_version" {
  type        = string
  description = "Rancher server version (format v0.0.0)"
  default     = "v2.3.5"
}

# Required
variable "rancher_server_admin_password" {
  type        = string
  description = "Admin password to use for Rancher server bootstrap"
}


# Local variables used to reduce repetition
locals {
  node_username = "ubuntu"
}
