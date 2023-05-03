You can install the NGINX Agent using `curl`, `wget`, or any command-line tool for transferring data with URLs. If the NGINX Management Suite host is not set up with valid TLS certificates, you can use the available insecure flags of those tools. See the following examples:

{{<tabs name="install-agent-api">}}

{{%tab name="curl"%}}

- Secure:

  ```bash
  curl https://<NMS-FQDN>/install/nginx-agent | sudo sh
  ```

- Insecure:

  ```bash
  curl --insecure https://<NMS-FQDN>/install/nginx-agent | sudo sh
  ```

  When installing the NGINX Agent with the install script, you can optionally set an [instance group]({{< relref "/nms/nim/how-to/nginx/manage-instance-groups.md" >}}) using the `--instance-group` flag.

  The following example shows how to download and run the script with the optional flag:

  ```bash
  curl https://<NMS-FQDN>/install/nginx-agent > install.sh
  sudo sh ./install.sh --instance-group my-instance-group
  ```

  By default, the install script attempts to use a secure connection when downloading packages. If, however, the script cannot create a secure connection, it uses an insecure connection instead and logs the following warning message:

  ``` text
  Warning: An insecure connection will be used during this nginx-agent installation
  ```

  To require a secure connection, you can set the optional flag `skip-verify` to `false`.

  The following example shows how to download and run the script with an enforced secure connection:

  ```bash
  curl https://<NMS-FQDN>/install/nginx-agent > install.sh
  sudo sh ./install.sh --skip-verify false
  ```

{{%/tab%}}

{{%tab name="wget"%}}

- Secure:

  ```bash
  wget https://<NMS-FQDN>/install/nginx-agent -O - | sudo sh -s --skip-verify false
  ```

- Insecure:

  ```bash
  wget --no-check-certificate https://<NMS-FQDN>/install/nginx-agent -O - | sudo sh
  ```

{{%/tab%}}
{{</tabs>}}

<!-- Do not remove. Keep this code at the bottom of the include -->
<!-- DOCS-1031 -->