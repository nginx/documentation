---
f5-product: NGINX One Console
f5-files:
- content/nginx-one-console/agent/containers/run-agent-container.md
- content/nginx-one-console/getting-started.md
---

```yaml
command:
  server:
    host: "agent.connect.nginx.com" # Command server host
    port: 443                       # Command server port
  auth:
    token: "<DATA_PLANE_KEY>" # Authentication token for the command server
  tls:
    skip_verify: false
```

Replace `<DATA_PLANE_KEY>` with your Data Plane key.
