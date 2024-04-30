resource "google_cloud_asset_organization_feed" "ocean_integration_assets_feed" {
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
  condition {
    expression = "'organizations/${var.organization}' in temporal_asset.asset.ancestors"
  }
}
