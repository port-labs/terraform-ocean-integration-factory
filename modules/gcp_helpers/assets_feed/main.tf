data "google_projects" "all" {
  filter = local.project_filter
}

locals {
  label_filter = var.project_label_filter != null ? " labels.${var.project_label_filter.key}:${var.project_label_filter.value}" : ""
  project_filter = "parent.id:'${var.organization}'${local.label_filter}"
  
  has_specific_projects = length(var.projects) > 0
  has_excluded_projects = length(var.excluded_projects) > 0
  filtered_projects     = local.has_excluded_projects ? [for project in data.google_projects.all.projects : project.project_id if !contains(var.excluded_projects, project.project_id)] : []

  included_projects = local.has_specific_projects ? var.projects : (local.has_excluded_projects ? local.filtered_projects : [])
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
  count           = length(local.included_projects)
  project         = local.included_projects[count.index]
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
