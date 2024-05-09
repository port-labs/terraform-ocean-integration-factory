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
