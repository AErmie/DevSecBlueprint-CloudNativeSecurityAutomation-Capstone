resource "random_uuid" "workbook" {}

resource "azurerm_application_insights_workbook" "this" {
  name                = random_uuid.workbook.result
  location            = var.location
  resource_group_name = var.resource_group_name
  display_name        = var.display_name
  source_id           = var.source_id
  data_json           = var.data_json
  tags                = var.tags
}
