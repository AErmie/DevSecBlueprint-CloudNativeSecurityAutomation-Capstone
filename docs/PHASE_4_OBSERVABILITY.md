# Phase 4: Total Visibility

## Objective

Provide end-to-end observability for detection and remediation activity with centralized logs, alerts, and a visual dashboard.

## Azure Approach

Phase 4 uses Azure Monitor and Log Analytics query-based monitoring.

- Centralized logs are already routed to Log Analytics from storage diagnostics and remediation telemetry.
- Scheduled Query Alerts create notification signals for high-priority conditions.
- A workbook provides security event and remediation trend visualization.

## Observability Components

- `azurerm_monitor_scheduled_query_rules_alert_v2` for query-driven alerts.
- `azurerm_application_insights_workbook` for security dashboards.
- Existing Action Group routing from Phase 2 for consistent alert delivery.

## Alerts in Scope

- Security event volume alert:
  - Monitors tracked storage and RBAC operation signals.

- Remediation failure alert:
  - Monitors for "Remediation failed" traces from the function runtime.

## Dashboard Scope

The workbook includes trend views for:

- Security events over time by operation type.
- Remediation failures over time.

## Milestone Mapping

Phase 4 is satisfied when all automated security actions are observable
through centralized logs, actionable alerts, and a shared dashboard.
