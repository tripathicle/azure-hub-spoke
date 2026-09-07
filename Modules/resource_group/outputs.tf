output "resource_group_names" {
    description = "Names of all Resource Groups"

    value = {
      
      for k , rg in azurerm_resource_group.this :
      k => rg.name


    }
  
}