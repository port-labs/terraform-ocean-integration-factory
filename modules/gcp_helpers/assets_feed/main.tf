resource "google_cloud_asset_organization_feed" "ocean_integration_assets_feed" {
  count           = length(var.projects) == 0 ? 1 : 0
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
  count           = length(var.projects)
  project         = var.projects[count.index]
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
