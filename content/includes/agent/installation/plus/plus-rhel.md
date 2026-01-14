---
nd-product: NAGENT
nd-files:
- content/agent/installation-upgrade/installation-plus.md
- content/nginx-one-console/agent/install-upgrade/install-from-plus-repo.md
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
   sudo yum install yum-utils procps
   ```

1. Set up the yum repository by creating the file `nginx-agent.repo` in
   `/etc/yum.repos.d`, for example using `vi`:

   ```shell
   sudo vi /etc/yum.repos.d/nginx-agent.repo
   ```

1. Add the following lines to `nginx-agent.repo`:

   ```ini
   [nginx-agent]
   name=nginx agent repo
   baseurl=https://pkgs.nginx.com/nginx-agent/centos/$releasever/$basearch/
   sslclientcert=/etc/ssl/nginx/nginx-repo.crt
   sslclientkey=/etc/ssl/nginx/nginx-repo.key
   gpgcheck=0
   enabled=1
   ```

1. To install `nginx-agent`, run the following command:

   ```shell
   sudo yum install nginx-agent
   ```

   {{<call-out "tip" "Tip: Install specific versions" "" >}}
   To install `nginx-agent` with a specific version (for example, 2.42.0):

   ```shell
   sudo yum install -y nginx-agent-2.42.0
   ```
   {{</call-out>}}

   When prompted to accept the GPG key, verify that the fingerprint matches `8540 A6F1 8833 A80E 9C16 53A4 2FD2 1310 B49F 6B46`, `573B FD6B 3D8F BC64 1079 A6AB ABF5 BD82 7BD9 BF62`, `9E9B E90E ACBC DE69 FE9B 204C BCDC D8A3 8D88 A2B3`, and if so, accept it.

1. Verify the installation:

   ```shell
   sudo nginx-agent -v
   ```