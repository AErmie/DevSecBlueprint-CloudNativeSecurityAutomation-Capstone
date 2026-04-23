# Operation Sentinel: Cloud-Native Security Automation (Azure)

This repository implements an Azure-first Security as Code blueprint for a self-healing cloud environment.

## Mission

Project Sentinel builds a cloud security control plane that can:

1. Detect risky infrastructure changes.
2. Trigger automated remediation.
3. Record all actions for audit and reporting.
4. Enforce guardrails through IaC and policy-as-code.

This project was delivered in phases, with each phase implemented on its own branch and merged to `main`.

## Cloud Mapping (AWS -> Azure)

- `S3 bucket` -> `Azure Storage Account (Blob service)`
- `CloudTrail` -> `Azure Activity Log + Azure Monitor Diagnostic Settings`
- `EventBridge` -> `Event Grid / Activity Log Alerts`
- `Lambda` -> `Azure Functions`
- `CloudWatch` -> `Azure Monitor + Log Analytics`
- `IAM roles` -> `Azure RBAC`
- `Secrets Manager` -> `Azure Key Vault`

## Phase Model

- `phase-1-foundation`: Provider baseline, monitored resource, and audit logging.
- `phase-2-detection`: Event rules and secure signal routing.
- `phase-3-remediation`: Automated first responder.
- `phase-4-observability`: Dashboards, alerts, and trend visibility.
- `phase-5-policy-as-code`: Compliance gates and policy enforcement.

## Current Status

- Phase 1 completed: Azure foundation, monitored resource, and audit logging.
- Phase 2 completed: event detection and secure signal routing.
- Phase 3 completed: automated remediation and secure responder runtime.
- Phase 4 completed: centralized observability, alerts, and dashboard reporting.
- Phase 5 completed: policy-as-code gates and compliance enforcement.

## Repository Layout

```text
.
|-- .github/
|   `-- workflows/
|-- docs/
|-- functions/
|   `-- remediation/
|-- policies/
|   `-- opa/
|-- terraform/
|   |-- environments/dev/
|   `-- modules/
|       |-- action_group/
|       |-- activity_log_alert/
|       |-- diagnostic_logging/
|       |-- key_vault/
|       |-- log_analytics/
|       |-- observability_workbook/
|       |-- remediation_function/
|       |-- scheduled_query_alert/
|       `-- storage_account/
|-- .editorconfig
|-- .gitattributes
|-- .markdownlint.json
|-- .pre-commit-config.yaml
`-- .yamllint.yml
```

## Phase 1 Deliverables

1. Baseline repository governance files.
2. Terraform code for Azure foundational resources:
   - Resource Group
   - Log Analytics Workspace
   - Secure Storage Account (monitored resource)
   - Diagnostic settings for storage service logs
3. CI workflows for linting and Terraform validation.
4. Architecture and implementation documentation.

## Phase 2 Deliverables

1. Azure Monitor Action Group for consistent signal routing.
2. Activity Log Alerts for:
   - storage account configuration changes
   - Azure RBAC role assignment writes and deletes
3. Documentation that defines the handoff into automated remediation.

## Phase 3 Deliverables

1. Azure Function remediation endpoint with managed identity.
2. Key Vault-backed allow-list configuration for RBAC enforcement.
3. Least-privilege RBAC assignments for remediation operations.
4. Terraform outputs and docs to connect Action Group webhook routing.

## Phase 4 Deliverables

1. Scheduled query alerts for security event and remediation failure visibility.
2. Shared workbook dashboard for event and remediation trend visualization.
3. Centralized alert routing through existing Azure Monitor Action Group.
4. Terraform outputs and docs for audit-oriented reporting.

## Phase 5 Deliverables

1. Policy gate workflow for Terraform security scanning (`tfsec`).
2. Versioned OPA/Rego policy definitions for storage and RBAC guardrails.
3. Documentation of policy governance and merge-gate expectations.
4. Repository structure that keeps controls and infrastructure code auditable together.

## Validation Commands

Run from repository root:

```bash
pre-commit run --all-files
pre-commit run --all-files
terraform -chdir=terraform/environments/dev fmt -check -recursive
terraform -chdir=terraform/environments/dev init -backend=false
terraform -chdir=terraform/environments/dev validate
```

Note: this phase intentionally avoids live deployment commands.
