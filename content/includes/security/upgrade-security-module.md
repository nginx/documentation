To upgrade the NGINX Security Monitoring module, take the following steps:

1. Open an SSH connection to the server where you've installed the Security Monitoring module and log in.

1. Install the updated version of the Security Monitoring module:

   - CentOS, RHEL, RPM-Based

      ```bash
      sudo yum -y makecache
      sudo yum update -y nms-sm
      ```

   - Debian, Ubuntu, Deb-Based

        ```bash
        sudo apt-get update
        sudo apt-get install -y nms-sm
        ```

<!-- Do not remove. Keep this code at the bottom of the include -->
<!-- DOCS-1184 -->
