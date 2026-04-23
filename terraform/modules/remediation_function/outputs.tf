output "function_app_id" {
  description = "Function App resource ID."
  value       = azurerm_linux_function_app.this.id
}

output "function_app_name" {
  description = "Function App name."
  value       = azurerm_linux_function_app.this.name
}

output "principal_id" {
  description = "Managed identity principal ID for the Function App."
  value       = azurerm_linux_function_app.this.identity[0].principal_id
}

output "default_hostname" {
  description = "Default hostname for the Function App."
  value       = azurerm_linux_function_app.this.default_hostname
}

output "webhook_url_template" {
  description = "Webhook URL template for action group integration."
  value       = "https://${azurerm_linux_function_app.this.default_hostname}/api/remediationWebhook"
}
