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

  remediation_key_vault_name = lower(substr(replace("kv-${var.project_name}-${var.environment}", "_", "-"), 0, 24))

  remediation_secret_values = {
    "allowed-principals"       = var.remediation_allowed_principal_ids_csv
    "allowed-role-definitions" = var.remediation_allowed_role_definition_ids_csv
  }
}

data "azurerm_client_config" "current" {}

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

module "remediation_key_vault" {
  source = "../../modules/key_vault"
  count  = var.remediation_enabled ? 1 : 0

  name                = local.remediation_key_vault_name
  location            = azurerm_resource_group.core.location
  resource_group_name = azurerm_resource_group.core.name
  tenant_id           = data.azurerm_client_config.current.tenant_id
  secrets             = local.remediation_secret_values
  tags                = var.tags
}

module "remediation_function" {
  source = "../../modules/remediation_function"
  count  = var.remediation_enabled ? 1 : 0

  name                                 = "func-${var.project_name}-${var.environment}"
  location                             = azurerm_resource_group.core.location
  resource_group_name                  = azurerm_resource_group.core.name
  subscription_id                      = data.azurerm_client_config.current.subscription_id
  service_plan_name                    = "asp-${var.project_name}-${var.environment}"
  service_plan_sku                     = var.remediation_service_plan_sku
  application_insights_name            = "appi-${var.project_name}-${var.environment}"
  function_storage_name_prefix         = "funcstore${var.environment}${var.project_name}"
  log_analytics_workspace_id           = module.log_analytics.workspace_id
  monitored_storage_account_id         = module.storage_account.storage_account_id
  monitored_storage_resource_group     = azurerm_resource_group.core.name
  key_vault_uri                        = module.remediation_key_vault[0].vault_uri
  allowed_principals_secret_name       = "allowed-principals"
  allowed_role_definitions_secret_name = "allowed-role-definitions"
  enforce_rbac_remediation             = var.remediation_enforce_rbac
  remediate_storage_public_access      = var.remediation_storage_public_access
  additional_app_settings = {
    "WEBSITE_CONTENTAZUREFILECONNECTIONSTRING" = ""
    "WEBSITE_CONTENTSHARE"                     = ""
  }
  tags = var.tags
}

resource "azurerm_role_assignment" "remediation_storage_account_contributor" {
  count = var.remediation_enabled ? 1 : 0

  scope                = module.storage_account.storage_account_id
  role_definition_name = "Storage Account Contributor"
  principal_id         = module.remediation_function[0].principal_id
}

resource "azurerm_role_assignment" "remediation_user_access_administrator" {
  count = var.remediation_enabled ? 1 : 0

  scope                = azurerm_resource_group.core.id
  role_definition_name = "User Access Administrator"
  principal_id         = module.remediation_function[0].principal_id
}

resource "azurerm_role_assignment" "remediation_key_vault_secrets_user" {
  count = var.remediation_enabled ? 1 : 0

  scope                = module.remediation_key_vault[0].vault_id
  role_definition_name = "Key Vault Secrets User"
  principal_id         = module.remediation_function[0].principal_id
}
