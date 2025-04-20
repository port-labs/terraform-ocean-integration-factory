variable "target_arn" {
  type        = string
  description = "The ARN of the target"
}

variable "api_key_param" {
  type        = string
  description = "The API Key parameter"
}


#TODO: implment Variable in main.tf of module
variable "tags" {
  description = "A map of tags to apply to all resources"
  type        = map(string)
  default     = {}
}
