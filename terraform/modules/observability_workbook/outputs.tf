output "id" {
  description = "Workbook resource ID."
  value       = azurerm_application_insights_workbook.this.id
}

output "name" {
  description = "Workbook UUID name."
  value       = azurerm_application_insights_workbook.this.name
}

output "display_name" {
  description = "Workbook display name."
  value       = azurerm_application_insights_workbook.this.display_name
}
