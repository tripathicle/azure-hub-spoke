variable "load_balancers" {
  description = "Map of Azure Load Balancers."

  type = map(object({
    name               = string
    resource_group_key = string
    sku                = string

    frontend_ip_configuration = object({
      name                           = string
      public_ip_key                 = optional(string)
      subnet_key                    = optional(string)
      private_ip_address_allocation = optional(string)
      private_ip_address            = optional(string)
    })

    backend_pool = object({
      name     = string
      nic_keys = set(string)
    })

    probe = object({
      protocol     = string
      port         = number
      request_path = string
    })

    rule = object({
      protocol      = string
      frontend_port = number
      backend_port  = number
    })
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


variable "public_ips" {
  description = "Map of public IP addresses."

  type = map(object({
    id   = string
    name = string
  }))
}


variable "nics" {
  description = "Map of network interfaces."

  type = map(object({
    id   = string
    name = string
  }))
}


variable "subnets" {
  description = "Map of subnets."

  type = map(object({
    id   = string
    name = string
  }))
}
