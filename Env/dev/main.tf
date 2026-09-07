module "resource_group" {
  source          = "../../Modules/resource_group"
  resource_groups = var.resource_groups

}

module "storage_account" {
  source          = "../../Modules/storage_account"
  storageaccounts = var.storageaccounts
  depends_on = [ module.resource_group ]

}