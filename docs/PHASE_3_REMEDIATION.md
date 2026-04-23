# Phase 3: The First Responder

## Objective

Implement an automated and secure remediation service that responds to Phase 2 detection events in seconds.

## Azure Approach

Phase 3 introduces an Azure Function-based remediation service with a managed identity.

- Azure Function receives Action Group webhook events.
- Function performs targeted remediation for storage and RBAC events.
- Key Vault stores allow-list configuration used by the function.
- RBAC assignments grant least privilege for remediation operations.

## Remediation Actions in Scope

- Storage configuration drift:
  - Trigger: `Microsoft.Storage/storageAccounts/write`
  - Action: enforce safe storage configuration (disable blob public access and keep TLS baseline).

- Over-privileged RBAC assignments:
  - Trigger: `Microsoft.Authorization/roleAssignments/write`
  - Action: remove role assignments if principal and role are not in allow-lists.

## Least-Privilege Access Model

The function managed identity receives:

- `Storage Account Contributor` at monitored storage account scope.
- `User Access Administrator` at Sentinel resource group scope.
- `Key Vault Secrets User` at remediation Key Vault scope.

## Secrets Handling

Allow-lists are read from Key Vault secrets:

- `allowed-principals`
- `allowed-role-definitions`

This avoids hardcoded sensitive control values in function code.

## Milestone Mapping

Phase 3 is satisfied when a secure responder is defined as code with:

- event-triggered remediation logic
- managed identity-based access
- key-vault-backed secret handling
- auditable logging through Application Insights and Log Analytics
