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

1. Copy the `nginx-repo.crt` and `nginx-repo.key` files to the `/etc/ssl/nginx/`
   directory:

   ```shell
   sudo cp nginx-repo.crt nginx-repo.key /etc/ssl/nginx/
   ```

1. Install the prerequisites:

   ```shell
   sudo yum install yum-utils procps ca-certificates
   ```

1. To set up the yum repository for Amazon Linux 2, create a file with name
   `/etc/yum.repos.d/nginx-agent.repo` with the following contents:

   ```ini
   [nginx-agent]
   name=nginx-agent repo
   baseurl=https://pkgs.nginx.com/nginx-agent/amzn2/$releasever/$basearch
   sslclientcert=/etc/ssl/nginx/nginx-repo.crt
   sslclientkey=/etc/ssl/nginx/nginx-repo.key
   gpgcheck=0
   enabled=1
   ```

1. To install `nginx-agent`, run the following command:

   ```shell
   sudo yum install nginx-agent
   ```

1. When prompted to accept the GPG key, verify that the fingerprint matches
   `573B FD6B 3D8F BC64 1079 A6AB ABF5 BD82 7BD9 BF62`, and if so, accept it.