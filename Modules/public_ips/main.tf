resource "azurerm_public_ip" "this" {
  for_each = var.pips

  name                = each.value.name
  location            = var.resource_groups[each.value.resource_group_key].location
  resource_group_name = var.resource_groups[each.value.resource_group_key].name
  allocation_method   = each.value.allocation_method
  sku                 = each.value.sku
}