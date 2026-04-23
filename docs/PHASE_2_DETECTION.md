# Phase 2: Identifying the Breach

## Objective

Add event-driven detection that emits a signal immediately when security-relevant Azure control-plane activity occurs.

## Azure Approach

This phase uses Azure Monitor Activity Log Alerts and an Azure Monitor Action Group.

- Activity Log Alerts provide immediate detection for administrative operations.
- The Action Group provides a consistent routing contract for notifications and future remediation.
- Optional email and webhook receivers let the project route to either a human notification path or an automation endpoint.

## Detection Rules in Scope

- `Microsoft.Storage/storageAccounts/write`
  - Detects changes to the monitored storage account configuration.
  - This is the Azure-equivalent control-plane signal for storage configuration drift.

- `Microsoft.Authorization/roleAssignments/write`
  - Detects new or modified RBAC grants in the Sentinel scope.

- `Microsoft.Authorization/roleAssignments/delete`
  - Detects RBAC assignment removals in the Sentinel scope.

## Routing Contract

The Action Group is the Phase 2 routing target.

- If `notification_email_address` is set, alerts can notify a security team mailbox.
- If `notification_webhook_uri` is set, alerts can be delivered to a future Azure Function or other automation endpoint.

## Milestone Mapping

Phase 2 is satisfied when defined Azure control-plane security events produce a routed signal through the Action Group.

## Handoff to Phase 3

Phase 3 can bind an Azure Function to the Action Group webhook path
and implement remediation logic without reworking the alert definitions.
