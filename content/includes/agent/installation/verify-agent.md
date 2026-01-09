---
nd-docs: DOCS-009
nd-product: NAGENT
nd-files:
- content/nginx-one-console/agent/install-upgrade/install-from-github.md
- content/nginx-one-console/agent/install-upgrade/install-from-oss-repo.md
- content/nginx-one-console/agent/install-upgrade/install-from-plus-repo.md
---

Once you have installed NGINX Agent, you can verify that it is running with the
following command:

```shell
sudo systemctl status nginx-agent
```

To check the version installed, run the following command:
```shell
sudo nginx-agent -v
```