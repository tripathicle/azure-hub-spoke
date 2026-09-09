output "vnets" {
  description = "Map of created virtual networks."

  value = {
    for key, vnet in azurerm_virtual_network.this : key => {
      id                  = vnet.id
      name                = vnet.name
      resource_group_name = vnet.resource_group_name
      location            = vnet.location
    }
  }
}