---
nd-files:
  - content/nim/install/vm-bare-metal/install-with-bash-script-offline.md
  - content/nim/install/vm-bare-metal/install-with-bash-script-online.md
---

You can customize the installation with the following options:

{{< table >}}
You can customize the installation with the following options:

| Category                      | Option |
|------------------------------|--------|
| **Installation mode and platform** | `-m offline`: Packages the installation files into a tarball for disconnected environments. *Only used in offline installations.*<br><br>`-m online`: Sets the installation to online mode. This is optional—if you don’t specify `-m`, online mode is used by default.<br><br>`-d <distribution>`: Target Linux distribution (for example, `ubuntu22.04` or `rhel8`).<br><br>`-l`: Lists the supported Linux distributions. |
| **SSL certificate and key**  | `-c <path/to/nginx-repo.crt>`: Path to the SSL certificate file. *(Default: `/etc/ssl/nginx`)*<br><br>`-k <path/to/nginx-repo.key>`: Path to the private key file. *(Default: `/etc/ssl/nginx`)* |
| **NGINX installation**       | `-n`: Installs the latest version of NGINX Open Source.<br><br>`-p`: Installs NGINX Plus as the API gateway. *Only supported in online mode.* Requires `-j`.<br><br>`-j <path>`: Path to the `license.jwt` file. Required with `-p`. |
| **ClickHouse installation**  | `-s`: Skips installing ClickHouse. This simplifies the setup and reduces system requirements by removing metrics collection. Ideal if you don’t need monitoring data or want a lightweight deployment. You can add ClickHouse later if your needs change.<br><br>If you skip ClickHouse, make sure you're using NGINX Agent version 2.4.11 or later. After installation, disable metrics collection in `/etc/nms/nms.conf`.<br><br>`-v <clickhouse-version>`: Installs a specific version of ClickHouse. If not set, version `{{< clickhouse-version >}}` is installed by default. |
| **Remove** | `-r`: Removes NGINX Instance Manager, ClickHouse, and all NGINX configuration files. **Use with caution.** This option permanently deletes data unless you have backups. It’s recommended only when you need to clean up the system before reinstalling. |
| **Help** | `-h`: Displays help and usage information for the installation script. |
{{< /table >}}