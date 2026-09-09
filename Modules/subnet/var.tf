variable "subnets" {
  description = "Map of subnets."

  type = map(object({
    name                = string
    resource_group_key  = string
    virtual_network_key = string
    address_prefixes    = list(string)
  }))
}

variable "resource_groups" {
  description = "Map of resource groups."

  type = map(object({
    name     = string
    location = string
  }))
}

variable "vnets" {
  description = "Map of virtual networks."

  type = map(object({
    name     = string
    id       = string
    location = string
  }))
}