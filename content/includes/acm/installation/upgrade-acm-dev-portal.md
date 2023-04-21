To upgrade the Developer Portal, take the following steps:

{{<tabs name="upgrade_dev_portal">}}
{{%tab name="CentOS, RHEL, RPM-Based"%}}

1. To install the latest version of the Developer Portal, run the following command:

   ```bash
   sudo yum update -y nginx-devportal nginx-devportal-ui
   ```

2. Enable the following Developer Portal service:

   ```bash
   sudo systemctl enable nginx-devportal.service
   ```

3. Restart the Developer Portal service:
  
   ```bash
   sudo systemctl restart nginx-devportal.service
   ```

{{%/tab%}}

{{%tab name="Debian, Ubuntu, Deb-Based"%}}

1. To install the latest version of the Developer Portal, run the following commands:

   ```bash
   sudo apt-get update
   sudo apt-get upgrade -y nginx-devportal nginx-devportal-ui
   ```

2. Enable the following Developer Portal service:

   ```bash
   sudo systemctl enable nginx-devportal.service
   ```

3. Restart the Developer Portal service:
  
   ```bash
   sudo systemctl restart nginx-devportal.service
   ```

   {{%/tab%}}
   {{</tabs>}}

<!-- Do not remove. Keep this code at the bottom of the include -->
<!-- DOCS-1019 -->