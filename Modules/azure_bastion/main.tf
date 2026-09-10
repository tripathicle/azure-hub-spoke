resource "azurerm_bastion_host" "this" {
  for_each = var.bastions

  name                = each.value.name
  location            = var.resource_groups[each.value.resource_group_key].location
  resource_group_name = var.resource_groups[each.value.resource_group_key].name

  sku = each.value.sku

  copy_paste_enabled     = each.value.copy_paste_enabled
  file_copy_enabled      = each.value.file_copy_enabled
  ip_connect_enabled     = each.value.ip_connect_enabled
  shareable_link_enabled = each.value.shareable_link_enabled
  tunneling_enabled      = each.value.tunneling_enabled
  scale_units            = each.value.scale_units

  ip_configuration {
    name = "${each.value.name}-ipconfig"

    subnet_id = var.subnets[
      each.value.subnet_key
    ].id

    public_ip_address_id = var.pips[
      each.value.public_ip_key
    ].id
  }
}