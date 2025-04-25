**Note**: To complete this step, make sure that `gpg` is installed on your system. You can install NGINX Agent using various command-line tools like `curl` or `wget`. If your NGINX Instance Manager host is not set up with valid TLS certificates, you can use the insecure flags provided by those tools. See the following examples:

{{<tabs name="install-agent-api">}}

{{%tab name="curl"%}}

- Secure:

  ```bash
  curl https://<NMS_FQDN>/install/nginx-agent | sudo sh
  ```

- Insecure:

  ```bash
  curl --insecure https://<NMS_FQDN>/install/nginx-agent | sudo sh
  ```

  You can add your NGINX instance to an existing instance group or create one using `--instance-group` or `-g` flag when installing NGINX Agent.

  The following example shows how to download and run the script with the optional `--instance-group` flag adding the NGINX instance to the instance group **my-instance-group**:

  ```bash
  curl https://<NMS_FQDN>/install/nginx-agent > install.sh; chmod u+x install.sh
  sudo ./install.sh --instance-group my-instance-group
  ```

  By default, the install script attempts to use a secure connection when downloading packages. If, however, the script cannot create a secure connection, it uses an insecure connection instead and logs the following warning message:

  ``` text
  Warning: An insecure connection will be used during this nginx-agent installation
  ```

  To require a secure connection, you can set the optional flag `skip-verify` to `false`.

  The following example shows how to download and run the script with an enforced secure connection:

  ```bash
  curl https://<NMS_FQDN>/install/nginx-agent > install.sh chmod u+x install.sh; chmod u+x install.sh
  sudo sh ./install.sh --skip-verify false
  ```

{{%/tab%}}

{{%tab name="wget"%}}


- Secure:

  ```bash
  wget https://<NMS_FQDN>/install/nginx-agent -O - | sudo sh -s --skip-verify false
  ```

- Insecure:

  ```bash
  wget --no-check-certificate https://<NMS_FQDN>/install/nginx-agent -O - | sudo sh
  ```

   When you install the NGINX Agent, you can use the  `--instance-group` or `-g` flag to add your NGINX instance to an existing instance group or to a new group that you specify.

   The following example downloads and runs the NGINX Agent install script with the optional `--instance-group` flag, adding the NGINX instance to the instance group **my-instance-group**:

   ```bash
   wget https://gnms1.npi.f5net.com/install/nginx-agent -O install.sh ; chmod u+x install.sh
   sudo ./install.sh --instance-group my-instance-group
   ```


{{%/tab%}}
{{</tabs>}}

<!-- Do not remove. Keep this code at the bottom of the include -->
<!-- DOCS-1031 -->
