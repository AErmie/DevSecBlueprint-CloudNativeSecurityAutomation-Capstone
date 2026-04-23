variable "name" {
  description = "Diagnostic setting name."
  type        = string
}

variable "target_resource_id" {
  description = "Resource ID where diagnostic settings are applied."
  type        = string
}

variable "log_analytics_workspace_id" {
  description = "Destination Log Analytics workspace ID."
  type        = string
}

variable "log_categories" {
  description = "Log categories to forward."
  type        = list(string)
  default     = []
}

variable "metric_categories" {
  description = "Metric categories to forward."
  type        = list(string)
  default     = []
}
