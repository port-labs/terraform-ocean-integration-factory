data "google_projects" "all" {
  filter =  coalesce(var.project_filter, "parent.id=${var.organization}")
}


locals {
  has_specific_projects = length(var.projects) > 0
  has_excluded_projects = length(var.excluded_projects) > 0
  has_project_filter    = var.project_filter != null

  # Safely get list of accessible projects, handling potential 403s
  accessible_projects = try(data.google_projects.all.projects[*].project_id, [])
  
  filtered_projects = local.has_excluded_projects ? [
    for project in local.accessible_projects : project 
    if !contains(var.excluded_projects, project)
  ] : local.accessible_projects

  validated_projects = local.has_specific_projects ? [
    for project in var.projects : project
    if contains(local.accessible_projects, project)
  ] : []

  included_projects = local.has_specific_projects ? local.validated_projects : (local.has_project_filter ? local.filtered_projects : [])
}

resource "google_cloud_asset_organization_feed" "ocean_integration_assets_feed" {
  count           = length(local.included_projects) == 0 ? 1 : 0
  billing_project = var.billing_project
  feed_id         = var.assets_feed_id
  org_id          = var.organization
  content_type    = "RESOURCE"

  asset_types = var.asset_types

  feed_output_config {
    pubsub_destination {
      topic = "projects/${var.feed_topic_project}/topics/${var.feed_topic}"
    }
  }
}

resource "google_cloud_asset_project_feed" "ocean_integration_per_project_feed" {
  for_each        = toset(local.included_projects)
  project         = each.key
  billing_project = var.billing_project
  feed_id         = var.assets_feed_id
  content_type    = "RESOURCE"

  asset_types = var.asset_types

  feed_output_config {
    pubsub_destination {
      topic = "projects/${var.feed_topic_project}/topics/${var.feed_topic}"
    }
  }
}
