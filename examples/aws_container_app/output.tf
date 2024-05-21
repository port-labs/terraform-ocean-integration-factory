output "load_balancer_dns_name" {
  value = module.port_ocean_ecs_lb[0].load_balancer_dns_name
  description = "After the installation please create a CNAME record in your DNS provider with this value, more information in https://docs.aws.amazon.com/Route53/latest/DeveloperGuide/resource-record-sets-creating.html"
}