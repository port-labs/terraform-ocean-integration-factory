resource "google_pubsub_topic" "ocean_integration_topic" {
  name                       = var.ocean_integration_topic_id
  project                    = var.project
  message_retention_duration = var.retention
}

resource "google_pubsub_subscription" "ocean_integration_topic_sub" {
  name    = "${var.ocean_integration_topic_id}-sub"
  project = var.project
  topic   = google_pubsub_topic.ocean_integration_topic.id
  push_config {
    push_endpoint = var.push_endpoint
    oidc_token {
      service_account_email = var.service_account_email
    }
  }
  retry_policy {
    minimum_backoff = "10s"
    maximum_backoff = "600s"
  }
  message_retention_duration = var.retention
}
