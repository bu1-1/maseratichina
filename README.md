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

### Option A: Auth URL（快速验证，推荐先用这个）

**第 1 步：在你本地电脑登录沙盒**

```bash
# 安装 SF CLI（如未安装）
npm install -g @salesforce/cli

# 浏览器登录沙盒
sf org login web \
  --instance-url https://test.salesforce.com \
  --alias sandbox
```

**第 2 步：导出 Auth URL**

```bash
sf org display --target-org sandbox --verbose --json
```

从输出 JSON 里复制 `result.sfdxAuthUrl`，形如：

```
force://PlatformCLI::5Aep861...refresh_token...@maseratichina--all.sandbox.my.salesforce.com
```

**第 3 步：添加到 Cursor Secrets**

打开 [Cloud Agents Environment](https://cursor.com/dashboard/cloud-agents/environments/e/642b767d-a682-11f1-a7d1-d6b4613131ce) → **Secrets**：

| Secret | 值 |
|--------|-----|
| `SFDX_AUTH_URL` | 完整的 `force://PlatformCLI::...` 字符串 |
| `SF_ORG_ALIAS` | *(可选)* 如 `sandbox` |

> 不要把 Auth URL 发到聊天或提交到 Git。Refresh token 过期后需重新导出。

**第 4 步：启动新 Cloud Agent**，环境会自动执行 `scripts/sf-auth.sh` 完成登录。

---

### Option B: JWT（长期稳定，适合生产）

In your sandbox (**Setup → App Manager → your Connected App**):

- OAuth scopes include `api` and `refresh_token, offline_access`
- **Enable JWT Bearer Flow** + upload digital certificate
- Integration user is **pre-authorized** for the app

Add Cursor Secrets:

| Secret | Value |
|--------|-------|
| `SF_CLIENT_ID` | Connected App Consumer Key |
| `SF_USERNAME` | Integration user email |
| `SF_JWT_KEY` | RSA private key (full PEM) |
| `SF_INSTANCE_URL` | `https://test.salesforce.com` |
| `SF_ORG_ALIAS` | *(optional)* e.g. `sandbox` |

> Never commit keys or tokens to the repository.

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
