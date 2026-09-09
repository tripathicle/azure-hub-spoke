resource "azurerm_network_security_group" "this" {
  for_each            = var.nsgs
  name                = each.value.name
  resource_group_name = var.resource_groups[each.value.resource_group_key].name
  location            = var.resource_groups[each.value.resource_group_key].location


  dynamic "security_rule" {
    for_each = each.value.security_rules

    content {
      name                         = security_rule.value.name
      priority                     = security_rule.value.priority
      direction                    = security_rule.value.direction
      access                       = security_rule.value.access
      protocol                     = security_rule.value.protocol
      source_port_ranges           = security_rule.value.source_port_ranges
      destination_port_ranges      = security_rule.value.destination_port_ranges
      source_address_prefixes      = security_rule.value.source_address_prefixes
      destination_address_prefixes = security_rule.value.destination_address_prefixes
      description                  = security_rule.value.description
    }
  }

}