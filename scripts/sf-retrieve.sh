#!/usr/bin/env bash
# Retrieve metadata from the connected sandbox into force-app.
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"
export PATH="${HOME}/.local/bin:${PATH}"

ORG="${SF_CLI_ALIAS:-aliyun-all}"
MANIFEST="${1:-manifest/package.xml}"

if ! sf org display --target-org "$ORG" >/dev/null 2>&1; then
  "$ROOT/scripts/sf-auth-jwt.sh"
fi

sf project retrieve start \
  --manifest "$MANIFEST" \
  --target-org "$ORG" \
  --wait 30
