resource "azurerm_subnet_network_security_group_association" "this" {
  for_each = var.subnet_nsg_associations

  subnet_id = var.subnets[each.value.subnet_key].id

  network_security_group_id = var.nsgs[each.value.nsg_key].id
}