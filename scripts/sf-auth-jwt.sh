#!/usr/bin/env bash
# Authenticate to the China Alibaba Salesforce sandbox via JWT.
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
exec "$ROOT/salesforce-auth/login-jwt.sh"
