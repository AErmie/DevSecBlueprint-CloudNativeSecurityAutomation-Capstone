resource "random_string" "storage_suffix" {
  length  = 5
  special = false
  upper   = false
  numeric = true
}

locals {
  function_storage_account_name = lower(substr(replace("${var.function_storage_name_prefix}${random_string.storage_suffix.result}", "-", ""), 0, 24))
}

resource "azurerm_storage_account" "function" {
  name                              = local.function_storage_account_name
  resource_group_name               = var.resource_group_name
  location                          = var.location
  account_tier                      = "Standard"
  account_replication_type          = "LRS"
  account_kind                      = "StorageV2"
  min_tls_version                   = "TLS1_2"
  allow_nested_items_to_be_public   = false
  shared_access_key_enabled         = true
  public_network_access_enabled     = true
  cross_tenant_replication_enabled  = false
  infrastructure_encryption_enabled = true
  tags                              = var.tags
}

resource "azurerm_service_plan" "function" {
  name                = var.service_plan_name
  resource_group_name = var.resource_group_name
  location            = var.location
  os_type             = "Linux"
  sku_name            = var.service_plan_sku
  tags                = var.tags
}

resource "azurerm_application_insights" "function" {
  name                = var.application_insights_name
  location            = var.location
  resource_group_name = var.resource_group_name
  application_type    = "web"
  workspace_id        = var.log_analytics_workspace_id
  tags                = var.tags
}

resource "azurerm_linux_function_app" "this" {
  name                        = var.name
  location                    = var.location
  resource_group_name         = var.resource_group_name
  service_plan_id             = azurerm_service_plan.function.id
  storage_account_name        = azurerm_storage_account.function.name
  storage_account_access_key  = azurerm_storage_account.function.primary_access_key
  functions_extension_version = "~4"
  https_only                  = true

  identity {
    type = "SystemAssigned"
  }

  site_config {
    ftps_state = "Disabled"

    application_stack {
      node_version = "20"
    }
  }

  app_settings = merge(
    {
      "FUNCTIONS_WORKER_RUNTIME"                  = "node"
      "WEBSITE_RUN_FROM_PACKAGE"                  = "1"
      "APPLICATIONINSIGHTS_CONNECTION_STRING"     = azurerm_application_insights.function.connection_string
      "AZURE_SUBSCRIPTION_ID"                     = var.subscription_id
      "SECURITY_STORAGE_ACCOUNT_ID"               = var.monitored_storage_account_id
      "SECURITY_STORAGE_ACCOUNT_RESOURCE_GROUP"   = var.monitored_storage_resource_group
      "KEY_VAULT_URI"                             = var.key_vault_uri
      "ALLOWED_PRINCIPALS_SECRET_NAME"            = var.allowed_principals_secret_name
      "ALLOWED_ROLE_DEFINITIONS_SECRET_NAME"      = var.allowed_role_definitions_secret_name
      "ENFORCE_RBAC_REMEDIATION"                  = tostring(var.enforce_rbac_remediation)
      "REMEDIATE_STORAGE_PUBLIC_ACCESS"           = tostring(var.remediate_storage_public_access)
      "FUNCTIONS_NODE_BLOCK_ON_ENTRY_POINT_ERROR" = "true"
    },
    var.additional_app_settings
  )

  tags = var.tags
}
