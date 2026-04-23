import { app } from "@azure/functions";
import { DefaultAzureCredential } from "@azure/identity";
import { StorageManagementClient } from "@azure/arm-storage";
import { AuthorizationManagementClient } from "@azure/arm-authorization";
import { SecretClient } from "@azure/keyvault-secrets";

const truthy = new Set(["1", "true", "yes", "on"]);

function isEnabled(value) {
  return truthy.has((value ?? "").toLowerCase());
}

function splitCsv(value) {
  if (!value) {
    return [];
  }

  return value
    .split(",")
    .map((item) => item.trim())
    .filter((item) => item.length > 0);
}

function parseResourceId(resourceId) {
  const parts = (resourceId ?? "").split("/").filter(Boolean);
  const resourceGroupIndex = parts.indexOf("resourceGroups");
  const storageIndex = parts.indexOf("storageAccounts");

  if (resourceGroupIndex < 0 || storageIndex < 0) {
    return null;
  }

  return {
    resourceGroupName: parts[resourceGroupIndex + 1],
    storageAccountName: parts[storageIndex + 1],
  };
}

async function getAllowLists(context) {
  const keyVaultUri = process.env.KEY_VAULT_URI;
  const principalSecretName = process.env.ALLOWED_PRINCIPALS_SECRET_NAME;
  const roleSecretName = process.env.ALLOWED_ROLE_DEFINITIONS_SECRET_NAME;

  if (!keyVaultUri || !principalSecretName || !roleSecretName) {
    return { allowedPrincipals: [], allowedRoleDefinitions: [] };
  }

  const credential = new DefaultAzureCredential();
  const secretClient = new SecretClient(keyVaultUri, credential);

  try {
    const [principalSecret, roleSecret] = await Promise.all([
      secretClient.getSecret(principalSecretName),
      secretClient.getSecret(roleSecretName),
    ]);

    return {
      allowedPrincipals: splitCsv(principalSecret.value),
      allowedRoleDefinitions: splitCsv(roleSecret.value),
    };
  } catch (error) {
    context.warn(`Unable to read allow-list secrets from Key Vault: ${error.message}`);
    return { allowedPrincipals: [], allowedRoleDefinitions: [] };
  }
}

async function remediateStorageConfiguration(context, payload) {
  if (!isEnabled(process.env.REMEDIATE_STORAGE_PUBLIC_ACCESS)) {
    return { action: "storage-remediation-disabled" };
  }

  const subscriptionId = process.env.AZURE_SUBSCRIPTION_ID;
  if (!subscriptionId) {
    throw new Error("AZURE_SUBSCRIPTION_ID is required for storage remediation");
  }

  const operationName = payload?.data?.context?.activityLog?.operationName;
  if (operationName !== "Microsoft.Storage/storageAccounts/write") {
    return { action: "storage-no-op", reason: "operation-not-targeted" };
  }

  const resourceId = payload?.data?.context?.activityLog?.resourceId;
  const parsed = parseResourceId(resourceId);

  if (!parsed) {
    return { action: "storage-no-op", reason: "resource-parse-failed" };
  }

  const credential = new DefaultAzureCredential();
  const storageClient = new StorageManagementClient(credential, subscriptionId);

  const updateResult = await storageClient.storageAccounts.update(parsed.resourceGroupName, parsed.storageAccountName, {
    allowBlobPublicAccess: false,
    minimumTlsVersion: "TLS1_2",
  });

  context.log(`Storage remediation applied to ${parsed.storageAccountName}`);
  return {
    action: "storage-remediated",
    target: parsed.storageAccountName,
    provisioningState: updateResult?.provisioningState ?? "unknown",
  };
}

async function remediateRbac(context, payload, allowLists) {
  if (!isEnabled(process.env.ENFORCE_RBAC_REMEDIATION)) {
    return { action: "rbac-remediation-disabled" };
  }

  const subscriptionId = process.env.AZURE_SUBSCRIPTION_ID;
  if (!subscriptionId) {
    throw new Error("AZURE_SUBSCRIPTION_ID is required for RBAC remediation");
  }

  const operationName = payload?.data?.context?.activityLog?.operationName ?? "";
  if (operationName !== "Microsoft.Authorization/roleAssignments/write") {
    return { action: "rbac-no-op", reason: "operation-not-targeted" };
  }

  const roleAssignmentId = payload?.data?.context?.activityLog?.resourceId;
  if (!roleAssignmentId) {
    return { action: "rbac-no-op", reason: "role-assignment-id-missing" };
  }

  const credential = new DefaultAzureCredential();
  const authClient = new AuthorizationManagementClient(credential, subscriptionId);

  const assignment = await authClient.roleAssignments.getById(roleAssignmentId);
  const principalId = assignment?.principalId ?? "";
  const roleDefinitionId = assignment?.roleDefinitionId ?? "";

  const principalAllowed = allowLists.allowedPrincipals.includes(principalId);
  const roleAllowed = allowLists.allowedRoleDefinitions.some((allowedRoleId) => roleDefinitionId.toLowerCase().endsWith(allowedRoleId.toLowerCase()));

  if (principalAllowed && roleAllowed) {
    return { action: "rbac-allowed", principalId, roleDefinitionId };
  }

  await authClient.roleAssignments.deleteById(roleAssignmentId);
  context.log(`RBAC remediation removed role assignment ${roleAssignmentId}`);

  return {
    action: "rbac-remediated",
    roleAssignmentId,
    principalId,
    roleDefinitionId,
  };
}

export async function remediationWebhook(request, context) {
  let payload;

  try {
    payload = await request.json();
  } catch {
    payload = {};
  }

  try {
    const allowLists = await getAllowLists(context);
    const [storageResult, rbacResult] = await Promise.all([
      remediateStorageConfiguration(context, payload),
      remediateRbac(context, payload, allowLists),
    ]);

    return {
      status: 200,
      jsonBody: {
        status: "processed",
        storageResult,
        rbacResult,
      },
    };
  } catch (error) {
    context.error(`Remediation failed: ${error.message}`);
    return {
      status: 500,
      jsonBody: {
        status: "failed",
        error: error.message,
      },
    };
  }
}

app.http("remediationWebhook", {
  route: "remediationWebhook",
  methods: ["POST"],
  authLevel: "function",
  handler: remediationWebhook,
});
