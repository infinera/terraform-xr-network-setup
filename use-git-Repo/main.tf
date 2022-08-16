// This module initializes the:
// network
// bandwidht
// service

terraform {
  experiments = [module_variable_optional_attrs]
}
module "network-setup" {
  source = "git::https://github.com/infinera/terraform-infinera-xr-modules.git//network-setup"
  hub_names  = var.hub_names
  leaf_names = var.leaf_names
  trafficmode = var.trafficmode
}
module "bandwidth-setup" {
  depends_on        = [module.network-setup]
  source = "git::https://github.com/infinera/terraform-infinera-xr-modules.git//bandwidth-setup"
  hub_names         = var.hub_names
  leaf_names        = var.leaf_names
  leaf_bandwidth = var.leaf_bandwidth
  hub_bandwidth = var.hub_bandwidth
  trafficmode = var.trafficmode
}
module "service-setup" {
  depends_on        = [module.bandwidth-setup]
  source = "git::https://github.com/infinera/terraform-infinera-xr-modules.git//service-setup"
  hub_names         = var.hub_names
  leaf_names        = var.leaf_names
  client-2-dscg     = var.client-2-dscg
  trafficmode = var.trafficmode
}