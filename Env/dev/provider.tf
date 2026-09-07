terraform {
  #which provder you want to call
  required_providers {
    #azure
     azurerm = {
      #source of azurerm 
      source = "hashicorp/azurerm"
      #version of azurerm
      version = "5.4.0"
     }
  }
}

# Configure the Microsoft Azure Provider
provider "azurerm" {
  features {}
  subscription_id = "2e24e6a2-184c-415a-858d-2f97d8b1ba27"
}
