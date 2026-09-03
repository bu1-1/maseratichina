#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
KEY_FILE="${SF_JWT_KEY_FILE:-$ROOT/salesforce-auth/certs/server.key}"
# Prefer SF_USERNAME; fall back to SF_ORG_ALIAS if that secret holds the login user
USERNAME="${SF_USERNAME:-${SF_ORG_ALIAS:-}}"
ALIAS="${SF_CLI_ALIAS:-aliyun-all}"
INSTANCE_URL="${SF_INSTANCE_URL:-https://maseratichina--all.sandbox.my.sfcrmapps.cn}"

export PATH="${HOME}/.local/bin:${PATH}"

if [[ -z "${SF_CLIENT_ID:-}" ]]; then
  echo "Missing SF_CLIENT_ID (Connected App Consumer Key)." >&2
  exit 1
fi

if [[ -z "$USERNAME" ]]; then
  echo "Missing SF_USERNAME (or SF_ORG_ALIAS) for the sandbox login user." >&2
  exit 1
fi

if [[ ! -f "$KEY_FILE" ]]; then
  echo "Missing JWT private key: $KEY_FILE" >&2
  exit 1
fi

if ! command -v sf >/dev/null 2>&1; then
  echo "Salesforce CLI (sf) not found. Install with:" >&2
  echo "  npm install -g @salesforce/cli --prefix \"\$HOME/.local\"" >&2
  exit 1
fi

sf org login jwt \
  --client-id "$SF_CLIENT_ID" \
  --jwt-key-file "$KEY_FILE" \
  --username "$USERNAME" \
  --alias "$ALIAS" \
  --instance-url "$INSTANCE_URL" \
  --set-default

sf org display --target-org "$ALIAS"
