output "storage_account_id" {
  description = "Storage account resource ID."
  value       = azurerm_storage_account.this.id
}

output "storage_account_name" {
  description = "Storage account name."
  value       = azurerm_storage_account.this.name
}

output "blob_service_resource_id" {
  description = "Resource ID for the blob service default endpoint."
  value       = "${azurerm_storage_account.this.id}/blobServices/default"
}

output "queue_service_resource_id" {
  description = "Resource ID for the queue service default endpoint."
  value       = "${azurerm_storage_account.this.id}/queueServices/default"
}

output "table_service_resource_id" {
  description = "Resource ID for the table service default endpoint."
  value       = "${azurerm_storage_account.this.id}/tableServices/default"
}

output "file_service_resource_id" {
  description = "Resource ID for the file service default endpoint."
  value       = "${azurerm_storage_account.this.id}/fileServices/default"
}
