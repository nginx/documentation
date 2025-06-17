---
docs: DOCS-000
files:
  - content/nginx-one/getting-started.md
  - content/nginx-one/agent/containers/run-agent-container.md
---

```yaml
command:
  server:
    host: "<NGINX-One-Console-URL>" # Command server host
    port: 443                       # Command server port
  auth:
    token: "<your-data-plane-key-here>" # Authentication token for the command server
  tls:
    skip_verify: false
```

Replace the placeholder values:

- `<NGINX-One-Console-URL>`: The URL of your NGINX One Console instance, typically https://INSERT_YOUR_TENANT_NAME.console.ves.volterra.io/ .
- `<your-data-plane-key-here>`: Your Data Plane key.
