variable "api_key_param" {
  description = "API Key for Port AWS Ocean"
  type        = string
  sensitive   = true
}

variable "webhook_url" {
  description = "Webhook URL for Port AWS Ocean"
  type        = string
  default     = "https://<your-app-url>/integration/webhook"
}