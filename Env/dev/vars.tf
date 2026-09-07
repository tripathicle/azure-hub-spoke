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
      name = string
      location = string
      resource_group_name = string
      address_space = list(string)
      
    }))
  
}