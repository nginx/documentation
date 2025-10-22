---
files:
   - content/agent/install-upgrade/install-from-oss-repo.md
   - content/nginx-one/agent/install-upgrade/install-from-oss-repo.md
---

1. To setup the pkg repository create a file with name `/etc/pkg/nginx-agent.conf`
with the following content:

   ```none
   nginx-agent: {
   URL: pkg+http://packages.nginx.org/nginx-agent/freebsd/${ABI}/latest
   ENABLED: true
   MIRROR_TYPE: SRV
   }
   ```

1. To install `nginx-agent`, run the following command:

   ```shell
   sudo pkg install nginx-agent
   ```