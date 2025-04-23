variable "rest_api_name" {
  type        = string
  default     = "port-ocean-aws-exporter"
  description = "The name of the REST API"
}

variable "webhook_url" {
  type        = string
  default     = "https://<your-app-url>/integration/webhook"
  description = "The webhook URL"
}

variable "tags" {
  description = "A map of tags to apply to all resources"
  type        = map(string)
  default     = {}
}
