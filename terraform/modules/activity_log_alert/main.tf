resource "azurerm_monitor_activity_log_alert" "this" {
  name                = var.name
  resource_group_name = var.resource_group_name
  location            = var.location
  scopes              = var.scopes
  description         = var.description
  enabled             = var.enabled
  tags                = var.tags

  criteria {
    category       = var.category
    operation_name = var.operation_name
    level          = var.level
    status         = var.status
  }

  action {
    action_group_id = var.action_group_id
  }
}