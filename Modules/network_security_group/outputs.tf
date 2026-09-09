output "nsgs" {
    description = "output of nsg "

    value = {
        for n , nsg in azurerm_network_security_group.this : n => {

            id = nsg.id
        }

    }
  
}