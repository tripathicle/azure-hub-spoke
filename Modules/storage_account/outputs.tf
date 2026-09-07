output "storageaccounts" {
    description = "All storageaccounts attributes"

    value = {

        # for k , stg in azurerm_storage_account.this :

        # k =>stg.name

        for k , stg in azurerm_storage_account.this : k=>{
            
            id = stg.id
            name = stg.name
            location = stg.location
            resource_group_name = stg.resource_group_name


        }
        



    

    }
  
}