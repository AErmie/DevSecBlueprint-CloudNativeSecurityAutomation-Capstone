output "resource_group_name" {
  description = "Resource group used for Phase 1 resources."
  value       = azurerm_resource_group.core.name
}

output "storage_account_id" {
  description = "Storage account resource ID."
  value       = module.storage_account.storage_account_id
}

output "storage_account_name" {
  description = "Storage account name."
  value       = module.storage_account.storage_account_name
}

output "blob_service_resource_id" {
  description = "Blob service resource ID used by diagnostics and Phase 2 detection."
  value       = module.storage_account.blob_service_resource_id
}

output "log_analytics_workspace_id" {
  description = "Log Analytics workspace resource ID."
  value       = module.log_analytics.workspace_id
}
