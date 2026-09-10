variable "vms" {
  description = "Map of virtual machines."

  type = map(object({
    name               = string
    resource_group_key = string
    nic_key            = string

    size = string

    admin_username       = string
    admin_ssh_public_key = string

    os_disk = object({
      caching              = string
      storage_account_type = string
    })

    source_image_reference = object({
      publisher = string
      offer     = string
      sku       = string
      version   = string
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

variable "nics" {
  description = "Map of created network interfaces."

  type = map(object({
    id   = string
    name = string
  }))
}