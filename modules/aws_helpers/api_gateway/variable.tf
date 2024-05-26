variable "rest_api_name" {
  description = "The name of the REST API"
  type        = string
  default     = "port-ocean-aws-exporter"
}

variable "webhook_url" {
  description = "The webhook URL"
  type        = string
  default     = "https://<your-app-url>/integration/webhook"
}