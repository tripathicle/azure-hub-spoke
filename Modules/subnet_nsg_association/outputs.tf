output "subnet_nsg_associations" {
  description = "Map of subnet to Network Security Group associations."

  value = {
    for key, association in azurerm_subnet_network_security_group_association.this : key => {
      id        = association.id
      subnet_id = association.subnet_id
      nsg_id    = association.network_security_group_id
    }
  }
}