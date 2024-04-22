output "endpoint" {
    value = google_cloud_run_service.integration_service.status.0.url
}