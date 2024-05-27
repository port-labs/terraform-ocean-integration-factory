variable "name" {
  type        = string
  description = "The name of the event"
}

variable "description" {
  type        = string
  description = "The description of the event"
}

variable "event_pattern_source" {
  type        = list(string)
  description = "The source of the event"
  default     = []
}

variable "detail_type" {
  type        = list(string)
  description = "The detail type of the event"
  default     = []
}

variable "event_source" {
  type        = list(string)
  description = "The event source"
  default     = []
}

variable "event_name" {
  type        = list(object({
    name = optional(string)
    prefix = optional(string)
  }))
  description = "The event name"
  default     = []
}

variable "input_paths" {
  type = object({
    account_id    = string,
    aws_region    = string,
    event_name    = string,
    identifier    = string,
    resource_type = string,
  })
  description = "The input paths"
}

variable "target_arn" {
  type        = string
  description = "The ARN of the target"
}

variable "api_key_param" {
  type        = string
  description = "The API Key parameter"
}