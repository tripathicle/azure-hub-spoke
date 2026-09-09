variable "vnets" {
  description = "Map of virtual networks."

  type = map(object({
    name               = string
    resource_group_key = string
    address_space      = list(string)
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