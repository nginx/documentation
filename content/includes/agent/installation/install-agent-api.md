You can install the NGINX Agent using `curl`, `wget`, or any command-line tool for transferring data with URLs. If the NGINX Management Suite host is not set up with valid TLS certificates, you can use the available insecure flags of those tools. See the following examples:

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

  Modules including App Delivery Manager and API Connectivity Manager take advantage of the [instance group]({{< relref "/nms/nim/how-to/nginx/manage-instance-groups.md" >}}) feature for managing NGINX Agents.  You can add your the NGINX Agent to an existing instance group or one will be added dynamically using the `--instance-group` or `-g` flag.  

  The following example shows how to download and run the script with the optional `--instance-group` flag adding the NGINX agent to **my-instance-group**:

  ```bash
  curl https://<NMS_FQDN>/install/nginx-agent > install.sh
  sudo sh ./install.sh --instance-group my-instance-group
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

   Modules including App Delivery Manager and API Connectivity Manager take advantage of the [instance group]({{< relref "/nms/nim/how-to/nginx/manage-instance-groups.md" >}}) feature for managing NGINX Agents.  You can add your NGINX Agent to an existing instance group or one will be added dynamically using the `--instance-group` or `-g` flag. 

   The following example shows how to download and run the script with the optional `--instance-group` flag adding the NGINX agent to **my-instance-group**:

   ```bash
   wget https://gnms1.npi.f5net.com/install/nginx-agent -O install.sh ; chmod u+x install.sh
   sudo ./install.sh --instance-group my-instance-group
   ```


{{%/tab%}}
{{</tabs>}}

<!-- Do not remove. Keep this code at the bottom of the include -->
<!-- DOCS-1031 -->