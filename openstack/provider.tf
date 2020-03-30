

provider "openstack" {
  version                       = "~> 1.26"
  auth_url                      = var.openstack_auth_url
  region                        = var.openstack_region
  insecure                      = var.openstack_insecure
  cacert_file                   = var.openstack_cacert_file
  cert                          = var.openstack_cert
  key                           = var.openstack_key
  user_domain_name              = var.openstack_user_domain_name
  user_domain_id                = var.openstack_user_domain_id
  project_domain_name           = var.openstack_project_domain_name
  project_domain_id             = var.openstack_project_domain_id
  domain_name                   = var.openstack_domain_name
  domain_id                     = var.openstack_domain_id
  tenant_name                   = var.openstack_tenant_name
  tenant_id                     = var.openstack_tenant_id
  user_name                     = var.openstack_user_name
  user_id                       = var.openstack_user_id
  password                      = var.openstack_password
  token                         = var.openstack_token
  application_credential_name   = var.openstack_application_credential_name
  application_credential_id     = var.openstack_application_credential_id
  application_credential_secret = var.openstack_application_credential_secret

}
