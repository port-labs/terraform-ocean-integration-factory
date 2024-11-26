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

variable "project_filter" {
  description = <<-EOT
    The filter string used to retrieve GCP projects, allowing complex filtering by combining multiple conditions with logical operators (AND | OR). Follows GCP's [filter expressions syntax](https://cloud.google.com/sdk/gcloud/reference/topic/filters). e.g.
    parent.id:184606565139 labels.environment:production AND labels.team:devops
    OR
    labels.priority:high
  EOT
  type        = string
  default     = null
}