---
docs:
files:
   - content/agent/install-upgrade/install-from-oss-repo.md
   - content/nginx-one/agent/install-upgrade/install-from-oss-repo.md
---

1. Install the prerequisites:

   ```shell
   sudo apt install curl gnupg2 ca-certificates lsb-release ubuntu-keyring
   ```

1. Import an official nginx signing key so apt can verify the packages authenticity. Fetch the key:

   ```shell
   curl https://nginx.org/keys/nginx_signing.key | gpg --dearmor \
      | sudo tee /usr/share/keyrings/nginx-archive-keyring.gpg >/dev/null
   ```

1. Verify that the downloaded file contains the proper key:

   ```shell
   gpg --dry-run --quiet --no-keyring --import --import-options import-show /usr/share/keyrings/nginx-archive-keyring.gpg
   ```

   The output should contain the full fingerprint `573BFD6B3D8FBC641079A6ABABF5BD827BD9BF62` as follows:

   ```
   pub   rsa2048 2011-08-19 [SC] [expires: 2027-05-24]
         573BFD6B3D8FBC641079A6ABABF5BD827BD9BF62
   uid                      nginx signing key <signing-key@nginx.com>
   ```

   {{< call-out "important" >}}If the fingerprint is different, remove the file.{{< /call-out >}}

1. Add the nginx agent repository:

   ```shell
   echo "deb [signed-by=/usr/share/keyrings/nginx-archive-keyring.gpg] \
   http://packages.nginx.org/nginx-agent/ubuntu/ `lsb_release -cs` agent" \
   | sudo tee /etc/apt/sources.list.d/nginx-agent.list
   ```

1. To install `nginx-agent`, run the following commands:

   ```shell
   sudo apt update
   sudo apt install nginx-agent
   ```