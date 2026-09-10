resource "azurerm_linux_virtual_machine" "this" {
  for_each = var.vms

  name                = each.value.name
  resource_group_name = var.resource_groups[each.value.resource_group_key].name
  location            = var.resource_groups[each.value.resource_group_key].location
  size                = each.value.size

  admin_username = each.value.admin_username

  admin_ssh_key {
    username   = each.value.admin_username
    public_key = each.value.admin_ssh_public_key
  }

  network_interface_ids = [
    var.nics[each.value.nic_key].id
  ]

  disable_password_authentication = true

  os_disk {
    caching              = each.value.os_disk.caching
    storage_account_type = each.value.os_disk.storage_account_type
  }

  source_image_reference {
    publisher = each.value.source_image_reference.publisher
    offer     = each.value.source_image_reference.offer
    sku       = each.value.source_image_reference.sku
    version   = each.value.source_image_reference.version
  }
}