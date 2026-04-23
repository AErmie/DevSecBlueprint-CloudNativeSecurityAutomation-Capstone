variable "name_prefix" {
  description = "Prefix used to generate a compliant storage account name."
  type        = string
}

variable "resource_group_name" {
  description = "Resource group that contains the storage account."
  type        = string
}

variable "location" {
  description = "Azure region for the storage account."
  type        = string
}

variable "account_tier" {
  description = "Storage account tier."
  type        = string
  default     = "Standard"
}

variable "account_replication_type" {
  description = "Replication type for the storage account."
  type        = string
  default     = "LRS"
}

variable "account_kind" {
  description = "Storage account kind."
  type        = string
  default     = "StorageV2"
}

variable "access_tier" {
  description = "Default access tier for blob data."
  type        = string
  default     = "Hot"
}

variable "public_network_access_enabled" {
  description = "Whether public network access is enabled."
  type        = bool
  default     = true
}

variable "blob_delete_retention_days" {
  description = "Retention in days for blob delete protection."
  type        = number
  default     = 14
}

variable "tags" {
  description = "Tags applied to the storage account."
  type        = map(string)
  default     = {}
}
