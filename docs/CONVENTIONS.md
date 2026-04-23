# Conventions

## Branching

- One branch per phase.
- All phase branches are merged to `main`.

## Naming

- Resource naming pattern: `<env><workload><type><suffix>`.
- Required tags on all resources:
  - `Environment`
  - `Project`
  - `Owner`
  - `CostCenter`
  - `DataClassification`

## Terraform

- Keep modules focused on one responsibility.
- Prefer explicit module inputs over hidden defaults.
- Keep environment composition in `terraform/environments/dev`.

## Security Baseline

- Deny public blob access unless explicitly required.
- Use Azure RBAC and managed identity for control-plane access.
- Keep secrets out of source control.
