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

1. Install the prerequisites:

   ```shell
   sudo apt install curl gnupg2 ca-certificates lsb-release debian-archive-keyring
   ```

1. Add the `nginx-agent` repository:

   ```shell
   echo "deb https://pkgs.nginx.com/nginx-agent/debian/ `lsb_release -cs` agent" \
   | sudo tee /etc/apt/sources.list.d/nginx-agent.list
   ```

1. Create apt configuration `/etc/apt/apt.conf.d/90pkgs-nginx`:

   ```conf
   Acquire::https::pkgs.nginx.com::Verify-Peer "true";
   Acquire::https::pkgs.nginx.com::Verify-Host "true";
   Acquire::https::pkgs.nginx.com::SslCert     "/etc/ssl/nginx/nginx-repo.crt";
   Acquire::https::pkgs.nginx.com::SslKey      "/etc/ssl/nginx/nginx-repo.key";
   ```

1. To install `nginx-agent`, run the following commands:

   ```shell
   sudo apt update
   sudo apt install nginx-agent
   ```