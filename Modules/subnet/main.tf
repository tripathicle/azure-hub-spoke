resource "azurerm_subnet" "this" {

  for_each = var.subnets

  name = each.value.name

  resource_group_name = var.resource_groups[each.value.resource_group_key].name

  virtual_network_name = var.vnets[each.value.virtual_network_key].name

  address_prefixes = each.value.address_prefixes
}