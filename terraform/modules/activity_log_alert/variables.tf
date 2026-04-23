variable "name" {
  description = "Activity Log Alert name."
  type        = string
}

variable "resource_group_name" {
  description = "Resource group where the alert resource is created."
  type        = string
}

variable "location" {
  description = "Azure region used for the alert resource metadata."
  type        = string
}

variable "scopes" {
  description = "List of Azure resource IDs used as alert scopes."
  type        = list(string)
}

variable "description" {
  description = "Alert description."
  type        = string
}

variable "enabled" {
  description = "Whether the alert is enabled."
  type        = bool
  default     = true
}

variable "category" {
  description = "Activity Log category to monitor."
  type        = string
  default     = "Administrative"
}

variable "operation_name" {
  description = "Operation name to match in the Activity Log."
  type        = string
}

variable "level" {
  description = "Optional Activity Log level filter."
  type        = string
  default     = null
}

variable "status" {
  description = "Optional Activity Log status filter."
  type        = string
  default     = null
}

variable "action_group_id" {
  description = "Action Group resource ID that receives the alert."
  type        = string
}

variable "tags" {
  description = "Tags applied to the alert resource."
  type        = map(string)
  default     = {}
}