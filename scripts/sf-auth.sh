#!/usr/bin/env bash
set -euo pipefail

# Authenticate to Salesforce sandbox using JWT Bearer flow.
# Required Cursor Secrets (environment-scoped):
#   SF_CLIENT_ID     - Connected App Consumer Key
#   SF_USERNAME      - Integration user email
#   SF_JWT_KEY       - RSA private key (PEM format, including BEGIN/END lines)
#   SF_INSTANCE_URL  - https://test.salesforce.com (sandbox default)
#   SF_ORG_ALIAS     - optional, defaults to "sandbox"

ORG_ALIAS="${SF_ORG_ALIAS:-sandbox}"
INSTANCE_URL="${SF_INSTANCE_URL:-https://test.salesforce.com}"
KEY_FILE="/tmp/sf-jwt-key.pem"

missing=()
[[ -z "${SF_CLIENT_ID:-}" ]] && missing+=("SF_CLIENT_ID")
[[ -z "${SF_USERNAME:-}" ]] && missing+=("SF_USERNAME")
[[ -z "${SF_JWT_KEY:-}" ]] && missing+=("SF_JWT_KEY")

if [[ ${#missing[@]} -gt 0 ]]; then
  echo "ERROR: Missing required Salesforce secrets: ${missing[*]}"
  echo "Add them in Cursor Dashboard → Cloud Agents → Environment → Secrets"
  exit 1
fi

printf '%s\n' "$SF_JWT_KEY" > "$KEY_FILE"
chmod 600 "$KEY_FILE"

echo "Authenticating to Salesforce sandbox as ${SF_USERNAME}..."
npx sf org login jwt \
  --client-id "$SF_CLIENT_ID" \
  --jwt-key-file "$KEY_FILE" \
  --username "$SF_USERNAME" \
  --instance-url "$INSTANCE_URL" \
  --alias "$ORG_ALIAS" \
  --set-default

rm -f "$KEY_FILE"

echo ""
echo "Connected org:"
npx sf org display --target-org "$ORG_ALIAS"
