variable "name" {
  description = "Scheduled query alert name."
  type        = string
}

variable "location" {
  description = "Azure region for the alert resource."
  type        = string
}

variable "resource_group_name" {
  description = "Resource group where the alert is created."
  type        = string
}

variable "scopes" {
  description = "Resource IDs for query scope, typically Log Analytics workspaces."
  type        = list(string)
}

variable "description" {
  description = "Alert description."
  type        = string
}

variable "severity" {
  description = "Alert severity from 0 to 4."
  type        = number
  default     = 2
}

variable "enabled" {
  description = "Whether the alert is enabled."
  type        = bool
  default     = true
}

variable "evaluation_frequency" {
  description = "How often the alert query is evaluated."
  type        = string
  default     = "PT5M"
}

variable "window_duration" {
  description = "Time window over which the query is evaluated."
  type        = string
  default     = "PT5M"
}

variable "query" {
  description = "KQL query used to detect conditions."
  type        = string
}

variable "time_aggregation_method" {
  description = "Aggregation method for evaluated query output."
  type        = string
  default     = "Count"
}

variable "threshold" {
  description = "Numeric threshold for alert triggering."
  type        = number
  default     = 0
}

variable "operator" {
  description = "Comparison operator for threshold evaluation."
  type        = string
  default     = "GreaterThan"
}

variable "action_group_ids" {
  description = "Action Group IDs to notify when alert triggers."
  type        = list(string)
  default     = []
}

variable "auto_mitigation_enabled" {
  description = "Automatically resolve alerts when condition clears."
  type        = bool
  default     = true
}

variable "skip_query_validation" {
  description = "Skip KQL query validation at creation time."
  type        = bool
  default     = false
}

variable "tags" {
  description = "Tags for the alert resource."
  type        = map(string)
  default     = {}
}
