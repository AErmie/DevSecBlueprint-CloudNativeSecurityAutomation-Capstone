locals {
  name_prefix = "${var.environment}${var.project_name}"

  alert_email_receiver = var.notification_email_address == null ? null : {
    name          = "security-email"
    email_address = var.notification_email_address
  }

  alert_webhook_receiver = var.notification_webhook_uri == null ? null : {
    name        = "sentinel-webhook"
    service_uri = var.notification_webhook_uri
  }
}

resource "azurerm_resource_group" "core" {
  name     = "rg-${var.project_name}-${var.environment}"
  location = var.location
  tags     = var.tags
}

module "log_analytics" {
  source = "../../modules/log_analytics"

  name                = "law-${var.project_name}-${var.environment}"
  location            = azurerm_resource_group.core.location
  resource_group_name = azurerm_resource_group.core.name
  retention_in_days   = var.log_analytics_retention_days
  tags                = var.tags
}

module "storage_account" {
  source = "../../modules/storage_account"

  name_prefix                   = local.name_prefix
  resource_group_name           = azurerm_resource_group.core.name
  location                      = azurerm_resource_group.core.location
  public_network_access_enabled = var.storage_public_network_access_enabled
  tags                          = var.tags
}

module "diag_blob" {
  source = "../../modules/diagnostic_logging"

  name                       = "diag-blob-${var.environment}"
  target_resource_id         = module.storage_account.blob_service_resource_id
  log_analytics_workspace_id = module.log_analytics.workspace_id
  log_categories             = ["StorageRead", "StorageWrite", "StorageDelete"]
  metric_categories          = ["Transaction"]
}

module "diag_queue" {
  source = "../../modules/diagnostic_logging"

  name                       = "diag-queue-${var.environment}"
  target_resource_id         = module.storage_account.queue_service_resource_id
  log_analytics_workspace_id = module.log_analytics.workspace_id
  log_categories             = ["StorageRead", "StorageWrite", "StorageDelete"]
  metric_categories          = ["Transaction"]
}

module "diag_table" {
  source = "../../modules/diagnostic_logging"

  name                       = "diag-table-${var.environment}"
  target_resource_id         = module.storage_account.table_service_resource_id
  log_analytics_workspace_id = module.log_analytics.workspace_id
  log_categories             = ["StorageRead", "StorageWrite", "StorageDelete"]
  metric_categories          = ["Transaction"]
}

module "diag_file" {
  source = "../../modules/diagnostic_logging"

  name                       = "diag-file-${var.environment}"
  target_resource_id         = module.storage_account.file_service_resource_id
  log_analytics_workspace_id = module.log_analytics.workspace_id
  log_categories             = ["StorageRead", "StorageWrite", "StorageDelete"]
  metric_categories          = ["Transaction"]
}

module "detection_action_group" {
  source = "../../modules/action_group"

  name                = "ag-${var.project_name}-${var.environment}"
  resource_group_name = azurerm_resource_group.core.name
  short_name          = var.action_group_short_name
  enabled             = var.detection_enabled
  email_receiver      = local.alert_email_receiver
  webhook_receiver    = local.alert_webhook_receiver
  tags                = var.tags
}

module "storage_configuration_change_alert" {
  source = "../../modules/activity_log_alert"

  name                = "alert-storage-config-${var.environment}"
  resource_group_name = azurerm_resource_group.core.name
  location            = azurerm_resource_group.core.location
  scopes              = [module.storage_account.storage_account_id]
  description         = "Detects storage account configuration changes that could introduce security drift."
  enabled             = var.detection_enabled
  category            = "Administrative"
  operation_name      = "Microsoft.Storage/storageAccounts/write"
  action_group_id     = module.detection_action_group.id
  tags                = var.tags
}

module "role_assignment_write_alert" {
  source = "../../modules/activity_log_alert"

  name                = "alert-rbac-write-${var.environment}"
  resource_group_name = azurerm_resource_group.core.name
  location            = azurerm_resource_group.core.location
  scopes              = [azurerm_resource_group.core.id]
  description         = "Detects new or changed RBAC role assignments within the Sentinel resource group scope."
  enabled             = var.detection_enabled
  category            = "Administrative"
  operation_name      = "Microsoft.Authorization/roleAssignments/write"
  action_group_id     = module.detection_action_group.id
  tags                = var.tags
}

module "role_assignment_delete_alert" {
  source = "../../modules/activity_log_alert"

  name                = "alert-rbac-delete-${var.environment}"
  resource_group_name = azurerm_resource_group.core.name
  location            = azurerm_resource_group.core.location
  scopes              = [azurerm_resource_group.core.id]
  description         = "Detects RBAC role assignment removals within the Sentinel resource group scope."
  enabled             = var.detection_enabled
  category            = "Administrative"
  operation_name      = "Microsoft.Authorization/roleAssignments/delete"
  action_group_id     = module.detection_action_group.id
  tags                = var.tags
}
