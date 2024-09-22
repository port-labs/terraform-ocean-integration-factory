data "google_projects" "all" {
  filter = "parent.id=${var.organization}"
}

locals {
  has_specific_projects = length(var.projects) > 0
  has_excluded_projects = length(var.excluded_projects) > 0
  filtered_projects     = local.has_excluded_projects ? [for project in data.google_projects.all.projects : project.project_id if !contains(var.excluded_projects, project.project_id)] : []
  included_projects     = local.has_specific_projects ? var.projects : (local.has_excluded_projects ? local.filtered_projects : [])

  should_create_setup_role  = length(local.included_projects) > 0 && !contains(local.included_projects, var.project)
  get_project_permissions   = ["resourcemanager.projects.get", "resourcemanager.projects.list"]
  setup_project_permissions = [for permission in var.permissions : permission if !contains(local.get_project_permissions, permission)]

  custom_role_combinations = length(local.included_projects) > 0 && length(var.custom_roles) > 0 ? flatten([
    for project in local.included_projects : [
      for role in var.custom_roles : {
        project = project
        role    = role
      }
    ]
  ]) : []

}

resource "google_service_account" "ocean_integration_service_account" {
  project      = var.project
  account_id   = var.service_account_id
  display_name = "Ocean Integration Service Account"
}

resource "google_organization_iam_custom_role" "ocean_integration_iam_org_role" {
  title       = "Ocean Integration organization role"
  role_id     = var.role_id
  permissions = var.permissions
  org_id      = var.organization
}

resource "google_organization_iam_member" "ocean_integration_organization_iam_member" {
  count  = length(local.included_projects) == 0 ? 1 : 0
  org_id = var.organization
  role   = google_organization_iam_custom_role.ocean_integration_iam_org_role.name
  member = "serviceAccount:${google_service_account.ocean_integration_service_account.email}"
}

resource "google_organization_iam_member" "ocean_integration_custom_roles_iam_members" {
  count  = length(local.custom_role_combinations) == 0 ? length(var.custom_roles) : 0
  org_id = var.organization
  role   = var.custom_roles[count.index]
  member = "serviceAccount:${google_service_account.ocean_integration_service_account.email}"
}

resource "google_organization_iam_custom_role" "setup_project_iam_org_role" {
  count       = local.should_create_setup_role ? 1 : 0
  title       = "Ocean Integration Setup Project organization role"
  role_id     = "${var.role_id}Setup"
  permissions = local.setup_project_permissions
  org_id      = var.organization
}
resource "google_project_iam_binding" "setup_project_role_binding" {
  count   = local.should_create_setup_role ? 1 : 0
  project = var.project
  role    = google_organization_iam_custom_role.setup_project_iam_org_role[0].name

  members = [
    "serviceAccount:${google_service_account.ocean_integration_service_account.email}"
  ]
}

resource "google_project_iam_binding" "included_projects_role_binding" {
  count = length(local.included_projects)

  project = local.included_projects[count.index]
  role    = google_organization_iam_custom_role.ocean_integration_iam_org_role.name

  members = [
    "serviceAccount:${google_service_account.ocean_integration_service_account.email}"
  ]
}

resource "google_project_iam_binding" "custom_roles_binding_on_setup_project" {
  count   = local.should_create_setup_role && length(var.custom_roles) > 0 ? length(var.custom_roles) : 0
  project = var.project
  role    = var.custom_roles[count.index]

  members = [
    "serviceAccount:${google_service_account.ocean_integration_service_account.email}"
  ]
}


resource "google_project_iam_binding" "custom_roles_bindings_to_included_projects" {
  for_each = { for combo in local.custom_role_combinations : "${combo.project}-${combo.role}" => combo }
  project  = each.value.project
  role     = each.value.role

  members = [
    "serviceAccount:${google_service_account.ocean_integration_service_account.email}"
  ]
}
