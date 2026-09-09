output "pips" {
  description = "Map of created public IP addresses."

  value = {
    for key, pip in azurerm_public_ip.this : key => {
      id   = pip.id
      name = pip.name
    }
  }
}