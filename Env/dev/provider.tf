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
  subscription_id = "ee2ae788-9582-4219-9666-16d19b8ebd6e"
}
