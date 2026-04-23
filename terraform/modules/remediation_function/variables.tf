variable "name" {
  description = "Function App name."
  type        = string
}

variable "location" {
  description = "Azure region for Function App resources."
  type        = string
}

variable "resource_group_name" {
  description = "Resource group where Function App is created."
  type        = string
}

variable "subscription_id" {
  description = "Azure subscription ID used by remediation code."
  type        = string
}

variable "service_plan_name" {
  description = "Service plan name for Function App."
  type        = string
}

variable "service_plan_sku" {
  description = "Service plan SKU (FC1 preferred for flex consumption)."
  type        = string
  default     = "FC1"
}

variable "application_insights_name" {
  description = "Application Insights name for Function App telemetry."
  type        = string
}

variable "function_storage_name_prefix" {
  description = "Prefix for Function App runtime storage account."
  type        = string
}

variable "log_analytics_workspace_id" {
  description = "Log Analytics workspace ID for Application Insights workspace-based mode."
  type        = string
}

variable "monitored_storage_account_id" {
  description = "Resource ID for the monitored storage account."
  type        = string
}

variable "monitored_storage_resource_group" {
  description = "Resource group for the monitored storage account."
  type        = string
}

variable "key_vault_uri" {
  description = "Key Vault URI used by remediation function."
  type        = string
}

variable "allowed_principals_secret_name" {
  description = "Secret name containing comma-separated allowed principal IDs."
  type        = string
}

variable "allowed_role_definitions_secret_name" {
  description = "Secret name containing comma-separated allowed role definition IDs."
  type        = string
}

variable "enforce_rbac_remediation" {
  description = "Whether RBAC remediation actions are enabled."
  type        = bool
  default     = true
}

variable "remediate_storage_public_access" {
  description = "Whether storage public access remediation is enabled."
  type        = bool
  default     = true
}

variable "additional_app_settings" {
  description = "Additional app settings to inject into Function App."
  type        = map(string)
  default     = {}
}

variable "tags" {
  description = "Tags to apply to Function resources."
  type        = map(string)
  default     = {}
}
