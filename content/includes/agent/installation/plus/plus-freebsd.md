---
docs:
files:
   - content/agent/install-upgrade/install-from-plus-repo.md
   - content/nginx-one/agent/install-upgrade/install-from-plus-repo.md
---

1. Create the `/etc/ssl/nginx` directory:

   ```shell
   sudo mkdir -p /etc/ssl/nginx
   ```

1. Log in to [MyF5 Customer Portal](https://account.f5.com/myf5/) and download
   your `nginx-repo.crt` and `nginx-repo.key` files.

1. Copy the files to the `/etc/ssl/nginx/` directory:

   ```shell
   sudo cp nginx-repo.crt nginx-repo.key /etc/ssl/nginx/
   ```

1. Install the prerequisite `ca_root_nss` package:

   ```shell
   sudo pkg install ca_root_nss
   ```

1. To setup the pkg repository create a file with name `/etc/pkg/nginx-agent.conf`
with the following content:

   ```none
   nginx-agent: {
   URL: pkg+https://pkgs.nginx.com/nginx-agent/freebsd/${ABI}/latest
   ENABLED: yes
   MIRROR_TYPE: SRV
   }
   ```

1. Add the following lines to the `/usr/local/etc/pkg.conf` file:

   ```conf
   PKG_ENV: { SSL_NO_VERIFY_PEER: "1",
   SSL_CLIENT_CERT_FILE: "/etc/ssl/nginx/nginx-repo.crt",
   SSL_CLIENT_KEY_FILE: "/etc/ssl/nginx/nginx-repo.key" }
   ```

1. To install `nginx-agent`, run the following command:

   ```shell
   sudo pkg install nginx-agent
   ```