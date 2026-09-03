# Connected App 配置核对清单

上传证书前请确认本地文件存在：

```bash
ls -la salesforce-auth/certs/server.crt
```

在 Salesforce Setup 中确认：

- [ ] OAuth 已启用
- [ ] JWT Bearer / Use digital signatures 已启用，且已上传 `server.crt`
- [ ] Scopes 含 `full` 与 `refresh_token` / `offline_access`
- [ ] Permitted Users = Admin approved users are pre-authorized
- [ ] 目标用户 Profile/Permission Set 已加入授权
- [ ] IP Relaxation = Relax IP restrictions（Cloud Agent 场景）
- [ ] 已复制 Consumer Key，并写入环境密钥 `SF_CLIENT_ID`

Instance URL 请用 **my** 域名，不要用 lightning：

- 错误：`https://….sandbox.lightning.sfcrmapps.cn`
- 正确：`https://….sandbox.my.sfcrmapps.cn`
