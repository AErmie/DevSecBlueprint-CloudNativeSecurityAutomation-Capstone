# Phase 5: Codifying the Shield

## Objective

Enforce Sentinel security controls through versioned policy gates before infrastructure code can be merged.

## Approach

Phase 5 adds policy-as-code governance using CI gates and versioned policy definitions.

- Terraform security scanning with `tfsec` in GitHub Actions.
- OPA/Rego policy definitions stored in-repo for guardrail traceability.
- Documentation of policy intent and merge-gate behavior.

## Gates in Scope

- Terraform static security gate:
  - workflow: `.github/workflows/policy-gates.yml`
  - scanner: `tfsec`

- OPA policy gate:
  - validates Rego syntax and formatting
  - evaluates policies against sample violation inputs

## Policy Domains

- Storage guardrails:
  - avoid broad public exposure patterns
  - avoid shared key access where not explicitly required

- RBAC guardrails:
  - block high-risk role assignment patterns
  - flag broad assignment scope patterns

## Milestone Mapping

Phase 5 is satisfied when Sentinel infrastructure and controls are defined as code
and cannot pass PR gates without meeting security policy requirements.
