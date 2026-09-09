output "vnet_peerings" {
  description = "Map of created VNet peerings."

  value = {
    for key, peering in azurerm_virtual_network_peering.this : key => {
      id   = peering.id
      name = peering.name
    }
  }
}