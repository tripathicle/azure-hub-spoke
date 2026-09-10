variable "bastions" {
  description = "Map of Azure Bastion hosts."

  type = map(object({
    name                   = string
    resource_group_key     = string
    subnet_key             = string
    public_ip_key          = string
    sku                    = string
    copy_paste_enabled     = bool
    file_copy_enabled      = bool
    ip_connect_enabled     = bool
    shareable_link_enabled = bool
    tunneling_enabled      = bool
    scale_units            = number
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

variable "subnets" {
  description = "Map of created subnets."

  type = map(object({
    id   = string
    name = string
  }))
}

variable "pips" {
  description = "Map of created public IP addresses."

  type = map(object({
    id   = string
    name = string
  }))
}