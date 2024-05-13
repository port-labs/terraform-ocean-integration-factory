locals {
  envs = var.environment_variables != null ? var.environment_variables : [
    {
      name  = "PORT_CLIENT_ID",
      value = var.port_client_id
      }, {
      name  = "PORT_CLIENT_SECRET",
      value = var.port_client_secret
  }]
  feed_topic_id = var.assets_feed_topic_id != null ? var.assets_feed_topic_id : "ocean-integration-topic"
  permissions = var.ocean_permissions != null ? var.ocean_permissions : ["cloudasset.assets.exportResource",
    "cloudasset.assets.listCloudAssetFeeds",
    "cloudasset.assets.listResource",
    "cloudasset.assets.searchAllResources",
    "cloudasset.feeds.create",
    "cloudasset.feeds.list",
    "pubsub.topics.list",
    "pubsub.topics.get",
    "resourcemanager.projects.get",
    "resourcemanager.projects.list",
    "resourcemanager.folders.get",
    "resourcemanager.folders.list",
    "resourcemanager.organizations.get",
    "run.routes.invoke",
  "run.jobs.run"]
  asset_types = var.assets_types_for_monitoring != null ? var.assets_types_for_monitoring : [
    "cloudresourcemanager.googleapis.com/Organization",
    "cloudresourcemanager.googleapis.com/Project",
    "storage.googleapis.com/Bucket",
    "cloudfunctions.googleapis.com/CloudFunction",
    "pubsub.googleapis.com/Subscription",
    "pubsub.googleapis.com/Topic"
  ]
  service_account_id = var.service_account_name != null ? var.service_account_name : "ocean-service-account"
  role_id            = var.role_name != null ? var.role_name : "OceanIntegrationRole"
}
module "port_ocean_authorization" {
  source             = "../../modules/gcp_helpers/authorization"
  permissions        = local.permissions
  service_account_id = local.service_account_id
  role_id            = local.role_id
  organization       = var.organization
  project            = var.ocean_project
  projects           = var.projects
}
module "port_ocean_pubsub" {
  source                     = "../../modules/gcp_helpers/pubsub"
  push_endpoint              = "${module.port_ocean_cloud_run.endpoint}/integration/events"
  ocean_integration_topic_id = local.feed_topic_id
  project                    = var.ocean_project
  service_account_email      = module.port_ocean_authorization.service_account_email
}

module "port_ocean_assets_feed" {
  source             = "../../modules/gcp_helpers/assets_feed"
  feed_topic_project = var.ocean_project
  billing_project    = var.ocean_project
  assets_feed_id     = var.assets_feed_id
  projects           = var.projects
  feed_topic         = module.port_ocean_pubsub.ocean_topic_name
  organization       = var.organization
  asset_types        = local.asset_types
  depends_on         = [module.port_ocean_cloud_run]
}
resource "time_sleep" "wait_for_authentication_to_take_affect" {
  depends_on      = [module.port_ocean_authorization]
  create_duration = "180s"
}
module "port_ocean_cloud_run" {
  source                = "../../modules/gcp_helpers/cloud_run"
  service_account_name  = module.port_ocean_authorization.service_account_name
  environment_variables = local.envs
  project               = var.ocean_project
  image                 = var.image
  depends_on            = [time_sleep.wait_for_authentication_to_take_affect]
}
