---
files:
  - content/nginx-one/getting-started.md
  - content/nginx-one/agent/containers/run-agent-container.md
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
