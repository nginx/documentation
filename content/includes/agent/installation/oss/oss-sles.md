---
docs:
files:
   - content/agent/install-upgrade/install-from-oss-repo.md
   - content/nginx-one/agent/install-upgrade/install-from-oss-repo.md
---

1. Install the prerequisites:

   ```shell
   sudo zypper install curl ca-certificates gpg2 gawk
   ```

1. To set up the zypper repository for `nginx-agent` packages, run the following command:

   ```shell
   sudo zypper addrepo --gpgcheck --refresh --check \
      'http://packages.nginx.org/nginx-agent/sles/$releasever_major' nginx-agent
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

1. The output should contain the full fingerprint `573B FD6B 3D8F BC64 1079 A6AB ABF5 BD82 7BD9 BF62` as follows:

   ```
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