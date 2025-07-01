---
nd-docs: DOCS-1031
files:
  - content/nim/nginx-app-protect/setup-waf-config-management.md
---

{{<note>}}Make sure `gpg` is installed on your system before continuing. You can install NGINX Agent using command-line tools like `curl` or `wget`.{{</note>}}

If your NGINX Instance Manager host doesn't use valid TLS certificates, you can use the insecure flags to bypass verification. Here are some example commands:

{{<tabs name="install-agent-api">}}

{{%tab name="curl"%}}

- **Secure:**

  ```bash
  curl https://<NIM_FQDN>/install/nginx-agent | sudo sh
  ```

- **Insecure:**

  ```bash
  curl --insecure https://<NIM_FQDN>/install/nginx-agent | sudo sh
  ```

To add the instance to a specific instance group during installation, use the `--instance-group` (or `-g`) flag:

```shell
curl https://<NIM_FQDN>/install/nginx-agent -o install.sh
chmod u+x install.sh
sudo ./install.sh --instance-group <instance group>
```

By default, the install script uses a secure connection to download packages. If it can’t establish one, it falls back to an insecure connection and logs this message:

```text
Warning: An insecure connection will be used during this nginx-agent installation
```

To enforce a secure connection, set the `--skip-verify` flag to false:

```shell
curl https://<NIM_FQDN>/install/nginx-agent -o install.sh
chmod u+x install.sh
sudo ./install.sh --skip-verify false
```

{{%/tab%}}

{{%tab name="wget"%}}

- **Secure:**

  ```shell
  wget https://<NIM_FQDN>/install/nginx-agent -O - | sudo sh -s --skip-verify false
  ```

- **Insecure:**

  ```shell
  wget --no-check-certificate https://<NIM_FQDN>/install/nginx-agent -O - | sudo sh
  ```

To add your instance to a group during installation, use the `--instance-group` (or `-g`) flag:

```shell
wget https://<NIM_FQDN>/install/nginx-agent -O install.sh
chmod u+x install.sh
sudo ./install.sh --instance-group <instance group>
```

{{%/tab%}}

{{</tabs>}}
