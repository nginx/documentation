---
docs: DOCS-1243
---

Select the tab matching your Linux distribution, then follow the instructions to add the NGINX Management Suite repository.

<br>

{{<tabs name="install_repo">}}
{{%tab name="CentOS, RHEL, RPM-Based"%}}

Add the NGINX Management Suite repository:

- **CentOS/RHEL**

   ```bash
   sudo wget -P /etc/yum.repos.d https://cs.nginx.com/static/files/nms.repo
   ```

   <br>

  - **RHEL 8**: If you're installing on RHEL 8 and using the distro's NGINX, run the following commands to use the new version of NGINX (1.20 at the time of this update):

    ```bash
    sudo yum module disable nginx:1.14
    sudo yum module enable nginx:1.20
    ```

- **Amazon Linux 2**

   ```bash
   sudo wget -P /etc/yum.repos.d https://cs.nginx.com/static/files/nms-amazon2.repo
   ```

{{%/tab%}}

{{%tab name="Debian, Ubuntu, Deb-Based"%}}

Add the NGINX Management Suite repository:

- **Debian**

  ```shell
  printf "deb [signed-by=/usr/share/keyrings/nginx-archive-keyring.gpg] https://pkgs.nginx.com/nms/debian `lsb_release -cs` nginx-plus\n" | sudo tee /etc/apt/sources.list.d/nms.list
  sudo wget -q -O /etc/apt/apt.conf.d/90pkgs-nginx https://cs.nginx.com/static/files/90pkgs-nginx
  ```

  <br>

- **Ubuntu**

  ```shell
  printf "deb [signed-by=/usr/share/keyrings/nginx-archive-keyring.gpg] https://pkgs.nginx.com/nms/ubuntu `lsb_release -cs` nginx-plus\n" | sudo tee /etc/apt/sources.list.d/nms.list
  sudo wget -q -O /etc/apt/apt.conf.d/90pkgs-nginx https://cs.nginx.com/static/files/90pkgs-nginx
  ```

{{%/tab%}}
{{</tabs>}}

