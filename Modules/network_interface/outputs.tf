output "nics" {
  description = "Map of created network interfaces."

  value = {
    for key, nic in azurerm_network_interface.this : key => {
      id   = nic.id
      name = nic.name
    }
  }
}


