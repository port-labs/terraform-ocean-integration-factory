data "google_projects" "all" {
  filter = "parent.id=${var.organization}"
}

data "external" "get_projects_feed" {
  for_each = toset(local.included_projects)
  program = ["python3", "${path.module}/external/main.py"]

  query = {
    feed_id = var.assets_feed_id
    project = each.key
    tag = var.integration_identifier
    tag_resource = local.tag_resource
  }
}

data "external" "check_org_asset_feed" {
  program = ["python3", "${path.module}/external/main.py"]

  query = {
    feed_id     = var.assets_feed_id
    organization = var.organization
    tag = var.integration_identifier
    tag_resource = local.tag_resource
  }
}

locals {
  has_specific_projects = length(var.projects) > 0
  has_excluded_projects = length(var.excluded_projects) > 0
  filtered_projects     = local.has_excluded_projects ? [for project in data.google_projects.all.projects : project.project_id if !contains(var.excluded_projects, project.project_id)] : []

  included_projects = local.has_specific_projects ? var.projects : (local.has_excluded_projects ? local.filtered_projects : [])

  project_feeds_managed_by_terraform = toset([
    for project in local.included_projects : project
    if data.external.get_projects_feed[project].result.managed_by_terraform == "true"
  ])
  create_org_feed = data.external.check_org_asset_feed.result.managed_by_terraform == "true" && length(local.project_feeds_managed_by_terraform) == 0
  tag_resource = "cloudresourcemanager.googleapis.com"
}

resource "google_tags_tag_key" "key" {
  parent = "organizations/${var.organization}"
  short_name = "managed-by"
  description = "Indicates which integration manages this resource"
}

resource "google_tags_tag_value" "value" {
  parent = "tagKeys/${google_tags_tag_key.key.name}"
  short_name  = var.integration_identifier
  description = "Tag value for integration ${var.integration_identifier}"
}

resource "google_tags_tag_binding" "project_binding" {
  for_each = toset(local.project_feeds_managed_by_terraform)
  parent = "//${local.tag_resource}/projects/${each.key}"
  tag_value = "tagValues/${google_tags_tag_value.value.name}"
}

resource "google_tags_tag_binding" "organization_binding" {
  count = length(local.project_feeds_managed_by_terraform) == 0 ? 1 : 0
  parent = "//${local.tag_resource}/organizations/${var.organization}"
  tag_value = "tagValues/${google_tags_tag_value.value.name}"
}


resource "google_cloud_asset_organization_feed" "ocean_integration_assets_feed" {
  count  = local.create_org_feed ? 1 : 0
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
  for_each        = toset(local.project_feeds_managed_by_terraform)
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
