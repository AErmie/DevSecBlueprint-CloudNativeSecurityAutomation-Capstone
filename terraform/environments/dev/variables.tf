variable "environment" {
  description = "Environment name."
  type        = string
  default     = "dev"
}

variable "project_name" {
  description = "Project short name used in resource naming."
  type        = string
  default     = "sentinel"
}

variable "location" {
  description = "Azure region for all resources."
  type        = string
  default     = "eastus2"
}

variable "log_analytics_retention_days" {
  description = "Retention period for Log Analytics."
  type        = number
  default     = 90
}

variable "storage_public_network_access_enabled" {
  description = "Enable public network access for storage account."
  type        = bool
  default     = true
}

variable "detection_enabled" {
  description = "Enable Phase 2 detection resources."
  type        = bool
  default     = true
}

variable "action_group_short_name" {
  description = "Short name for the Azure Monitor Action Group."
  type        = string
  default     = "sentinelag"
}

variable "notification_email_address" {
  description = "Optional email receiver for detection alerts."
  type        = string
  default     = null
  nullable    = true
}

variable "notification_webhook_uri" {
  description = "Optional webhook receiver URI for detection alerts and future automation."
  type        = string
  default     = null
  nullable    = true
}

variable "remediation_enabled" {
  description = "Enable Phase 3 remediation resources."
  type        = bool
  default     = true
}

variable "remediation_service_plan_sku" {
  description = "SKU for the remediation Function service plan."
  type        = string
  default     = "FC1"
}

variable "remediation_enforce_rbac" {
  description = "Whether RBAC remediation is enabled in the function app."
  type        = bool
  default     = true
}

variable "remediation_storage_public_access" {
  description = "Whether storage public-access remediation is enabled."
  type        = bool
  default     = true
}

variable "remediation_allowed_principal_ids_csv" {
  description = "Comma-separated allowed principal IDs for RBAC remediation."
  type        = string
  default     = ""
}

variable "remediation_allowed_role_definition_ids_csv" {
  description = "Comma-separated allowed role definition IDs for RBAC remediation."
  type        = string
  default     = ""
}

variable "tags" {
  description = "Required tags for all resources."
  type        = map(string)
  default = {
    Environment        = "dev"
    Project            = "OperationSentinel"
    Owner              = "SecurityEngineering"
    CostCenter         = "TBD"
    DataClassification = "Confidential"
  }
}
