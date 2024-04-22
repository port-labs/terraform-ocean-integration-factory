resource "google_cloud_run_service" "integration_service" {
  name     = var.cloud_run_service_name
  location = var.location
  project  = var.project
  template {
    metadata {
      annotations = {
        "autoscaling.knative.dev/minScale" = 1
        "autoscaling.knative.dev/maxScale" = 1
      }
    }
    spec {
      service_account_name = var.service_account_name
      containers {
        image = var.image

        dynamic "env" {
          for_each = var.environment_variables
          content {
            name  = env.value.name
            value = env.value.value
          }
        }
        ports {
          container_port = var.port
        }
        startup_probe {
          initial_delay_seconds = 5
          timeout_seconds       = 1
          period_seconds        = 3
          failure_threshold     = 1
          http_get {
            path = "/docs"
          }
        }
      }
    }
  }
  traffic {
    percent         = 100
    latest_revision = true
  }
}
