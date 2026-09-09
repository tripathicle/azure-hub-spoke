variable "nics" {
  description = "nics"

  type = map(object({
    name = string
    # location            = string
    # resource_group_name = string
    resource_group_key = string
    subnet_key         = string

    ip_configuration = object({
      name                          = string
      private_ip_address_allocation = string
      private_ip_address            = optional(string)

    })



  }))

}


variable "resource_groups" {
  description = "Map of resource groups."

  type = map(object({
    name     = string
    location = string
  }))
}

variable "subnets" {
  description = "Map of subnets."

  type = map(object({
    id = string
  }))
}