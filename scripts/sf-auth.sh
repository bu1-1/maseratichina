#!/usr/bin/env bash
set -euo pipefail

# Authenticate to Salesforce sandbox.
#
# Method 1 (quick): SFDX Auth URL
#   SFDX_AUTH_URL  - force://PlatformCLI::... from local `sf org display --verbose`
#   SF_ORG_ALIAS   - optional, defaults to "sandbox"
#
# Method 2 (production): JWT Bearer flow
#   SF_CLIENT_ID, SF_USERNAME, SF_JWT_KEY, SF_INSTANCE_URL

ORG_ALIAS="${SF_ORG_ALIAS:-sandbox}"

if [[ -n "${SFDX_AUTH_URL:-}" ]]; then
  echo "Authenticating via SFDX Auth URL..."
  AUTH_FILE="/tmp/sfdx-auth.url"
  printf '%s\n' "$SFDX_AUTH_URL" > "$AUTH_FILE"
  chmod 600 "$AUTH_FILE"

  npx sf org login sfdx-url \
    --sfdx-url-file "$AUTH_FILE" \
    --alias "$ORG_ALIAS" \
    --set-default

  rm -f "$AUTH_FILE"

elif [[ -n "${SF_CLIENT_ID:-}" && -n "${SF_USERNAME:-}" && -n "${SF_JWT_KEY:-}" ]]; then
  INSTANCE_URL="${SF_INSTANCE_URL:-https://test.salesforce.com}"
  KEY_FILE="/tmp/sf-jwt-key.pem"

  printf '%s\n' "$SF_JWT_KEY" > "$KEY_FILE"
  chmod 600 "$KEY_FILE"

  echo "Authenticating via JWT as ${SF_USERNAME}..."
  npx sf org login jwt \
    --client-id "$SF_CLIENT_ID" \
    --jwt-key-file "$KEY_FILE" \
    --username "$SF_USERNAME" \
    --instance-url "$INSTANCE_URL" \
    --alias "$ORG_ALIAS" \
    --set-default

  rm -f "$KEY_FILE"

else
  echo "ERROR: No Salesforce credentials found."
  echo ""
  echo "Quick setup — add this Cursor Secret:"
  echo "  SFDX_AUTH_URL  (from: sf org display --target-org <alias> --verbose --json)"
  echo ""
  echo "Or JWT setup — add these Cursor Secrets:"
  echo "  SF_CLIENT_ID, SF_USERNAME, SF_JWT_KEY, SF_INSTANCE_URL"
  exit 1
fi

echo ""
echo "Connected org:"
npx sf org display --target-org "$ORG_ALIAS"
