output "load_balancer_dns_name" {
  value = module.port_ocean_ecs_lb[0].load_balancer_dns_name
}