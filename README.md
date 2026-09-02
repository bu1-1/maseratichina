# maseratichina

Maserati China Salesforce project — Apex, LWC, metadata deployment, and data queries against a **sandbox** org.

## Project structure

```
force-app/main/default/
├── classes/     # Apex classes
├── lwc/         # Lightning Web Components
└── triggers/    # Apex triggers
```

## Connect your Salesforce sandbox

### 1. Verify Connected App settings

In your sandbox (**Setup → App Manager → your Connected App**):

- OAuth scopes include `api` and `refresh_token, offline_access`
- Digital certificate is uploaded (matches your private key)
- Integration user is **pre-authorized** for the app

### 2. Add Cursor Secrets

Open [Cloud Agents Environment](https://cursor.com/dashboard/cloud-agents/environments/e/642b767d-a682-11f1-a7d1-d6b4613131ce) → **Secrets** and add:

| Secret | Value |
|--------|-------|
| `SF_CLIENT_ID` | Connected App Consumer Key |
| `SF_USERNAME` | Integration user email |
| `SF_JWT_KEY` | RSA private key (full PEM, including `BEGIN/END` lines) |
| `SF_INSTANCE_URL` | `https://test.salesforce.com` |
| `SF_ORG_ALIAS` | *(optional)* default alias, e.g. `sandbox` |

> Never commit keys or tokens to the repository.

### 3. Start a new Cloud Agent

The environment installs Salesforce CLI on build and runs `scripts/sf-auth.sh` on start to authenticate via JWT.

## Common commands

```bash
# Verify connection
sf org display

# Deploy metadata to sandbox
sf project deploy start --source-dir force-app

# Validate deployment (no changes applied)
sf project deploy validate --source-dir force-app --test-level RunLocalTests

# Retrieve metadata from sandbox
sf project retrieve start --source-dir force-app

# Query data
sf data query --query "SELECT Id, Name FROM Account LIMIT 10"

# Run Apex tests
sf apex run test --test-level RunLocalTests --wait 10
```

## Local development (optional)

```bash
npm install -g @salesforce/cli
export SF_CLIENT_ID=... SF_USERNAME=... SF_JWT_KEY=... SF_INSTANCE_URL=https://test.salesforce.com
bash scripts/sf-auth.sh
```
