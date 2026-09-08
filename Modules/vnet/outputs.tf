output "output_vnets" {
  description = "output of vnets"

  value = {
    for v, vnet in azurerm_virtual_network.this : v => {
      id                  = vnet.id
      name                = vnet.name
      resource_group_name = vnet.resource_group_name
    }
  }
}