resource "azurerm_lb" "this" {

  for_each = var.load_balancers

  name                = each.value.name
  location            = var.resource_groups[each.value.resource_group_key].location
  resource_group_name = var.resource_groups[each.value.resource_group_key].name
  sku                 = each.value.sku

  frontend_ip_configuration {

    name = each.value.frontend_ip_configuration.name

    public_ip_address_id = try(
      var.public_ips[each.value.frontend_ip_configuration.public_ip_key].id,
      null
    )

    subnet_id = try(
      var.subnets[each.value.frontend_ip_configuration.subnet_key].id,
      null
    )

    private_ip_address_allocation = try(
      each.value.frontend_ip_configuration.private_ip_address_allocation,
      null
    )

    private_ip_address = try(
      each.value.frontend_ip_configuration.private_ip_address,
      null
    )
  }
}


resource "azurerm_lb_backend_address_pool" "this" {

  for_each = var.load_balancers

  name            = each.value.backend_pool.name
  loadbalancer_id = azurerm_lb.this[each.key].id
}


resource "azurerm_network_interface_backend_address_pool_association" "this" {

  for_each = {
    for association in flatten([
      for lb_key, lb in var.load_balancers : [
        for nic_key in lb.backend_pool.nic_keys : {
          association_key = length(lb.backend_pool.nic_keys) == 1 ? lb_key : "${lb_key}-${nic_key}"
          lb_key          = lb_key
          nic_key         = nic_key
        }
      ]
    ]) : association.association_key => association
  }

  network_interface_id = var.nics[each.value.nic_key].id

  ip_configuration_name = "internal"

  backend_address_pool_id = azurerm_lb_backend_address_pool.this[
    each.value.lb_key
  ].id
}


resource "azurerm_lb_probe" "this" {

  for_each = var.load_balancers

  name            = "${each.value.name}-health-probe"
  loadbalancer_id = azurerm_lb.this[each.key].id

  protocol     = each.value.probe.protocol
  port         = each.value.probe.port
  request_path = each.value.probe.request_path
}


resource "azurerm_lb_rule" "this" {

  for_each = var.load_balancers

  name = "${each.value.name}-http-rule"

  loadbalancer_id = azurerm_lb.this[each.key].id

  protocol      = each.value.rule.protocol
  frontend_port = each.value.rule.frontend_port
  backend_port  = each.value.rule.backend_port

  frontend_ip_configuration_name = each.value.frontend_ip_configuration.name

  backend_address_pool_ids = [
    azurerm_lb_backend_address_pool.this[each.key].id
  ]

  probe_id = azurerm_lb_probe.this[each.key].id
}