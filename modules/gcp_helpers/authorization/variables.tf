variable "role_id" {
  type = string
}
variable "service_account_id" {
  type = string
}
variable "organization" {
  type = string
}
variable "project" {
  type = string
}
variable "permissions" {
  type = list(string)
}
variable "projects" {
  type    = list(string)
  default = []
}

variable "excluded_projects" {
  type    = list(string)
  default = []
}

variable "project_label_filters" {
  description = "Optional map of label key-value pairs to filter projects"
  type        = map(string)
  default     = {}
}

variable "custom_roles" {
  type    = list(string)
  default = []
}

variable "create_role" {
  type        = bool
  description = "Whether to create the organizational role"
  default     = true
}

variable "create_service_account" {
  type        = bool
  description = "Flag to indicate whether or not to create a service account"
  default     = true
}
