variable "storageaccounts" {
  description = "Map of storage accounts."

  type = map(object({
    name                     = string
    resource_group_key       = string
    account_tier             = string
    account_replication_type = string
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