variable "api_destination_arn" {
  description = "The ARN of the API Destination"
  type        = string
}

variable "api_destination_name" {
  description = "The name of the API Destination"
  type        = string
}

variable "api_destinations_role_arn" {
  description = "The API Key parameter"
  type        = string
}

variable "event_bus_name" {
  description = "The name of the Event Bus"
  type        = string
  default     = "default"
}