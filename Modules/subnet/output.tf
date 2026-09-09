output "subnets" {
  description = "subnet output"

  value = {
    for s, subnet in azurerm_subnet.this : s => {
      id   = subnet.id
      name = subnet.name


    }

  }

}

