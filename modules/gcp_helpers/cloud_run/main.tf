resource "google_cloud_run_v2_service" "integration_service" {
  name     = var.cloud_run_service_name
  location = var.location
  project  = var.project
  template {
    containers {
      image = var.image
      resources {
        limits = {
          cpu    = "2"
          memory = "1024Mi"
        }
      }
      ports {
        container_port = var.port
      }
      dynamic "env" {
        for_each = var.environment_variables
        content {
          name  = env.value.name
          value = env.value.value
        }
      }
      startup_probe {
        initial_delay_seconds = 20
        timeout_seconds       = 1
        period_seconds        = 3
        failure_threshold     = 1
        http_get {
          path = "/docs"
        }
      }
    }

    scaling {
      min_instance_count = 1
      max_instance_count = 1
    }
    service_account = var.service_account_name
  }
  traffic {
    type    = "TRAFFIC_TARGET_ALLOCATION_TYPE_LATEST"
    percent = 100
  }
  ingress = "INGRESS_TRAFFIC_ALL"
}
