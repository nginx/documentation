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

1. Create a file bundle of the certificate and key:

   ```shell
   cat /etc/ssl/nginx/nginx-repo.crt /etc/ssl/nginx/nginx-repo.key > /etc/ssl/nginx/nginx-repo-bundle.crt
   ```

1. Install the prerequisites:

   ```shell
   sudo zypper install curl ca-certificates gpg2 gawk
   ```

1. To set up the zypper repository for `nginx-agent` packages, run the following
   command:

   ```shell
   sudo zypper addrepo --refresh --check \
      'https://pkgs.nginx.com/nginx-agent/sles/$releasever_major?ssl_clientcert=/etc/ssl/nginx/nginx-repo-bundle.crt&ssl_verify=peer' nginx-agent
   ```

1. Next, import an official NGINX signing key so `zypper`/`rpm` can verify the
   package's authenticity. Fetch the key:

   ```shell
   curl -o /tmp/nginx_signing.key https://nginx.org/keys/nginx_signing.key
   ```

1. Verify that the downloaded file contains the proper key:

   ```shell
   gpg --with-fingerprint --dry-run --quiet --no-keyring --import --import-options import-show /tmp/nginx_signing.key
   ```

1. The output should contain the full fingerprint
   `573B FD6B 3D8F BC64 1079 A6AB ABF5 BD82 7BD9 BF62` as follows:

   ```none
   pub   rsa2048 2011-08-19 [SC] [expires: 2027-05-24]
      573B FD6B 3D8F BC64 1079  A6AB ABF5 BD82 7BD9 BF62
   uid                      nginx signing key <signing-key@nginx.com>
   ```

1. Finally, import the key to the rpm database:

   ```shell
   sudo rpmkeys --import /tmp/nginx_signing.key
   ```

1. To install `nginx-agent`, run the following command:

   ```shell
   sudo zypper install nginx-agent
   ```