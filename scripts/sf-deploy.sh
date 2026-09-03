#!/usr/bin/env bash
# Deploy force-app (or a path) to the connected sandbox.
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"
export PATH="${HOME}/.local/bin:${PATH}"

ORG="${SF_CLI_ALIAS:-aliyun-all}"
SOURCE="${1:-force-app}"
TEST_LEVEL="${SF_TEST_LEVEL:-NoTestRun}"
DRY_RUN="${SF_DRY_RUN:-false}"

if ! sf org display --target-org "$ORG" >/dev/null 2>&1; then
  "$ROOT/scripts/sf-auth-jwt.sh"
fi

args=(
  project deploy start
  --source-dir "$SOURCE"
  --target-org "$ORG"
  --test-level "$TEST_LEVEL"
  --wait 30
)

if [[ "$DRY_RUN" == "true" ]]; then
  args+=(--dry-run)
fi

sf "${args[@]}"
