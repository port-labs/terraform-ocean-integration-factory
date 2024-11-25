variable "assets_feed_id" {
  type        = string
  description = "The identifier for the asset feed"
}
variable "billing_project" {
  type        = string
  description = "The project which has connected billing account"
}
variable "organization" {
  type        = string
  description = "The organization to the organization feed"
}
variable "feed_topic_project" {
  type        = string
  description = "The project hosting the topic that digests events"
}
variable "feed_topic" {
  type        = string
  description = "The events digesting topic"
}
variable "asset_types" {
  type = list(string)
}

variable "projects" {
  type    = list(string)
  default = []
}

variable "excluded_projects" {
  type    = list(string)
  default = []
}

variable "project_label_filters" {
  description = "Optional map of label key-value pairs to filter projects"
  type        = map(string)
  default     = {}
}