package sentinel.storage

# Guardrail intent: storage resources should not permit broad unauthenticated paths.
# This policy is written for policy-as-code review and can be evaluated with OPA/Conftest.

deny[msg] {
  input.resource_type == "azurerm_storage_account"
  input.public_network_access_enabled == true
  msg := "Storage account public network access must be reviewed and explicitly justified."
}

deny[msg] {
  input.resource_type == "azurerm_storage_account"
  input.shared_access_key_enabled == true
  msg := "Storage account shared key access must remain disabled unless exception approved."
}
