output "pip_output" {
  description = "pip output"

  value = {
    for p, pips in azurerm_public_ip.this : p => {
      id   = pips.id
      name = pips.name

    }
  }


}