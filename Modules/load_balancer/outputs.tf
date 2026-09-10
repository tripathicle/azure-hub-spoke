output "load_balancers" {
  description = "Map of created load balancers."

  value = {
    for key, lb in azurerm_lb.this : key => {
      id   = lb.id
      name = lb.name
    }
  }
}

output "backend_address_pools" {
  description = "Map of load balancer backend address pools."

  value = {
    for key, pool in azurerm_lb_backend_address_pool.this : key => {
      id   = pool.id
      name = pool.name
    }
  }
}