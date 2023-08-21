variable "port_client_id" {
  type = string
  description = "The Port client id"
}

variable "port_client_secret" {
  type = string
  description = "The Port client secret"
}

variable "port_base_url" {
  type = string
  default = "https://api.getport.io"
  description = "The Port base url, if not provided the module will use the prod url"
}

variable "initialize_port_resources" {
    type = bool
    default = true
    description = "If true, the module will initialize the default port resources (blueprints and relations)"
}

variable "integration_identifier" {
    type = string
    description = "The identifier of the integration"
}

variable "integration_type" {
    type = string
    description = "The type of the integration"
}

variable "integration_version" {
  type    = string
  default = "latest"
  description = "The version of the integration to deploy"
}

variable "location" {
  type    = string
  default = "East US"
  description = "The location to deploy the container to"
}

variable "image" {
  type = string
  default = ""
  description = "The image that the integration will use, if not provided the module will use the latest image"
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

variable "resource_group_name" {
  type    = string
  default = null
  description = "The resource group to deploy the container to and where the role definition will be created"
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

variable "hosting_subscription_id" {
  type    = string
  default = null
  description = "The subscription to deploy the infrastructure to, e.g (1231-1231-1231-1231-1231)"
}

variable "needs_assigned_identity"{
  type = bool
  default = false
  description = "If true, the module will create an identity for the integration and assign it to the container"
}