variable "event_listener" {
  type = object({
    type = string

    # POLLING
    resync_on_start = optional(bool)
    interval        = optional(number)

    # WEBHOOK
    app_host = optional(string)


    # KAFKA
    brokers                  = optional(string)
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

variable "additional_secrets" {
  type = map(string)
  default = {}
  description = "Additional secrets to be injected into the container, the key of the map is the name of the secret and will be the environment variable name, e.g. {MY_SECRET: \"my-secret\"}"
}

variable "additional_environment_variables" {
  type = map(string)
  default = {}
  description = "Additional environment variables to be injected into the container"
}

variable "port" {
  type = object({
    client_id     = string
    client_secret = string
    base_url      = optional(string, "https://api.getport.io")
  })
  description = "The port configuration, this is used to authenticate with the port API"
}

variable "initialize_port_resources" {
  type    = bool
  default = false
  description = "If true, the module will create the port resources required for the integration"
}

variable "scheduled_resync_interval" {
  type    = number
  default = 1440
  description = "The interval to resync the integration (in minutes)"
}

variable "integration_version" {
  type    = string
  default = "latest"
  description = "The version of the integration to deploy"
}

variable "integration" {
  type = object({
    identifier = optional(string)
    type       = string
    config     = map(any)
  })
  description = "The integration configuration, this is used to configure the integration and register it with port"
}

variable "assign_public_ip" {
  type    = bool
  default = true
  description = "If true, the container will be assigned a public IP"
}

variable "container_port" {
  default = 8000
  description = "The port the container will listen on"
}

variable "image_registry" {
  type    = string
  default = "ghcr.io/port-labs"
  description = "The image registry to pull the image from"
}

variable "location" {
  type    = string
  default = "West US 2"
  description = "The location to deploy the container to"
}

variable "resource_group_name" {
  type    = string
  default = null
  description = "The name of the resource group to deploy the container to"
}

variable "container_app_environment_id" {
  type    = string
  default = null
  description = "The ID of the container app environment to deploy the container to, if not provided, a new container app environment will be created"
}

variable "log_analytics_workspace_id" {
  type    = string
  default = null
  description = "The ID of the log analytics workspace to send logs to, if not provided, log analytics will be created"
}

variable "cpu" {
  type    = string
  default = "1.0"
  description = "The CPU to allocate to the container"
}

variable "memory" {
  type    = string
  default = "2Gi"
  description = "The memory to allocate to the container"
}

variable "image" {
  type    = string
  default = null
  description = "The image to deploy, if not provided, the latest image of the integration will be deployed"
}

variable "min_replicas" {
  type    = number
  default = 1
  description = "The minimum number of replicas to deploy"
}

variable "max_replicas" {
  type    = number
  default = 1
  description = "The maximum number of replicas to deploy"
}

variable "user_assigned_identity_ids" {
  type    = list(string)
  default = []
  description = "The IDs of the user assigned identities to assign to the container"
}

variable "user_assigned_client_id" {
  type    = string
  default = null
  description = "The client ID of the user assigned identity to assign to the container"
}
