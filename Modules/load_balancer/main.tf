resource "azurerm_lb" "this" {
  for_each = var.load_balancers

  name                = each.value.name
  location            = var.resource_groups[each.value.resource_group_key].location
  resource_group_name = var.resource_groups[each.value.resource_group_key].name
  sku                 = each.value.sku

  frontend_ip_configuration {
    name                 = each.value.frontend_ip_configuration.name
    public_ip_address_id = var.public_ips[each.value.frontend_ip_configuration.public_ip_key].id
  }
}

resource "azurerm_lb_backend_address_pool" "this" {
  for_each = var.load_balancers

  name            = each.value.backend_pool.name
  loadbalancer_id = azurerm_lb.this[each.key].id
}

resource "azurerm_network_interface_backend_address_pool_association" "this" {
  for_each = var.load_balancers

  network_interface_id    = var.nics[each.value.backend_pool.nic_key].id
  ip_configuration_name   = "internal"
  backend_address_pool_id = azurerm_lb_backend_address_pool.this[each.key].id
}

resource "azurerm_lb_probe" "this" {
  for_each = var.load_balancers

  name                = "${each.value.name}-health-probe"
  loadbalancer_id     = azurerm_lb.this[each.key].id
  protocol            = "Http"
  port                = 80
  request_path        = "/"
}

resource "azurerm_lb_rule" "this" {
  for_each = var.load_balancers

  name                           = "${each.value.name}-http-rule"
  loadbalancer_id                = azurerm_lb.this[each.key].id
  protocol                      = "Tcp"
  frontend_port                 = 80
  backend_port                  = 80
  frontend_ip_configuration_name = each.value.frontend_ip_configuration.name
  backend_address_pool_ids       = [
    azurerm_lb_backend_address_pool.this[each.key].id
  ]
  probe_id = azurerm_lb_probe.this[each.key].id
}