locals {
  name_prefix = "${var.environment}${var.project_name}"
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
