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
