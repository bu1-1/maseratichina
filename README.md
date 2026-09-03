# maseratichina — GitHub ↔ Salesforce

Source of truth for the Alibaba Cloud Salesforce sandbox (`all`), managed from GitHub with Salesforce DX + JWT.

## Connection map

```
GitHub repo (bu1-1/maseratichina)
        │
        │  PR  → workflow: Salesforce Validate (dry-run deploy)
        │  main → workflow: Salesforce Deploy
        ▼
Salesforce CLI (JWT)
        │
        ▼
Sandbox: maseratichina--all.sandbox.my.sfcrmproducts.cn
Alias:   aliyun-all
```

## Local setup

```bash
# 1) Install CLI (once)
npm install -g @salesforce/cli --prefix "$HOME/.local"
export PATH="$HOME/.local/bin:$PATH"

# 2) Place JWT private key at salesforce-auth/certs/server.key
# 3) Export secrets
export SF_CLIENT_ID='...'          # Connected App Consumer Key
export SF_USERNAME='...'           # sandbox username
export SF_AUDIENCE_URL='https://maseratichina--all.sandbox.my.sfcrmproducts.cn'

# 4) Login
./scripts/sf-auth-jwt.sh

# 5) Retrieve / deploy
./scripts/sf-retrieve.sh              # uses manifest/package.xml
./scripts/sf-deploy.sh                # deploys force-app
SF_DRY_RUN=true ./scripts/sf-deploy.sh
```

## GitHub Actions secrets (required)

Repo → Settings → Secrets and variables → Actions:

| Secret | Meaning |
|--------|---------|
| `SF_CLIENT_ID` | Connected App Consumer Key |
| `SF_USERNAME` | JWT user (pre-authorized profile) |
| `SF_JWT_KEY` | Full PEM contents of `server.key` |

China My Domain audience is hard-coded in the workflows (`SF_AUDIENCE_URL`).

## Layout

| Path | Purpose |
|------|---------|
| `force-app/` | DX source (deployed to Salesforce) |
| `manifest/package.xml` | Retrieve scope |
| `salesforce-auth/` | JWT cert docs + login script (private key gitignored) |
| `scripts/` | auth / retrieve / deploy helpers |
| `.github/workflows/` | CI validate + CD deploy |

## Smoke marker

`GhSfBridgeHealth` Apex class is included so the first deploy proves GitHub → Salesforce works.
