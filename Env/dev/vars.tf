variable "resource_groups" {
  description = "Map of Resource Groups"
  type = map(object({
    name     = string
    location = string
  }))

}

# STEP 2: STORAGE ACCOUNTS
variable "storageaccounts" {
  description = "map of storage account"
  type = map(object({
    name                     = string
    resource_group_name      = string
    location                 = string
    account_tier             = string
    account_replication_type = string




  }))

}

# STEP 3: VIRTUAL NETWORKS

variable "vnets" {
  description = "map of vnets"
  type = map(object({
    name                = string
    location            = string
    resource_group_name = string
    address_space       = list(string)

  }))

}

# STEP 4: SUBNETS
variable "subnets" {
  description = "map of subnets"
  type = map(object({
    name                 = string
    resource_group_name  = string
    virtual_network_name = string
    address_prefixes     = list(string)
  }))

}

# STEP 4: PUBLIC PIPS
variable "pips" {
  description = "public ip"
  type = map(object({
    name                = string
    location            = string
    resource_group_name = string
    allocation_method   = string
  }))


}

#NICS

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

variable "subnet_nsg_associations" {
  description = "Map of subnet to Network Security Group associations."

  type = map(object({
    subnet_key = string
    nsg_key    = string
  }))
}