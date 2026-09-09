module "resource_group" {
  source          = "../../Modules/resource_group"
  resource_groups = var.resource_groups

}

module "storage_account" {
  source          = "../../Modules/storage_account"
  storageaccounts = var.storageaccounts
  depends_on      = [module.resource_group]

}

module "vnet" {
  source     = "../../Modules/vnet"
  vnets      = var.vnets
  depends_on = [module.resource_group]

}

module "subnet" {
  source = "../../Modules/subnet"

  subnets = var.subnets

  depends_on = [module.resource_group, module.vnet]

}

module "public_ips" {
  source = "../../Modules/public_ips"
  pips   = var.pips

  depends_on = [module.resource_group, module.vnet, module.subnet]

}

module "network_interface" {
  source          = "../../Modules/network_interface"
  nics            = var.nics
  subnets         = module.subnet.subnets
  resource_groups = module.resource_group.resource_groups

}

module "network_security_group" {
  source          = "../../Modules/network_security_group"
  nsgs            = var.nsgs
  resource_groups = module.resource_group.resource_groups



}

module "subnet_nsg_association" {
  source = "../../Modules/subnet_nsg_association"

  subnet_nsg_associations = var.subnet_nsg_associations

  subnets = module.subnet.subnets
  nsgs    = module.network_security_group.nsgs
}