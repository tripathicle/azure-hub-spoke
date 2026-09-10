resource "azurerm_storage_account" "this" {
  for_each = var.storageaccounts

  name = each.value.name

  resource_group_name = var.resource_groups[
    each.value.resource_group_key
  ].name

  location = var.resource_groups[
    each.value.resource_group_key
  ].location

  account_tier             = each.value.account_tier
  account_replication_type = each.value.account_replication_type
}