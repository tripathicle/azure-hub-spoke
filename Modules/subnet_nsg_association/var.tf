variable "subnet_nsg_associations" {
  description = "Map of subnet to Network Security Group associations."

  type = map(object({
    subnet_key = string
    nsg_key    = string
  }))
}

variable "subnets" {
  description = "Map of created subnets."

  type = map(object({
    id = string
  }))
}

variable "nsgs" {
  description = "Map of created Network Security Groups."

  type = map(object({
    id = string
  }))
}