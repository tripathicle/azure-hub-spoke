variable "vnet_peerings" {
  description = "Map of Azure VNet peerings."

  type = map(object({
    name                    = string
    source_vnet_key         = string
    remote_vnet_key         = string
    allow_forwarded_traffic = bool
    allow_gateway_transit   = bool
    use_remote_gateways     = bool
  }))
}

variable "vnets" {
  description = "Map of created virtual networks."

  type = map(object({
    id                  = string
    name                = string
    resource_group_name = string
  }))
}