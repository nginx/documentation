---
docs:
files:
   - content/agent/install-upgrade/install-from-github.md
   - content/agent/install-upgrade/install-from-oss-repo.md
   - content/agent/install-upgrade/install-from-plus-repo.md
   - content/nginx-one/agent/install-upgrade/install-from-oss-repo.md
   - content/nginx-one/agent/install-upgrade/install-from-plus-repo.md
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