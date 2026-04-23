# Phase 1: Foundation Setup

## Objective

Create an Azure-first baseline where monitored resources and audit logging are fully defined as code.

## In Scope

- Azure provider and Terraform layout.
- Storage account as monitored resource.
- Diagnostic logging to Log Analytics.
- Repository governance and validation automation.

## Out of Scope

- Live deployment of resources.
- Event detection rules.
- Remediation function.
- Dashboards and alert routing.

## Milestone Mapping

The Phase 1 milestone is met when every action against the monitored resource
can be routed into centralized logs via configured diagnostic settings.

## Output Contract for Phase 2

Phase 2 will consume these outputs from `terraform/environments/dev`:

- `resource_group_name`
- `storage_account_id`
- `blob_service_resource_id`
- `log_analytics_workspace_id`

These outputs provide the IDs needed to wire detection rules
without reworking Phase 1 modules.
