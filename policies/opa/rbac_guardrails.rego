package sentinel.rbac

import rego.v1

# Guardrail intent: avoid wildcard privilege and broad role assignment scope.

deny contains msg if {
  input.resource_type == "azurerm_role_assignment"
  lower(input.role_definition_name) == "owner"
  msg := "Owner role assignments are prohibited in Sentinel automation scope."
}

deny contains msg if {
  input.resource_type == "azurerm_role_assignment"
  contains(lower(input.scope), "/subscriptions/")
  not contains(lower(input.scope), "/resourcegroups/")
  msg := "Subscription-scope role assignments are prohibited."
}
