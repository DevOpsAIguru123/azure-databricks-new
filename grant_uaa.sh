#!/bin/bash
# Run this as an ADMIN account (not the SP).
# Replaces the unconditional UAA assignment on the SP with one restricted
# via ABAC to Key Vault Crypto Officer + Key Vault Crypto User only.
set -euo pipefail

SP_OBJECT_ID="c7b59079-681b-417a-b2fe-2bf2fd282ba5"
SUBSCRIPTION_ID="60992dbe-c574-4373-948b-bb02216c5b0a"
SCOPE="/subscriptions/${SUBSCRIPTION_ID}"

# Key Vault Crypto Officer: 14b46e9e-c2b7-41b4-b07b-48a6ebf60603
# Key Vault Crypto User:    12338af0-0e69-4776-bea7-57ae8d297424
CONDITION=$(cat <<'EOF'
((!(ActionMatches{'Microsoft.Authorization/roleAssignments/write'})) OR (@Request[Microsoft.Authorization/roleAssignments:RoleDefinitionId] ForAnyOfAnyValues:GuidEquals {14b46e9e-c2b7-41b4-b07b-48a6ebf60603, 12338af0-0e69-4776-bea7-57ae8d297424})) AND ((!(ActionMatches{'Microsoft.Authorization/roleAssignments/delete'})) OR (@Resource[Microsoft.Authorization/roleAssignments:RoleDefinitionId] ForAnyOfAnyValues:GuidEquals {14b46e9e-c2b7-41b4-b07b-48a6ebf60603, 12338af0-0e69-4776-bea7-57ae8d297424}))
EOF
)

echo "=== Step 1: Delete existing unconditional UAA assignment ==="
az role assignment delete --assignee "${SP_OBJECT_ID}" --role "18d7d88d-d35e-4fb5-a5c3-7773c20a72d9" --scope "${SCOPE}" 2>/dev/null && echo "  Deleted." || echo "  Not found (continuing)."

echo ""
echo "=== Step 2: Create UAA with ABAC condition ==="
az role assignment create \
  --assignee-object-id "${SP_OBJECT_ID}" \
  --assignee-principal-type ServicePrincipal \
  --role "18d7d88d-d35e-4fb5-a5c3-7773c20a72d9" \
  --scope "${SCOPE}" \
  --condition "${CONDITION}" \
  --condition-version "2.0"

echo ""
echo "=== Verify ==="
az role assignment list --assignee "${SP_OBJECT_ID}" --scope "${SCOPE}" --query "[?roleDefinitionName=='User Access Administrator'].{Condition:condition,Version:conditionVersion}" -o table
