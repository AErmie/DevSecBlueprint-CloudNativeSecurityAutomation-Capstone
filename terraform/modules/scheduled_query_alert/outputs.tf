output "id" {
  description = "Scheduled query alert resource ID."
  value       = azurerm_monitor_scheduled_query_rules_alert_v2.this.id
}

output "name" {
  description = "Scheduled query alert name."
  value       = azurerm_monitor_scheduled_query_rules_alert_v2.this.name
}
