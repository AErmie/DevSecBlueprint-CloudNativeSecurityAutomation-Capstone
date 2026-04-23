# Remediation Function (Phase 3)

This Azure Function is the automated first responder for Operation Sentinel.

## What it does

- Handles Azure Monitor Action Group webhook payloads.
- Enforces secure storage baseline by disabling blob public access when required.
- Removes RBAC role assignments that are not allow-listed.
- Reads allow-list values from Azure Key Vault.

## Security model

- Uses system-assigned managed identity through `DefaultAzureCredential`.
- Uses Key Vault for sensitive allow-list configuration.
- Requires `function` auth level for webhook invocation.
- Expects least-privilege RBAC assignment from Terraform.

## Local run

1. Copy `local.settings.json.example` to `local.settings.json`.
2. Set environment values.
3. Install dependencies with `npm install`.
4. Start with `npm start`.
