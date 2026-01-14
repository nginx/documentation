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

1. The output should contain the full fingerprints `8540 A6F1 8833 A80E 9C16 53A4 2FD2 1310 B49F 6B46`, `573B FD6B 3D8F BC64 1079 A6AB ABF5 BD82 7BD9 BF62`, `9E9B E90E ACBC DE69 FE9B 204C BCDC D8A3 8D88 A2B3` as follows:

   ```shell
   pub   rsa4096 2024-05-29 [SC]
         8540A6F18833A80E9C1653A42FD21310B49F6B46
   uid                      nginx signing key <signing-key-2@nginx.com>

   pub   rsa2048 2011-08-19 [SC] [expires: 2027-05-24]
         573BFD6B3D8FBC641079A6ABABF5BD827BD9BF62
   uid                      nginx signing key <signing-key@nginx.com>

   pub   rsa4096 2024-05-29 [SC]
         9E9BE90EACBCDE69FE9B204CBCDCD8A38D88A2B3
   uid                      nginx signing key <signing-key-3@nginx.com>
   ```

1. Finally, import the key to the rpm database:

   ```shell
   sudo rpmkeys --import /tmp/nginx_signing.key
   ```

1. To install `nginx-agent`, run the following command:

   ```shell
   sudo zypper install nginx-agent
   ```

   {{<call-out "tip" "Tip: Install specific versions" "" >}}
   To install `nginx-agent` with a specific version (for example, 2.42.0):

   ```shell
   sudo zypper install -y nginx-agent=2.42.0
   ```
   {{< /call-out >}}

1. Verify the installation:

   ```shell
   sudo nginx-agent -v
   ```