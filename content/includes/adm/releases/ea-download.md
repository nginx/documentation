### App Delivery Manager Trial Download and Installation

<style>
ul#ea_download_app_delivery_manager {
  margin: 0 0 10px 0px;
}
</style>

For early access to App Delivery Manager, follow the steps in the [prerequisites]({{< relref "/nms/installation/vm-bare-metal/prerequisites.md" >}}) section to download an NGINX Management Suite trial.

Add the NGINX Management Suite and App Delivery Manager repositories to your system:

{{<tabs name="ea_download_app_delivery_manager">}}
{{%tab name="CentOS, RHEL, and RPM-Based"%}}
  ```bash
  sudo wget -P /etc/yum.repos.d https://cs.nginx.com/static/files/nms.repo
  ```
{{%/tab%}}
{{%tab name="Debian"%}}

  ```bash
  printf "deb https://pkgs.nginx.com/nms/debian `lsb_release -cs` nginx-plus\n" | sudo tee /etc/apt/sources.list.d/nms.list
  printf "deb https://pkgs.nginx.com/adm/debian `lsb_release -cs` nginx-plus\n" | sudo tee -a /etc/apt/sources.list.d/nms.list
  sudo wget -q -O /etc/apt/apt.conf.d/90pkgs-nginx https://cs.nginx.com/static/files/90pkgs-nginx
  ```
{{%/tab%}}
{{%tab name="Ubuntu"%}}

  ```bash
  printf "deb https://pkgs.nginx.com/nms/ubuntu `lsb_release -cs` nginx-plus\n" | sudo tee /etc/apt/sources.list.d/nms.list
  printf "deb https://pkgs.nginx.com/adm/ubuntu `lsb_release -cs` nginx-plus\n" | sudo tee -a /etc/apt/sources.list.d/nms.list
  sudo wget -q -O /etc/apt/apt.conf.d/90pkgs-nginx https://cs.nginx.com/static/files/90pkgs-nginx
  ```
{{%/tab%}}
{{</tabs>}}

After completing the steps in the [prerequisites]({{< relref "/nms/installation/vm-bare-metal/prerequisites.md" >}}) section, follow the steps in the [Install or Upgrade App Delivery Manager]({{< relref "/nms/installation/vm-bare-metal/install-adm.md" >}}) guide.