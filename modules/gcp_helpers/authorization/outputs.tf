output "service_account_id" {
  description = "The ID of the service account."
  value = (var.create_service_account
    ? google_service_account.ocean_integration_service_account[0].id
    : data.google_service_account.existing_service_account[0].id)
}
output "service_account_email" {
  description = "The email address of the service account being used."
  value       = local.service_account_email
}
output "service_account_name" {
  description = "The account ID (name) of the service account."
  value = (var.create_service_account
    ? google_service_account.ocean_integration_service_account[0].account_id
    : data.google_service_account.existing_service_account[0].account_id)
}
