---
docs:
files:
   - content/agent/install-upgrade/install-from-oss-repo.md
   - content/nginx-one/agent/install-upgrade/install-from-oss-repo.md
---

1. Install the prerequisites:

   ```shell
   sudo yum install yum-utils procps
   ```

1. To set up the yum repository for Amazon Linux 2, create a file with name
`/etc/yum.repos.d/nginx-agent.repo` with the following contents:

   ```ini
   [nginx-agent]
   name=nginx agent repo
   baseurl=http://packages.nginx.org/nginx-agent/amzn2/$releasever/$basearch/
   gpgcheck=1
   enabled=1
   gpgkey=https://nginx.org/keys/nginx_signing.key
   module_hotfixes=true
   ```

1. To install `nginx-agent`, run the following command:

   ```shell
   sudo yum install nginx-agent
   ```

1. When prompted to accept the GPG key, verify that the fingerprint matches
`573B FD6B 3D8F BC64 1079 A6AB ABF5 BD82 7BD9 BF62`, and if so, accept it.