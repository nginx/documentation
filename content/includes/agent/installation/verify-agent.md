---
docs:
files:
   - content/agent/install-upgrade/install-from-github.md
   - content/agent/install-upgrade/install-from-oss-repo.md
   - content/agent/install-upgrade/install-from-plus-repo.md
   - content/nginx-one/agent/install-upgrade/install-from-oss-repo.md
   - content/nginx-one/agent/install-upgrade/install-from-plus-repo.md
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