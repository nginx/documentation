---
nd-docs: DOCS-007
nd-product: NAGENT
nd-files:
- content/nginx-one-console/agent/install-upgrade/install-from-github.md
- content/nginx-one-console/agent/install-upgrade/install-from-oss-repo.md
- content/nginx-one-console/agent/install-upgrade/install-from-plus-repo.md
---

To start NGINX Agent on `systemd` systems, run the following command:

```shell
sudo systemctl start nginx-agent
```

To enable NGINX Agent to start on boot, run the following command:

```shell
sudo systemctl enable nginx-agent
```

To stop NGINX Agent, run the following command:

```shell
sudo systemctl stop nginx-agent
```