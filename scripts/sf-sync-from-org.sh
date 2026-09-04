#!/usr/bin/env bash
# Pull sandbox metadata into force-app (Org → local Git working tree).
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"
export PATH="${HOME}/.local/bin:${PATH}"

ORG="${SF_CLI_ALIAS:-aliyun-all}"
MANIFEST="${1:-manifest/sync-package.xml}"

if ! sf org display --target-org "$ORG" >/dev/null 2>&1; then
  "$ROOT/scripts/sf-auth-jwt.sh"
fi

echo "Retrieving from $ORG using $MANIFEST ..."
sf project retrieve start \
  --manifest "$MANIFEST" \
  --target-org "$ORG" \
  --wait 60

# Drop ignored / sensitive paths if they slipped in
rm -rf force-app/main/default/labels || true

echo "Retrieve complete."
