---
title: Install the WAF compiler in a disconnected environment
description: Install the WAF compiler on a system without internet access by generating and transferring the package from a connected system.
toc: true
weight: 200
nd-content-type: how-to
nd-product: NIM
nd-docs:
---

You can install the WAF compiler on a system without internet access by creating the package on a connected system, then transferring and installing it offline.

- **Step 1:** Generate the WAF compiler package on a system with internet access.  
- **Step 2:** Move the generated package to the offline target system and install it.

## Before you begin

{{< include "/nim/waf/nim-waf-before-you-begin.md" >}}

## WAF compiler version support

Use the table below to find the correct WAF compiler version for each release of F5 WAF for NGINX:

{{< include "/waf/waf-nim-compiler-support.md" >}}

{{< call-out "note" >}}
Beginning with version 5.9.0, both the virtual machine and container installation packages are categorized under the 5.x.x tag.  
Earlier releases used 4.x.x for VM packages (for example, NAP 4.15.0, NAP 4.16.0) and 5.x.x for container packages (for example, NAP 5.7.0, NAP 5.8.0).
{{< /call-out >}}

---

## Install the WAF compiler by distribution

{{< tabs name="install-waf-compiler-offline" >}}

{{% tab name="Ubuntu 22.04 and 24.04" %}}

1. **On a system with internet access:**

   Place your `nginx-repo.crt` and `nginx-repo.key` files on this system.

   ```shell
   sudo apt-get update -y
   sudo mkdir -p /etc/ssl/nginx/
   sudo mv nginx-repo.crt /etc/ssl/nginx/
   sudo mv nginx-repo.key /etc/ssl/nginx/

   wget -qO - https://cs.nginx.com/static/keys/nginx_signing.key \
       | gpg --dearmor \
       | sudo tee /usr/share/keyrings/nginx-archive-keyring.gpg >/dev/null

   printf "deb [signed-by=/usr/share/keyrings/nginx-archive-keyring.gpg] \
   https://pkgs.nginx.com/nms/ubuntu $(lsb_release -cs) nginx-plus\n" | \
   sudo tee /etc/apt/sources.list.d/nms.list

   sudo wget -q -O /etc/apt/apt.conf.d/90pkgs-nginx https://cs.nginx.com/static/files/90pkgs-nginx
   mkdir -p compiler && cd compiler
   sudo apt-get update

   sudo apt-get download nms-nap-compiler-v5.527.0
   cd ../
   mkdir -p compiler/compiler.deps
   sudo apt-get install --download-only --reinstall --yes --print-uris \
     nms-nap-compiler-v5.527.0 \
     | grep ^\' \
     | cut -d\' -f2 \
     | xargs -n 1 wget -P ./compiler/compiler.deps
   tar -czvf compiler.tar.gz compiler/
   ```

1. **On the offline target system:**

   Make sure the OS libraries are up to date, especially `glibc`.  
   Move the `compiler.tar.gz` file from Step 1 to this system.

   ```shell
   tar -xzvf compiler.tar.gz
   sudo dpkg -i ./compiler/compiler.deps/*.deb
   sudo dpkg -i ./compiler/*.deb
   ```

{{% /tab %}}

{{% tab name="Debian 11 and 12" %}}

