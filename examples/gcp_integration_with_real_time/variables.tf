variable "port_client_id" {
  type        = string
  description = "The Port client id"
  sensitive = true
}
variable "port_client_secret" {
  type        = string
  sensitive = true
  description = "The Port client secret"
}
variable "organization" {
  type        = string
  description = "Your Organization Id. Example: 1234567890"
}
variable "ocean_project" {
  type        = string
  description = "The Project ot create all the Integration's infrastructure (Topic, Subscription, Service account etc.) on. Format - your-project-name"
}
variable "assets_types_for_monitoring" {
  type    = list(string)
  default = null
}
variable "ocean_permissions" {
  type    = list(string)
  default = null
}
variable "assets_feed_topic_id" {
  type        = string
  default     = null
}
variable "assets_feed_id" {
  type        = string
  default     = "ocean-gcp-integration-assets-feed"
  description = "The ID for the Ocean GCP Integration feed"
}
variable "service_account_name" {
  type    = string
  default = null
}
variable "role_name" {
  type    = string
  default = null
}
variable "image" {
  type        = string
  description = "The Artifact Registry / Dockerhub image to deploy. Run docker pull --platform=linux/amd64 ghcr.io/port-labs/port-ocean-gcp and then push it to your preffered registry. For example: europe-west2-docker.pkg.dev/<project_id>/<your-artifact-registry>/<your_image_id>@sha256:123456789mysha987654321 OR europe-west2-docker.pkg.dev/<project_id>/<your-artifact-registry>/<your_image_id>"
}
variable "environment_variables" {
  type    = list(map(string))
  default = null
}
