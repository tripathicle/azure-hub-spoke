output "bastions" {
  description = "Map of created Azure Bastion hosts."

  value = {
    for key, bastion in azurerm_bastion_host.this : key => {
      id                  = bastion.id
      name                = bastion.name
      resource_group_name = bastion.resource_group_name
      location            = bastion.location
    }
  }
}