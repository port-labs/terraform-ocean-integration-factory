data "google_projects" "all" {
  filter = "parent.id=${var.organization}"
}

data "external" "get_projects_feed" {
  for_each = toset(local.included_projects)
  program = ["python3", "${path.module}/external/main.py"]

  query = {
    feed_id = var.assets_feed_id
    project = each.key
  }
}

data "external" "check_org_asset_feed" {
  program = ["python3", "${path.module}/external/main.py"]

  query = {
    feed_id     = var.assets_feed_id
    organization = var.organization
  }
}

locals {
  has_specific_projects = length(var.projects) > 0
  has_excluded_projects = length(var.excluded_projects) > 0
  filtered_projects     = local.has_excluded_projects ? [for project in data.google_projects.all.projects : project.project_id if !contains(var.excluded_projects, project.project_id)] : []

  included_projects = local.has_specific_projects ? var.projects : (local.has_excluded_projects ? local.filtered_projects : [])

  projects_without_feed = toset([
    for project in local.included_projects : project
    if data.external.get_projects_feed[project].result.exists == "false"
  ])
}

resource "google_cloud_asset_organization_feed" "ocean_integration_assets_feed" {
  count           = data.external.check_org_asset_feed.result.exists == "false" && length(local.projects_without_feed) == 0 ? 1 : 0
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
  for_each        = toset(local.projects_without_feed)
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
