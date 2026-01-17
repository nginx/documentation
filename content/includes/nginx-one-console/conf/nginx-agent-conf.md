---
nd-docs: DOCS-166
nd-product: NONECO
nd-files:
- content/nginx-one-console/agent/containers/run-agent-container.md
- content/nginx-one-console/getting-started.md
---

```yaml
command:
  server:
    host: "agent.connect.nginx.com" # Command server host
    port: 443                       # Command server port
  auth:
    token: "<your-data-plane-key-here>" # Authentication token for the command server
  tls:
    skip_verify: false
```

Replace `<your-data-plane-key-here>` with your Data Plane key.
