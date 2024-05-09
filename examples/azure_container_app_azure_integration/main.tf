data "azurerm_subscription" "current_subscription" {}

locals {
  # splits the list into chunks of 25 elements, due to the limit of 25 elements in the advanced filtering for each subscription filter
  # https://learn.microsoft.com/en-us/azure/event-grid/event-filtering#limitations
  chunked_resources_filter_values = chunklist(var.resources_filter_values, 25)
  # creates a dictionary with the index of the chunk as key and the chunk as value
  chunked_resouces_filter_dict = { for i in range(length(local.chunked_resources_filter_values)) : i => local.chunked_resources_filter_values[i] }
}


module "ocean_integration" {
  source       = "../../modules/azure_container_app"

  # required port parameters so that the integration could communicate with Port
  port = {
    client_id     = var.port_client_id
    client_secret = var.port_client_secret
    base_url = var.port_base_url
  }

  initialize_port_resources = var.initialize_port_resources
  event_listener = var.event_listener

  # required port integration parameters so Port could identify the integration
  integration = {
    type       = var.integration_type
    identifier = var.integration_identifier
    config     = {
    }
  }
  integration_version = var.integration_version

  permissions_scope = var.permissions_scope
  needs_assigned_identity = var.needs_assigned_identity
  resource_group_name = var.resource_group_name
  subscription_id = var.hosting_subscription_id
  location = var.location

  image = var.image

  permissions = {
    actions = var.action_permissions_list
    not_actions = []
    data_actions = []
    not_data_actions = []
  }
  additional_environment_variables = var.additional_environment_variables
  additional_secrets = var.additional_secrets
}

resource "azurerm_eventgrid_system_topic" "subscription_event_grid_topic" {
  # if the event grid topic name is not provided, the module will create a new one
  depends_on = [module.ocean_integration]
  count               = var.event_grid_system_topic_name != "" ? 0 : 1
  name                = "subscription-event-grid-topic"
  resource_group_name = module.ocean_integration.resource_group_name
  location            = "Global"
  topic_type = "Microsoft.Resources.Subscriptions"
  source_arm_resource_id = module.ocean_integration.subscription_id
}


resource "azurerm_eventgrid_system_topic_event_subscription" "subscription_event_grid_topic_subscription" {
  # creates a subscription for each chunk of filter values ( 25 per chunk )
  for_each            = local.chunked_resouces_filter_dict
  name                = replace(replace("ocean-${module.ocean_integration.integration.type}-${module.ocean_integration.integration.identifier}-subscription-${each.key}","_", "-"),".","-")
  resource_group_name = var.event_grid_resource_group != "" ? var.event_grid_resource_group: module.ocean_integration.resource_group_name
  system_topic        = var.event_grid_system_topic_name != "" ? var.event_grid_system_topic_name : azurerm_eventgrid_system_topic.subscription_event_grid_topic[0].name

  included_event_types = var.included_event_types
  event_delivery_schema = "CloudEventSchemaV1_0"
  webhook_endpoint {
        url = "https://${module.ocean_integration.container_app_latest_fqdn}/integration/events"
    }
  advanced_filtering_on_arrays_enabled = true
  advanced_filter {
    string_contains {
      key    = "data.operationName"
      values = each.value
    }
  }
  delivery_property {
    header_name = "Access-Control-Request-Method"
    type        = "Static"
    value       = "POST"
  }
  delivery_property {
    header_name = "Origin"
    type        = "Static"
    value       = "azure"
  }
}
