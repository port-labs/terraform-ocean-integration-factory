resource "google_pubsub_topic" "ocean_integration_topic" {
  name    = var.ocean_integration_topic_id
  project = var.project
}

resource "google_pubsub_subscription" "ocean_integration_topic_sub" {
  depends_on = [google_pubsub_topic.ocean_integration_topic]
  name       = "${var.ocean_integration_topic_id}_sub"
  project    = var.project
  topic      = google_pubsub_topic.ocean_integration_topic.id
  push_config {
    push_endpoint = var.push_endpoint
  }
}
