variable "service_account_name" {
  type= string
}
variable "project" {
  type = string
}
variable "image" {
  type = string
}
variable "cloud_run_memory" {
  type = string
}
variable "cloud_run_cpu" {
  type = string
}
variable "environment_variables" {
  type    = list(map(string))
  default = null
}
variable "cloud_run_service_name" {
  type = string
  default = "ocean-gcp-integration-service"
}
variable "location" {
  type        = string
  default     = "europe-west1"
}
variable "port" {
  type = number
  default = 8000
}
