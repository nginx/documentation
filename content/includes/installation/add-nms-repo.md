---
docs: "000"
---
Select the tab matching your Linux distribution, then follow the instructions to add the NGINX Management Suite repository.

<br>

{{<tabs name="install_repo">}}
{{%tab name="CentOS, RHEL, RPM-Based"%}}

1. Add the NGINX Management Suite repository:

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


2. Add the [NGINX Signing Key](https://nginx.org/keys/nginx_signing.key):

    ```bash
    curl -o /tmp/nginx_signing.key https://nginx.org/keys/nginx_signing.key
    sudo rpmkeys --import /tmp/nginx_signing.key
    ```

{{%/tab%}}

{{%tab name="Debian, Ubuntu, Deb-Based"%}}

1. Add the NGINX Management Suite repository:

   - **Debian**

      ```bash
      printf "deb https://pkgs.nginx.com/nms/debian `lsb_release -cs` nginx-plus\n" | sudo tee /etc/apt/sources.list.d/nms.list
      printf "deb https://pkgs.nginx.com/adm/debian `lsb_release -cs` nginx-plus\n" | sudo tee -a /etc/apt/sources.list.d/nms.list
      sudo wget -q -O /etc/apt/apt.conf.d/90pkgs-nginx https://cs.nginx.com/static/files/90pkgs-nginx
      ```

   - **Ubuntu**

      ```bash
      printf "deb https://pkgs.nginx.com/nms/ubuntu `lsb_release -cs` nginx-plus\n" | sudo tee /etc/apt/sources.list.d/nms.list
      printf "deb https://pkgs.nginx.com/adm/ubuntu `lsb_release -cs` nginx-plus\n" | sudo tee -a /etc/apt/sources.list.d/nms.list
      sudo wget -q -O /etc/apt/apt.conf.d/90pkgs-nginx https://cs.nginx.com/static/files/90pkgs-nginx
      ```

2. Add the [NGINX Signing Key](https://nginx.org/keys/nginx_signing.key):

    ```bash
    wget -O /tmp/nginx_signing.key https://cs.nginx.com/static/keys/nginx_signing.key
    sudo apt-key add /tmp/nginx_signing.key
    ```

{{%/tab%}}
{{</tabs>}}
