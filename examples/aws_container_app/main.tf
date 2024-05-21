provider "aws" {
  profile = "port-admin"
  region  = "eu-west-1"
}

locals {
  security_groups = concat(
    var.additional_security_groups,
    var.allow_incoming_requests ? module.port_ocean_ecs_lb[0].security_groups : []
  )
}

module "port_ocean_ecs_lb" {
  count                   = var.allow_incoming_requests ? 1 : 0
  source                  = "./modules/ecs_lb"
  vpc_id                  = var.vpc_id
  subnets                 = var.subnets
  certificate_domain_name = var.certificate_domain_name
}


module "port_ocean_ecs" {
  source = "./modules/ecs_service"

  subnets      = var.subnets
  cluster_name = var.cluster_name


  lb_targ_group_arn          = var.allow_incoming_requests ? module.port_ocean_ecs_lb[0].target_group_arn : ""
  additional_security_groups = local.security_groups

  image_registry = var.image_registry

  port = {
    client_id     = var.port.client_id
    client_secret = var.port.client_secret
  }

  integration_version       = var.integration_version
  initialize_port_resources = var.initialize_port_resources
  event_listener            = var.event_listener

  integration = {
    type       = var.integration.type
    identifier = var.integration.identifier
    config = var.allow_incoming_requests ? merge({
      app_host = module.port_ocean_ecs_lb[0].dns_name
    }, var.integration.config) : var.integration.config
  }
}

module "api_destinations" {
  source        = "./modules/api_destinations"
  api_key_param = var.integration.config.live_events_api_key
  webhook_url   = var.allow_incoming_requests ? module.port_ocean_ecs_lb[0].dns_name : ""
}

module "events" {
  source = "./modules/events"

  api_destination_arn       = module.api_destinations.api_destination.arn
  api_destination_name      = module.api_destinations.api_destination.name
  api_destinations_role_arn = module.api_destinations.api_destinations_role.arn
}