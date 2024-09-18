variable "port_client_id" {
  type        = string
  description = "The Port client id"
  sensitive   = true
}
variable "port_client_secret" {
  type        = string
  sensitive   = true
  description = "The Port client secret"
}
variable "port_base_url" {
  type        = string
  description = "The Port Base url"
  default     = "https://api.getport.io"
}
variable "gcp_organization" {
  type        = string
  description = "Your Organization Id. Example: 1234567890"
}
variable "gcp_ocean_setup_project" {
  type        = string
  description = "The Project ot create all the Integration's infrastructure (Topic, Subscription, Service account etc.) on. Format - your-project-name"
}
variable "gcp_included_projects" {
  type        = list(string)
  description = "The Projects list you want the integration to collect from"
  default     = []
}
variable "gcp_excluded_projects" {
  type        = list(string)
  description = "The Projects list you want the integration NOT to collect from"
  default     = []
}
variable "assets_types_for_monitoring" {
  type    = list(string)
  default = null
}
variable "ocean_integration_service_account_permissions" {
  type    = list(string)
  default = null
}
variable "assets_feed_topic_id" {
  type    = string
  default = null
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
variable "gcp_ocean_integration_image" {
  type        = string
  description = "The Artifact Registry / Dockerhub image to deploy. Run docker pull --platform=linux/amd64 ghcr.io/port-labs/port-ocean-gcp and then push it to your preffered registry. For example: europe-west2-docker.pkg.dev/<project_id>/<your-artifact-registry>/<your_image_id>@sha256:123456789mysha987654321 OR europe-west2-docker.pkg.dev/<project_id>/<your-artifact-registry>/<your_image_id>"
}

variable "gcp_ocean_integration_cloud_run_location" {
  type    = string
  default = "europe-west1"
}

variable "environment_variables" {
  type    = list(map(string))
  default = null
}
variable "initialize_port_resources" {
  type        = bool
  default     = true
  description = "If true, the module will create the port resources required for the integration"
}
variable "event_listener" {
  type = object({
    type = string

    # POLLING
    resync_on_start = optional(bool)
    interval        = optional(number)

    # WEBHOOK
    app_host = optional(string)


    # KAFKA
    brokers                  = optional(list(string))
    security_protocol        = optional(list(string))
    authentication_mechanism = optional(list(string))
    kafka_security_enabled   = optional(list(bool))
    consumer_poll_timeout    = optional(list(number))
  })

  default = {
    type = "POLLING"
  }
  description = "The event listener configuration"
}

variable "integration_identifier" {
  type        = string
  description = "The identifier of the integration"
}

variable "integration_version" {
  type        = string
  default     = "latest"
  description = "The version of the integration to deploy"
}
variable "integration_type" {
  type        = string
  description = "The type of the integration"
  default     = "gcp"
}
variable "scheduled_resync_interval" {
  type        = number
  default     = 1440
  description = "The interval to resync the integration (in minutes)"
}

variable "ocean_service_account_custom_roles" {
  type        = list(string)
  description = "A list of custom roles you want to grant the Integration's Service account. The module will grant these permissions to every available project and to the setup project `gcp_ocean_setup_project`. Example value: [\"organizations/1234567890/roles/MyCustomRole\", \"organizations/1234567890/roles/MyOtherCustomRole\"]"
  default     = []
}
