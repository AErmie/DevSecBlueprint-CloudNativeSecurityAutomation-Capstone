# Policy as Code

This folder contains policy-as-code controls for Phase 5 of Operation Sentinel.

## Enforcement gates

- CI gate: `tfsec` runs on Terraform code in pull requests.
- CI gate: OPA validates and evaluates Rego policy files in `policies/opa`.

## Included policy domains

- Storage guardrails: `policies/opa/storage_guardrails.rego`
- RBAC guardrails: `policies/opa/rbac_guardrails.rego`

## Intended workflow

1. Author or update Terraform in phase branch.
2. Open pull request.
3. Policy gate workflow blocks merge on security findings.
4. Resolve findings before merge.
