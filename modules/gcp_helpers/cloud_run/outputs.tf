output "endpoint" {
    value = google_cloud_run_v2_service.integration_service.uri
}