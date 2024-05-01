variable "ocean_integration_topic_id" {
  type = string
}
variable "push_endpoint" {
  type        = string
  description = "The webhook endpoints for the push subscriber"
}
variable "project" {
  type = string
}

variable "service_account_email" {
  type = string
}

variable "retention" {
  type    = string
  default = "7200s" # 2 Hours
}
