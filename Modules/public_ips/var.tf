variable "pips" {
  description = "Map of public IP addresses."

  type = map(object({
    name               = string
    resource_group_key = string
    allocation_method  = string
    sku                = string
  }))
}

variable "resource_groups" {
  description = "Map of resource groups."

  type = map(object({
    id       = string
    name     = string
    location = string
  }))
}