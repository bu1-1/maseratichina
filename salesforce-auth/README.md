# Salesforce 阿里云沙盒 JWT 认证

## 已生成文件

| 文件 | 用途 | 是否可提交 Git |
|------|------|----------------|
| `certs/server.crt` | 公钥证书，上传到 Connected App / External Client App | 是 |
| `certs/server.key` | 私钥，CLI JWT 登录用 | **否**（已 gitignore） |
| `certs/server.csr` | 证书请求（备用） | 可选 |

证书有效期至 **2036-08-31**，指纹 SHA1：`8A:CC:C9:08:69:78:66:4C:29:DF:C0:D3:57:EF:08:87:1A:00:5C:DB`

## Org 信息（用环境变量，勿把真实账号写进仓库）

| 变量 | 含义 |
|------|------|
| `SF_USERNAME` 或 `SF_ORG_ALIAS` | 沙盒登录用户名 |
| `SF_CLIENT_ID` | Connected App Consumer Key（你上传证书后从 Setup 复制） |
| `SF_INSTANCE_URL` | API 域名，默认见下方 |
| `SF_CLI_ALIAS` | CLI 本地别名，默认 `aliyun-all` |

- Lightning URL（浏览器）: `https://maseratichina--all.sandbox.lightning.sfcrmapps.cn/`
- API / JWT Instance URL（推荐）: `https://maseratichina--all.sandbox.my.sfcrmapps.cn`

## 你需要在 Salesforce 里完成的步骤

用浏览器登录沙盒后：

1. **Setup** → 搜索 **App Manager** 或 **External Client App Manager**（新 org 可能只有后者）
2. **New Connected App** / **New External Client App**
3. 基本信息随意填，例如名称 `Cursor JWT CLI`
4. 启用 **OAuth Settings** / **Enable OAuth**：
   - Callback URL：`http://localhost:1717/OauthRedirect`（CLI 惯例，JWT 本身不用回调）
   - Selected OAuth Scopes：至少勾选  
     - `Full access (full)`  
     - `Perform requests at any time (refresh_token, offline_access)`
   - **Use digital signatures** / **Enable JWT Bearer Flow**：勾选，并上传仓库中的 `salesforce-auth/certs/server.crt`
5. 保存后打开 **Manage Consumer Details**，复制 **Consumer Key**（Client ID）→ 设为环境密钥 `SF_CLIENT_ID`
6. **Manage** → **Edit Policies**（或 Policies 页）：
   - Permitted Users：**Admin approved users are pre-authorized**
   - IP Relaxation：建议 **Relax IP restrictions**（Cloud Agent 出口 IP 不固定时必要）
7. 把运行用户的 Profile / Permission Set 加到该 App 的授权列表

> 新建 Connected App 后策略生效可能要等几分钟。

## 拿到 Consumer Key 后登录

```bash
export PATH="$HOME/.local/bin:$PATH"
export SF_CLIENT_ID='<paste-consumer-key>'

./salesforce-auth/login-jwt.sh
```

脚本会读取 `SF_USERNAME`（若无则回退 `SF_ORG_ALIAS`）与 `SF_CLIENT_ID`，使用本地私钥完成 JWT 登录。
