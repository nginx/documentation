---
docs:
---

``` shell
curl agent.connect.nginx.com/nginx-agent/install | DATAPLANE_KEY="<data-plane-key>" sh -s -- -y
```

- `<data-plane-key>`: Replace with the actual data plane key value.
- `-y`: An argument passed to the installation script. `-y` automatically answers "yes" to any prompts that require user interaction.