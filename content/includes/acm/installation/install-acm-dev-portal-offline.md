#
{{< dev-portal-dedicated-host >}}

{{<tabs name="install_devportal_offline">}}
{{%tab name="CentOS, RHEL, and RPM-Based"%}}

1. On the Developer Host, complete the same steps from the [Install the Data Plane](#acm-offline-dependencies) section to install PostgreSQL, NGINX Plus, and njs.

2. Log in to the [MyF5 Customer Portal](https://account.f5.com/myf5) and download the NGINX Developer Portal package files, or use the package provided by your NGINX Sales Team.

3. Install the NGINX Developer Portal packages:

   ```bash
   sudo yum -y --nogpgcheck install /home/user/nginx-devportal-<version>.x86_64.rpm /home/user/nginx-devportal-ui-<version>.x86_64.rpm
   ```

4. Upgrade the NGINX Developer Portal packages:

   ```bash
   sudo yum -y --nogpgcheck upgrade /home/user/nginx-devportal-<version>.x86_64.rpm /home/user/nginx-devportal-ui-<version>.x86_64.rpm
   ```

{{%/tab%}}
{{%tab name="Debian, Ubuntu, and Deb-Based"%}}

1. On the Developer Host, complete the same steps from the [Install the Data Plane](#acm-offline-dependencies) section to install PostgreSQL, NGINX Plus, and njs.

2. Log in to the [MyF5 Customer Portal](https://account.f5.com/myf5) and download the NGINX Developer Portal package files, or use the package provided by your NGINX Sales Team.

3. Install the NGINX Developer Portal package:

   ```bash
   sudo apt-get -y install -f /home/user/nginx-devportal_<version>_amd64.deb /home/user/nginx-devportal-ui_<version>_amd64.deb
   ```

4. Upgrade the NGINX Developer Portal packages:

   ```bash
   sudo apt-get -y install -f /home/user/nginx-devportal_<version>_amd64.deb /home/user/nginx-devportal-ui_<version>_amd64.deb
   ```

   {{%/tab%}}
   {{</tabs>}}

<!-- Do not remove. Keep this code at the bottom of the include -->
<!-- DOCS-1013 -->