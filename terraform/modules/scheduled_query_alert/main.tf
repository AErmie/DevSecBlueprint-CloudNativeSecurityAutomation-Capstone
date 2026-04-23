resource "azurerm_monitor_scheduled_query_rules_alert_v2" "this" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name
  scopes              = var.scopes
  description         = var.description
  severity            = var.severity
  enabled             = var.enabled
  evaluation_frequency = var.evaluation_frequency
  window_duration      = var.window_duration
  auto_mitigation_enabled = var.auto_mitigation_enabled
  skip_query_validation   = var.skip_query_validation
  tags                   = var.tags

  criteria {
    query                   = var.query
    time_aggregation_method = var.time_aggregation_method
    threshold               = var.threshold
    operator                = var.operator
  }

  action {
    action_groups = var.action_group_ids
  }
}
