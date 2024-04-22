resource "google_service_account" "ocean_integration_service_account" {
  project      = var.project
  account_id   = var.service_account_id
  display_name = "Ocean Integration Service Account"
}

resource "google_organization_iam_custom_role" "ocean_integration_iam_org_role" {
  title       = "The Ocean Integration organization role"
  role_id     = var.role_id
  permissions = var.permissions
  org_id      = var.organization
}

resource "google_service_account_iam_binding" "ocean_integration_iam_org_binding" {
  service_account_id = google_service_account.ocean_integration_service_account.name
  role               = google_organization_iam_custom_role.ocean_integration_iam_org_role.name
  members            = []
}


# Uncomment & Copy this these if you want to give permissions to specific projects

# resource "google_project_iam_custom_role" "iam_project_role" {
#   title       = "The Ocean Integration organization role"
#   role_id     = var.role_id
#   permissions = []
#   project     = local.project_name
# }


# resource "google_service_account_iam_binding" "iam_project_binding" {
#   depends_on         = [google_service_account.service_account, google_organization_iam_custom_role.iam_project_role]
#   service_account_id = google_service_account.service_account.name
#   role               = google_project_iam_custom_role.iam_project_role.name
#   members            = []
# }
