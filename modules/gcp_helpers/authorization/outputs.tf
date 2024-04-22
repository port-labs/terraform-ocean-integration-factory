output "service_account_id" {
  value = google_service_account.ocean_integration_service_account.id
}
output "service_account_email" {
  value = google_service_account.ocean_integration_service_account.email
}
output "service_account_name" {
  value = google_service_account.ocean_integration_service_account.account_id
}
