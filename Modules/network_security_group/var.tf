variable "nsgs" {
  description = "Map of Network Security Groups."

  type = map(object({
    name               = string
    resource_group_key = string

    security_rules = map(object({
      name      = string
      priority  = number
      direction = string
      access    = string
      protocol  = string

      source_port_ranges      = list(string)
      destination_port_ranges = list(string)

      source_address_prefixes      = list(string)
      destination_address_prefixes = list(string)

      description = optional(string)
    }))
  }))
}

variable "resource_groups" {
  description = "Map of Resource Groups."

  type = map(object({
    id       = string
    name     = string
    location = string
  }))
}


































# variable "nsgs" {
#   description = "map of nsgs"
#   type = map(object({
#     name               = string
#     resource_group_key = string

#     security_rules = map(object({
#       name               = string
#       priority           = string
#       direction          = string
#       access             = string
#       protocall          = string
#       source_port_range  = optional(string)
#       source_port_ranges = optional(list(string))

#       destination_port_range  = optional(string)
#       destination_port_ranges = optional(list(string))

#       source_address_prefix   = optional(string)
#       source_address_prefixes = optional(list(string))

#       destination_address_prefix   = optional(string)
#       destination_address_prefixes = optional(list(string))

#       description = optional(string)

#     }))


#   }))
# }

# variable "resource_groups" {
#   description = "Map of Resource Groups."

#   type = map(object({
#     id       = string
#     name     = string
#     location = string
#   }))
# }