1. **On a system with internet access:**

   Place your `nginx-repo.crt` and `nginx-repo.key` files on this system.

   ```shell
   sudo apt-get update -y
   sudo mkdir -p /etc/ssl/nginx/
   sudo mv nginx-repo.crt /etc/ssl/nginx/
   sudo mv nginx-repo.key /etc/ssl/nginx/

   wget -qO - https://cs.nginx.com/static/keys/nginx_signing.key \
       | gpg --dearmor \
       | sudo tee /usr/share/keyrings/nginx-archive-keyring.gpg >/dev/null

   printf "deb [signed-by=/usr/share/keyrings/nginx-archive-keyring.gpg] \
   https://pkgs.nginx.com/nms/debian $(lsb_release -cs) nginx-plus\n" | \
   sudo tee /etc/apt/sources.list.d/nms.list

   sudo wget -q -O /etc/apt/apt.conf.d/90pkgs-nginx https://cs.nginx.com/static/files/90pkgs-nginx
   mkdir -p compiler && cd compiler
   sudo apt-get update

   sudo apt-get download nms-nap-compiler-v5.527.0
   cd ../
   mkdir -p compiler/compiler.deps
   sudo apt-get install --download-only --reinstall --yes --print-uris \
     nms-nap-compiler-v5.527.0 \
     | grep ^\' \
     | cut -d\' -f2 \
     | xargs -n 1 wget -P ./compiler/compiler.deps
   tar -czvf compiler.tar.gz compiler/
   ```

1. **On the offline target system:**

   Make sure the OS libraries are up to date, especially `glibc`.  
   Move the `compiler.tar.gz` file from Step 1 to this system.

   ```shell
   tar -xzvf compiler.tar.gz
   sudo dpkg -i ./compiler/compiler.deps/*.deb
   sudo dpkg -i ./compiler/*.deb
   ```

{{% /tab %}}

{{% tab name="RHEL 8 or Oracle Linux 8" %}}

1. **On a system with internet access:**

   Place your `nginx-repo.crt` and `nginx-repo.key` files on this system.

   ```shell
   sudo yum update -y
   sudo yum install yum-utils tar -y
   sudo mkdir -p /etc/ssl/nginx/
   sudo mv nginx-repo.crt /etc/ssl/nginx/
   sudo mv nginx-repo.key /etc/ssl/nginx/
   sudo wget -P /etc/yum.repos.d https://cs.nginx.com/static/files/nms.repo

   sudo tee /etc/yum.repos.d/centos-vault-powertools.repo << 'EOF'
   [centos-vault-powertools]
   name=CentOS Vault - PowerTools
   baseurl=https://vault.centos.org/centos/8/PowerTools/x86_64/os/
   enabled=1
   gpgcheck=0
   EOF

   sudo yum update -y
   sudo mkdir -p nms-nap-compiler

   sudo yumdownloader --resolve --destdir=nms-nap-compiler nms-nap-compiler-v5.527.0
   tar -czvf compiler.tar.gz nms-nap-compiler/
   ```

1. **On the offline target system:**

   Make sure the OS libraries are up to date, especially `glibc`.  
   Move the `compiler.tar.gz` file from Step 1 to this system.

   ```shell
   sudo yum install tar -y
   tar -xzvf compiler.tar.gz
   sudo dnf install --disablerepo=* nms-nap-compiler/*.rpm
   ```

{{% /tab %}}

{{% tab name="RHEL 9 or Oracle Linux 9" %}}

1. **On a system with internet access:**

   Place your `nginx-repo.crt` and `nginx-repo.key` files on this system.

   ```shell
   sudo yum update -y
   sudo yum install yum-utils -y
   sudo mkdir -p /etc/ssl/nginx/
   sudo mv nginx-repo.crt /etc/ssl/nginx/
   sudo mv nginx-repo.key /etc/ssl/nginx/
   sudo wget -P /etc/yum.repos.d https://cs.nginx.com/static/files/nms.repo
   sudo yum-config-manager --disable rhel-9-appstream-rhui-rpms
   sudo yum update -y
   sudo mkdir -p nms-nap-compiler

   sudo yumdownloader --resolve --destdir=nms-nap-compiler nms-nap-compiler-v5.527.0
   tar -czvf compiler.tar.gz nms-nap-compiler/
   ```

1. **On the offline target system:**

   Make sure the OS libraries are up to date, especially `glibc`.  
   Move the `compiler.tar.gz` file from Step 1 to this system.

   ```shell
   tar -xzvf compiler.tar.gz
   cd nms-nap-compiler
   sudo dnf install *.rpm --disablerepo=*
   ```

{{% /tab %}}

{{< /tabs >}}
