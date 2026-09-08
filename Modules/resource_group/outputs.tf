output "resource_groups" {
  description = "Map of created Resource Groups."

  value = {
    for key, rg in azurerm_resource_group.this : key => {
      id       = rg.id
      name     = rg.name
      location = rg.location
    }
  }
}