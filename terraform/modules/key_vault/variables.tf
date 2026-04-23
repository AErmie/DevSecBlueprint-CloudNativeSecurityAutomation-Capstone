variable "name" {
  description = "Key Vault name."
  type        = string
}

variable "location" {
  description = "Azure region for Key Vault."
  type        = string
}

variable "resource_group_name" {
  description = "Resource group where Key Vault is created."
  type        = string
}

variable "tenant_id" {
  description = "Tenant ID for Key Vault."
  type        = string
}

variable "sku_name" {
  description = "Key Vault SKU name."
  type        = string
  default     = "standard"
}

variable "soft_delete_retention_days" {
  description = "Soft-delete retention for Key Vault."
  type        = number
  default     = 90
}

variable "purge_protection_enabled" {
  description = "Enable purge protection for Key Vault."
  type        = bool
  default     = true
}

variable "public_network_access_enabled" {
  description = "Whether public network access is enabled."
  type        = bool
  default     = true
}

variable "secrets" {
  description = "Map of secrets to create in Key Vault."
  type        = map(string)
  default     = {}
}

variable "tags" {
  description = "Tags to apply to Key Vault resources."
  type        = map(string)
  default     = {}
}
