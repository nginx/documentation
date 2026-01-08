---
nd-docs: DOCS-013
nd-product: NAGENT
nd-files:
- content/agent/installation-upgrade/installation-oss.md
- content/nginx-one-console/agent/install-upgrade/install-from-oss-repo.md
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

    The output should contain the full fingerprints `8540 A6F1 8833 A80E 9C16 53A4 2FD2 1310 B49F 6B46`, `573B FD6B 3D8F BC64 1079 A6AB ABF5 BD82 7BD9 BF62`, `9E9B E90E ACBC DE69 FE9B 204C BCDC D8A3 8D88 A2B3` as follows:

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

   {{<call-out "tip" "Tip: Install specific versions" "" >}}
   To install `nginx-agent` with a specific version (for example, 2.42.0):

   Update your package index and install a specific version of the nginx-agent. Replace <VERSION_CODENAME> with your current Ubuntu codename (for example, jammy, noble).

   ```shell
   sudo apt update
   sudo apt install -y nginx-agent=2.42.0~<VERSION_CODENAME>
   ```
   {{< /call-out >}}

1. Verify the installation:

    ```shell
    sudo nginx-agent -v
    ```