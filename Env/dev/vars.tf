variable "resource_groups" {
description = "Map of Resource Groups"
  type = map(object({
    name     = string
    location = string
  }))

}