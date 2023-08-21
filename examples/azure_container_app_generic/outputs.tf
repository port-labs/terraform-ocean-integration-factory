output "container_app_latest_fqdn" {
  value = module.ocean_integration.container_app_latest_fqdn
}

output "container_app_outbound_ip_addresses" {
  value = module.ocean_integration.container_app_outbound_ip_addresses
}

output "container_latest_revision_name" {
  value = module.ocean_integration.container_latest_revision_name
}

output "resource_group_name" {
  value = module.ocean_integration.resource_group_name
}

output "location" {
  value = var.location
}

output "integration" {
  value = module.ocean_integration.integration
}