# maseratichina — GitHub ↔ Salesforce

双向同步：GitHub 与阿里云 Salesforce 沙盒（`all`），JWT + Salesforce DX。

## Connection map

```
GitHub repo (bu1-1/maseratichina)
   │                              ▲
   │ PR → Validate (dry-run)      │ 每 30 分钟 / 手动
   │ main → Deploy                │ Salesforce Sync From Org
   ▼                              │
Salesforce CLI (JWT) ─────────────┘
   │
   ▼
Sandbox: https://maseratichina--all.sandbox.my.sfcrmproducts.cn
Alias:   aliyun-all
```

| 方向 | 机制 | 触发 |
|------|------|------|
| GitHub → Salesforce | `Salesforce Deploy` | push 到 `main`（`force-app/**`） |
| Salesforce → GitHub | `Salesforce Sync From Org` | 每 30 分钟 cron + 手动 `workflow_dispatch` |

> 定时同步 **只在默认分支 `main` 上运行**。合并本 PR 后才会开始自动从沙盒拉代码。

## Local setup

```bash
# 1) Install CLI (once)
npm install -g @salesforce/cli --prefix "$HOME/.local"
export PATH="$HOME/.local/bin:$PATH"

# 2) Place JWT private key at salesforce-auth/certs/server.key
# 3) Export secrets
export SF_CLIENT_ID='...'
export SF_USERNAME='...'
export SF_AUDIENCE_URL='https://maseratichina--all.sandbox.my.sfcrmproducts.cn'

# 4) Login
./scripts/sf-auth-jwt.sh

# 5) Retrieve / deploy / sync
./scripts/sf-retrieve.sh                 # small manifest
./scripts/sf-sync-from-org.sh            # sync-package.xml (Org → local)
./scripts/sf-deploy.sh                   # local → Org
SF_DRY_RUN=true ./scripts/sf-deploy.sh
```

## GitHub Actions secrets (required)

| Secret | Meaning |
|--------|---------|
| `SF_CLIENT_ID` | Connected App Consumer Key |
| `SF_USERNAME` | JWT user (pre-authorized profile) |
| `SF_JWT_KEY` | Full PEM contents of `server.key` |

## Layout

| Path | Purpose |
|------|---------|
| `force-app/` | DX source |
| `manifest/package.xml` | 小范围 retrieve |
| `manifest/sync-package.xml` | Org→GitHub 自动同步范围 |
| `salesforce-auth/` | JWT 文档（私钥 gitignore） |
| `scripts/` | auth / retrieve / deploy / sync |
| `.github/workflows/` | validate / deploy / org-sync |

## Notes

- 同步提交带 `[org-sync]`，不会再触发 Deploy，避免回环。
- `CustomLabels` 默认不同步（可能含密钥）。
- 首次全量同步体积较大（约数百 Apex / 对象 / Layout），之后只提交有 diff 的变更。
