To see which version of an NGINX Management Suite module is installed, run the following commands:

{{<tabs>}}

  {{%tab name="CentOS, RHEL, RPM-Based"%}}

- Instance Manager:

    ```bash
    yum info nms-instance-manager
    ```

- API Connectivity Manager:

  ```bash
  yum info nms-api-connectivity-manager
  ```

- Security Monitoring module:

  ```bash
  yum info nms-sm
  ```

  {{%/tab%}}

  {{%tab name="Debian, Ubuntu, Deb-Based"%}}

- Instance Manager:

  ```bash
  dpkg -s nms-instance-manager
  ```

- API Connectivity Manager:

  ```bash
  dpkg -s nms-api-connectivity-manager
  ```

- Security Monitoring module:

  ```bash
  dpkg -s nms-sm
  ```

   {{%/tab%}}

{{</tabs>}}

<!-- Do not remove. Keep this code at the bottom of the include -->
<!-- DOCS-1057 -->
