To upgrade the Developer Portal in an offline environment, take the following steps:

{{<tabs name="upgrade_dev_portal_offline">}}
{{%tab name="CentOS, RHEL, and RPM-Based"%}}

1. Log in to the [MyF5 Customer Portal](https://account.f5.com/myf5) and download the Developer Portal package files, or use the package provided by your NGINX Sales Team.

2. Upgrade the Developer Portal packages:

   ```bash
   sudo yum -y --nogpgcheck update /home/user/nginx-devportal_<version>.x86_64.rpm
   sudo yum -y --nogpgcheck update /home/user/nginx-devportal-ui_<version>.x86_64.rpm
   ```

3. Enable the following Developer Portal service:

   ```bash
   sudo systemctl enable nginx-devportal.service
   ```

4. Restart the Developer Portal service:
  
   ```bash
   sudo systemctl restart nginx-devportal.service
   ```

{{%/tab%}}
{{%tab name="Debian, Ubuntu, and Deb-Based"%}}

1. Log in to the [MyF5 Customer Portal](https://account.f5.com/myf5) and download the Developer Portal package files, or use the package provided by your NGINX Sales Team.

2. Upgrade the Developer Portal packages:

   ```bash
   sudo apt-get -y install -f /home/user/nginx-devportal_<version>_amd64.deb
   sudo apt-get -y install -f /home/user/nginx-devportal-ui_<version>_amd64.deb
   ```

3. Enable the following Developer Portal service:

   ```bash
   sudo systemctl enable nginx-devportal.service
   ```

4. Restart the Developer Portal service:
  
   ```bash
   sudo systemctl restart nginx-devportal.service
   ```
   
   {{%/tab%}}
   {{</tabs>}}

<!-- Do not remove. Keep this code at the bottom of the include -->
<!-- DOCS-1018 -->